import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or update user in Firestore
  Future<void> createUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .set(userData, SetOptions(merge: true));
      print('User data added/updated successfully');
    } catch (e) {
      print('Error adding user data: $e');
    }
  }

  // Fetch user data by userId
  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('users').doc(userId).update(updatedData);
      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
