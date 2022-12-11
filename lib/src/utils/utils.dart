import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if(s.isEmpty) return false;
  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(
            style: flatButtonStyle,
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Ok'),
          )
        ],
      );
    }
  );
}