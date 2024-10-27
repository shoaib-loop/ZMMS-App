import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image selection
import 'package:firebase_storage/firebase_storage.dart'; // For uploading profile picture
import 'package:cloud_firestore/cloud_firestore.dart'; // For profile data storage
import 'dart:io'; // Import for File handling

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;

  // Example form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // For uploading a new profile picture
  Future<void> _pickAndUploadImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('user_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(pickedImage.path));

      final url = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = url;
      });

      // Save the URL to Firestore
      FirebaseFirestore.instance.collection('users').doc('USER_ID').update({
        'profileImageUrl': _profileImageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            _profileImageUrl != null
                ? Image.network(_profileImageUrl!)
                : const Icon(Icons.person, size: 100),

            TextButton(
              onPressed: _pickAndUploadImage,
              child: const Text('Change Profile Picture'),
            ),

            const SizedBox(height: 20),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            // Email field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Save updated profile details to Firestore
                FirebaseFirestore.instance
                    .collection('users')
                    .doc('USER_ID')
                    .update({
                  'name': _nameController.text,
                  'email': _emailController.text,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated!')),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

