import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/ResultDetail.dart';
import 'package:omr/color_utils.dart';

class ResultList extends StatefulWidget {
  String subjectCode;
  List<dynamic> questions;

  ResultList(this.subjectCode, this.questions);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  int positiveMarks = 1, negativeMarks = 0;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("Incoming Subject Code ${widget.subjectCode}" );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result List"),
        backgroundColor: ColorsUtils.SecondaryColor,
      ),
      body: FirebaseAnimatedList(
          query: databaseReference
              .child('subjects/' + '${widget.subjectCode}' + "/answers"),
          itemBuilder:
              (_, DataSnapshot snapshot, Animation<double> animation, int x) {
            print("Snapshot ${snapshot.value}");
            String roll = snapshot.key.toString();
            List answers = snapshot.value.toList();
            int totalMarks = 0 ;
            int correctChoice = 0 ;
            //print("Roll $roll");
            //print("Length of Questions List ${widget.questions.length}");
            Map<dynamic, dynamic> testData = {};
            testData["options"] = {};
            for (int i = 0; i < widget.questions.length; i++) {
             // if (!snapshot.key.contains("$i")) {
              //  print("Roll $roll None : $i");
//                Map data = {
//                  "correctChoice" : "${widget.questions[i]}",
//                  "answerOutcome" : "Not Answered",
//                  "selectedChoice": "None"
//                };
//                testData["options"]["$i"] = data;
              //  continue;
           //   }

              Map data;
              if (widget.questions[i] == snapshot.value[i]) {
                data = {
                  "correctChoice" : "${widget.questions[i]}",
                  "selectedChoice": "${snapshot.value[i]}",
                  "answerOutcome" : "Correct"
                };

                totalMarks += positiveMarks;
                correctChoice += 1;
              } else {
                data = {
                  "correctChoice" : "${widget.questions[i]}",
                  "selectedChoice": "${snapshot.value[i]}",
                  "answerOutcome" : snapshot.value[i] =="None"? "Unanswered": "Incorrect"
                };
                totalMarks -= negativeMarks;
              }
              //print("$i ${widget.questions[i]} ${snapshot.value[i]}");
              testData["options"]["$i"] = data;
            }
            testData["totalMarks"] = totalMarks;
            testData["correctChoice"] = correctChoice;
            //print("Roll : $roll \n TestData : ${testData}");
            //print("Total Marks ${totalMarks}");
            return InkWell(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultDetails(testData)),
                );
              },
              child: Card(
                //   color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Roll : $roll",
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      Text(
                        'Total Marks $totalMarks',
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      Text(
                        'Correct Choice $correctChoice',
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
