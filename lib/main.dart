import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(CarbonDashboardApp());
}

class CarbonDashboardApp extends StatelessWidget {
  const CarbonDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Intensity Dashboard',
      theme: ThemeData(primarySwatch: Colors.green),
      home: DashboardScreen(),
    );
  }
}
