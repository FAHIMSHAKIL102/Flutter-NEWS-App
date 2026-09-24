import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/view/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.heightOf(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Image.asset(
            'assets/images/splash_pic.jpg',
            height: height * .5,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: height * .04),
          Text(
            'TOP HEADLINES',
            style: GoogleFonts.anton(
              letterSpacing: .6,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: height * .04),
          SpinKitChasingDots(color: Colors.blue, size: 50),
        ],
      ),
    );
  }
}
