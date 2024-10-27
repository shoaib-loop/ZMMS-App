import 'package:flutter/material.dart';
import 'attendance.dart'; // Adjust the path if necessary
import 'schedule.dart'; // Adjust the path if necessary
import 'test_system.dart'; // Adjust the path if necessary
import 'performance_dashboard.dart'; // Adjust the path if necessary
import 'profile_screen.dart'; // Import Profile Edit Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Zeenat Muslim Model School'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Profile icon
            onPressed: () {
              // Navigate to Profile Edit Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout logic (for future implementation)
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to ZMMS App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendanceScreen()),
                );
              },
              child: const Text('Attendance'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClassScheduleScreen()),
                );
              },
              child: const Text('Class Schedules'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TestSystemScreen()),
                );
              },
              child: const Text('Test System'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PerformanceDashboard()),
                );
              },
              child: const Text('Performance Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}



