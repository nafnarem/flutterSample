import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUser extends StatefulWidget {
  static const routeName = '/update-user';

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class Arguments {
  final String id;
  final String name;
  final String company;
  final int age;
  Arguments(this.id, this.name, this.company, this.age);
}

class _UpdateUserState extends State<UpdateUser> {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Arguments;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> updateUser() {
      return users
          .doc(args.id)
          .update({
            'full_name': _nameController.text, // John Doe
            'company': _companyController.text, // Stokes and Sons
            'age': int.parse(_ageController.text), // 42
          })
          .then((value) => Navigator.of(context).pop())
          .catchError((error) => print("Failed to add user: $error"));
    }

    _nameController.text = args.name;
    _ageController.text = args.age.toString();
    _companyController.text = args.company;

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
                    updateUser();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add User')),
            ]));
  }
}
