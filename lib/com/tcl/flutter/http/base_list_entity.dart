
import 'EntityFactory.dart';

/**
 * 数据基类2， 返回的参数类型为{"code":0, "data":[]}
 */
class BaseListEntity<T> {
  int code;
  String message;
  List<T> data;

  BaseListEntity({this.code, this.message, this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> data = new List<T>();
    if (null != json["data"]) {
      //遍历data并转换为我们传进来的类型
      (json["data"] as List).forEach((value) {
        data.add(EntityFactory.generateOBJ<T>(value));
      });
    }

    return BaseListEntity(
      code: json["code"],
      message: json["message"],
      data: data,
    );
  }
}