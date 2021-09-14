import 'package:flutter/material.dart';

class MyConfigs {
  static String appName = 'C-A-P-D';
  static String domain = 'http://banmihospital.moph.go.th/backend2';
  static AssetImage logoImage = AssetImage('assets/images/logo.png');

  static Color primary = Color(0xff87861d);
  static Color dark = Color(0xff575900);
  static Color darker = Color(0xff0088a3);
  static Color light = Color(0xffb9b64e);

  TextStyle labelText() => TextStyle(
      fontSize: 14.0,
      fontFamily: 'FC-Lamoon',
      color: dark,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.8);
}
