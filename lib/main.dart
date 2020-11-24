import 'package:dostyk/DepartmentInfo.dart';
import 'package:dostyk/Education.dart';
import 'package:dostyk/Home.dart';
import 'package:flutter/material.dart';
import 'package:dostyk/getStudentsInfo.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      home: MyHomePage(),
      home: GSI(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String city, secWord;
  MyHomePage(this.city, this.secWord);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [Home(widget.city), Education(widget.secWord)];
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.school),
              title: new Text('Education'),
            ),
          ],
          onTap: onItemTapped,
        ),
        body: widgetOptions.elementAt(selectedIndex));
  }
}
