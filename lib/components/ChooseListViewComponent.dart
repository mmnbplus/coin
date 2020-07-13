import 'package:flutter/cupertino.dart';

class ChooseListViewComponent{
  static ListView create(List<String> spanList){

    List<Widget> wl = new List<Widget>();

    for(var span in spanList){
      wl.add(Container(
        width: 80,
        child: Text(
          span,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0x00cccccccc),
              fontSize: 20
          ),
        ),
      ));
    }

    ListView lv = ListView(
      scrollDirection: Axis.horizontal,
      children: wl,
    );

    return lv;
  }
}