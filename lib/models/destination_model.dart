import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Destination {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final double price;
  final String description;
  final String category;
  bool isBookmarked;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.description,
    required this.category,
    this.isBookmarked = false,
  });
}

class Booking {
  final String id;
  final String travelerName;
  final String destinationName;
  final String destinationLocation;
  final String travelDate;
  final double price;
  final String status;

  Booking({
    required this.id,
    required this.travelerName,
    required this.destinationName,
    required this.destinationLocation,
    required this.travelDate,
    required this.price,
    this.status = 'Confirmed',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'travelerName': travelerName,
        'destinationName': destinationName,
        'destinationLocation': destinationLocation,
        'travelDate': travelDate,
        'price': price,
        'status': status,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        travelerName: json['travelerName'],
        destinationName: json['destinationName'],
        destinationLocation: json['destinationLocation'],
        travelDate: json['travelDate'],
        price: (json['price'] as num).toDouble(),
        status: json['status'] ?? 'Confirmed',
      );
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'time': time,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        time: json['time'],
      );
}

// Global state variables
List<Booking> userBookings = [];
List<AppNotification> userNotifications = [];
String currentUserName = 'Guest User';
String currentUserEmail = 'guest@example.com';

class StorageService {
  static const String _bookingsKey = 'saved_user_bookings';
  static const String _notificationsKey = 'saved_user_notifications';
  static const String _userNameKey = 'saved_user_name';
  static const String _userEmailKey = 'saved_user_email';

  static Future<void> loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    final String? bookingsString = prefs.getString(_bookingsKey);
    if (bookingsString != null) {
      final List<dynamic> jsonList = jsonDecode(bookingsString);
      userBookings = jsonList.map((j) => Booking.fromJson(j)).toList();
    }

    final String? notifsString = prefs.getString(_notificationsKey);
    if (notifsString != null) {
      final List<dynamic> jsonList = jsonDecode(notifsString);
      userNotifications = jsonList.map((j) => AppNotification.fromJson(j)).toList();
    }

    currentUserName = prefs.getString(_userNameKey) ?? 'Makeba';
    currentUserEmail = prefs.getString(_userEmailKey) ?? 'makeba@example.com';
  }

  static Future<void> saveUserProfile(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    currentUserName = name;
    currentUserEmail = email;
  }

  static Future<void> saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(userBookings.map((b) => b.toJson()).toList());
    await prefs.setString(_bookingsKey, encoded);
  }

  static Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(userNotifications.map((n) => n.toJson()).toList());
    await prefs.setString(_notificationsKey, encoded);
  }
}

// SAMPLE DESTINATIONS
final List<Destination> sampleDestinations = [
  Destination(
    id: '1',
    name: 'Bali Beach Resort',
    location: 'Bali, Indonesia',
    imageUrl: 'https://picsum.photos/id/1015/800/600',
    rating: 4.8,
    price: 250.0,
    category: 'Beach',
    description: 'Experience pristine sandy beaches, turquoise waters, and luxury island villas.',
  ),
  Destination(
    id: '2',
    name: 'Santorini Sunset Bay',
    location: 'Santorini, Greece',
    imageUrl: 'https://picsum.photos/id/1039/800/600',
    rating: 4.9,
    price: 310.0,
    category: 'Beach',
    description: 'Relax along Aegean coastlines with dramatic cliff views and clear blue waters.',
  ),
  Destination(
    id: '3',
    name: 'Lake Como Villa',
    location: 'Lombardy, Italy',
    imageUrl: 'https://picsum.photos/id/1040/800/600',
    rating: 4.9,
    price: 380.0,
    category: 'Lake',
    description: 'Enjoy tranquil alpine lake views surrounded by historic villas and gardens.',
  ),
  Destination(
    id: '4',
    name: 'Lake Tahoe Retreat',
    location: 'California, USA',
    imageUrl: 'https://picsum.photos/id/1016/800/600',
    rating: 4.7,
    price: 220.0,
    category: 'Lake',
    description: 'Crystal-clear freshwater lake nestled in majestic mountain terrain.',
  ),
  Destination(
    id: '5',
    name: 'Mount Fuji Expedition',
    location: 'Honshu, Japan',
    imageUrl: 'https://picsum.photos/id/1018/800/600',
    rating: 4.9,
    price: 420.0,
    category: 'Mountain',
    description: 'Hike famous alpine trails and explore snow-capped peaks with scenic valleys.',
  ),
  Destination(
    id: '6',
    name: 'Swiss Alps Lodge',
    location: 'Zermatt, Switzerland',
    imageUrl: 'https://picsum.photos/id/1025/800/600',
    rating: 4.8,
    price: 490.0,
    category: 'Mountain',
    description: 'Cozy luxury mountain chalets offering world-class skiing and panoramic peaks.',
  ),
  Destination(
    id: '7',
    name: 'Black Forest Canopy',
    location: 'Baden-Württemberg, Germany',
    imageUrl: 'https://picsum.photos/id/1043/800/600',
    rating: 4.6,
    price: 195.0,
    category: 'Forest',
    description: 'Dense evergreen woodlands filled with scenic walking trails and wildlife.',
  ),
  Destination(
    id: '8',
    name: 'Redwood National Park',
    location: 'California, USA',
    imageUrl: 'https://picsum.photos/id/1044/800/600',
    rating: 4.8,
    price: 210.0,
    category: 'Forest',
    description: 'Walk among towering ancient trees and misty forest trails.',
  ),
];

