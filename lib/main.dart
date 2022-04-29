import 'package:flutter/material.dart';
import 'package:xray_detection/home.dart';
import 'package:xray_detection/landing_page.dart';

void main() {
  runApp(const MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      title: 'Covid Detection Using XRAY',
    );
  }
}
