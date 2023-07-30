import 'package:flutter/material.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/Menu.dart';
import 'package:untitled1/UserSheetsApi.dart';
import 'dart:async';



Future main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await UserSheetsApi.init();
   await Data.getAll();
   await MainScreen.init();









       runApp(MaterialApp(
   theme: ThemeData(
      // primarySwatch: _mainColorTheme,
                  ),
    initialRoute: '/todo',
    routes: {
    '/':(context) =>  MainScreen(),
    '/todo': (context) => const Home(),
 //   '/start': (context) =>  RadioWidgetDemo(),
    },
  ));
}


