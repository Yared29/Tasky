import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:Tasky/screens/activeTasks.dart';
import 'package:Tasky/screens/doneTasks.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  List<Widget> _tabList = [
    ActiveTasks(),
    DoneTasks(),
  ];
  List<Widget> _iconList = [
    Icon(
      Icons.assignment,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      Icons.assignment_turned_in,
      size: 30,
      color: Colors.white,
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      initialIndex: 0,
      length: _tabList.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blueAccent,
        height: 50,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        animationCurve: Curves.ease, // You can change Animation Here
        buttonBackgroundColor: Colors.blueAccent,
        items: _iconList,
        onTap: (index) {
          setState(() {
            _tabController.animateTo(index);
          });
        },
      ),
      body: Container(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: TabBarView(
          children: _tabList,
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
