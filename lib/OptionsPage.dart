import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:omr/AddQuestionPaper.dart';
import 'package:omr/ResultList.dart';
import 'package:omr/color_utils.dart';
import 'package:omr/uploadAnswerSheets.dart';

class OptionsPage extends StatefulWidget {
  String subjectCode;

  OptionsPage(this.subjectCode);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List questionsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  readData() async {
    DataSnapshot snapshot = await databaseReference
        .child("subjects/" + "${widget.subjectCode}/" + "Questions")
        .once();
    //print(" Snapshot value ${snapshot.value}");
    questionsList = snapshot.value == null ? null : snapshot.value.toList();
    print("List $questionsList");
    // return snapshot.value ;
  }

  addQuestionPaper() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddQuestionPaper(widget.subjectCode)),
    );
  }

  resultList() {
    if (questionsList != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultList(widget.subjectCode, questionsList)),
      );
    } else {
      print("Add Question Paper ");
    }
  }

  addAnswerScrips() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadAnswerSheets(widget.subjectCode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.SecondaryColor,
        title: Text('Options Page'),
      ),
      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.all(25.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: resultList,
                color: Color(0xff3CB371),
                child: Text(
                  "View Result",
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
          Padding(
            padding: EdgeInsets.all(25.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: addAnswerScrips,
                color: Color(0xff3CB371),
                child: Text(
                  "Upload Answer Sheets",
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
          Padding(
            padding: EdgeInsets.all(25.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: addQuestionPaper,
                color: Color(0xff3CB371),
                child: Text(
                  "Add Question Paper",
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
    );
  }
}
