// ignore_for_file: library_private_types_in_public_api, invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vicall/app/models/user_model.dart';
import 'package:vicall/app/views/home/home_view.dart';
import 'package:vicall/app/views/login/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? errorMessege = '';
  bool isLoding = false;
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUp() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      log('user Credential--> $userCredential');
      addUser(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (kata) {
      rethrow;
    }
  }

  addUser(UserCredential userCredential) async {
    // final fcmToken = FirebaseMessaging.instance.getToken();

    final UserModel userModel = UserModel(
      id: userCredential.user!.uid,
      userName: userNameController.text,
      email: emailController.text,
    );
    FirebaseCollections.userCollection
        .doc(userCredential.user!.uid)
        .set(userModel.toFirebase())
        .then((value) {
      log("User Added");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }).catchError((error) => log("Failed to add user: $error"));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: const Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              },
              child: const Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}
