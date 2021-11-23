import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message)=> Fluttertoast.showToast(
  msg: message,
  gravity: ToastGravity.CENTER,
  backgroundColor: Colors.white,
  textColor: Colors.black,
);
