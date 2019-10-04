import 'package:json_annotation/json_annotation.dart';

DateTime _fromJsonToDateTime(dynamic field) {
  if (field.runtimeType == String) {
    return DateTime.parse(field);
  }
  if (field is Map) {
    return DateTime.fromMillisecondsSinceEpoch(field['\$date'], isUtc: true);
  }
  return null;
}

Map<String, int> dateTimeToMap(DateTime dt) {
  var r = Map<String, int>();
  r["\$date"] = dt.millisecondsSinceEpoch;
  return r;
}

@JsonSerializable()
class MeteorDocument {
  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'createdAt', includeIfNull: false, fromJson: _fromJsonToDateTime)
  DateTime createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false, fromJson: _fromJsonToDateTime)
  DateTime updatedAt;
}
