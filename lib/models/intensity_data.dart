// API Service
// Create a class CarbonApiService that fetches:
// Current intensity
// Today’s half-hourly data

class IntensityData {
  final DateTime from;
  final DateTime to;
  final int intensity;

  IntensityData({
    required this.from,
    required this.to,
    required this.intensity,
  });

  factory IntensityData.fromJson(Map<String, dynamic> json) {
    return IntensityData(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      intensity:
          json['intensity']['actual'] ??
          0, // Default to 0 if null., This prevents the crash and assigns 0 if actual is missing. You can style 0 as “data unavailable” in the UI later.
    );
  }
}
