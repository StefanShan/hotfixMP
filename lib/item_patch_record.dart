import 'package:flutter/material.dart';
import 'package:tinker_manager/http_holder.dart';
import 'package:tinker_manager/model/patch_record.dart';
import 'package:tinker_manager/patch_info_dialog.dart';

class PatchRecordItem extends StatefulWidget {
  final PatchRecordResult _record;

  const PatchRecordItem(this._record, {super.key});

  @override
  State<PatchRecordItem> createState() => _PatchRecordItemState();
}

class _PatchRecordItemState extends State<PatchRecordItem> {
  int _recordState = -1;
  late String _createTimeStr;

  @override
  void initState() {
    super.initState();
    _recordState = widget._record.state;
    var createTime = DateTime.parse(widget._record.createdAt).toLocal();
    _createTimeStr =
    "${createTime.year}-${_twoDigits(createTime.month)}-${_twoDigits(
        createTime.day)} ${_twoDigits(createTime.hour)}:${_twoDigits(
        createTime.minute)}:${_twoDigits(createTime.second)}";
  }

  String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  void _requestChangeRecordState(int state) {
    HttpHolder().post(Urls.updatePatchState,
        {"id": widget._record.id, "state": state}).catchError((error) {
      //请求失败，恢复原状态
      setState(() {
        _recordState = _recordState == 0 ? 1 : 0;
      });
    });
  }

  void _showInfoDialog(BuildContext buildContext){
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return Dialog(
            child: PatchInfoWidget(widget._record),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInfoDialog(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget._record.fileName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(
                          _recordState == 0
                              ? "images/close.webp"
                              : "images/open.webp",
                          width: 15,
                          height: 15,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "目标版本: ${widget._record.targetVersion}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  Text(
                      "创建时间: $_createTimeStr",
                      style: const TextStyle(color: Colors.black54))
                ],
              ),
              Switch(
                  value: _recordState == 1,
                  onChanged: (isOpen) {
                    var state = isOpen ? 1 : 0;
                    _requestChangeRecordState(state);
                    setState(() {
                      _recordState = state;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
