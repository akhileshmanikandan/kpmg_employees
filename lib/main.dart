import 'package:flutter/material.dart';
import 'package:kpmg_employees/login_page.dart';
import './welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}


class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}