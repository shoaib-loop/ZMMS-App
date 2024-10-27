import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // List of students and their attendance status
  List<Map<String, dynamic>> students = [
    {'name': 'Ali', 'isPresent': false},
    {'name': 'Ayesha', 'isPresent': false},
    {'name': 'Bilal', 'isPresent': false},
    {'name': 'Fatima', 'isPresent': false},
    {'name': 'Hassan', 'isPresent': false},
  ];

  // Function to toggle attendance status
  void toggleAttendance(int index) {
    setState(() {
      students[index]['isPresent'] = !students[index]['isPresent'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index]['name']),
            trailing: IconButton(
              icon: Icon(
                students[index]['isPresent']
                    ? Icons.check_circle
                    : Icons.cancel,
                color: students[index]['isPresent'] ? Colors.green : Colors.red,
              ),
              onPressed: () {
                toggleAttendance(index);
              },
            ),
          );
        },
      ),
    );
  }
}
