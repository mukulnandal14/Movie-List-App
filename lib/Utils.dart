import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_hud/progress_hud.dart';

final String tableUser = 'user';
final String columnId = '_id';
final String columnMovie = 'movie';
final String columnPhoto = 'photo';
final String columnDirector = 'director';

showtoast(String string) {
  Fluttertoast.showToast(
      msg: "$string",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0);
}

showProgress() {
  return ProgressHUD(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Colors.black38,
    borderRadius: 5.0,
    text: 'Loading...',
  );
}