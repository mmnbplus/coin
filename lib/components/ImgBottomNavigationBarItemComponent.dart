import 'package:flutter/cupertino.dart';

/// 自定义底部导航栏
class BottomNavigationImgBarItemComponent{
    static BottomNavigationBarItem create(String imgSrc,String text,int colorHex,double imgSize,double fontSize){
      return BottomNavigationBarItem(
          icon: Image.asset(imgSrc,width: imgSize,height: imgSize),
          title: Text(
            text,
            style: TextStyle(
                color: Color(colorHex),
                fontSize: fontSize
            ),
          )
      );
    }
}
