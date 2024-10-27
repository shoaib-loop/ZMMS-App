import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For bar chart
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceDashboard extends StatefulWidget {
  const PerformanceDashboard({super.key});

  @override
  _PerformanceDashboardState createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  List<String> students = [];
  Map<String, String> testResults = {};

  double averageScore = 0;
  int highestScore = 0;
  int lowestScore = 100;

  @override
  void initState() {
    super.initState();
    loadStudentsAndResults();
  }

  // Function to load student data and test results
  Future<void> loadStudentsAndResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      students = prefs.getStringList('students') ?? [];
      for (String student in students) {
        testResults[student] = prefs.getString(student) ?? '0';
      }
      calculatePerformanceStats(); // Calculate performance stats after loading data
    });
  }

  // Calculate average, highest, and lowest scores
  void calculatePerformanceStats() {
    if (students.isEmpty) return;

    int totalScore = 0;
    int highest = 0;
    int lowest = 100;

    for (String student in students) {
      int score = int.tryParse(testResults[student] ?? '0') ?? 0;
      totalScore += score;

      if (score > highest) highest = score;
      if (score < lowest) lowest = score;
    }

    setState(() {
      averageScore = totalScore / students.length;
      highestScore = highest;
      lowestScore = lowest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Performance Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance stats: Average, Highest, Lowest
            Text(
              'Performance Stats',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Average Score: ${averageScore.toStringAsFixed(1)}'),
            Text('Highest Score: $highestScore'),
            Text('Lowest Score: $lowestScore'),

            SizedBox(height: 30),

            // Bar Chart for student test scores
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: students.asMap().entries.map((entry) {
                    int index = entry.key;
                    String student = entry.value;
                    int score = int.tryParse(testResults[student] ?? '0') ?? 0;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: score.toDouble(), // Corrected toY for bar height
                          color: Colors.blue, // Use color for a single color
                          width: 15, // Optional: Set bar width
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < students.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Transform.rotate(
                                angle:
                                    -1.0, // Rotate labels by approximately 60 degrees
                                child: Text(
                                  students[index],
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            );
                          }
                          return const Text(''); // Empty for invalid indices
                        },
                        reservedSize: 42, // Space for labels
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 10, // Interval between Y-axis labels
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






