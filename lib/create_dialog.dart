
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tinker_manager/model/patch_record.dart';
import 'http_holder.dart';

class CreatePatchWidget extends StatefulWidget {
  const CreatePatchWidget({
    super.key,
  });

  @override
  State<CreatePatchWidget> createState() => _CreatePatchWidgetState();
}

class _CreatePatchWidgetState extends State<CreatePatchWidget> {
  bool _openPatch = true;
  String _fileName = "";
  String _patchUrl = "";
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.25,
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () {
                  _selectPatch();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "上传Patch",
                    style: TextStyle(fontSize: 16),
                  ),
                )),
            Row(
              children: [
                const Text(
                  "目标版本",
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      fillColor: Color(0x30cccccc),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00FF0000)),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      hintText: '例如: 3.1.34.0',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000)),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "立即生效",
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Checkbox(
                      value: _openPatch,
                      onChanged: (isChecked) {
                        setState(() {
                          _openPatch = isChecked ?? true;
                        });
                      }),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  if (_patchUrl == "") {
                    EasyLoading.showToast("等待上传结果");
                    return;
                  }
                  _createPatchInfo(_fileName, _patchUrl,
                      _textEditingController.text, _openPatch ? 1 : 0);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("创建", style: TextStyle(fontSize: 16)),
                ))
          ],
        ),
      ),
    );
  }

  _createPatchInfo(
      String fileName, String url, String targetVersion, int state) async {
    HttpHolder().post(Urls.createPatchRecord, {
      "fileName": fileName,
      "fileUrl": url,
      "targetVersion": targetVersion,
      "state": state
    }).then((value) {
      var result = PatchRecordResult.fromJson(jsonDecode(value.toString()));
      Navigator.of(context).pop(result);
    }).catchError((error) {
      print("创建失败 = $error");
      EasyLoading.showToast("创建失败 -> $error");
    });
  }

  _selectPatch() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'select patch',
      extensions: <String>['apk'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file == null) return;
    var xFileBytes = await file.readAsBytes();
    var map = <String, dynamic>{}..["myFile"] =
        MultipartFile.fromBytes(xFileBytes.toList(), filename: file.name);
    HttpHolder().post(Urls.uploadFile, FormData.fromMap(map)).then((value) {
      EasyLoading.showToast("上传成功!");
      setState(() {
        _patchUrl = jsonDecode(value.toString())["url"];
        _fileName = file.name;
      });
    }).catchError((e) {
      print("上传失败 = $e");
      EasyLoading.showToast("上传失败 -> $e");
    });
  }
}
