import 'package:flutter/material.dart';

class ProgressIcons extends StatelessWidget {
  const ProgressIcons({Key? key, required this.total, required this.completo}) : super(key: key);
  final int total;
  final int completo;
  @override
  Widget build(BuildContext context) {
    final iconSize = 50.0;
    final iconCompleto = Icon(
      Icons.beenhere,
      color: Colors.amber,
      size: iconSize,
    );

    final iconIncompleto = Icon(
      Icons.beenhere,
      color: Colors.deepOrange,
      size: iconSize,
    );

    List<Icon> icons = [];

    for (int i = 0; i < total; i++) {
      if (i < completo) {
        icons.add(iconCompleto);
      } else {
        icons.add(iconIncompleto);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: icons,
      ),
    );
  }
}
