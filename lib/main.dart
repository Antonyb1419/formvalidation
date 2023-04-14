import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/producto_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Provider(
        child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: 'login',
          routes: {
            'login': (BuildContext context) => LoginPage(),
            'home': (BuildContext context) => HomePage(),
            'producto': (BuildContext context) => ProductoPage(),

          },
          theme: ThemeData(
            inputDecorationTheme:  InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.deepPurple),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurple
                )
              )
            ),
          ),
        ) ,
    );
   }
  }
