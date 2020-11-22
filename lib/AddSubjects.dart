import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/color_utils.dart';

class AddSubjects extends StatefulWidget {
  @override
  _AddSubjectsState createState() => _AddSubjectsState();
}

class _AddSubjectsState extends State<AddSubjects> {
  String subjectName, subjectTeacher, subjectCode;

  final databaseReference = FirebaseDatabase.instance.reference();

  void addSubject() {
    databaseReference.child("subjects/" + "${subjectCode.toUpperCase()}").set(
        {'subjectName': '${subjectName.capitalize()}', 'subjectTeacher': '${subjectTeacher.capitalize()}'}).then((value) => {
          Navigator.pop(context)

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.SecondaryColor,
        title: Text("Add Subject",style: GoogleFonts.lato(color:Colors.white),),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Subject Name",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: TextEditingController()
                                        ..text = this.subjectName,
                                      // keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                        hintText: "Enter Subject Name",
                                      ),
                                      onChanged: (text) {
                                        this.subjectName = text;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Subject Teacher",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: TextEditingController()
                                        ..text = this.subjectTeacher,
                                      //keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                        hintText: "Enter Subject Teacher",
                                      ),
                                      onChanged: (text) {
                                        this.subjectTeacher = text;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Subject Code",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: TextEditingController()
                                        ..text = this.subjectCode,
                                      // keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                        hintText: "Enter Subject Code",
                                      ),
                                      onChanged: (text) {
                                        this.subjectCode = text;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ])),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: addSubject,
                  color: ColorsUtils.SecondaryColor,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Helvetica",
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}