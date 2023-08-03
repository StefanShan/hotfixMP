import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpHolder {
  late Dio _dio;
  static final HttpHolder _instance = HttpHolder._init();

  factory HttpHolder() => _instance;

  HttpHolder._init() {
    var baseOptions = BaseOptions(
        baseUrl: "https://ny2xk44fm7.hk.aircode.run");
    _dio = Dio(baseOptions);
    _dio.interceptors.add(LogInterceptor(requestBody: kDebugMode, responseBody: kDebugMode));
  }

  Future get(String path, {Map<String, dynamic>? params}) async {
    return await _dio.get<String>(path, queryParameters: params);
  }

  Future post(String path, [Object? params]) async {
    return await _dio.post<String>(path, data: params);
  }
}

class Urls {
  Urls._();

  //获取所有 patch 记录
  static const String urlAllPatch = "/showAllPatch";

  //修改 patch 状态
  static const String updatePatchState = "/updatePatch";

  //创建 patch 记录
  static const String createPatchRecord = "/createPatch";

  //上传文件
  static const String uploadFile = "/uploadPatch";

  //删除 patch 记录
  static const String deletePatch = "/deletePatch";
}

enum RequestState{
  unKnown, //原始状态
  success, //成功
  fail //失败
}
