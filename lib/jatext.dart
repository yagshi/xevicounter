import 'package:flutter/cupertino.dart';

class JaText extends StatefulWidget {
  JaText(this.num, {Key? key}) : super(key: key);
  double num;
  final _JaTextState _state = _JaTextState();
  @override
  State<StatefulWidget> createState() {
    _state.value = num;
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
  @override
  Widget build(BuildContext context) {
    String jaString = value.toString();
    return Text(jaString);
  }
}
