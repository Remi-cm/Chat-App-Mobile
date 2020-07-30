import 'dart:async';

import 'package:customerchat/services/localStorage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _loggedIn = true;
  bool _loggedInStateExists;

  getLoggedInState () async {
    await LocalStorage.getUserLoggedInState().then((value){
      setState(() {
        _loggedIn = value;
      });
      print("$value");

    });
  }

  checkLoggedInStateExistence () async {
    bool val = await LocalStorage.checkLoggedInStateExistence();
    setState(() {
      _loggedInStateExists = val;
    });
  }

  @override
  void initState() {
    checkLoggedInStateExistence();
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    Timer(
      Duration(seconds: 3),
      (){ 
        if(_loggedInStateExists){
          _loggedIn ? Navigator.pushNamed(context, '/chatRoom') : Navigator.pushNamed(context, '/signIn');
        }
        else {Navigator.pushNamed(context, '/signIn');  }
        }
    );
    return Scaffold(
      body: Center(
        child: Text("Splash screeeeen !!")
      ),
    );
  }
}