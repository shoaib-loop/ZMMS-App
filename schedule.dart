import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassScheduleScreen extends StatefulWidget {
  const ClassScheduleScreen({super.key});

  @override
  _ClassScheduleScreenState createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  // Schedule data stored as a Map<String, List<Map<String, String>>>
  Map<String, List<Map<String, String>>> classSchedule = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
  };

  // Form controllers
  String selectedDay = 'Monday';
  TextEditingController subjectController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSchedule(); // Load saved class schedule on app start
  }

  // Function to save schedule to SharedPreferences
  Future<void> saveSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String day in classSchedule.keys) {
      List<String> scheduleList = classSchedule[day]!
          .map((classInfo) => '${classInfo['time']}:${classInfo['subject']}')
          .toList();
      prefs.setStringList(day, scheduleList);
    }
  }

  // Function to load schedule from SharedPreferences
  Future<void> loadSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (String day in classSchedule.keys) {
        List<String>? savedSchedule = prefs.getStringList(day);
        if (savedSchedule != null) {
          classSchedule[day] = savedSchedule.map((entry) {
            List<String> parts = entry.split(':');
            return {'time': parts[0], 'subject': parts[1]};
          }).toList();
        }
      }
    });
  }

  // Function to add a new class to the schedule
  void addClass() {
    setState(() {
      classSchedule[selectedDay]!.add({
        'time': timeController.text,
        'subject': subjectController.text,
      });
      saveSchedule(); // Save the updated schedule
    });
    timeController.clear();
    subjectController.clear();
  }

  // Function to delete a class from the schedule
  void deleteClass(String day, int index) {
    setState(() {
      classSchedule[day]!.removeAt(index);
      saveSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editable Class Schedule'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Form for adding a new class
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Class',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedDay,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue!;
                      });
                    },
                    items: classSchedule.keys.map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: subjectController,
                    decoration: InputDecoration(labelText: 'Subject'),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: InputDecoration(labelText: 'Time'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addClass,
                    child: Text('Add Class'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Displaying the schedule for each day
          ...classSchedule.keys.map((day) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                title: Text(
                  day,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                children: classSchedule[day]!.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String> classInfo = entry.value;
                  return ListTile(
                    title: Text(classInfo['subject']!),
                    subtitle: Text(classInfo['time']!),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteClass(day, index);
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}


