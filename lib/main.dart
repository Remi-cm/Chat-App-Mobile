import 'package:customerchat/routes.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        accentColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),

      navigatorKey: _navigatorKey,
      onGenerateRoute: Routes.generateRoute, 
    );
  }
}
