// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchRecordResult _$PatchRecordResultFromJson(Map<String, dynamic> json) =>
    PatchRecordResult(
      json['_id'] as String,
      json['fileName'] as String,
      json['fileUrl'] as String,
      json['targetVersion'] as String,
      json['state'] as int,
      json['createdAt'] as String,
      json['updatedAt'] as String,
    );

Map<String, dynamic> _$PatchRecordResultToJson(PatchRecordResult instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'targetVersion': instance.targetVersion,
      'state': instance.state,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
