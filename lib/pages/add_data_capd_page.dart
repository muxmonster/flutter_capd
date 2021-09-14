import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_login_app/models/kind_fluid_color.dart';
import 'package:simple_login_app/my_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AddDataCapdPage extends StatefulWidget {
  const AddDataCapdPage({Key? key}) : super(key: key);

  @override
  _AddDataCapdPageState createState() => _AddDataCapdPageState();
}

class _AddDataCapdPageState extends State<AddDataCapdPage> {
  TextEditingController ctrlVstdate = TextEditingController();
  TextEditingController ctrlTimeInFluidBegin = TextEditingController();
  TextEditingController ctrlTimeInFluidEnd = TextEditingController();
  TextEditingController ctrlInFluidValue = TextEditingController();
  TextEditingController ctrlTimeOutFluidBegin = TextEditingController();
  TextEditingController ctrlTimeOutFluidEnd = TextEditingController();
  TextEditingController ctrlOutFluidValue = TextEditingController();
  TextEditingController ctrlSumFluidValue = TextEditingController();

  DateTime? vstdate;
  String? numof;
  String? typeFluid;

  /// ลักษณะสีของน้ำยา
  String? kindFluidColor;

  DateTime? timeInFluidBegin;
  DateTime? timeInFluidEnd;

  DateTime? timeOutFluidBegin;
  DateTime? timeOutFluidEnd;

  /// ตรวจสอบ กำไร/ขาดทุน น้ำยา
  bool isLoss = true;

  /// Loading
  bool isLoading = true;

  final listNumOf = ['1', '2', '3', '4', '5'];
  final listTypeFluid = ['1.5', '2.0', '2.5', '3.0', '3.5', '4.0'];
  // final listKindFluidColor = ['แดงจาง + ใส', 'เหลือง + ใส'];

  /// เตรียมข้อมูลก่อนบันทึก
  Future<Null> prepareData() async {
    print(kindFluidColor);
  }

  /// ดึงข้อมูลมาจาก ฐานข้อมูล ตาราง kind_fluid_color
  List<String> listKindFluidColor = [];

  Future<Null> loadKindFluidColor() async {
    var url = Uri.parse('${MyConfigs.domain}/api/kindfluid');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        // listKindFluidColor = jsonDecode(response.body);
        // print(jsonResponse['data']);

        setState(() {
          isLoading = false;
          listKindFluidColor.clear();
          for (var item in jsonResponse['data']) {
            listKindFluidColor.add(item['kind_fluid_color_detail']);
            //print(item['kind_fluid_color_detail']);
          }
        });
      } else {
        isLoading = false;
        print('##### Error code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('Error: $e');
      isLoading = false;
    }
  }

  Future<Null> _loadKindFluidColor() async {
    var dio = Dio();
    String url = '${MyConfigs.domain}/api/kindfluid';
    await dio.get(url).then((value) {
      if (value.data == null) return;
      print(value.data);
      listKindFluidColor.clear();
      for (var item in json.decode(value.data['data'])) {
        KindFluidColorModel model = KindFluidColorModel.fromMap(item);
        listKindFluidColor.add(model.kind_fluid_color_detail);
        // print('##### ${model.kind_fluid_color_detail}');
        // print(listKindFluidColor);
      }
    }).catchError((error, stackTrace) {
      listKindFluidColor.add('ไม่พบข้อมูล');
    }).whenComplete(() => dio.interceptors.requestLock.unlock());
  }

