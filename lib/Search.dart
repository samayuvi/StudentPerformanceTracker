import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'Home.dart';
import 'DepartmentInfo.dart';

class Search extends StatelessWidget {
  String text;
  Search(this.text);
  List<Department> departments = [];
  List<Teacher> teachers = [];
  Future<int> dbc() async {
    var connection = PostgreSQLConnection("35.224.75.97", 5432, "postgres",
        username: "postgres", password: "123");
    await connection.open();
    print("connected");

    List<List<dynamic>> results = await connection
        .query("SELECT * FROM teachers WHERE name LIKE '$text%' ");
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
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Search Teachers")),
        body: FutureBuilder(
            future: dbc(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Search(text)),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DepartmentInfo(teachers[index].id)),
                          );
                        },
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(teachers[index].photo),
                            ),
                            trailing: Icon(Icons.drag_handle),
                            title: Text(teachers[index].name)),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
