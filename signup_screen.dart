import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart' as validator;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _guardianFirstNameController =
      TextEditingController();
  final TextEditingController _guardianLastNameController =
      TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  String _role = 'Student';
  String _class = 'Play';
  String _section = 'A';
  String? _generatedCode;
  DateTime? _codeExpirationTime;

  Future<void> _sendVerificationCode() async {
    _generatedCode =
        (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
    _codeExpirationTime = DateTime.now().add(Duration(minutes: 10));
    print('Verification code: $_generatedCode'); // For testing
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      if (_verificationCodeController.text == _generatedCode &&
          DateTime.now().isBefore(_codeExpirationTime!)) {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'role': _role,
            'class': _class,
            'section': _section,
            'mobile': _mobileController.text,
            if (_role == 'Student')
              'guardianFirstName': _guardianFirstNameController.text,
            if (_role == 'Student')
              'guardianLastName': _guardianLastNameController.text,
          });

          Navigator.pushReplacementNamed(context, '/login');
        } catch (e) {
          _showErrorDialog('Error', 'Failed to create an account. Try again.');
        }
      } else {
        _showErrorDialog(
            'Verification Error', 'Invalid or expired verification code.');
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account ($_role)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButton<String>(
                value: _role,
                items: ['Student', 'Teacher', 'Principal'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (newValue) => setState(() => _role = newValue!),
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your first name' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your last name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    validator.isEmail(value!) ? null : 'Enter a valid email',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
              ),
              if (_role == 'Student') ...[
                TextFormField(
                  controller: _guardianFirstNameController,
                  decoration: InputDecoration(labelText: 'Guardian First Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter guardian first name' : null,
                ),
                TextFormField(
                  controller: _guardianLastNameController,
                  decoration: InputDecoration(labelText: 'Guardian Last Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter guardian last name' : null,
                ),
                DropdownButton<String>(
                  value: _class,
                  items: ['Play', 'Nursery', 'Prep', 'One', 'Two']
                      .map((className) {
                    return DropdownMenuItem(
                        value: className, child: Text(className));
                  }).toList(),
                  onChanged: (newValue) => setState(() => _class = newValue!),
                ),
                DropdownButton<String>(
                  value: _section,
                  items: ['A', 'B', 'C', 'D'].map((section) {
                    return DropdownMenuItem(
                        value: section, child: Text(section));
                  }).toList(),
                  onChanged: (newValue) => setState(() => _section = newValue!),
                ),
              ],
              TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(labelText: 'Verification Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter verification code' : null,
              ),
              ElevatedButton(
                onPressed: _sendVerificationCode,
                child: Text('Send Verification Code'),
              ),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



