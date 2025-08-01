import 'package:flutter/material.dart';
import '../services/carbon_api_services.dart';
import '../widgets/current_intensity_widget.dart';
import '../widgets/intensity_chart.dart';
import '../models/intensity_data.dart';
import '../widgets/filter_toggle_widget.dart';

enum FilterType { today, month }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = CarbonApiService();

  int? _currentIntensity;
  List<IntensityData>? _todayData;
  List<IntensityData>? _monthData;

  FilterType selectedFilter = FilterType.today;

  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final current = await _api.fetchCurrentIntensity();
      final today = await _api.fetchTodayIntensity();
      final month = await _api.fetchMonthIntensity();

      setState(() {
        _currentIntensity = current;
        _todayData = today;
        _monthData = month;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Failed to load data: $e');
    }
  }

  List<IntensityData>? getSelectedData() {
    switch (selectedFilter) {
      case FilterType.today:
        return _todayData?.isNotEmpty == true ? _todayData : null;
      case FilterType.month:
        return _monthData?.isNotEmpty == true ? _monthData : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedData = getSelectedData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carbon Intensity Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 96, 136),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 96, 136),
      body: _error != null
          ? Center(child: Text(_error!))
          : _currentIntensity == null || selectedData == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  CurrentIntensityWidget(intensity: _currentIntensity!),
                  const SizedBox(height: 16),
                  // 🔽 Filter Toggle Bar
                  Center(
                    child: FilterToggle(
                      selectedFilter: selectedFilter,
                      onChanged: (filter) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  IntensityChart(
                    data: selectedData!,
                    title: selectedFilter == FilterType.today
                        ? "Today's Half-Hourly Intensity"
                        : 'Monthly Intensity',
                  ),
                ],
              ),
            ),
    );
  }
}
