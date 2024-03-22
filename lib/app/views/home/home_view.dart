// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vicall/app/test/agora.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seach acount'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: const Column(
          children: [],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final _firestore = FirebaseFirestore.instance;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final currentQuery = query.trim();

    final querySnapshot = _firestore
        .collection('users')
        .where('userName', isEqualTo: currentQuery)
        .get();

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: querySnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final querySnapshot = snapshot.data!;
          if (querySnapshot.size > 0) {
            return UserListView(querySnapshot.docs);
          } else {
            log('No user found with that username.');
            return const Center(
                child: Text(
              'User not found.',
            ));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final querySnapshot = _firestore
        .collection('users')
        .where('userName', isEqualTo: query)
        .get();

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: querySnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (query.isNotEmpty) {
          if (snapshot.connectionState == ConnectionState.done) {
            final querySnapshot = snapshot.data!;
            if (querySnapshot.size > 0) {
              // Got a match!
              log(querySnapshot.docs[0].data().toString());
              return UserListView(querySnapshot.docs);
            } else {
              log('No user found with that email address.');
            }
            return const Center(
              child: Text(
                'User not founded',
                style: TextStyle(fontSize: 35),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }
}

class UserListView extends StatefulWidget {
  const UserListView(this.users, {Key? key}) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> users;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        var user = widget.users[index].data();
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutUser(
                  infoAboutUser: widget.users,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.amber,
            child: ListTile(
              title: Text(
                user['userName'],
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user['email'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AboutUser extends StatefulWidget {
  const AboutUser({super.key, required this.infoAboutUser});

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> infoAboutUser;

  @override
  State<AboutUser> createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Expanded(
              child: ListView.builder(
                itemCount: widget.infoAboutUser.length,
                itemBuilder: (context, index) {
                  var user = widget.infoAboutUser[index].data();
                  return Card(
                    color: Colors.amber,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user['userName'],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyApp(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.video_call,
                              size: 35,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        user['email'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
