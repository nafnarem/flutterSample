import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatelessWidget {
  static const routeName = '/add-user';
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _ageController = TextEditingController();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    void _tester() {
      _usersStream.listen((value) {
        print(value.docs.map((doc) => doc.id));
      });
    }

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user

      return users
          .add({
            'full_name': _nameController.text, // John Doe
            'company': _companyController.text, // Stokes and Sons
            'age': int.parse(_ageController.text), // 42
          })
          .then((value) => Navigator.of(context).pop())
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Add a new Place'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Full Name'),
                          controller: _nameController,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Company'),
                          controller: _companyController,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Age'),
                          controller: _ageController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _companyController.text.isEmpty ||
                        _ageController.text.isEmpty) {
                      return;
                    }
                    addUser();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add User')),
            ]));
  }
}
