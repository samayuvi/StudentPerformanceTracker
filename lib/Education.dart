import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:postgres/postgres.dart';

class Education extends StatefulWidget {
  String secWord;
  Education(this.secWord);
  @override
  _EducationState createState() => _EducationState();
}

class Mark {
  int mark;
  String course;

  Mark(
    this.mark,
    this.course,
  );
}

class MarkInfo {
  int mark;
  int markId;
  String course;
  String date;
  MarkInfo(this.mark, this.markId, this.course, this.date);
}

class _EducationState extends State<Education> {
  String secWord;
  double attendance;
  String name;
  double avgMark;
  int attScore;
  List<MarkInfo> marksHistory = [];

  List<Mark> avgSBC = [];

  Future<int> dbc() async {
    secWord = widget.secWord;
    var connection = PostgreSQLConnection("35.224.75.97", 5432, "postgres",
        username: "postgres", password: "123");
    await connection.open();
    var nameT = await connection
        .query("Select name from students where secret_word='$secWord'");
    name = nameT[0][0];
    List<List<dynamic>> avg = await connection.query(
        "Select cast(round(avg(mark)) as float) from marks where student_id=(select student_id from students where secret_word='$secWord')");
    avgMark = avg[0][0];
    if (avg[0][0] == null) {
      avgMark = 0;
    }

    var attendanceT = await connection.query(
        "Select (cast(sum(attendance) as float)/(select sum(lesson_id)from lesson inner join class on class.class_id=lesson.class_id where class.name='CS2009')*10)att from attendance where student_id=(select student_id from students where secret_word='$secWord') group by student_id ");
    attendance = attendanceT[0][0];
    if (attendanceT[0][0] == null) {
      attendance = 0;
    }
    attScore = (attendance * 100).round();
    List<List<dynamic>> markHistoryT = await connection.query(
        "Select mark,mark_id,subject.name,date from marks inner join lesson on lesson.lesson_id=marks.lesson_id inner join subject on lesson.subject_id=subject.subject_id where student_id =(Select student_id from students where secret_word='$secWord') order by date desc"); //todo add real secWord

    for (var rows in markHistoryT) {
      marksHistory.add(MarkInfo(rows[0], rows[1], rows[2], rows[3].toString()));
    }
    List<List<dynamic>> avgSBCT = await connection.query(
        "Select name ,cast(round(avg(mark)) as bigInt) from marks inner join lesson on marks.lesson_id=lesson.lesson_id inner join subject on subject.subject_id=lesson.subject_id where marks.student_id=(Select student_id from students where secret_word='$secWord') group by name"); //todo add real secWord

    for (var rows in avgSBCT) {
      avgSBC.add(Mark(rows[1], rows[0]));
    }

    print('suc');
    return 1;
  }

  Future<void> _showMyDialog(String date, String course) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Date: $date'),
                Text('Course: $course'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Education"),
      ),
      body: FutureBuilder(
          future: dbc(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                  child: Text(
                    "Hello $name",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(
                            child: CircularPercentIndicator(
                                radius: 150.0,
                                progressColor: Colors.blue,
                                animation: true,
                                animationDuration: 1200,
                                lineWidth: 5.0,
                                percent: attendance,
                                center: Text(
                                  "Attendance\n" + "$attScore%",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(
                            child: CircularPercentIndicator(
                                radius: 150.0,
                                progressColor: Colors.red,
                                animation: true,
                                animationDuration: 1200,
                                lineWidth: 5.0,
                                percent: avgMark / 100,
                                center: Text(
                                  "Average Score\n" + "$avgMark%",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Marks history",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: marksHistory.length,
                            itemBuilder: (context, index) {
                              int localMark = marksHistory[index].mark;
                              Color color = Colors.red;
                              if (localMark > 70) {
                                color = Colors.green;
                              }
                              String date = marksHistory[index].date.substring(
                                  0, marksHistory[index].date.length - 13);
                              String courseName = marksHistory[index].course;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    _showMyDialog(date, courseName);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: color)),
                                    child: Center(
                                      child: Text(
                                        "$localMark",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Average scores sorted\nby courses",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: avgSBC.length,
                            itemBuilder: (context, index) {
                              String name = avgSBC[index].course;
                              int mark = avgSBC[index].mark;
                              Color color;
                              if (mark < 70) {
                                color = Colors.red;
                              } else {
                                color = Colors.green;
                              }
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "$name: ",
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text("$mark",
                                                style: TextStyle(fontSize: 18)),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border:
                                                    Border.all(color: color)),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.deepPurpleAccent,
                                      )
                                    ],
                                  ));
                            }),
                      ),
                    ],
                  ),
                  flex: 2,
                )
              ],
            );
          }),
    );
  }
}
