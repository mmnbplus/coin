

import 'dart:convert';

class ListUtil {

  static List stringToList(String s){
    List<String> list = new List<String>();
    if(s == null){
      return null;
    }

    for (var value in JsonDecoder().convert(s)) {
      if(value == null){
        
      }else {
        list.add(value);
      }
    };

    return list;
  }
}