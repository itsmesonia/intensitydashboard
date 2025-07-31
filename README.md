# Carbon Intensity Tracker 📊

A Flutter application that fetches and displays real-time and historical UK carbon intensity data using the [Carbon Intensity API](https://carbon-intensity.github.io/).

## Features

- 🔥 **Current Intensity**: Displays the most recent carbon intensity (in gCO₂eq/kWh).
- 📅 **Daily Intensity**: Shows all half-hourly carbon intensity values for the current day.
- 📈 **Monthly Intensity**: Aggregates and filters carbon intensity data for the entire current month (in 14-day chunks due to API limits).
- ⚙️ Built using `Flutter`, `Dart`, and `http` package for networking.

---

## Getting Started

### Prerequisites

Make sure you have:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart (comes with Flutter)
- For iOS:
  - macOS with [Xcode](https://developer.apple.com/xcode/) installed
  - CocoaPods (`sudo gem install cocoapods`)
- For Android:
  - Android Studio with Android SDK installed
- Optional: A physical device or emulator/simulator

---

## Running the App

### Web (Chrome)

```
flutter run -d chrome
```

### Mobile (ios/android)

open -a Simulator

```
flutter run -d ios
flutter run -d android
```

API Reference
This app uses the Carbon Intensity API (UK) endpoints:

```
/intensity – Current carbon intensity

/intensity/date/{date} – All half-hourly values for a day

/intensity/{from}/{to} – Half-hourly values between two datetimes (max 14-day range)
```

### Folder Structure

```
lib/
├── models/
│   └── intensity_data.dart   # Model for parsing intensity data
├── services/
│   └── carbon_api_service.dart  # API logic
├── main.dart

```
