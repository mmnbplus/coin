
import 'package:coin/utils/screenutil.dart';
import 'package:flutter/material.dart';

class AppSize{

  static init(BuildContext context){
    ScreenUtil.init(context);
  }

  static height(value){
    return ScreenUtil().setHeight(value.toDouble());
  }

  static width(value){
    return ScreenUtil().setWidth(value.toDouble());
  }

  static sp(value){
    return ScreenUtil().setSp(value.toDouble());
  }

  static instance() => ScreenUtil;
}


