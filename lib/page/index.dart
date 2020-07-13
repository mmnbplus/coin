import 'package:coin/components/ImgBottomNavigationBarItemComponent.dart';
import 'package:coin/config/StaticConfig.dart';
import 'package:coin/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'dynamic/dynamic.dart';

final List<BottomNavigationBarItem> bottomBar = [
  BottomNavigationImgBarItemComponent.create("assets/image/coin/coin.png", "投币", 0x00aaaaaaaa,20,11),
  BottomNavigationImgBarItemComponent.create("assets/image/coin/dynamic.png", "动态", 0x00aaaaaaaa,20,11),
  BottomNavigationImgBarItemComponent.create("assets/image/coin/me.png", "我的", 0x00aaaaaaaa,20,11)
];

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  @override
  void dispose(){
    spanListStreamController.close();
    dynamicListStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///初始化屏幕适配包
    AppSize.init(context);

    StaticConfig.phoneWeight = MediaQuery.of(context).size.width;

    return new Scaffold(
      body: DynamicPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomBar,
      ),
    );
  }
}