import 'package:flutter/material.dart';
import 'package:flutter_uas/screen/auth/login.dart';
import 'package:flutter_uas/screen/edit_category.dart';
import 'package:flutter_uas/screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const Login(),
        "/Home": (context) => const Home(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
