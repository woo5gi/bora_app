import 'package:flutter/material.dart';
var theme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey,
    )
  ),
  iconTheme: IconThemeData(color: Colors.red, size: 60),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    titleTextStyle: TextStyle(color: Colors.black,fontSize: 25),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      color : Colors.blue,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 2,
      selectedItemColor: Colors.black,
  ),
);