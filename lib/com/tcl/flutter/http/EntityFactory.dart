

import 'json_convert_help.dart';

/**
 * Json转换辅助工厂，把json转为T
 */
class EntityFactory {
  static JsonConvertHelp _jsonConvertHelp;

  static void setJsonConvertHelp(JsonConvertHelp value) {
    print("setJsonConvertHelp, value: $value");
    _jsonConvertHelp = value;
  }

  static T generateOBJ<T>(json) {
    if (null == json) {
      return null;
    }
    if (null != _jsonConvertHelp) {
      return _jsonConvertHelp.fromJsonAsT(json);
    }
    return json as T;

  }
}