  /// รายการลักษณะสีของน้ำยา
  DropdownMenuItem<String> buildMenuKindFluidColor(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              fontFamily: 'FC-Lamoon'),
        ),
      );

  /// คำนวณปริมาตรน้ำยา
  void calculateVolume(int volumeFluidIn, int volumeFluidOut) {
    if (volumeFluidIn == '') volumeFluidIn = 0;
    if (volumeFluidOut == '') volumeFluidIn = 0;

    ctrlSumFluidValue.text = (volumeFluidOut - volumeFluidIn).toString();
    setState(() {
      if (volumeFluidOut - volumeFluidIn >= 0)
        isLoss = true;
      else
        isLoss = false;
    });
  }

  /// เวลาสิ้นสุดการปล่อยน้ำยาออก
  Future<Null> pickTimeOutFluidEnd(BuildContext context) async {
    await CupertinoRoundedDatePicker.show(
      context,
      use24hFormat: true,
      era: EraMode.BUDDHIST_YEAR,
      textColor: Colors.white,
      background: Colors.indigo,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (_rTime) {
        if (_rTime == null) return;
        setState(() {
          timeOutFluidEnd = _rTime;
          print(timeOutFluidEnd);
          ctrlTimeOutFluidEnd.text =
              DateFormat('HH:mm').format(timeOutFluidEnd!);
        });
      },
    );
  }

  /// เวลาเริ่มปล่อยน้ำยาออก
  Future<Null> pickTimeOutFluidBegin(BuildContext context) async {
    await CupertinoRoundedDatePicker.show(
      context,
      use24hFormat: true,
      era: EraMode.BUDDHIST_YEAR,
      textColor: Colors.white,
      background: Colors.cyan,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (_rTime) {
        if (_rTime == null) return;
        setState(() {
          timeOutFluidBegin = _rTime;
          print(timeOutFluidBegin);
          ctrlTimeOutFluidBegin.text =
              DateFormat('HH:mm').format(timeOutFluidBegin!);
        });
      },
    );
  }

  /// เวลาสิ้นสุดนำน้ำยาเข้า
  Future<Null> pickTimeInFluidEnd(BuildContext context) async {
    await CupertinoRoundedDatePicker.show(
      context,
      use24hFormat: true,
      era: EraMode.BUDDHIST_YEAR,
      textColor: Colors.white,
      background: Colors.indigo,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (_rTime) {
        if (_rTime == null) return;
        setState(() {
          timeInFluidEnd = _rTime;
          print(timeInFluidEnd);
          ctrlTimeInFluidEnd.text = DateFormat('HH:mm').format(timeInFluidEnd!);
        });
      },
    );
  }

  /// เวลาเริ่มปล่อยนำน้ำยาเข้า
  Future<Null> pickTimeInFluidBegin(BuildContext context) async {
    await CupertinoRoundedDatePicker.show(
      context,
      use24hFormat: true,
      era: EraMode.BUDDHIST_YEAR,
      textColor: Colors.white,
      background: Colors.cyan,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (_rTime) {
        if (_rTime == null) return;
        setState(() {
          timeInFluidBegin = _rTime;
          print(timeInFluidBegin);
          ctrlTimeInFluidBegin.text =
              DateFormat('HH:mm').format(timeInFluidBegin!);
        });
      },
    );
  }

  /// รายการชนิดของน้ำยา
  DropdownMenuItem<String> buildMenuTypeFluid(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22.0,
              fontFamily: 'FC-Lamoon'),
        ),
      );

  /// จำนวนรอบต่อวัน
  DropdownMenuItem<String> buildMenuItemNumOf(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22.0,
              fontFamily: 'FC-Lamoon'),
        ),
      );

  /// วันที่บันทึกข้อมูล
  Future<Null> pickRoundVstdate(BuildContext context) async {
    DateTime? _vstdate = await showRoundedDatePicker(
        textPositiveButton: 'ตกลง',
        textNegativeButton: 'ยกเลิก',
        context: context,
        locale: Locale('th', 'TH'),
        era: EraMode.BUDDHIST_YEAR);

    if (_vstdate == null) return;
    setState(() {
      vstdate = _vstdate;
      print(vstdate);
      ctrlVstdate.text = DateFormat('yyyy-MM-dd').format(vstdate!);
    });
  }

  /// Load ค่าเริ่มต้น
  @override
  void initState() {
    super.initState();
    loadKindFluidColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyConfigs.darker,
        title: Text(
          'บันทึกข้อมูล CAPD',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'FC-Lamoon',
              fontWeight: FontWeight.w500,
              fontSize: 24.0,
              color: Colors.white),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: loadKindFluidColor,
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.group_add,
                                    size: 50.0,
                                    color: Colors.black54,
                                  ),
                                  title: const Text(
                                    'บันทึกข้อมูล CAPD',
                                    style: TextStyle(
                                        fontFamily: 'FC-Lamoon',
                                        fontSize: 24.0),
                                  ),
                                  subtitle: Text(
                                    'ระบบบันทึกข้อมูล Capd ตามรอบวัน',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontFamily: 'FC-Lamoon'),
                                  ),
                                ),
                                Divider(),
                                Column(
                                  children: [
                                    /// วันที่บันทึกข้อมูล
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onTap: () => pickRoundVstdate(context),
                                        controller: ctrlVstdate,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                            suffixIcon: Icon(Icons.date_range),
                                            border: OutlineInputBorder(),
                                            labelText: 'วันที่บันทึกข้อมูล',
                                            labelStyle: TextStyle(
                                                fontFamily: 'FC-Lamoon')),
                                      ),
                                    ),

                                    /// ครั้งที่/รอบที่ (1,2,3, ...5)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                                labelText: 'ครั้งที่/รอบที่',
                                                labelStyle: TextStyle(
                                                    fontFamily: 'FC-Lamoon'),
                                                border: OutlineInputBorder()),
                                            value: numof,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: Colors.black45),
                                            isExpanded: true,
                                            items: listNumOf
                                                .map(buildMenuItemNumOf)
                                                .toList(),
                                            onChanged: (_numof) =>
                                                setState(() => numof = _numof)),
                                      ),
                                    ),

                                    /// ชนิดของน้ำยา (1.5, 2.0, 2.5, ...4)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                                labelText: 'ชนิดของน้ำยา',
                                                labelStyle: TextStyle(
                                                    fontFamily: 'FC-Lamoon'),
                                                border: OutlineInputBorder()),
                                            value: typeFluid,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: Colors.black45),
                                            isExpanded: true,
                                            items: listTypeFluid
                                                .map(buildMenuTypeFluid)
                                                .toList(),
                                            onChanged: (fluid) => setState(
                                                () => typeFluid = fluid)),
                                      ),
                                    ),

                                    /// เวลาเริ่มปล่อยน้ำยาเข้าท้อง
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onTap: () =>
                                            pickTimeInFluidBegin(context),
                                        controller: ctrlTimeInFluidBegin,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText:
                                              'เวลาเริ่มปล่อย(น้ำยาเข้า)',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon'),
                                          suffixIcon: Icon(Icons.timer),
                                        ),
                                      ),
                                    ),

                                    /// เวลาสิ้นสุดนำน้ำยาเข้าท้อง
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onTap: () =>
                                            pickTimeInFluidEnd(context),
                                        controller: ctrlTimeInFluidEnd,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'เวลาสิ้นสุด(น้ำยาเข้า)',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon'),
                                          suffixIcon: Icon(Icons.timer),
                                        ),
                                      ),
                                    ),

                                    /// ปริมาตรน้ำยาเข้า
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        //textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onTap: () {},
                                        controller: ctrlInFluidValue,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'ปริมาตรน้ำยาเข้า',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon'),
                                          suffixIcon: Icon(Icons.move_to_inbox),
                                        ),
                                      ),
                                    ),

                                    /// เวลาเริ่มปล่อยน้ำยาออกท้อง
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onTap: () =>
                                            pickTimeOutFluidBegin(context),
                                        controller: ctrlTimeOutFluidBegin,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'เวลาเริ่มปล่อย(น้ำยาออก)',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon'),
                                          suffixIcon: Icon(Icons.timer),
                                        ),
                                      ),
                                    ),

                                    /// เวลาสิ้นสุดการปล่อยน้ำยาออกท้อง
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onTap: () =>
                                            pickTimeOutFluidEnd(context),
                                        controller: ctrlTimeOutFluidEnd,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText:
                                              'เวลาสิ้นสุดการปล่อย(น้ำยาออก)',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon'),
                                          suffixIcon: Icon(Icons.timer),
                                        ),
                                      ),
                                    ),

                                    /// ปริมาตรน้ำยาออก
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        //textInputAction: TextInputAction.next,
                                        onTap: () {},
                                        controller: ctrlOutFluidValue,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'ปริมาตรน้ำยาออก',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon'),
                                          suffixIcon: Icon(
                                            Icons.outbox,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// กำไร / ขาดทุน
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.indigo),
                                        readOnly: true,
                                        keyboardType: TextInputType.number,
                                        // textInputAction: TextInputAction.next,
                                        onTap: () {},
                                        controller: ctrlSumFluidValue,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          labelText:
                                              'กำไร/ขาดทุน(น้ำยาออก - น้ำยาเข้า)',
                                          labelStyle: TextStyle(
                                              fontFamily: 'FC-Lamoon',
                                              color: Colors.indigo),
                                          filled: true,
                                          fillColor: isLoss
                                              ? Colors.green
                                              : Colors.pink,
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                int volumeFluidIn = int.parse(
                                                    (ctrlInFluidValue.text ==
                                                            '')
                                                        ? '0'
                                                        : ctrlInFluidValue
                                                            .text);
                                                int volumeFluidOut = int.parse(
                                                    (ctrlOutFluidValue.text ==
                                                            '')
                                                        ? '0'
                                                        : ctrlOutFluidValue
                                                            .text);
                                                calculateVolume(volumeFluidIn,
                                                    volumeFluidOut);
                                              },
                                              icon: Icon(Icons.calculate,
                                                  size: 32.0,
                                                  color: Colors.indigo)),
                                        ),
                                      ),
                                    ),

                                    /// ลักษณะของสีน้ำยา
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                                labelText: 'ลักษณะสีของน้ำยา',
                                                labelStyle: TextStyle(
                                                    fontFamily: 'FC-Lamoon'),
                                                border: OutlineInputBorder()),
                                            value: kindFluidColor,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: Colors.black45),
                                            isExpanded: true,
                                            items: listKindFluidColor
                                                .map(buildMenuKindFluidColor)
                                                .toList(),
                                            onTap: () => loadKindFluidColor(),
                                            onChanged: (fluid) => setState(
                                                () => kindFluidColor = fluid)),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),

                                /// ปุ่มบันทึกข้อมูล
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => prepareData(),
                                      child: const Text(
                                        'บันทึกข้อมูล',
                                        style: TextStyle(
                                          fontFamily: 'FC-Lamoon',
                                          fontSize: 18.0,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: MyConfigs.darker,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      // textColor: const Color(0xFF6200EE),
                                      onPressed: () {
                                        // Perform some action
                                      },
                                      child: const Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          fontFamily: 'FC-Lamoon',
                                          fontSize: 18.0,
                                          color: Colors.red,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
