import 'package:Spo2_project/stayfit-health-home.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'stayfit-health-home.dart';
import 'login-register.dart';

void main(){
  runApp(new spo2App());

}
final FirebaseAuth auth = FirebaseAuth.instance;

class spo2App extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'SP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFFC0F0E8),
          primaryColor: Color(0xFF80E1D1),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StayfitHealthPage();
          }
          return LoginRegister();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/stayfit-health-home' : (BuildContext context) => new StayfitHealthPage(),
        '/home': (BuildContext context) => new Home(),
        '/login': (BuildContext context) => new LoginRegister()
      },
    );
  }
}