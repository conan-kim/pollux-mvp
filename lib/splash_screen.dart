import 'package:flutter/material.dart';
import 'package:pollux_mvp/vad_test_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => VADTestPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Pollux MVP APP', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
