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
      title: 'Flutter Demo',
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
  List<XeviPainter> digits = [
    XeviPainter(),
    XeviPainter(),
    XeviPainter(),
    XeviPainter(),
  ];
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 10), (t) {
      setState(() {
        count++;
        digits[3].num = (count & 0x000f) >> 0;
        digits[2].num = (count & 0x00f0) >> 4;
        digits[1].num = (count & 0x0f00) >> 8;
        digits[0].num = (count & 0xf000) >> 12;
      });
    });
    super.initState();
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

    return Scaffold(
        appBar: AppBar(title: const Text("XEVICOUNTER")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: const Icon(Icons.plus_one),
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
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ));
  }
}
