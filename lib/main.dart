import 'dart:async';
import 'package:coin/components/DynamicViewComponent.dart';
import 'package:coin/utils/HttpRequest.dart';
import 'package:coin/utils/ListUtil.dart';
import 'package:flutter/material.dart';
import 'components/ChooseListViewComponent.dart';
import 'components/ImgBottomNavigationBarItemComponent.dart';
import 'config/StaticConfig.dart';
import 'otherpage/SearchPage.dart';

var width;
List<String> spanList = new List<String>();
List<dynamic> dynamicList = new List<dynamic>();
final StreamController<List<String>> spanListStreamController = StreamController<List<String>>(); //初始化
final StreamController<List<dynamic>> dynamicListStreamController = StreamController<List<dynamic>>(); //初始化
ScrollController dynamicScrollController = new ScrollController();
bool isDynamicScrollBottom = false;

void main() {
  runApp(new MaterialApp(
    title: '喵喵',
    debugShowCheckedModeBanner: false,    //去掉debug图标
    home: new MainPage(),
  ));
}

/// 获取动态类型
void getDynameicType() async {
  Map<String, Object> response = await HttpRequest.request("/dynamic/getDynameicType");
  List<dynamic> data = response["data"];

  for(var item in data){
    spanList.add(item["name"]);
  }

  spanListStreamController.sink.add(spanList);
}

///获取动态
void getDynameicList(int dynamicTypeId, int dynamicId) async {
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

ListView createDynamic(List<dynamic> dynamicList){

  List<Row> dRow = new List<Row>();

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
    dRow.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        add(dynamicList[i]),add(dynamicList[i+1])
      ],
    ));
    i++;
  }

  return ListView(
    controller: dynamicScrollController,
    scrollDirection:Axis.vertical,
    children: dRow,
  );
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  MainPageState(){
    getDynameicType();
    getDynameicList(0,0);
  }

  @override
  void dispose(){
    spanListStreamController.close();
    dynamicListStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    StaticConfig.phoneWeight = MediaQuery.of(context).size.width;
    /**
     * 搜索框
     */
    Container searchInput = new Container(
      width: 300,
      padding: EdgeInsets.only(top: 8,bottom: 8,left: 15),
      margin: EdgeInsets.only(top:30,left: 10),
      decoration: BoxDecoration(
          color: Color(0x00ffffffff),
          borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: GestureDetector(
        onTap: ()=>{
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => SearchPage()),
            )
        },
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Icon(Icons.search,color: Color(0x0033333333)),
            Text(
              "搜索文章·视频·答案",
              style: TextStyle(
                  color: Color(0x0033333333)
              ),
            ),
          ],
        ),
      )
    );

    /**
     * 顶部头像和搜索框
     */
    Container headerViewTopView = new Container(
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:30,left: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://wx.qlogo.cn/mmopen/vi_32/LH99GfeT31hdYG8W8c6wRialyC4nicTfssDXeqtIs4f5XogNqHhTdmVIuQDeGcgE0KRlZyzAz7JO5Nc7yesHx9Lg/132",
              ),
            ),
          ),
          searchInput
        ],
      ),
    );

    /**
     * 分类
     */
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

    /**
     * 头部
     */
    Container headerView = Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://image.weilanwl.com/color2.0/plugin/cjkz2329.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        width: StaticConfig.phoneWeight,
        height: 110,
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            headerViewTopView,
            solrView
          ],
        )
    );

    ///动态卡片
    Container sectionView = Container(
      color: Color(0x00ffffffff),
      height: 510,
      child: StreamBuilder(
          stream: dynamicListStreamController.stream,
          initialData: dynamicList,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
            return createDynamic(snapshot.data);
          }
      )
    );

    ///页面到底事件监听
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

    return new Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          headerView,
          sectionView
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationImgBarItemComponent.create("assets/image/coin/coin.png", "投币", 0x00aaaaaaaa,20,11),
          BottomNavigationImgBarItemComponent.create("assets/image/coin/dynamic.png", "动态", 0x00aaaaaaaa,20,11),
          BottomNavigationImgBarItemComponent.create("assets/image/coin/me.png", "我的", 0x00aaaaaaaa,20,11)
        ],
      ),
    );
  }
}


