import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static String localUserLoggedInKey = "ISLOGGEDIN";
  static String localUserNameKey = "USERNAMEKEY";
  static String localuserEmailKey = "USEREMAILKEY";

  // Saving data to local storage

  static Future<bool> saveUserLoggedInState(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(localUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localUserNameKey, username);
  }

  static Future<bool> saveUserLEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localuserEmailKey, email);
  }

  // Getting data from local storage
  
  static Future<bool> getUserLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(localUserLoggedInKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(localUserNameKey);
  }

  static Future<String> getUserLEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(localuserEmailKey);
  }

  //Clear Storage

   static clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(localUserNameKey);
    await prefs.remove(localuserEmailKey);
  }

  //checking if the logged In state exists in storage
  
  static Future<bool> checkLoggedInStateExistence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(localUserLoggedInKey);
  } 
  
}