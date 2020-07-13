import 'package:dio/dio.dart';
import 'dart:convert';

class HttpRequest {
  static final Dio dio = Dio();
  static final String path = "https://minapp.cstbservice.top";


  static Future<Map<String, Object>> request<T>(String url, {
    String method = "get",
    Map<String, dynamic> params
  }) async {
    // 1.创建单独配置
    final options = Options(
        method: method,
        responseType: ResponseType.plain,
    );
    url = path + url;
    // 2.发送网络请求
    try {
      Response response = await dio.request(url, queryParameters: params, options: options);
      Map<String, Object> news = jsonDecode(response.data.toString());
      return news;
    } on DioError catch(e) {
      return null;
    }
  }
}