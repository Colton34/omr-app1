import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:omr/AddSubjects.dart';
import 'package:omr/OptionsPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:omr/AddSubjects.dart';
import 'package:omr/color_utils.dart';

class ViewSubjects extends StatefulWidget {
  @override
  _ViewSubjectsState createState() => _ViewSubjectsState();
}

class _ViewSubjectsState extends State<ViewSubjects> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final List<Color> colors = <Color>[
    Color(0xff6b34eb),
    Color(0xffbd2020),
    Color(0xff915e3f),
    Color(0xffb8a9a0),
    Color(0xff913368)

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.SecondaryColor,

        title: Text('Dashboard',style: GoogleFonts.lato(color:Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FirebaseAnimatedList(
            query: databaseReference.child("subjects/"),
            itemBuilder:
                (_, DataSnapshot snapshot, Animation<double> animation, int x) {
              //print("Key : ${snapshot.key} \n Value : ${snapshot.value}");
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OptionsPage(snapshot.key)),
                  );
                },
                child: Card(
                    //Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
                    //color:  Colors.primaries[Random().nextInt(Colors.primaries.length)],
                    color: colors[x % colors.length],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${snapshot.value["subjectName"]}',
                              style: GoogleFonts.lato(
                                  fontSize: 20, color: Colors.white)),
                          Text(
                            '${snapshot.key}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${snapshot.value["subjectTeacher"]}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSubjects()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
