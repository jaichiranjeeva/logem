import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

String ss = "", sb = "", p = "";
String res = "";
String xyz = "file";
String plog = '';
bool pause = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.logem/grab');

  int i = 1;
  Future<void> _setlog() async {
    if (true) {
      p = res;
      res = "${await platform.invokeMethod('getLatestLog')}\n";

      i += 1;

      if (p != res) {
        ss = res + ss;
        if (i > 55) {
          ss = sb;
          i = 1;
        } else if (i > 45) {
          sb += ss;
        }
        xyz = xyz;
        setState(() {
          plog = ss;
        });
      }
    }
  }

  Future<void> _printlogs() async {
    const interval = Duration(milliseconds: 200);
    Timer.periodic(interval, (Timer t) async {
      if (!pause) {
        _setlog();
      }
    });
  }

  Future<void> _pa() async {
    setState(() {
      pause = !pause;
    });
  }

  @override
  void initState() {
    _printlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 100,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logem'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: const Icon(Icons.cleaning_services_rounded),
              onPressed: () {
                ss = "";
              },
            ),
            // action button
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                String dmp =
                    await platform.invokeMethod('svelogs', {"log": plog});
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  plog,
                  style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 15.0),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pa,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.pause_circle_outline_outlined),
        ),
      ),
    );
  }
}
