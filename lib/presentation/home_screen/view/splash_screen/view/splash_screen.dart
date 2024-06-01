import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:music_player_app/presentation/home_screen/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2, milliseconds: 150),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: Lottie.asset("assets/animations/music.json"),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 23, 102, 240),
            Color.fromARGB(255, 248, 44, 248),
            Color.fromARGB(255, 23, 173, 242)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
      ),
    );
  }
}
