import 'package:flutter/material.dart';
import 'package:nofa/pages/home.dart';
import 'package:nofa/pages/loading.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
    },
  ));
}

