import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_booking_app/main.dart';

void main() {
  testWidgets('App starts on Signup screen and shows correct UI', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const TravelBookingApp());
    await tester.pumpAndSettle();

    // Verify that we are on the Signup screen
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign up to unlock destination bookings'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);

    // Verify the three input fields exist
    expect(find.byType(TextField), findsNWidgets(3));

    // Verify the flight icon is present
    expect(find.byIcon(Icons.flight_takeoff_rounded), findsOneWidget);
  });
}