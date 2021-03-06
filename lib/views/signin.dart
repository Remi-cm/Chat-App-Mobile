import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerchat/services/auth.dart';
import 'package:customerchat/services/database.dart';
import 'package:customerchat/services/localStorage.dart';
import 'package:customerchat/views/components/appBar.dart';
import 'package:customerchat/views/components/formTools.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _signInFormKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _autovalidate = false;
  bool _buttonState = true;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final hv =MediaQuery.of(context).size.height/100;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: hv*5),
                  Hero(
                    tag: "logo",
                    child: Container(
                      padding: EdgeInsets.all(hv*2.6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.withOpacity(0.1)
                      ),
                      child: CircleAvatar(
                        radius: hv*3.75,
                        backgroundColor: Colors.green,
                        child : Icon(Icons.local_florist, size: hv*5, color: Colors.white)
                        ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      Text("Agro", style: TextStyle(color: Colors.black38, fontSize: hv*3.8, fontWeight: FontWeight.w900 )),
                      Text("Hub", style: TextStyle(color: Colors.green, fontSize: hv*3.9, fontWeight: FontWeight.w900 )),
                    ],),
                  ),

                  Text("A Sustainable Development Goals' project", style: TextStyle(color: Colors.black38, fontSize: hv*1.6, fontWeight: FontWeight.w800 )),
                  SizedBox(height: hv*8)
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _signInFormKey,
                  autovalidate: _autoValidate,
                  child: Column(children: <Widget>[
                    CustomTextField(
                      hintText: "Email",
                      icon: Icons.mail,
                      emptyValidatorText: 'Enter email address',
                      validator: _emailFieldValidator,
                      controller: _emailController,
                    ),
                    SizedBox(height: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CustomPasswordTextField(
                          hintText: "Password",
                          icon: Icons.lock,
                          validator: _passwordFieldValidator,
                          emptyValidatorText: 'Enter password',
                          controller: _passwordController),
                          SizedBox(height: 7),
                          Text("Forgot Password ?  ", style: TextStyle(color: Colors.black38, fontSize: 15, fontWeight: FontWeight.w800 ))
                      ],
                    ),

                      SizedBox(height: hv*3.6),

                      _buttonState ?
                        CustomButton(onPressed: _signIn, text: "Sign In", textColor: Colors.white, color: Colors.green)
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                          child: CircularProgressIndicator(
                          strokeWidth: 4, valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                        ),

                      SizedBox(height: hv*2.1),

                      Row(children: <Widget>[
                        Text("------------   ", style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w100)),
                        Text("Or", style: TextStyle(color: Colors.black38, fontSize: 18, fontWeight: FontWeight.w600 )),
                        Text("   ------------", style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w100)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,),

                      SizedBox(height: hv*2.1),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 27,
                            backgroundColor: Color(0xff3b5998),
                            child: Text("f", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),),
                          ),
                          SizedBox(width: 30,),
                          CircleAvatar(
                          radius: 27,
                          backgroundColor: Color(0xffde5246),
                          child: Icon(MdiIcons.google),
                        ),
                      ],),

                      SizedBox(height: 15)

                      //Center(child: Text("Forgot Password ?", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w800 )),)
                  ],),
                )
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(margin: EdgeInsets.symmetric(vertical: hv*3),
          child: Row(children: <Widget>[
              Text("Don't you have an account?  ", style: TextStyle(color: Colors.black38, fontSize: 15, fontWeight: FontWeight.w600)),
              InkWell(
                child: Text("Sign Up Now", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w600 )),
                onTap: (){Navigator.pushNamed(context, '/signUp');},)
            ],
            mainAxisAlignment: MainAxisAlignment.center,),
        )
      ),
    );
  }

  _signIn (){
    if (_signInFormKey.currentState.validate()){
      print(_passwordController.text+" and "+ _emailController.text);

      //LocalStorage.saveUserName(_nameController.text);
      LocalStorage.saveUserLEmail(_emailController.text);
      
      setState(() {
        _buttonState = false;
      });
 
      databaseMethods.getUserByEmail(_emailController.text)
      .then((val){
        snapshotUserInfo = val;
        LocalStorage.saveUserName(snapshotUserInfo.documents[0].data["username"]);
      }) ;

      authMethods.signInWithEmailAndPassword(_emailController.text, _passwordController.text)
      .then((val){
        if (val == null){
          setState(() {
            _buttonState = true;
          });
          print("error");
        }
        print("${val.userId}");

        LocalStorage.saveUserLoggedInState(true);

        Navigator.pushReplacementNamed(context, "/chatRoom");
      });


    }
    else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

 String _passwordFieldValidator (String value) {
    if (value.length < 6) {
    return "Password must be greater than 5";
    }
  }

  
  //Fonction de validation du numéro de téléphone

  String _emailFieldValidator (String value) {
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return "Provide a valid email";
    }
  }
}