import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lockstars_sample/providers/update_users.dart';
import 'package:lockstars_sample/screens/add_user.dart';

class GetUserName extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> deleteUser(id) {
    return users
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Widget build(BuildContext context) {
    void _edit(id, fullName, company, age) {
      Navigator.of(context).pushNamed(UpdateUser.routeName,
          arguments: Arguments(id, fullName, company, age));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            var fullName = data['full_name'];
            var age = data['age'];
            var company = data['company'];
            var id = document.id;
            return Center(
              child: ListTile(
                  title: Text(
                    '$company ',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    children: [
                      Text("Full Name: $fullName $age"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () =>
                                  _edit(id, fullName, company, age),
                              icon: Icon(Icons.edit),
                              label: Text('Edit')),
                          ElevatedButton.icon(
                              onPressed: () => deleteUser(id),
                              icon: Icon(Icons.delete),
                              label: Text('Delete')),
                        ],
                      )
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }
}
