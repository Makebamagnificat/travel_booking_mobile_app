# Travel Booking App GROUP 8 (BTECH Computer SCience)

This is a modern, cross-platform mobile and desktop application built with **Flutter**, designed to provide users with a seamless travel booking experience—from discovering top destinations and filtering categories to managing bookings, bookmarks, and user profiles.

---

## Overview

The **Travel Booking App** features an intuitive user interface, modular architecture, and robust state management. Built for high performance across iOS, Android, macOS, Windows, and Linux, the application abstracts complex API communication into clean repository interfaces and reactive presentation state.

### Key Features

**Authentication:** User sign-up, login, and secure session management.
**Destination Discovery:** Explore curated destinations with category filtering (e.g., Beaches, Mountains, Cities).
**Interactive Details:** View rich destination media, location details, pricing, and user reviews.
**Booking Engine:** Multi-step booking form with dynamic price calculation and summary confirmation.
**Bookmarks & Saved Lists:** Save favorite destinations locally or synced with your account.
**Notifications & Profile:** Manage personal information, app preferences, and updates.

---

## Tech Stack & Dependencies

**Framework:** [Flutter](https://flutter.dev/) (Dart SDK)
**State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
**Networking:** [Dio](https://pub.dev/packages/dio) for HTTP calls, interceptors, and error handling
**Icons & UI:** Custom Flutter Material / Cupertino Widgets
**Platforms Supported:** Android, iOS, Windows, macOS, Linux, Web

---

## Project Architecture

This project follows a **Feature-First / Clean Architecture** approach, separating code into distinct modules based on user features. This improves testability, scalability, and code maintainability.

```text
lib/
├── core/                         # Shared utilities, app themes, network client
│   ├── network/
│   │   ├── api_client.dart       # Dio HTTP client setup with interceptors
│   │   └── api_endpoints.dart    # API route constants
│   ├── theme/                    # Color palettes and text typography
│   └── utils/                    # Helper functions and formatters
│
├── features/                     # Feature modules
│   ├── auth/                     # Authentication feature
│   │   ├── data/                 # Auth API services & user models
│   │   └── presentation/         # Login & Signup screens, state providers
│   │
│   ├── booking/                  # Booking management
│   │   ├── data/                 # Booking repositories & DTOs
│   │   └── presentation/         # Booking form, history, & summary views
│   │
│   ├── destination/              # Destination catalog & details
│   │   ├── data/                 # Destination models & remote repositories
│   │   └── presentation/         # Home screen, details view, custom widgets
│   │
│   └── user/                     # Profile, Bookmarks, & Notifications
│       ├── data/
│       └── presentation/         # Bookmark screen, notification list, settings
│
└── main.dart                     # App entrance point & ProviderScope initialization
