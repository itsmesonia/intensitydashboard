import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/intensity_data.dart';

class CarbonApiService {
  final String _baseUrl = 'https://api.carbonintensity.org.uk';

  // Shared GET helper function
  Future<dynamic> _getJson(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to GET $endpoint (Status ${response.statusCode})',
      );
    }
  }

  /// Gets the most recent actual intensity value
  Future<int> fetchCurrentIntensity() async {
    final json = await _getJson('/intensity');
    print('[DEBUG] /intensity response: $json');
    final intensity = json['data'][0]['intensity']['actual'];
    if (intensity != null) {
      return intensity;
    } else {
      throw Exception('Actual intensity value is null');
    }
  }

  Future<List<IntensityData>> fetchTodayIntensity() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final json = await _getJson('/intensity/date/$today');

    final rawData = json['data'] as List;
    final parsedData = rawData
        .map((item) => IntensityData.fromJson(item))
        .where((d) => d.intensity < 300)
        .toList();

    if (parsedData.isEmpty) {
      throw Exception('No valid intensity data found for today');
    }

    return parsedData;
  }

  /// Gets daily average intensity for the current month
  Future<List<IntensityData>> fetchMonthIntensity() async {
    final now = DateTime.now().toUtc();
    final start = DateTime(now.year, now.month, 1).toUtc();
    final end = DateTime(
      now.year,
      now.month + 1,
      0,
      23,
      30,
    ).toUtc(); // last day 23:30

    List<IntensityData> allData = [];

    DateTime rangeStart = start;
    while (rangeStart.isBefore(end)) {
      final rangeEnd = rangeStart.add(Duration(days: 14)).isBefore(end)
          ? rangeStart.add(Duration(days: 14))
          : end;

      final fromStr = _formatDateTimeForApi(rangeStart);
      final toStr = _formatDateTimeForApi(rangeEnd);

      final json = await _getJson('/intensity/$fromStr/$toStr');
      final rawData = json['data'] as List;
      allData.addAll(
        rawData
            .map((item) => IntensityData.fromJson(item))
            .where((d) => d.intensity < 300)
            .toList(),
      );

      rangeStart = rangeEnd.add(
        Duration(minutes: 30),
      ); // move to next half hour after rangeEnd
    }

    return allData;
  }

  String _formatDateTimeForApi(DateTime dt) {
    // Format like '2025-07-01T00:00Z'
    return dt.toIso8601String().substring(0, 16) + 'Z';
  }
}
