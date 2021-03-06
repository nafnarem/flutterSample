import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lockstars_sample/providers/get_username.dart';
import 'package:lockstars_sample/providers/great_places.dart';
import 'package:lockstars_sample/screens/add_place_screen.dart';
import 'package:lockstars_sample/screens/add_user.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Expanded(
              child: Center(
                  child: Text(
                'Your Places',
                textScaleFactor: 1.5,
              )),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Your Users',
                  textScaleFactor: 1.5,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddUser.routeName);
              },
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
            child: FutureBuilder(
              future: Provider.of<GreatPlaces>(context, listen: false)
                  .fetchAndSetPlaces(),
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<GreatPlaces>(
                      child: Center(
                        child: Text('Got no places yet! Start adding some'),
                      ),
                      builder: (ctx, greatPlaces, ch) => greatPlaces
                              .items.isEmpty
                          ? ch!
                          : ListView.builder(
                              itemCount: greatPlaces.items.length,
                              itemBuilder: (context, index) => ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: FileImage(
                                          greatPlaces.items[index].image),
                                    ),
                                    title: Text(greatPlaces.items[index].title),
                                    subtitle: Text(greatPlaces
                                        .items[index].location!.address!),
                                    onTap: () {},
                                  )),
                    ),
            ),
          ),
          Divider(
            thickness: 2.0,
            color: Colors.black,
          ),
          Expanded(child: GetUserName()),
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.logout),
            ),
          ),
        ]));
  }
}
