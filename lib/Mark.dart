import 'package:flutter/material.dart';

class Mark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mark Info")),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Card(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Course"),
                  Text("Teacher"),
                  Text("date")
                ],
              ),
              color: Colors.white),
        ),
      ),
    );
  }
}
