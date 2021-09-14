import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_login_app/my_constant.dart';
import 'package:simple_login_app/pages/member_main_page.dart';
import 'package:simple_login_app/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasImage = true;
  Future<Null> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.get('isLogin');
    print('##### Status Login : $isLogin');
  }

  Future<Null> getLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogout = await prefs.setString('isLogin', 'no');
    print('##### Status Login : $isLogout');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    getLogin();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: MyConfigs.darker,
      title: Text(
        'หน้าหลัก',
        style: TextStyle(
            fontFamily: 'FC-Lamoon',
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            letterSpacing: 0.6),
      ),
    );

    Widget drawer = Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: hasImage
                  ? CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/member_picture.png'))
                  : CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(
                        'M',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                    ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/drawer_bg.jpg'),
                ),
              ),
              accountName: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Text(
                  'iMuxmonster',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              accountEmail: Text('main@gmail.com')),
          ListTile(
            leading: Icon(Icons.home),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('หน้าเมนูใช้งานหลัก'),
            title: const Text(
              'หน้าหลัก',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('ข้อมูลผู้ใช้งาน'),
            title: const Text(
              'ข้อมูลผู้ใช้งาน',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('Setting'),
            title: const Text(
              'ตั้งค่าการใช้งาน',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            trailing: Icon(Icons.logout),
            subtitle: Text('Logout'),
            title: const Text(
              'ลงชื่อออกจากระบบ ',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'FC-Lamoon',
                color: Colors.red,
              ),
            ),
            onTap: () => getLogout(),
          ),
          ListTile(
            tileColor: Colors.pink,
            trailing: Icon(Icons.exit_to_app),
            subtitle: Text('Exit'),
            title: const Text(
              'ออกจากโปรแกรม',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
                  fontFamily: 'FC-Lamoon',
                  fontWeight: FontWeight.w700),
            ),
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      // body: Container(
      //   child: GridView.builder(
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 2, mainAxisSpacing: 5),
      //     itemBuilder: (context, int index) {
      //       return Container(
      //         child: Container(
      //           color: MyConfigs.darker,
      //           child: Card(
      //             child: Container(
      //               color: Colors.white,
      //               child: Text('data'),
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //     itemCount: 4,
      //   ),
      // )

      body: MemberMainPage(),
      // body: Card(
      //   child: GridView.count(
      //     padding: const EdgeInsets.all(10.0),
      //     mainAxisSpacing: 2,
      //     crossAxisSpacing: 2,
      //     crossAxisCount: 2,
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.all(5.0),
      //         child: Card(
      //           child: Container(
      //             color: Colors.white,
      //             padding: EdgeInsets.all(8.0),
      //             child: Column(
      //               children: [
      //                 Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       child: IconButton(
      //                         onPressed: () {},
      //                         icon:
      //                             Image.asset('assets/images/appointment.png'),
      //                         iconSize: 80.0,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   children: [
      //                     const Text(
      //                       'ข้อมูลการนัดหมาย',
      //                       style: TextStyle(
      //                         fontFamily: 'FC-Lamoon',
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold,
      //                         letterSpacing: 0.5,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         color: MyConfigs.darker,
      //       ),
      //       Container(
      //         padding: const EdgeInsets.all(5.0),
      //         child: Card(
      //           child: Container(
      //             color: Colors.white,
      //             padding: EdgeInsets.all(8.0),
      //             child: Column(
      //               children: [
      //                 Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       child: IconButton(
      //                         onPressed: () {},
      //                         icon:
      //                             Image.asset('assets/images/record_dialy.png'),
      //                         iconSize: 80.0,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   children: [
      //                     const Text(
      //                       'บันทึกข้อมูลรายวัน',
      //                       style: TextStyle(
      //                         fontFamily: 'FC-Lamoon',
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold,
      //                         letterSpacing: 0.5,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         color: MyConfigs.darker,
      //       ),
      //       Container(
      //         padding: const EdgeInsets.all(5.0),
      //         child: Card(
      //           child: Container(
      //             color: Colors.white,
      //             padding: EdgeInsets.all(8.0),
      //             child: Column(
      //               children: [
      //                 Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       child: IconButton(
      //                         onPressed: () {},
      //                         icon: Icon(Icons.inbox, color: Colors.blue),
      //                         //Image.asset('assets/images/record_dialy.png'),
      //                         iconSize: 80.0,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   children: [
      //                     const Text(
      //                       'รับน้ำยาล้างไต',
      //                       style: TextStyle(
      //                         fontFamily: 'FC-Lamoon',
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold,
      //                         letterSpacing: 0.5,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         color: MyConfigs.darker,
      //       ),
      //       Container(
      //         padding: const EdgeInsets.all(5.0),
      //         child: Card(
      //           child: Container(
      //             color: Colors.white,
      //             padding: EdgeInsets.all(8.0),
      //             child: Column(
      //               children: [
      //                 Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       child: IconButton(
      //                         onPressed: () {},
      //                         icon: Icon(
      //                           Icons.outbox,
      //                           color: Colors.pink,
      //                         ),
      //                         //Image.asset('assets/images/record_dialy.png'),
      //                         iconSize: 80.0,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   children: [
      //                     const Text(
      //                       'จ่ายน้ำยาล้างไต',
      //                       style: TextStyle(
      //                         fontFamily: 'FC-Lamoon',
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold,
      //                         letterSpacing: 0.5,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         color: MyConfigs.darker,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
