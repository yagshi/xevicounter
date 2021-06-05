import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xevicounter/jatext.dart';
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
  double _sliderValue = 1;
  int _timeCounter = 0;

  List<XeviPainter> digits = [
    XeviPainter(),
    XeviPainter(),
    XeviPainter(),
    XeviPainter(),
  ];
  JaText _jaText = const JaText(0);

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_running) {
        if (--_timeCounter <= 0) {
          _timeCounter = getIntervalTimeCounter(_sliderValue);
          setState(() {
            count++;
            _setValue(count);
          });
        }
      }
    });
    super.initState();
  }

  void _setValue(int num) {
    digits[3].num = (num & 0x000f) >> 0;
    digits[2].num = (num & 0x00f0) >> 4;
    digits[1].num = (num & 0x0f00) >> 8;
    digits[0].num = (num & 0xf000) >> 12;
    _jaText = JaText(num.toDouble());
  }

  int getIntervalTimeCounter(double index) {
    // 0.1, 1, 10, 60
    if (index <= 1) {
      return 1;
    } else if (index <= 2) {
      return 10;
    } else if (index <= 3) {
      return 100;
    } else {
      return 600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;
    List<CustomPaint> rowcontent = [];
    for (XeviPainter element in digits) {
      rowcontent.add(CustomPaint(
        size: Size((width - 10) / 4, (width - 10) / 4),
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
        backgroundColor: const Color(0xfff0fff0),
        appBar: AppBar(title: const Text("XEVICOUNTER")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _running = !_running;
            });
          },
          child: Icon(_running ? Icons.pause : Icons.play_arrow),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowcontent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => setState(() => _setValue(--count)),
                      child: const Icon(Icons.exposure_minus_1_outlined)),
                  const Padding(padding: EdgeInsets.all(20)),
                  Text(
                    (s) {
                      return s.length > 8
                          ? s
                          : (" " * 8 + s).substring(s.length, s.length + 8);
                    }(count.toString()),
                    style: Theme.of(context).textTheme.headline2,
                    //style: const TextStyle(fontSize: 48),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  ElevatedButton(
                      onPressed: () => setState(() => _setValue(++count)),
                      child: const Icon(Icons.exposure_plus_1_outlined)),
                ],
              ),
              _jaText,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("interval:"),
                  Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 4,
                    label:
                        (getIntervalTimeCounter(_sliderValue) / 10).toString() +
                            ' s',
                    divisions: 3,
                    onChanged: (v) {
                      setState(() {
                        _sliderValue = v;
                      });
                    },
                  ),
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ));
  }
}
