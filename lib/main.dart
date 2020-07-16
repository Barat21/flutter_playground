import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:documents_picker/documents_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[RaisedButton(
            onPressed: () => writeData("data"),
            child: Text('Write File'),
            color: Colors.blue,
            textColor: Colors.white,
          ),RaisedButton(
            onPressed: () => requestPermission(),
            child: Text('Request permission'),
            color: Colors.blue,
            textColor: Colors.white,
          ),RaisedButton(
            onPressed: () => shareFile(),
            child: Text('Share'),
            color: Colors.blue,
            textColor: Colors.white,
          )],
        ),
      ),
    );
  }

  requestPermission() async{
    print('Requesting permission');
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);

  }

  Future<String> get localPath async{
    final dir = await getExternalStorageDirectory();
    final Directory _appDocDirFolder =  Directory('${dir.path}/AssetGather/Proximity');

    if(await _appDocDirFolder.exists()){ //if folder already exists return path
      return _appDocDirFolder.path;
    }else{//if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }


    print("dir $dir.path");
    return dir.path;
  }

  Future<File> get localFile async{
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<File> writeData(String data) async{
    print("ins wrtie data");
    final file = await localFile;
    print(file);
    return file.writeAsString(data);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'
    );
  }

  Future<void> shareFile() async {
    final path = await localPath;
    print('$path/db.txt');
    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: '$path/db.txt' as String,
    );
  }


}

class storage{

  Future<String> get localPath async{
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async{
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<File> writeData(String data) async{
    final file = await localFile;
    return file.writeAsString(data);
  }
}
