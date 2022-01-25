import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lockstars_sample/providers/great_places.dart';
import 'package:lockstars_sample/screens/add_place_screen.dart';
import 'package:lockstars_sample/screens/login_screen.dart';
import 'package:lockstars_sample/screens/places_list_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'FlutterSample',
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          debugShowCheckedModeBanner: false,
          // home: const LoginScreen()),
          home: const LoginScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          }),
    );
  }
}
