import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_login_app/my_constant.dart';
import 'package:simple_login_app/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController ctrlTelephone = TextEditingController();
  bool isLogin = false;

// Check Logged
  Future<Null> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.get('isLogin');

    if (isLogin == 'ok') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  //Login Method
  Future<Null>? doLogin({required String telephone}) async {
    String apiCheckAuthen = '${MyConfigs.domain}/login.php?u=$telephone';
    final response = await http.post(Uri.parse(apiCheckAuthen));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('##### Data : $jsonResponse');
      try {
        String resTelephone = jsonResponse['data'][0]['telephone'];
        if (resTelephone == telephone) {
          print('##### Login Success');
          // เก็บค่าที่ได้จากฐานข้อมูลลง File
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('isLogin', 'ok');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        print('### Error message : $e');
        final snackBar = SnackBar(
          content: Text(
            'เกิดข้อผิดพลาด : ไม่พบข้อมูลในระบบ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'FC-Lamoon',
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    // await Dio().get(apiCheckAuthen).then((value) {
    // print(json.decode(value.data));
    // for (var item in json.decode(value.data)) {
    //   UserModel model = UserModel.fromMap(item);
    //   print(model.fullname);
    // }

    // await Dio().get('https://www.google.co.th').then((value) async {
    //   print('## value for API ==>> $value');
    //   if (value.toString() == 'null') {
    //     final snackBar = SnackBar(
    //       content: Text(
    //         'เกิดข้อผิดพลาด !!!',
    //         style: TextStyle(
    //             fontWeight: FontWeight.w400,
    //             fontFamily: 'EkkamaiStandard-Light'),
    //       ),
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   } else {
    //     for (var item in json.decode(value.data)) {
    //       UserModel model = UserModel.fromMap(item);
    //       if (telephone == model.telephone) {
    // //Success Authen
    //         String type = model.type;
    //         print('## Authen Success in Type ==> $type');
    //       }
    //     }
    //   }
    // });
  }

  @override
  void initState() {
    getLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Colors.cyan[700],
              ),
              ListView(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: MyConfigs.logoImage,
                          width: size * 0.6,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                MyConfigs.appName,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          child: Column(
                            children: [
                              Container(
                                width: size * 0.8,
                                child: TextFormField(
                                  controller: ctrlTelephone,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'FC-Lamoon',
                                        color: MyConfigs.dark),
                                    labelText: 'ระบุหมายเลขโทรศัพท์',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: MyConfigs.dark),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: MyConfigs.light),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    prefixIcon: Icon(
                                      Icons.mobile_friendly,
                                      color: MyConfigs.dark,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                width: size * 0.6,
                                height: 60.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    doLogin(telephone: ctrlTelephone.text);
                                  },
                                  child: Text(
                                    'ลงชื่อเข้าใช้งาน',
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'FC-Lamoon',
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: MyConfigs.darker,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'โรงพยาบาลบ้านหมี่',
                                                style: TextStyle(
                                                  fontFamily: 'FC-Lamoon',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.9,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '| Version: 1.0.0',
                                              style: TextStyle(
                                                  fontFamily: 'FC-Lamoon',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.9),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
