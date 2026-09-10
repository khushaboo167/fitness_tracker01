import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../db/database_helper.dart';
import '../models/workout.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<String> _exerciseNames = [];
  String? _selectedExercise;
  List<Workout> _exerciseHistory = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExerciseNames();
  }

  Future<void> _loadExerciseNames() async {
    final names = await DatabaseHelper.instance.getDistinctExerciseNames();
    setState(() {
      _exerciseNames = names;
      _selectedExercise = names.isNotEmpty ? names.first : null;
      _loading = false;
    });
    if (_selectedExercise != null) {
      _loadHistory(_selectedExercise!);
    }
  }

  Future<void> _loadHistory(String exerciseName) async {
    final history =
        await DatabaseHelper.instance.getWorkoutsByExercise(exerciseName);
    setState(() => _exerciseHistory = history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _exerciseNames.isEmpty
              ? const Center(
                  child: Text(
                    'Log a few workouts first to see progress charts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedExercise,
                        decoration: const InputDecoration(
                          labelText: 'Select exercise',
                          border: OutlineInputBorder(),
                        ),
                        items: _exerciseNames
                            .map((name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedExercise = value);
                          _loadHistory(value);
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text('Weight lifted over time (kg)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _exerciseHistory.length < 2
                            ? const Center(
                                child: Text(
                                  'Log this exercise at least twice\nto see a trend line.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : _buildChart(),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildChart() {
    final spots = <FlSpot>[];
    for (var i = 0; i < _exerciseHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), _exerciseHistory[i].weight));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= _exerciseHistory.length) {
                  return const SizedBox.shrink();
                }
                final date = _exerciseHistory[i].date;
                return Text('${date.month}/${date.day}',
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true),
          ),
        ],
      ),
    );
  }
}
