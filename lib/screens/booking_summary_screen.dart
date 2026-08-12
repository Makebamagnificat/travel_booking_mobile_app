import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/destination_model.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String travelerName;
  final Destination destination;
  final String travelDate;

  const BookingSummaryScreen({
    super.key,
    required this.travelerName,
    required this.destination,
    required this.travelDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 1. Deep Modern Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. Ambient Light Glow Effects
          Positioned(
            top: -60,
            right: -60,
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
            bottom: 80,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent,
              ),
            ),
          ),

          // 3. Glassmorphic Summary Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 450),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Confirmation Badge
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.cyanAccent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.cyanAccent,
                                  size: 32,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Please confirm your details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Summary Details Rows
                          _buildSummaryRow('Traveler Name:', travelerName),
                          Divider(color: Colors.white.withValues(alpha: 0.15)),
                          _buildSummaryRow('Destination:', destination.name),
                          Divider(color: Colors.white.withValues(alpha: 0.15)),
                          _buildSummaryRow('Location:', destination.location),
                          Divider(color: Colors.white.withValues(alpha: 0.15)),
                          _buildSummaryRow('Travel Date:', travelDate),
                          Divider(color: Colors.white.withValues(alpha: 0.15)),
                          _buildSummaryRow('Total Price:', '\$${destination.price.toInt()}'),
                          const SizedBox(height: 32),

                          // Hoverable Confirm & Finalize Button
                          _HoverableConfirmButton(
                            onPressed: () async {
                              // 1. Save to in-memory state
                              userBookings.add(
                                Booking(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  travelerName: travelerName,
                                  destinationName: destination.name,
                                  destinationLocation: destination.location,
                                  travelDate: travelDate,
                                  price: destination.price,
                                ),
                              );

                              // 2. Add confirmation notification
                              userNotifications.insert(
                                0,
                                AppNotification(
                                  id: DateTime.now().toString(),
                                  title: 'Booking Confirmed!',
                                  message: 'Trip to ${destination.name} booked for $travelDate.',
                                  time: 'Just now',
                                ),
                              );

                              // 3. Save permanently to device local storage
                              await StorageService.saveBookings();
                              await StorageService.saveNotifications();

                              // 4. Safely check context before navigating back
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Booking Confirmed & Saved Locally!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Navigate back to main screen
                                Navigator.popUntil(context, (route) => route.isFirst);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Interactive Hoverable Confirm Button Widget
class _HoverableConfirmButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _HoverableConfirmButton({required this.onPressed});

  @override
  State<_HoverableConfirmButton> createState() => _HoverableConfirmButtonState();
}

class _HoverableConfirmButtonState extends State<_HoverableConfirmButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52,
        transform: _isHovered
        ? (Matrix4.identity()..scaleByDouble(1.02, 1.02, 1.0, 1.0))
        : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _isHovered
                ? [Colors.lightGreenAccent, Colors.green]
                : [Colors.green, Colors.green.shade700],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: _isHovered ? 0.5 : 0.3),
              blurRadius: _isHovered ? 18 : 10,
              spreadRadius: _isHovered ? 2 : 0,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: widget.onPressed,
          child: const Text(
            'Confirm & Finalize Booking',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}