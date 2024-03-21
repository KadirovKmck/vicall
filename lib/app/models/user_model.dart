import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String userName;
  final String email;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
  });

  Map<String, dynamic> toFirebase() => {
        'id': id,
        'userName': userName,
        'email': email,
      };
  factory UserModel.fromFirebase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
    );
  }
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      email: snapshot['email'], userName: '',
      // Add other fields as necessary
    );
  }
}

class FirebaseCollections {
  static final userCollection = FirebaseFirestore.instance.collection('users');
  static final messagesCollection =
      FirebaseFirestore.instance.collection('message');
}
