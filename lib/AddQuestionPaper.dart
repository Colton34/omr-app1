import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/OptionsPage.dart';
import 'package:omr/color_utils.dart';

class AddQuestionPaper extends StatefulWidget {
  String subjectCode;
  List questionPaper;

  AddQuestionPaper(this.subjectCode, this.questionPaper);

  @override
  _AddQuestionPaperState createState() => _AddQuestionPaperState();
}

class _AddQuestionPaperState extends State<AddQuestionPaper> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<int> actualAnswers = List(30);
  int questionsCount = 20;
  int _radioVal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.questionPaper != null)
     for(int i =  0 ; i  < widget.questionPaper.length ; i++)
       {
         if(widget.questionPaper[i] == "1"  || widget.questionPaper[i] == "0" || widget.questionPaper[i] == "2" ||widget.questionPaper[i] == "3" )
         actualAnswers[i] = int.parse(widget.questionPaper[i]);
       }

     }

  Future<void> addQuestions() async {
    Map<dynamic, dynamic> questions = {};
    //print("Inside Add Questions");
    for (int i = 0; i <= questionsCount; i++) {
      //print("${i.toString()} ${actualAnswers[i]}");
      questions["$i"] = "${actualAnswers[i]}";
    }
    //print("After for loop");
    await databaseReference
        .child("subjects/" + "${widget.subjectCode}/" + "Questions")
        .set(questions)
        .then((value) => {
              //Navigator.pop(context)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OptionsPage(widget.subjectCode)),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.SecondaryColor,
        title: Text(
          'Add Question Paper',
          style: GoogleFonts.lato(color: Colors.white),
        ),
        actions: [
          InkWell(
              onTap: () {
                questionsCount += 1;
                setState(() {});
              },
              child: Icon(Icons.add)),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              // color: Colors.greenAccent,
              height: 200,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Q ${index + 1}"),
                        Flexible(
                          child:

                              Row(
                            children: [0, 1, 2, 3]
                                .map(
                                  (int i) => Radio<int>(
                                    value: i,
                                    groupValue: this.actualAnswers[index + 1],
                                    onChanged: (int value) {
                                      setState(() {
                                        this.actualAnswers[index + 1] = value;
                                        print("Actual Answers : ${actualAnswers}");
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        //Text('A')
                      ],
                    ),
                  );
                },
                itemCount: questionsCount,
              ),
            )),
//            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: addQuestions,
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
