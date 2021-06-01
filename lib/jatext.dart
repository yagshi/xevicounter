import 'package:flutter/cupertino.dart';

class JaText extends StatefulWidget {
  JaText(double val, {Key? key}) : super(key: key) {
    _state.value = val;
  }

  final _JaTextState _state = _JaTextState();

  @override
  _JaTextState createState() {
    return _state;
  }

  void setValue(double value) {
    _state.setState(() {
      _state.value = value;
    });
  }
}

class _JaTextState extends State<JaText> {
  double value = 0;
  static const _digitNames = [
    '',
    '拾',
    '百',
    '阡',
    '萬',
    '',
    '',
    '',
    '億',
    '',
    '',
    ''
  ];
  static const _jfigures = ['〇', '壹', '貮', '參', '肆', '伍', '陸', '漆', '捌', '玖'];
  String _num2ja(double x) {
    int idx = 1;
    int pos = 0;
    String str = "";
    for (; pos < _digitNames.length - 1; pos++, idx *= 10);
    for (; pos >= 0; pos--, idx ~/= 10) {
      if (_digitNames[pos] == '' && pos != 0) continue;
      if (idx > x) continue;
      int d = x ~/ idx;
      if (d == 0 && pos != 0) continue;
      //debugPrint('${d} ${idx}');
      if (d > 9) {
        str += _num2ja(d.toDouble()) + _digitNames[pos];
      } else {
        if (pos == 0 || pos > 2 || d != 1) {
          // 壱拾とか壱百とか言わない
          str += _jfigures[d] + _digitNames[pos];
        } else {
          str += _digitNames[pos];
        }
      }
      x = x - d * idx;
    }
    if (str == '') str = _jfigures[0];
    return str;
  }

  @override
  Widget build(BuildContext context) {
    String jaString = _num2ja(value);
    return Text(
      jaString,
      style: TextStyle(fontSize: 30),
    );
  }
}
