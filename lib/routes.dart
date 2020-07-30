import 'package:flutter/material.dart';
import 'views/signin.dart';
import 'views/signup.dart';
import 'views/chatRoom.dart';
import 'views/search.dart';
import 'views/conversation.dart';
import 'views/splashScreen.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreen()); 
      case '/signIn':
        return MaterialPageRoute(builder: (context) => SignIn());  
      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());  
      case '/chatRoom':
        return MaterialPageRoute(builder: (context) => ChatRoom());  
      case '/search':
        return MaterialPageRoute(builder: (context) => Search()); 
      case '/conversation':
        return MaterialPageRoute(builder: (context) => Conversation(chatRoom: arguments));
      case '/splashScreen':
        return MaterialPageRoute(builder: (context) => SplashScreen());


      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child:Text('Erreur 404 : Page Introuvable')
            )
          )
        );
    }
  }
}