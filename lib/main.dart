import 'package:customersearch/crud/editcustomer.dart';
import 'package:customersearch/crud/viewcustomer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './homepage.dart/homepage.dart';
import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'crud/addnewcustomer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //Establish connection with firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 17,color: Colors.white),
          headline2: TextStyle(fontSize: 30,color: Colors.amber),
          headline3: TextStyle(fontSize: 17,color: Colors.amber),
          headline4: TextStyle(fontSize: 30,color: Colors.white),
        )
      ),
      routes: {
        "signup":(context) => SignUp(),
        "login":(context) => LogIn(),
        "homepage":(context) => HomePage(),
        "addcustomer":(context) => AddCustomer(),
        "editcustomer":(context) => EditCustomer(),
        "viewcustomer":(context) => ViewCustomer(),

      },

      home:(FirebaseAuth.instance.currentUser == null)? LogIn():HomePage(),
     );
  }
}