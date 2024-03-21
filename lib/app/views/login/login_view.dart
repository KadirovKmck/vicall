// ignore_for_file: library_private_types_in_public_api, unused_local_variable, use_build_context_synchronously, prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vicall/app/models/user_model.dart';
import 'package:vicall/app/views/home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final UserModel userModel = UserModel(
        id: credential.user!.uid,
        userName: '',
        email: emailController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(),
        ),
      );
      log('login credentiial--> $credential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true, // Hide password input
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
