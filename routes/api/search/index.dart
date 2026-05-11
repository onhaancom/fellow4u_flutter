import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_application_1/database/database.dart';
import 'package:drift/drift.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final db = context.read<AppDatabase>();
  final queryParams = context.request.uri.queryParameters;
  final rawQuery = queryParams['q'] ?? '';

  if (rawQuery.isEmpty) {
    return Response.json(body: {'guides': [], 'tours': []});
  }

  // Split query by comma and take the first part as the main search term (e.g. "Danang" from "Danang, Vietnam")
  final query = rawQuery.split(',').first.trim();

  try {
    // 1. Search Guides (Users)
    final guidesRows = await db.customSelect('''
      SELECT * FROM users 
      WHERE (city LIKE ? OR country LIKE ? OR full_name LIKE ?)
    ''', variables: [
      Variable.withString('%$query%'),
      Variable.withString('%$query%'),
      Variable.withString('%$query%'),
    ]).get();

    final guides = await Future.wait(guidesRows.map((row) async {
      final userId = row.read<int>('id');
      
      final languages = await (db.select(db.userLanguages)..where((ul) => ul.userId.equals(userId))).get();
      final langDetails = <String>[];
      
      for (final l in languages) {
        final lang = await (db.select(db.languages)..where((table) => table.id.equals(l.languageId))).getSingle();
        langDetails.add(lang.name);
      }

      return {
        'id': userId,
        'username': row.read<String>('username'),
        'firstName': row.readNullable<String>('first_name'),
        'lastName': row.readNullable<String>('last_name'),
        'fullName': row.readNullable<String>('full_name'),
        'role': row.read<String>('role'),
        'address': row.readNullable<String>('address'),
        'city': row.readNullable<String>('city'),
        'country': row.readNullable<String>('country'),
        'phone': row.readNullable<String>('phone'),
        'bio': row.readNullable<String>('bio'),
        'avatarUrl': row.readNullable<String>('avatar_url'),
        'coverPhotoUrl': row.readNullable<String>('cover_photo_url'),
        'videoIntroUrl': row.readNullable<String>('video_intro_url'),
        'rating': row.read<double>('rating'),
        'reviewCount': row.read<int>('review_count'),
        'languages': langDetails,
      };
    }));

    // 2. Search Tours
    final toursRows = await db.customSelect('''
      SELECT 
        t.*, 
        u.full_name as guide_name, 
        u.avatar_url as guide_avatar,
        u.city as guide_city,
        u.country as guide_country
      FROM tours t
      LEFT JOIN users u ON t.guide_id = u.id
      WHERE t.location LIKE ? OR t.title LIKE ?
    ''', variables: [
      Variable.withString('%$query%'),
      Variable.withString('%$query%'),
    ]).get();

    final tours = toursRows.map((row) => {
      'id': row.read<int>('id'),
      'title': row.read<String>('title'),
      'location': row.readNullable<String>('location'),
      'price': row.read<double>('price'),
      'rating': row.read<double>('rating'),
      'imageUrl': row.readNullable<String>('image_url'),
      'date': row.readNullable<String>('date'),
      'duration': row.readNullable<String>('duration'),
      'likes': row.read<int>('likes'),
      'guideId': row.read<int>('guide_id'),
      'guide': {
        'fullName': row.readNullable<String>('guide_name'),
        'avatarUrl': row.readNullable<String>('guide_avatar'),
        'city': row.readNullable<String>('guide_city'),
        'country': row.readNullable<String>('guide_country'),
      }
    }).toList();

    return Response.json(body: {
      'guides': guides,
      'tours': tours,
    });
  } catch (e) {
    return Response.json(statusCode: 500, body: {'error': e.toString()});
  }
}
