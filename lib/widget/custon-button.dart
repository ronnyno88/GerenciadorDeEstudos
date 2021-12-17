import 'package:flutter/material.dart';

class CustonButton extends StatelessWidget {
  final onTap;
  final String text;

  const CustonButton({this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      child: RaisedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
