import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  List<dynamic> actualAnswers = List(30);
  int questionsCount = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.questionPaper != null) actualAnswers = widget.questionPaper;
    for (int i = 0; i < actualAnswers.length; i++) {
      if (actualAnswers[i] == "null") {
        actualAnswers[i] = "";
      }
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
              Navigator.push(
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
        title: Text('Add Question Paper'),
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
                        Flexible(child: Text("Q ${index + 1}")),
                        Flexible(
                          child: TextField(
                            controller: TextEditingController()
                              ..text = this.actualAnswers[index + 1],
                            // keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              hintText: "",
                            ),
                            onChanged: (text) {
                              this.actualAnswers[index + 1] = text;
                            },
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
                  color: Color(0xff3CB371),
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
