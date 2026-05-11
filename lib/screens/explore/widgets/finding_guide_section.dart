import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/widgets/server_image.dart';

class FindingGuideSection extends StatefulWidget {
  const FindingGuideSection({super.key});

  @override
  State<FindingGuideSection> createState() => _FindingGuideSectionState();
}

class _FindingGuideSectionState extends State<FindingGuideSection> {
  List<dynamic> guides = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGuides();
  }

  Future<void> _fetchGuides() async {
    try {
      final response = await ApiService.get('api/users?role=Traveler');
      setState(() {
        guides = response as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching guides: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Finding a Guide",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: _fetchGuides,
                child: const Text(
                  "REFRESH",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
          else if (guides.isEmpty)
            const Center(child: Text("No travelers found"))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: guides.length > 4 ? 4 : guides.length, // Show up to 4 guides
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final guide = guides[index];
                final firstName = guide['firstName'] ?? '';
                final lastName = guide['lastName'] ?? '';
                final fullName = '$firstName $lastName';
                final country = guide['country'] ?? 'Unknown';
                final city = guide['city'] ?? 'Location';
                final avatarUrl = guide['avatarUrl'];
                
                // Get original URL if it's from the server
                final fullAvatarUrl = avatarUrl != null && avatarUrl.startsWith('/')
                    ? '${ApiService.baseUrl}$avatarUrl'
                    : avatarUrl;

                return GuideCard(
                  name: fullName,
                  country: country,
                  date: "Joined Jan 2024", // Placeholder date
                  location: city,
                  imageUrl: fullAvatarUrl,
                );
              },
            ),
        ],
      ),
    );
  }
}

class GuideCard extends StatelessWidget {
  final String name;
  final String country;
  final String date;
  final String location;
  final String? imageUrl;

  const GuideCard({
    required this.name,
    required this.country,
    required this.date,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Left Image
            Expanded(
              flex: 2,
              child: ServerImage(
                url: imageUrl,
                height: double.infinity,
                fallbackUrl: 'img/avatar/1.png',
              ),
            ),
            // Right Content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " from $country",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Finding a Guide",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
