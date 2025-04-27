
import 'package:bible/home_page.dart';
import 'package:bible/source/speech_source.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(Main());

}

class Main extends StatefulWidget {

  _MainState createState() => _MainState();

}

class _MainState extends State<Main> {
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner:false,
        theme: ThemeData(

        ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();

    SpeechSource.initialize();

  }

  @override
  Widget build(BuildContext context) {

   return  MaterialApp(
    // theme:ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
     theme: ThemeData(

         appBarTheme: AppBarTheme(
           color: Colors.white,
             foregroundColor: Colors.black,

         )
     ),
     debugShowCheckedModeBanner: false,
      home: HomePage(),
    );

  }
}
