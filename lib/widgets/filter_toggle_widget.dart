import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart'; // For FilterType enum

class FilterToggle extends StatelessWidget {
  final FilterType selectedFilter;
  final ValueChanged<FilterType> onChanged;

  const FilterToggle({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 31, 51, 90),
        // color: const Color(0xFF2A5B87),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30),
        fillColor: const Color(0xFF0D1A36),
        selectedColor: Colors.white,
        color: Colors.white70,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        constraints: const BoxConstraints(minWidth: 90, minHeight: 36),
        isSelected: [
          selectedFilter == FilterType.today,
          selectedFilter == FilterType.month,
        ],
        onPressed: (index) {
          onChanged(FilterType.values[index]);
        },
        children: const [Text('TODAY'), Text('MONTH')],
      ),
    );
  }
}
