// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<void> singIn({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> singOut() async {
    await _firebaseAuth.signOut();
  }
}
