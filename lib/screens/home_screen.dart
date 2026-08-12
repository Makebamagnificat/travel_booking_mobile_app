import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../widgets/category_selector.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Destination> displayedDestinations = allDestinations;
  String selectedCategory = 'Popular';

  void _filterCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'Popular') {
        displayedDestinations = allDestinations;
      } else {
        displayedDestinations = allDestinations
            .where((d) => d.category.toLowerCase() == category.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 700;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Ambient Glows
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent,
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Explore',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Find your favorite destination',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          _HoverableProfileAvatar(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Autocomplete Search Bar
                      Autocomplete<Destination>(
                        displayStringForOption: (Destination option) => option.name,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            _filterCategory(selectedCategory);
                            return const Iterable<Destination>.empty();
                          }

                          final query = textEditingValue.text.toLowerCase();
                          final matches = allDestinations.where((destination) {
                            return destination.name.toLowerCase().contains(query) ||
                                destination.location.toLowerCase().contains(query);
                          }).toList();

                          setState(() {
                            displayedDestinations =
                                matches.isNotEmpty ? matches : allDestinations;
                          });

                          return matches;
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onEditingComplete) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                onEditingComplete: onEditingComplete,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      'Search destinations (e.g. Lake, Bali)...',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.lightBlueAccent),
                                  suffixIcon: controller.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear,
                                              size: 20, color: Colors.white70),
                                          onPressed: () {
                                            controller.clear();
                                            _filterCategory(selectedCategory);
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.1),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.white.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Material(
                                  elevation: 4.0,
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black.withValues(alpha: 0.6),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 32,
                                    constraints:
                                        const BoxConstraints(maxHeight: 250, maxWidth: 600),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        height: 1,
                                        color: Colors.white.withValues(alpha: 0.1),
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final Destination option =
                                            options.elementAt(index);
                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              option.imageUrl,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                      const Icon(Icons.image,
                                                          size: 48,
                                                          color: Colors.white54),
                                            ),
                                          ),
                                          title: Text(
                                            option.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            option.location,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.7),
                                            ),
                                          ),
                                          trailing: Text(
                                            '\$${option.price.toInt()}',
                                            style: const TextStyle(
                                              color: Colors.lightBlueAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onTap: () {
                                            onSelected(option);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetailScreen(
                                                    destination: option),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      CategorySelector(
                        onCategorySelected: _filterCategory,
                      ),

                      const SizedBox(height: 20),

                      displayedDestinations.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  'No destinations found for this category.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            )
                          : isWideScreen
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1.2,
                                  ),
                                  itemCount: displayedDestinations.length,
                                  itemBuilder: (context, index) {
                                    return _HoverableDestinationWrapper(
                                      child: DestinationCard(
                                        destination: displayedDestinations[index],
                                      ),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: displayedDestinations.length,
                                  itemBuilder: (context, index) {
                                    return _HoverableDestinationWrapper(
                                      child: DestinationCard(
                                        destination: displayedDestinations[index],
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableProfileAvatar extends StatefulWidget {
  final VoidCallback onTap;

  const _HoverableProfileAvatar({required this.onTap});

  @override
  State<_HoverableProfileAvatar> createState() =>
      _HoverableProfileAvatarState();
}

class _HoverableProfileAvatarState extends State<_HoverableProfileAvatar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.1, 1.1, 1.0)
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.lightBlueAccent.withValues(alpha: 0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: _isHovered
                ? Colors.lightBlueAccent
                : Colors.white.withValues(alpha: 0.18),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverableDestinationWrapper extends StatefulWidget {
  final Widget child;

  const _HoverableDestinationWrapper({required this.child});

  @override
  State<_HoverableDestinationWrapper> createState() =>
      _HoverableDestinationWrapperState();
}

class _HoverableDestinationWrapperState
    extends State<_HoverableDestinationWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 16),
        transform: _isHovered
            ? Matrix4.diagonal3Values(1.03, 1.03, 1.0)
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}