import 'package:dostyk/DepartmentInfo.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:postgres/postgres.dart';
import 'Search.dart';

class Department {
  Department(this.id, this.city, this.address, this.photo, this.date);
  int id;
  String city;
  String address;
  String photo;
  String date;
}

class Teacher {
  Teacher(this.id, this.name, this.subjectId, this.contact, this.startDate,
      this.photo);
  int id;
  String name;
  int subjectId;
  String contact;
  String startDate;
  String photo;
}

class Home extends StatelessWidget {
  var number, groupLeader;
  var supervisor;

  String className;
  Home(this.className);
  List<Department> departments = [];
  List<Teacher> teachers = [];

  Future<int> dbc() async {
    var connection = PostgreSQLConnection("35.224.75.97", 5432, "postgres",
        username: "postgres", password: "123");
    await connection.open();
    print("connected");

    List<List<dynamic>> results = await connection.query(
        "Select * from teachers where teacher_id=(select first_subjects_teacher from course inner join class on class.course_id=course.course_id where class.name='$className')OR(teacher_id=(select second_subjects_teacher from course inner join class on class.course_id=course.course_id where class.name='$className'))OR(teacher_id=(select third_subjects_teacher from course inner join class on class.course_id=course.course_id where class.name='$className'))");
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

  Future<int> dbc1() async {
    var connection = PostgreSQLConnection("35.224.75.97", 5432, "postgres",
        username: "postgres", password: "123");
    await connection.open();
    print("connected");
    var numbers = await connection.query(
        "Select count(*),(Select name from students where student_id=(Select class_leader from class where name='$className')),(Select name from teachers where teacher_id=(Select class_teacher_id from class where name='$className')) from students");

    number = numbers[0][0];
    groupLeader = numbers[0][1];
    supervisor = numbers[0][2];

    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search Teacher",
                        ),
                        onSubmitted: (text) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(text)),
                          );
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      "CS2009 group teachers:",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: dbc(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return CarouselSlider(
                        options: CarouselOptions(
                            height: 300.0, enableInfiniteScroll: false),
                        items: teachers.map((i) {
                          return Builder(
                            builder: (
                              BuildContext context,
                            ) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DepartmentInfo(i.id)),
                                  );
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(i.photo),
                                            fit: BoxFit.cover)),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          i.name,
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.white,
                                              backgroundColor: Colors.black),
                                        ),
                                      ),
                                    )),
                              );
                            },
                          );
                        }).toList(),
                      );
                    }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      "About CS2009 class",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: dbc1(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LinearProgressIndicator();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Number of students in $className: ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: "$number",
                                        style: TextStyle(
                                            backgroundColor: Colors.yellow))
                                  ]),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "Your group leader- ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "$groupLeader",
                                        style: TextStyle(
                                            backgroundColor: Colors.yellow,
                                            fontSize: 18)),
                                  ]),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "Your supervisor(curator)- ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "$supervisor",
                                        style: TextStyle(
                                            backgroundColor: Colors.yellow,
                                            fontSize: 18)),
                                  ]),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
