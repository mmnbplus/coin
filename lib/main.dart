import 'dart:io';
import 'package:coin/page/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MMApp());
}

class MMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new MaterialApp(
        title: '喵喵',
        debugShowCheckedModeBanner: false,    //去掉debug图标
        home: new MainPage(),
      )
    );
  }
}