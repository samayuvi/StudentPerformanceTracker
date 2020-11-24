import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'Home.dart';

class DepartmentInfo extends StatelessWidget {
  List<Department> departments = [];
  List<Teacher> teachers = [];
  int id;
  DepartmentInfo(this.id);
  String subject_name;
  String contact;
  Future<int> dbc() async {
    var connection = PostgreSQLConnection("35.224.75.97", 5432, "postgres",
        username: "postgres", password: "123");
    await connection.open();
    print("connected");

    List<List<dynamic>> results = await connection
        .query("SELECT * from teachers where teacher_id=$id"); //TODO
    if (results.length == 0) {
      teachers.add(Teacher(
        0,
        "No Teachers Yet",
        0,
        "No Contact",
        "---",
        "https://us.123rf.com/450wm/pe3check/pe3check1710/pe3check171000054/88673746-no-image-available-sign-internet-web-icon-to-indicate-the-absence-of-image-until-it-will-be-download.jpg?ver=6",
      ));
    }
    for (final rows in results) {
      teachers.add(Teacher(
          rows[0], rows[1], rows[2], rows[3], rows[4].toString(), rows[5]));
      contact = rows[3];

      teachers[0].startDate =
          teachers[0].startDate.substring(0, teachers[0].startDate.length - 13);
    }
    var subject =
        await connection.query("SELECT name from subject where subject_id=$id");
    subject_name = subject[0][0];
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: dbc(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(teachers[0].photo),
                          ),
                          Text(
                            teachers[0].name + "\n", //Name
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Contact: " + contact,
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Text(subject_name + " Educator",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Text(
                                "The teacher works from " +
                                    teachers[0].startDate,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        color: Colors.white),
                  ),
                  flex: 2,
                )
              ],
            );
          }),
    );
  }
}
