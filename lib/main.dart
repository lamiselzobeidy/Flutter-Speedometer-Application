import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sensors/sensors.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

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
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Speedometer App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _everySecond;
  int _Accelerating_Time = 0;
  int _Decelerating_Time = 0;
  double _Current_Speed = 0;
  int _upCounter = 0;
  int _downCounter = 0;
  bool speeding = false;

  //function to fetch the new speed every second
  void _changeSpeed() {
    var geolocator = Geolocator();
    var options = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(options).listen((position) {
      var speedInMps = position.speed; // current speed in m/s
      print("Your speed: ");
      print(speedInMps);
      _Current_Speed = ((speedInMps * 3.6)*10).roundToDouble(); // current speed in km/h
    });
  }

  @override
  void initState() {
    super.initState();

    // defines a timer with 1 second interval
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {

        //update the current speed each second
        _changeSpeed();

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
