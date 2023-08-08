import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tinker_manager/http_holder.dart';
import 'package:tinker_manager/item_patch_record.dart';
import 'package:tinker_manager/model/patch_record.dart';

import 'create_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '热修复管理平台',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '热修复管理平台'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<PatchRecordResult> _showCreatePatchDialog(
      BuildContext buildContext) async {
    return await showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return const Dialog(
            child: CreatePatchWidget(),
          );
        });
  }

  late EasyRefreshController _refreshController;

  List<PatchRecordResult>? _recordList;
  RequestState _requestState = RequestState.unKnown;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(controlFinishRefresh: true)
      ..resetHeader();
    EasyLoading.show();
    _requestAllRecord();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void _requestAllRecord() {
    HttpHolder().get(Urls.urlAllPatch).then((value) {
      List<PatchRecordResult> list =
          getPatchRecordResultList(jsonDecode(value.toString()));
      setState(() {
        _recordList = list;
        _requestState = RequestState.success;
      });
      _refreshController.finishRefresh(IndicatorResult.success);
    }).catchError((error) {
      setState(() {
        _requestState = RequestState.fail;
      });
      _refreshController.finishRefresh(IndicatorResult.fail);
    }).whenComplete(() => EasyLoading.dismiss());
  }

  Future<bool> _deletePatch(String id) async {
    Response<String> deleteResult =
        await HttpHolder().post(Urls.deletePatch, {"id": id});
    return deleteResult.data == "0";
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container();
    if (_requestState == RequestState.success) {
      content = _listWidget();
    } else if (_requestState == RequestState.fail) {
      content = _loadingErrorWidget();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _refreshController.callRefresh();
            },
            icon: const Icon(Icons.refresh),
            tooltip: "刷新",
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              _showCreatePatchDialog(context).then((value) {
                _recordList?.insert(0, value);
                setState(() {
                  _recordList = _recordList?.toList();
                });
              });
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "创建",
            iconSize: 30,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      ),
    );
  }

  Widget _listWidget() {
    return EasyRefresh(
        controller: _refreshController,
        header: const ClassicHeader(
            dragText: "下拉可以刷新",
            armedText: "松开立即刷新",
            readyText: "刷新中...",
            processingText: "刷新中...",
            processedText: "刷新完成",
            failedText: "刷新失败",
            messageText: "上次刷新时间 %T"),
        onRefresh: () {
          _requestAllRecord();
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            var itemData = _recordList!.elementAt(index);
            return Dismissible(
                key: Key(itemData.id),
                confirmDismiss: (direction) {
                  return _deletePatch(itemData.id);
                },
                onDismissed: (direction) {
                  _recordList?.remove(itemData);
                  setState(() {
                    _recordList = _recordList?.toList();
                  });
                },
                child: PatchRecordItem(itemData));
          },
          itemCount: _recordList?.length ?? 0,
        ));
  }

  Widget _loadingErrorWidget() {
    return const Center(
      child: Text('数据加载失败，请重试。'),
    );
  }
}
