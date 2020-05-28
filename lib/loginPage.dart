import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndLogin(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  void validateAndSubmit() async{
    if(validateAndLogin()){
      try {
        FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        print('Kullanıcı Girişi Başarılı ${user.uid}');
      }
      catch(e){
        print('Hata: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Spo2 Login Sayfasına Hoş Geldiniz.")
      ),
      body: new Container(
        padding: EdgeInsets.all(25.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Lütfen E-Posta Adresinizi Giriniz.'),
                validator: (value) => value.isEmpty ? "E-Posta adresinizi boş bırakmayınız" : null ,
                onSaved: (value) => _email=value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Lütfen Şifrenizi Giriniz.'),
                obscureText: true,
                validator: (value) => value.isEmpty ? "Şifrenizi boş bırakmayınız"  : null ,
                onSaved: (value) => _password=value,
              ),
              new RaisedButton(
                child: new Text("GİRİŞ", style: new TextStyle(fontSize: 15)),
                onPressed: validateAndSubmit,
              )
            ],
          ),
        ),
      )
    );
  }
}