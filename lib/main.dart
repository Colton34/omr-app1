import 'package:flutter/material.dart';
import 'package:omr/AddQuestionPaper.dart';
import 'package:omr/AddSubjects.dart';
import 'package:omr/ViewSubjects.dart';
import 'package:omr/OptionsPage.dart';
import 'package:omr/ResultList.dart';
import 'homePage.dart';
import 'uploadAnswerSheets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ViewSubjects()
    );
  }
}
