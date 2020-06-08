import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:Spo2_project/bloc/theme.bloc.dart';
import 'package:Spo2_project/configs/themes.dart';
import 'package:Spo2_project/progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:Spo2_project/firebase_database_util.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StayfitHealthPage extends StatefulWidget {

  _StayfitHealthPageState createState() => _StayfitHealthPageState();
}

class _StayfitHealthPageState extends State<StayfitHealthPage> {

  FirebaseDatabaseUtil databaseUtil;
  DatabaseReference _bpmRef = FirebaseDatabase.instance.reference().child('BPM');
  DatabaseReference _bTempRef = FirebaseDatabase.instance.reference().child('BTemp');
  DatabaseReference _eTempRef = FirebaseDatabase.instance.reference().child('ETemp');
  DatabaseReference _humRef = FirebaseDatabase.instance.reference().child('Hum');
  DatabaseReference _sStateRef = FirebaseDatabase.instance.reference().child('S_State');

  final DBRef = FirebaseDatabase.instance.reference();
  String name;
  var fruits = ["BPM", "BTemp", "ETemp","Hum","S_State"];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    handleGetBpm(name);
    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
    themeBloc.changeTheme(Themes.stayfit);
  }

  @override
  void dispose() {
    super.dispose();
    databaseUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  'https://www.debuda.net/wp-content/uploads/2017/11/como-decorar-una-habitacion-para-meditar.jpg',
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF422479).withOpacity(0.95),
                        Color(0xFF1C0746).withOpacity(0.75),
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){},
                          child: Container(
                            width: 65,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'SPo2 Anasayfa',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  child: Icon(
                                    Icons.new_releases,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '34',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.favorite),
                                color: Colors.white,
                                onPressed: handleLoginOutPopup,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'ATIM ORANI',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: _bpmRef.onValue,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data.snapshot.value != null) {
                                      return Text(
                                        (snapshot.data.snapshot.value),
                                        style: TextStyle(
                                          fontSize: 70,
                                          letterSpacing: 0.2,
                                          color: Color(0xFFF83B6D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("NO DATA YET"),
                                      );
                                    }
                                  }),
                              SizedBox(width: 10),
                              Text(
                                'BPM',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  width: size.width,
                  height: size.height - size.height * .3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      new FlareActor(
                        "assets/demo.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "record",
                      ),
                      Container(
                        width: size.width,
                        height: size.height - size.height * .28,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.favorite,
                          size: 100,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: size.width,
            height: size.height * .28,
            child:
            Row(
              children: <Widget>[
                StreamBuilder(
                    stream: _eTempRef.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          !snapshot.hasError &&
                          snapshot.data.snapshot.value != null) {
                        return _buildDashboardItem(
                          Color(0xFF23BFFF),
                          Icons.accessibility,
                          70,
                          snapshot.data.snapshot.value+" C°",
                          'DERECE',
                          'VÜCUT',
                        );
                      } else {
                        return _buildDashboardItem(
                          Color(0xFF23BFFF),
                          Icons.accessibility,
                          30,
                          "30"+" C°",
                          'DERECE',
                          'VÜCUT',
                        );
                      }
                    }),
                StreamBuilder(
                    stream: _bTempRef.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          !snapshot.hasError &&
                          snapshot.data.snapshot.value != null) {
                        return _buildDashboardItem(
                          Color(0xFF9CDD5D),
                          Icons.wb_sunny,
                          50,
                          snapshot.data.snapshot.value+" C°",
                          'DERCECE',
                          'ORTAM',
                          true,
                        );
                      } else {
                        return _buildDashboardItem(
                          Color(0xFF9CDD5D),
                          Icons.wb_sunny,
                          80,
                          '80'+" C°",
                          'DERCECE',
                          'ORTAM',
                          true,
                        );
                      }
                    }),
                StreamBuilder(
                    stream: _humRef.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          !snapshot.hasError &&
                          snapshot.data.snapshot.value != null) {
                        return _buildDashboardItem(
                          Color(0xFFFFC537),
                          Icons.invert_colors,
                          10,
                          snapshot.data.snapshot.value+' %',
                          'GRAM/M³',
                          'NEM',
                        );
                      } else {
                        return _buildDashboardItem(
                          Color(0xFFFFC537),
                          Icons.invert_colors,
                          50,
                          '50'+' %',
                          'GRAM/M³',
                          'NEM',
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget handleLoginOutPopup() {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Login Out",
      desc: "Do you want to login out now?",
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.teal,
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: handleSignOut,
          color: Colors.teal,
        )
      ],
    ).show();
  }
  void handleGetBpm(name) async{ // NOTE THE ASYNC HERE
    //use await to wait for async execution
    fruits.forEach((fruit) =>
        DBRef.child(fruit).once().then((DataSnapshot dataSnapShot){
          name = dataSnapShot.value;
          print("one $name");
          return name;
        })
    );
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await auth.signOut().then((onValue) {
      Navigator.of(context).pushReplacementNamed('/login');
    });

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => spo2App()),
            (Route<dynamic> route) => false);
  }


  Widget _buildDashboardItem(Color color, IconData icon,
      double completedPercentage, String value, String unit, String name,
      [bool useLight = false]) {
    List<Color> colors = [
      Color(0xFF311b5b),
      Color(0xFF221441),
    ];

    if (useLight) {
      colors = [
        Color(0xFF311b5b),
        Color(0xFF321c5c),
      ];
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomPaint(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          value,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          unit,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  foregroundPainter: ProgressPainter(
                    percentageCompletedCircleColor: color,
                    completedPercentage: completedPercentage,
                    circleWidth: 10.0,
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}