import 'package:dostyk/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dostyk/Home.dart';

class GSI extends StatefulWidget {
  @override
  _GSIState createState() => _GSIState();
}

class _GSIState extends State<GSI> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController emailController2 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: emailController,
            obscureText: false,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: 'PLEASE ENTER YOUR GROUP NAME',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: emailController2,
            obscureText: true,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: 'SECRET WORD(optional)',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            child: Text("SUBMIT"),
            onPressed: () {
              if (emailController.text != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          emailController.text, emailController2.text)),
                );
              }
            },
          )
        ]),
      ),
    );
  }
}
