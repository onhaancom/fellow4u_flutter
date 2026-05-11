import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import 'widgets/finding_guide_section.dart'; // For GuideCard
import 'widgets/featured_tours_section.dart'; // For TourCard

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;
  List<dynamic> guides = [];
  List<dynamic> tours = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _fetchResults(widget.searchQuery);
  }

  Future<void> _fetchResults(String query) async {
    setState(() => isLoading = true);
    try {
      final response = await ApiService.get('api/search?q=$query');
      setState(() {
        guides = response['guides'] as List<dynamic>;
        tours = response['tours'] as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching search results: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (guides.isNotEmpty) _buildGuidesSection(),
                          if (tours.isNotEmpty) _buildToursSection(),
                          if (guides.isEmpty && tours.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50),
                                child: Text("No results found", style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                ),
                onSubmitted: (val) => _fetchResults(val),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Finding a Guide",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "SEE MORE",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: guides.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final guide = guides[index];
              final firstName = guide['firstName'] ?? '';
              final lastName = guide['lastName'] ?? '';
              final fullName = guide['fullName'] ?? '$firstName $lastName';
              final country = guide['country'] ?? 'Unknown';
              final city = guide['city'] ?? 'Location';
              final avatarUrl = guide['avatarUrl'];
              
              final fullAvatarUrl = avatarUrl != null && avatarUrl.startsWith('/')
                  ? '${ApiService.baseUrl}$avatarUrl'
                  : avatarUrl;

              return GuideCard(
                name: fullName,
                country: country,
                date: "Jan 30, 2020", 
                location: "$city, $country",
                imageUrl: fullAvatarUrl,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToursSection() {
    final location = _searchController.text.split(',').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tours in $location",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "SEE MORE",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: tours.length,
          itemBuilder: (context, index) {
            final tour = tours[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TourCard(
                title: tour['title'] ?? 'Tour',
                date: tour['date'] ?? 'Jan 30, 2020',
                duration: tour['duration'] ?? '3 days',
                price: "\$${tour['price']?.toStringAsFixed(2) ?? '0.00'}",
                likes: "${tour['likes'] ?? 0} likes",
                isFavorite: false,
                imageUrl: tour['imageUrl'] ?? 'img/scene/1.png',
              ),
            );
          },
        ),
      ],
    );
  }
}
