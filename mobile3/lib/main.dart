import 'package:flutter/material.dart';
import 'package:mobile3/home_screen.dart';

void main() async {
  // // Remove the following line if you have it
  // sqflite.sqfliteFfiInit();

//   sqfliteFfiInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as sqflite_common_ffi_web;
// import 'package:mobile3/home_screen.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// void main() async {
//   sqflite_common_ffi_web.databaseFactory = databaseFactoryFfiWeb;
//   runApp(const MyApp());
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
