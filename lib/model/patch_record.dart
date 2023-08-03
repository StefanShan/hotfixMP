import 'package:json_annotation/json_annotation.dart';

part 'patch_record.g.dart';


List<PatchRecordResult> getPatchRecordResultList(List<dynamic> list){
  List<PatchRecordResult> result = [];
  list.forEach((item){
    result.add(PatchRecordResult.fromJson(item));
  });
  return result;
}
@JsonSerializable()
class PatchRecordResult extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'fileName')
  String fileName;

  @JsonKey(name: 'fileUrl')
  String fileUrl;

  @JsonKey(name: 'targetVersion')
  String targetVersion;

  @JsonKey(name: 'state')
  int state;

  @JsonKey(name: 'createdAt')
  String createdAt;

  @JsonKey(name: 'updatedAt')
  String updatedAt;

  PatchRecordResult(this.id,this.fileName,this.fileUrl,this.targetVersion,this.state,this.createdAt,this.updatedAt,);

  factory PatchRecordResult.fromJson(Map<String, dynamic> srcJson) => _$PatchRecordResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PatchRecordResultToJson(this);

}


