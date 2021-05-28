import 'package:flutter/material.dart';

class XeviPainter extends CustomPainter {
  XeviPainter({this.num = 0});
  int num;
  final List<List<double>> _segments = [
    [0.15, 0.90, 0.85, 0.90], // 1
    [0.90, 0.85, 0.90, 0.15], // 2
    [0.85, 0.10, 0.15, 0.10], // 4
    [0.10, 0.15, 0.10, 0.85], // 8
    [0.20, 0.80, 0.80, 0.20], // 0
  ];
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final p = Paint();
    p.style = PaintingStyle.stroke;
    p.strokeWidth = width / 25;
    final _len = width > height ? height : width;
    canvas.drawLine(Offset(_segments[4][0] * _len, _segments[4][1] * _len),
        Offset(_segments[4][2] * _len, _segments[4][3] * _len), p);
    for (int i = 1, j = 0; i < 15; i += i, j++) {
      if (i & num == 0) continue;
      canvas.drawLine(Offset(_segments[j][0] * _len, _segments[j][1] * _len),
          Offset(_segments[j][2] * _len, _segments[j][3] * _len), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    debugPrint("---");
    return true;
  }
}
