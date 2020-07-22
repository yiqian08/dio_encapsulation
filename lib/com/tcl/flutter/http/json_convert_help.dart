/**
 * Json实体类转换工具
 */
abstract class JsonConvertHelp {
  T fromJsonAsT<T>(json); /*{
    switch (T.toString()) {
      case "BasePhotoBean":
        return BasePhotoBean.fromJson(json) as T;
      case "AllPhotoEntity":
        return AllPhotoEntity.fromJson(json) as T;
    }
    return json as T;
  }*/
}