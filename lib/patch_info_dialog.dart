import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'model/patch_record.dart';

class PatchInfoWidget extends StatelessWidget {
  final PatchRecordResult _record;
  late String _createTimeStr;

  PatchInfoWidget(this._record, {super.key}) {
    var createTime = DateTime.parse(_record.createdAt).toLocal();
    _createTimeStr =
        "${createTime.year}-${_twoDigits(createTime.month)}-${_twoDigits(createTime.day)} ${_twoDigits(createTime.hour)}:${_twoDigits(createTime.minute)}:${_twoDigits(createTime.second)}";
  }

  String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
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
            _buildSimpleContent("Patch包名称: ", _record.fileName),
            _buildSimpleContent("目标版本: ", _record.targetVersion),
            _buildSimpleContent("创建时间: ", _createTimeStr),
            _buildSimpleContent("当前状态: ", _record.state == 0 ? "已开启" : "已停止"),
            const Row(
              children: [
                Text("下发情况: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                Column(
                  children: [
                    Text("已生效: 0", style: TextStyle(fontSize: 16)),
                    Text("已下发: 0", style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  launchUrlString(_record.fileUrl);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("下载 Patch 包", style: TextStyle(fontSize: 16)),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleContent(String title, String msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        Text(
          msg,
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
