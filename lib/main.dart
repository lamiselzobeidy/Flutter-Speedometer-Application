import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sensors/sensors.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Speedometer App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random random = new Random();
  Timer _everySecond;
  var changeaccelerometer ;
  int _Accelerating_Time = 0;
  int _Decelerating_Time = 0;
  int _Current_Speed = 0;
  int _CurrentSpeed = 0;
  int _upCounter = 0;
  int _downCounter = 0;
  bool speeding = false;

  //function to fetch the new speed
  int _changeSpeed() {
    int _speed;
    _speed = (changeaccelerometer.round().abs()) * 10;
    if (_speed < 10) {
      _speed = 10;
    } else if (_speed > 30) {
      _speed = 30;
    }
    return _speed;
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      changeaccelerometer = event.y;
      print(event.y);
    });
    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {

        //update the current speed
        _Current_Speed = _changeSpeed();

        //speeding is set to true when the driver reaches speed of 30 km/h else the speeding is set to false
        if (speeding) {
          if (_Current_Speed == 10) {
            speeding = false;
            _Decelerating_Time = _downCounter;
            _downCounter = 0;
          }
          _downCounter++;
        } else {
          if (_Current_Speed >= 30) {
            speeding = true;
            _Accelerating_Time = _upCounter;
            _upCounter = 0;
          }
          _upCounter++;
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Speed',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            Text(
              '$_Current_Speed',
              style: GoogleFonts.changa(
                fontSize: 60.0,
                color: Colors.green
              ),
            ),
            Text(
              'km/h \n\n',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'From 10 to 30',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            Text(
              '$_Accelerating_Time',
              style: GoogleFonts.changa(
                  fontSize: 35.0,
                  color: Colors.green
              ),
            ),
            Text(
              'Seconds \n',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'From 30 to 10',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            Text(
              '$_Decelerating_Time',
              style: GoogleFonts.changa(
                  fontSize: 35.0,
                  color: Colors.green
              ),
            ),
            Text(
              'Seconds',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
