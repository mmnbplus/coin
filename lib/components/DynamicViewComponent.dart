import 'package:coin/config/StaticConfig.dart';
import 'package:coin/utils/ColorTextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicViewComponent{
  static Container create(String img,String title,String nickname,int good,int talk,int look,String provider){
    return Container(
      margin: EdgeInsets.only(left: 2,right: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Image.network(
                      img,
                      width: (StaticConfig.phoneWeight/2)-4,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    padding: EdgeInsets.only(left: 5,right: 5),
                    constraints: BoxConstraints.tightFor(width: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('点赞 ${good} 评论 ${talk} 浏览 ${look}', style: ColorTextStyle.white(10)),
                        Text('来自${provider}', style: ColorTextStyle.white(10)),
                      ],
                    )
                  ),
                ],
              ),
              Container(
                width: 200,
                padding: EdgeInsets.only(left: 5),
                child: Text(title,textAlign: TextAlign.left),
              ),
              Container(
                width: 200,
                padding: EdgeInsets.only(left: 5),
                child: Text(nickname,textAlign: TextAlign.left,style: TextStyle(
                  color: Colors.grey
                )),
              ),
            ],
          ),
      )
    );
  }
}