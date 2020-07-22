/**
 * 请求报错基类，{"code":0, "message":""}
 */
class ErrorEntity{
  int code;
  String message;

  ErrorEntity({this.code, this.message});
}