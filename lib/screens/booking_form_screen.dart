import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import 'booking_summary_screen.dart';

// Top-level variable fallback in case currentUserName is defined globally in your app.
// Replace with your global state/user model import if needed.
String currentUserName = '';

class BookingFormScreen extends StatefulWidget {
  final Destination destination;

  const BookingFormScreen({super.key, required this.destination});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Pre-fill with saved user name if available
    _nameController.text = currentUserName.isNotEmpty ? currentUserName : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Safe helper to read property name safely from Destination model
  String get _destinationName {
    final dynamic d = widget.destination;
    try {
      return (d.name ?? d.title ?? 'Destination').toString();
    } catch (_) {
      return 'Destination';
    }
  }

  // Safe helper to read location safely from Destination model
  String get _destinationLocation {
    final dynamic d = widget.destination;
    try {
      return (d.location ?? d.city ?? d.country ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF203A43),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF0F2027)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Book Destination',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 1. Dark Gradient Background
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

          // 2. Ambient Light Orbs
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
            bottom: 100,
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

          // 3. Form Glassmorphic Card
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
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Booking for $_destinationName',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (_destinationLocation.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                _destinationLocation,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),

                            // Traveler Name Input
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Traveler Name',
                                labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                                hintText: 'Enter your full name',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.cyanAccent,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Please enter traveler name'
                                      : null,
                            ),
                            const SizedBox(height: 20),

                            // Read-Only Destination Field
                            TextFormField(
                              initialValue: _destinationName,
                              enabled: false,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Destination',
                                labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                prefixIcon: const Icon(
                                  Icons.location_on,
                                  color: Colors.cyanAccent,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Preferred Travel Date Selector
                            InkWell(
                              onTap: () => _pickDate(context),
                              borderRadius: BorderRadius.circular(12),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Preferred Travel Date',
                                  labelStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.cyanAccent,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _selectedDate == null
                                      ? 'Select travel date'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? Colors.white.withValues(alpha: 0.4)
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Continue Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_selectedDate == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please select a preferred travel date',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final travelDateStr =
                                        '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

                                    // Fully passes the destination object forward along with details
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookingSummaryScreen(
                                          travelerName:
                                              _nameController.text.trim(),
                                          destination: widget.destination,
                                          travelDate: travelDateStr,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}