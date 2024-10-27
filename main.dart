import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'firebase_options.dart'; // Import the generated Firebase options
import 'screens/login_screen.dart'; // Import Login screen
import 'screens/signup_screen.dart'; // Import for the Sign-Up screen
import 'screens/home_screen.dart'; // Import Home screen

// Initialize Firebase before the app runs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize with the platform-specific Firebase options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Made the constructor const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZMMS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Start with the login screen
      routes: {
        '/login': (context) => LoginScreen(), // Route for Login screen
        '/signUp': (context) => SignUpScreen(), // Route for Sign-Up screen
        '/home': (context) => HomeScreen(), // Route for Home screen after login
      },
    );
  }
}

