import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  AdaptativeButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(text),
            onPressed: onPressed,
            color: Theme.of(context).primaryColor,
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
          );
  }
}
