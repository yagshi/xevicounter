import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'xevipainter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XeviCounter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'XEVICOUNTER'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int count = 0;
  int preset = 0;
  bool _running = false;

  List<XeviPainter> digits = [
    XeviPainter(),
    XeviPainter(),
    XeviPainter(),
    XeviPainter(),
  ];
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_running) {
        setState(() {
          count++;
          _setValue(count);
        });
      }
    });
    super.initState();
  }

  void _setValue(int num) {
    digits[3].num = (num & 0x000f) >> 0;
    digits[2].num = (num & 0x00f0) >> 4;
    digits[1].num = (num & 0x0f00) >> 8;
    digits[0].num = (num & 0xf000) >> 12;
  }

  @override
  Widget build(BuildContext context) {
    List<CustomPaint> rowcontent = [];
    for (XeviPainter element in digits) {
      rowcontent.add(CustomPaint(
        size: const Size(100, 100),
        painter: element,
      ));
    }
    final numField = TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: "number"),
      onChanged: (str) {
        int _x = 0;
        try {
          _x = int.parse(str);
          preset = _x;
        } on FormatException {
          preset = 0;
        }
        preset = int.parse(str);
      },
    );

    return Scaffold(
        appBar: AppBar(title: const Text("XEVICOUNTER")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _running = !_running;
            });
          },
          child: Icon(_running ? Icons.play_arrow : Icons.pause),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowcontent,
              ),
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 48),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: numField,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          count = preset;
                          _setValue(count);
                        });
                      },
                      child: const Text("Set")),
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ));
  }
}