List<Destination> additionalDestinations = [
  Destination(
    id: 'dest_01',
    name: 'Kyoto Ancient Shrines',
    location: 'Kyoto, Japan',
    category: 'Historic',
    description:
        'Explore timeless bamboo groves, historic Shinto shrines, and serene Zen gardens in Japan\'s former imperial capital.',
    imageUrl:
        'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1000&auto=format&fit=crop',
    price: 320.0,
    rating: 4.9,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_02',
    name: 'Amalfi Coast Overlook',
    location: 'Positano, Italy',
    category: 'Beach',
    description:
        'Marvel at pastel-colored villages clinging to dramatic cliffside vistas overlooking the pristine Mediterranean Sea.',
    imageUrl:
        'https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=1000&auto=format&fit=crop',
    price: 450.0,
    rating: 4.8,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_03',
    name: 'Santorini Sunset Caldera',
    location: 'Santorini, Greece',
    category: 'Beach',
    description:
        'Experience iconic whitewashed architecture, blue-domed churches, and world-famous Aegean Sea sunsets.',
    imageUrl:
        'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?q=80&w=1000&auto=format&fit=crop',
    price: 380.0,
    rating: 4.9,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_04',
    name: 'Machu Picchu Citadel',
    location: 'Cusco, Peru',
    category: 'Historic',
    description:
        'Journey through the high Andes to discover the mystical 15th-century Inca citadel set amidst lush cloud forests.',
    imageUrl:
        'https://images.unsplash.com/photo-1526392060635-9d6019884377?q=80&w=1000&auto=format&fit=crop',
    price: 290.0,
    rating: 4.9,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_05',
    name: 'Serengeti Wildlife Safari',
    location: 'Serengeti, Tanzania',
    category: 'Safari',
    description:
        'Witness the magnificent African Great Migration and vast wilderness landscapes teeming with majestic wildlife.',
    imageUrl:
        'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=1000&auto=format&fit=crop',
    price: 520.0,
    rating: 4.9,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_06',
    name: 'Banff National Lakes',
    location: 'Alberta, Canada',
    category: 'Lake',
    description:
        'Immerse yourself in turquoise glacier lakes, towering Canadian Rockies peaks, and pine-scented mountain wilderness.',
    imageUrl:
        'https://images.unsplash.com/photo-1511884642898-4c92249e20b6?q=80&w=1000&auto=format&fit=crop',
    price: 260.0,
    rating: 4.7,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_07',
    name: 'Bora Bora Lagoon Resort',
    location: 'French Polynesia',
    category: 'Beach',
    description:
        'Relax in luxury overwater bungalows surrounding crystal-clear turquoise lagoons and extinct volcanic peaks.',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000&auto=format&fit=crop',
    price: 680.0,
    rating: 5.0,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_08',
    name: 'Reykjavik Northern Lights',
    location: 'Reykjavik, Iceland',
    category: 'Mountain',
    description:
        'Discover dramatic waterfalls, volcanic geysers, thermal blue lagoons, and dazzling aurora borealis night skies.',
    imageUrl:
        'https://images.unsplash.com/photo-1504893524553-b855bce32c67?q=80&w=1000&auto=format&fit=crop',
    price: 340.0,
    rating: 4.8,
    isBookmarked: false,
  ),
  Destination(
    id: 'dest_09',
    name: 'Cappadocia Hot Air Balloons',
    location: 'Nevşehir, Turkey',
    category: 'Historic',
    description:
        'Soar above ancient fairy chimneys, cave dwellings, and surreal honeycombed landscape formations at sunrise.',
    imageUrl:
        'https://images.unsplash.com/photo-1527838832700-5059252407fa?q=80&w=1000&auto=format&fit=crop',
    price: 210.0,
    rating: 4.8,
    isBookmarked: false,
  ),
 Destination(
  id: 'dest_10',
  name: 'Petra Ancient Rose City',
  location: 'Ma\'an, Jordan',
  category: 'Historic',
  description:
      'Walk through narrow rock canyons to uncover stunning ancient temples carved directly into pink sandstone cliffs.',
  imageUrl: 'https://picsum.photos/id/1019/800/600',
  price: 230.0,
  rating: 4.9,
  isBookmarked: false,
),
];

// Combined full list of destinations for easy access across the app
final List<Destination> allDestinations = [
  ...sampleDestinations,
  ...additionalDestinations,
];