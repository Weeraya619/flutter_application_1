import 'package:flutter/material.dart';
import 'package:flutter_application_1/week3.dart';

void main() {
  runApp(const MyApp());
}

// class state
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: Week3(),
    );
  }
}
