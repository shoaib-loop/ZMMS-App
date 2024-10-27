import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // For file I/O
import 'package:path_provider/path_provider.dart'; // For file paths
import 'package:csv/csv.dart'; // CSV package
import 'package:pdf/widgets.dart' as pw; // PDF package
import 'package:open_file/open_file.dart'; // To open files

class TestSystemScreen extends StatefulWidget {
  const TestSystemScreen({super.key});

  @override
  _TestSystemScreenState createState() => _TestSystemScreenState();
}

class _TestSystemScreenState extends State<TestSystemScreen> {
  List<String> students = [];
  Map<String, String> testResults = {};

  TextEditingController studentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadStudentsAndResults();
  }

  Future<void> loadStudentsAndResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      students = prefs.getStringList('students') ?? [];
      for (String student in students) {
        testResults[student] = prefs.getString(student) ?? 'Not Set';
      }
    });
  }

  Future<void> saveStudentsAndResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('students', students);
    for (String student in students) {
      if (testResults[student] != null) {
        prefs.setString(student, testResults[student]!);
      }
    }
  }

  void addStudent() {
    setState(() {
      String studentName = studentController.text.trim();
      if (studentName.isNotEmpty && !students.contains(studentName)) {
        students.add(studentName);
        testResults[studentName] = 'Not Set';
        saveStudentsAndResults();
      }
      studentController.clear();
    });
  }

  void deleteStudent(String student) {
    setState(() {
      students.remove(student);
      testResults.remove(student);
      saveStudentsAndResults();
    });
  }

  // Generate and export CSV
  Future<void> exportToCSV() async {
    List<List<String>> csvData = [
      // Header row
      ['Student', 'Score'],
      // Data rows
      ...students
          .map((student) => [student, testResults[student] ?? 'Not Set']),
    ];

    String csvString = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/test_report.csv';
    final file = File(path);
    await file.writeAsString(csvString);

    // Open the file to view
    OpenFile.open(path);
  }

  // Generate and export PDF
  Future<void> exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.ListView(
          children: [
            pw.Text('Test Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Student', 'Score'],
              data: students.map((student) {
                return [student, testResults[student] ?? 'Not Set'];
              }).toList(),
            ),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/test_report.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    // Open the file to view
    OpenFile.open(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test System'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Form for adding new students
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Student',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: studentController,
                    decoration: InputDecoration(labelText: 'Student Name'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addStudent,
                    child: Text('Add Student'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Displaying the list of students and their test results
          ...students.map((student) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(student),
                subtitle: Text('Score: ${testResults[student]}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        TextEditingController tempTestScoreController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Enter Test Score for $student'),
                              content: TextField(
                                controller: tempTestScoreController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Test Score'),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Save'),
                                  onPressed: () {
                                    setState(() {
                                      testResults[student] =
                                          tempTestScoreController.text;
                                      saveStudentsAndResults();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete $student'),
                              content: Text(
                                  'Are you sure you want to delete $student and their test result?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    deleteStudent(student);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),

          // Export buttons
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: exportToCSV,
            child: Text('Export as CSV'),
          ),
          ElevatedButton(
            onPressed: exportToPDF,
            child: Text('Export as PDF'),
          ),
        ],
      ),
    );
  }
}
