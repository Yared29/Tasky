import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Text('Developed by Yared'));
  }
}
