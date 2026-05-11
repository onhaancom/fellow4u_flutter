// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/uploads/[filename].dart' as uploads_$filename;
import '../routes/auth/update.dart' as auth_update;
import '../routes/auth/signup.dart' as auth_signup;
import '../routes/auth/login.dart' as auth_login;
import '../routes/api/upload.dart' as api_upload;
import '../routes/api/users/index.dart' as api_users_index;
import '../routes/api/trips/index.dart' as api_trips_index;
import '../routes/api/trips/[id].dart' as api_trips_$id;
import '../routes/api/tours/index.dart' as api_tours_index;
import '../routes/api/seed/index.dart' as api_seed_index;
import '../routes/api/search/index.dart' as api_search_index;
import '../routes/api/news/index.dart' as api_news_index;
import '../routes/api/chat/messages/index.dart' as api_chat_messages_index;
import '../routes/api/chat/conversations/index.dart' as api_chat_conversations_index;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/', (context) => buildHandler()(context))
    ..mount('/uploads', (context) => buildUploadsHandler()(context))
    ..mount('/auth', (context) => buildAuthHandler()(context))
    ..mount('/api', (context) => buildApiHandler()(context))
    ..mount('/api/users', (context) => buildApiUsersHandler()(context))
    ..mount('/api/trips', (context) => buildApiTripsHandler()(context))
    ..mount('/api/tours', (context) => buildApiToursHandler()(context))
    ..mount('/api/seed', (context) => buildApiSeedHandler()(context))
    ..mount('/api/search', (context) => buildApiSearchHandler()(context))
    ..mount('/api/news', (context) => buildApiNewsHandler()(context))
    ..mount('/api/chat/messages', (context) => buildApiChatMessagesHandler()(context))
    ..mount('/api/chat/conversations', (context) => buildApiChatConversationsHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildUploadsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<filename>', (context,filename,) => uploads_$filename.onRequest(context,filename,));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/login', (context) => auth_login.onRequest(context,))..all('/signup', (context) => auth_signup.onRequest(context,))..all('/update', (context) => auth_update.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/upload', (context) => api_upload.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiUsersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_users_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiTripsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<id>', (context,id,) => api_trips_$id.onRequest(context,id,))..all('/', (context) => api_trips_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiToursHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_tours_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiSeedHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_seed_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiSearchHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_search_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiNewsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_news_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiChatMessagesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_chat_messages_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiChatConversationsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_chat_conversations_index.onRequest(context,));
  return pipeline.addHandler(router);
}

