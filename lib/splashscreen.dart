import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_classify_app/testhomescreen.dart';
import 'package:lottie/lottie.dart';

import 'constants.dart';

//import 'HomeScreen.dart';
//

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: Lottie.asset('assets/image classify.json',
                  repeat: true, reverse: true, animate: true),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "          WELCOME TO \n\n Image Classification App",
            style: new TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30.0, color: kTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "By",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Group No - 22",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic),
          ),
        ],
      )),
    );
  }
}
