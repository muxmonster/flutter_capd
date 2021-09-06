import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_login_app/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capd',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white70,
        primaryColor: Colors.cyan,
      ),
      home: LoginPage(),
    );
  }
}
