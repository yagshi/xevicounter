import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

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
  List<XeviPainter> xevi = [XeviPainter(), XeviPainter()];
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        count++;
        xevi[0].angle = count.toDouble();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("XEVICOUNTER")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            count++;
            xevi[0].angle = count.toDouble();
          });
        },
        child: const Icon(Icons.plus_one),
      ),
      body: Column(children: [
        CustomPaint(
          size: const Size(400, 400),
          painter: xevi[0],
        ),
        Text(count.toString())
      ]),
    );
  }
}

class XeviPainter extends CustomPainter {
  double angle = 0;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(const Offset(200, 200) & const Size(100, 100), -pi / 2,
        angle / 180 * 6 * pi, true, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
