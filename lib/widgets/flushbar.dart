import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<Widget> buildFlushBar(context, barcodeScanRes, icon, duration) async {
  return await Flushbar(
    icon: Icon(
        icon,
        color: Colors.white,
        size: 30
      ),
    message: barcodeScanRes.toString(),
    messageSize: 20,
    duration: Duration(seconds: duration),
  ).show(context);
}