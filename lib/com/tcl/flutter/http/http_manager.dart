

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'EntityFactory.dart';
import 'base_entity.dart';
import 'ErrorEntity.dart';
import 'http_config.dart';
import 'http_method.dart';
import 'json_convert_help.dart';

class HttpManager{
  static final HttpManager _shared = HttpManager._internal();
  factory HttpManager() => _shared;

  Dio dio;

  HttpManager._internal() {
    if (null == dio) {
      BaseOptions options = BaseOptions(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          receiveDataWhenStatusError: false,
          connectTimeout: HttpConfig.ConnectTimeout,
          receiveTimeout: HttpConfig.ReceiveTimeout
      );
      dio = Dio(options);

    }

  }

  /**
   * 添加拦截器
   */
  HttpManager addIntercept(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
    return this;
  }

  /**
   * 设置BaseUrl
   */
  HttpManager setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
    return this;
  }

  /**
   * 设置连接超时
   */
  HttpManager setConnectTimout(int connectTimeout) {
    dio.options.connectTimeout = connectTimeout;
    return this;
  }

  /**
   * 设置响应超时
   */
  HttpManager setReceiveTimeout(int receiveTimeout) {
    dio.options.receiveTimeout = receiveTimeout;
    return this;
  }

  /**
   * 设置返回成功的code值，默认为1
   */
  setSuccessCode(int successCode) {
    BaseEntity.STATUS_OK = successCode;
  }

  /**
   * 设置对返回bean的Json转换子类
   */
  setJsonConvertHelp(JsonConvertHelp help) {
    EntityFactory.setJsonConvertHelp(help);
  }

  Future request<T>({
    @required HTTPMethod method,
    @required String url,
    Map params,
    data,
    String baseUrl,
    Map headers,
    @required Function(T) success,
    @required Function(ErrorEntity) error
  }) async {
    try {
      if (null != baseUrl && baseUrl.isNotEmpty) {
        dio.options.baseUrl = baseUrl;
      }
      if (null != headers && headers.isNotEmpty) {
        dio.options.headers.addAll(headers);
      }
      print("start request");
      Response response = await dio.request(
                  url, queryParameters: params, data: data,
                  options: Options(method: HTTPMethodValues[method]),
                  );
      print("response: " + response.toString());
      if (null != response) {
        BaseEntity<T> entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == BaseEntity.STATUS_OK) {
          success(entity.data);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: "未知错误！"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  Future get<T> ({
    @required String url,
    Map params,
    String baseUrl,
    Map headers,
    data,
    @required Function(T) success,
    @required Function(ErrorEntity) error
  }){
    request(method: HTTPMethod.GET, url: url, params: params, baseUrl: baseUrl, data: data,
        headers: headers, success: success, error: error);
  }

  Future post<T> ({
    @required String url,
    Map params,
    String baseUrl,
    Map headers,
    data,
    @required Function(T) success,
    @required Function(ErrorEntity) error
  }){
    request(method: HTTPMethod.POST, url: url, params: params, baseUrl: baseUrl, data: data,
        headers: headers, success: success, error: error);
  }

  Future put<T> ({
    @required String url,
    Map params,
    String baseUrl,
    Map headers,
    data,
    @required Function(T) success,
    @required Function(ErrorEntity) error
  }){
    request(method: HTTPMethod.PUT, url: url, params: params, baseUrl: baseUrl, data: data,
        headers: headers, success: success, error: error);
  }

  Future delete<T> ({
    @required String url,
    Map params,
    String baseUrl,
    Map headers,
    data,
    @required Function(T) success,
    @required Function(ErrorEntity) error
  }){
    request(method: HTTPMethod.DELETE, url: url, params: params, baseUrl: baseUrl, data: data,
        headers: headers, success: success, error: error);
  }

  Future patch<T> ({
    @required String url,
    Map params,
    String baseUrl,
    Map headers,
    data,
    @required Function(T) success,
    @required Function(ErrorEntity) error
  }){
    request(method: HTTPMethod.PATCH, url: url, params: params, baseUrl: baseUrl, data: data,
        headers: headers, success: success, error: error);
  }

  ErrorEntity createErrorEntity(DioError e) {
    switch (e.type) {
      case DioErrorType.CANCEL:
        return ErrorEntity(code: -1, message: "请求取消！");
      case DioErrorType.CONNECT_TIMEOUT:
        return ErrorEntity(code: -1, message: "连接超时!");
      case DioErrorType.SEND_TIMEOUT:
        return ErrorEntity(code: -1, message: "发送超时！");
      case DioErrorType.RECEIVE_TIMEOUT:
        return ErrorEntity(code: -1, message: "响应超时！");
      case DioErrorType.RESPONSE:
        try {
          int errCode = e.response.statusCode;
          String errMsg = e.response.statusMessage;
          return ErrorEntity(code: errCode, message: errMsg);
        } on Exception catch(exception) {
          return ErrorEntity(code: -1, message: "未知错误！");
        }
        break;
      default:
        return ErrorEntity(code: -1, message: e.message);
    }
  }
}