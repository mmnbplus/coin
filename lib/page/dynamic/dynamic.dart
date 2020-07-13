import 'dart:async';
import 'package:coin/components/ChooseListViewComponent.dart';
import 'package:coin/components/DynamicViewComponent.dart';
import 'package:coin/config/StaticConfig.dart';
import 'package:coin/otherpage/SearchPage.dart';
import 'package:coin/page/color/theme_ui.dart';
import 'package:coin/utils/HttpRequest.dart';
import 'package:coin/utils/ListUtil.dart';
import 'package:coin/utils/app_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var width;
BuildContext mcontext;
List<String> spanList = new List<String>();
List<dynamic> dynamicList = new List<dynamic>();
final StreamController<List<String>> spanListStreamController = StreamController<List<String>>(); //初始化
final StreamController<List<dynamic>> dynamicListStreamController = StreamController<List<dynamic>>(); //初始化
ScrollController dynamicScrollController = new ScrollController();
bool isDynamicScrollBottom = false;

class DynamicPage extends StatefulWidget {
  @override
  DynamicPageState createState() => DynamicPageState();
}

class DynamicPageState extends State<DynamicPage>{
  /// 获取动态类型
  static void getDynameicType() async {
    Map<String, Object> response = await HttpRequest.request("/dynamic/getDynameicType");
    List<dynamic> data = response["data"];

    for(var item in data){
      spanList.add(item["name"]);
    }

    spanListStreamController.sink.add(spanList);
  }

  ///获取动态
  static void getDynameicList(int dynamicTypeId, int dynamicId) async {
    Map<String, Object> dynamicResponse = await HttpRequest.request("/dynamic/getDynameicList",method: "get",params: {
      'dynamicId': dynamicId,
      'size': 10,
      'dynamicTypeId': dynamicTypeId
    });
    if(dynamicId == 0){
      dynamicList = dynamicResponse["data"];
    }else{
      dynamicList.addAll(dynamicResponse["data"]);
    }
    dynamicListStreamController.sink.add(dynamicList);
    isDynamicScrollBottom = false;
  }

  static Table createDynamicTable(List<dynamic> dynamicList){

    List<TableRow> tableRow = new List<TableRow>();

    Container add(Map<String, dynamic> dynamicObj){
      String imgUrl = "";
      int ctype = dynamicObj["dynamic"]["ctype"];
      List<String> imgSrcList = ListUtil.stringToList(dynamicObj["dynamic"]["imgUrlList"]);
      dynamic dynamicDet = dynamicObj["dynamic"];

      if(ctype == 4 || ctype == 1){
        imgUrl = "https://mm.cstbservice.top/"+imgSrcList[0];
      }else if(ctype == 3){
        imgUrl = "http://vpic.video.qq.com//"+dynamicObj["dynamic"]["videoSrc"]+"_ori_1.jpg";
      }

      Container c = DynamicViewComponent.create(
          imgUrl,
          dynamicDet["title"],
          dynamicObj["userRoughModel"]["nickName"],
          dynamicDet["goodCount"],
          dynamicDet["talkCount"],
          dynamicDet["lookCount"],
          dynamicObj["userRoughModel"]["provider"]
      );
      return c;
    }

    for(var i=0;i<dynamicList.length;i++){
      tableRow.add(TableRow(
        children: <Widget>[
          add(dynamicList[i]),add(dynamicList[i+1])
        ]
      ));
      i++;
    }


    return Table(
      border: TableBorder(
          bottom: BorderSide(color: ThemeColor.appBg),
          horizontalInside: BorderSide(color: ThemeColor.appBg),
          verticalInside: BorderSide(color: ThemeColor.appBg)),
      children: tableRow,
    );
  }


  DynamicPageState(){
    ///获取初始数据
    getDynameicType();
    getDynameicList(0,0);

    dynamicScrollController.addListener((){
      if (dynamicScrollController.position.pixels == dynamicScrollController.position.maxScrollExtent && isDynamicScrollBottom == false) {
        isDynamicScrollBottom = true;
        getDynameicList(0,dynamicList[dynamicList.length-1]["dynamic"]["dynamicId"]);
        //防抖
        new Timer(new Duration(milliseconds: 2), () {
          isDynamicScrollBottom = true;
        });
      }
    });
  }

  @override
  void dispose(){
    spanListStreamController.close();
    dynamicListStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mcontext = context;

    return new Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          headerView,
          sectionTable
        ],
      )
    );
  }

}

/// 搜索框
Container searchInput = new Container(
    width: 200,
    padding: EdgeInsets.only(top: 6,bottom: 6,left: 15),
    margin: EdgeInsets.only(top:30,left: 10),
    decoration: BoxDecoration(
        color: Color(0x00ffffffff),
        borderRadius: BorderRadius.all(Radius.circular(30))
    ),
    child: GestureDetector(
      onTap: ()=>{
        Navigator.push(
          mcontext,
          new MaterialPageRoute(builder: (context) => SearchPage()),
        )
      },
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Icon(Icons.search,color: Color(0x0033333333),size: 15,),
          Text(
            "搜索文章·视频·答案",
            style: TextStyle(
                color: Color(0x0033333333),
              fontSize: 12
            ),
          ),
        ],
      ),
    )
);

/// 头部->顶部
Container headerViewTopView = new Container(
  child: Flex(
    direction: Axis.horizontal,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top:30,left: 10),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
            "https://wx.qlogo.cn/mmopen/vi_32/LH99GfeT31hdYG8W8c6wRialyC4nicTfssDXeqtIs4f5XogNqHhTdmVIuQDeGcgE0KRlZyzAz7JO5Nc7yesHx9Lg/132",
          ),
        ),
      ),
      searchInput
    ],
  ),
);

/// 分类
Container solrView = new Container(
    height: 25,
    margin: EdgeInsets.only(top: 7),
    child: StreamBuilder(
      stream: spanListStreamController.stream,
      initialData: spanList,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot){
        return ChooseListViewComponent.create(snapshot.data);
      },
    )
);

/// 头部
Container headerView = Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage("https://image.weilanwl.com/color2.0/plugin/cjkz2329.jpg"),
        fit: BoxFit.fitWidth,
      ),
    ),
    width: StaticConfig.phoneWeight,
    height: AppSize.height(300),
    child: Flex(
      direction: Axis.vertical,
      children: <Widget>[
        headerViewTopView,
        solrView
      ],
    )
);

///动态卡片
Container sectionTable = Container(
    margin: EdgeInsets.only(top: AppSize.width(10)),
    height: AppSize.height(1440),
    child: SingleChildScrollView(
        //滑动的方向 Axis.vertical为垂直方向滑动，Axis.horizontal 为水平方向
        controller: dynamicScrollController,
        scrollDirection: Axis.vertical,
        //true 滑动到底部
        reverse: false,
        padding: EdgeInsets.all(0.0),
        child: StreamBuilder(
            stream: dynamicListStreamController.stream,
            initialData: dynamicList,
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
              return DynamicPageState.createDynamicTable(snapshot.data);
            }
        )
    ),
);


