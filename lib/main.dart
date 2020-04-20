import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smart_house/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Home",
      home: HomeScreen(),
    );
  }
}
