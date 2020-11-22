import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/color_utils.dart';

class ResultDetails extends StatefulWidget {
  Map<dynamic, dynamic> response;

  ResultDetails(this.response);

  @override
  _ResultDetailsState createState() => _ResultDetailsState();
}

class _ResultDetailsState extends State<ResultDetails> {
  TextStyle textStyle = GoogleFonts.lato();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Length : ${widget.response["options"].length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUtils.SecondaryColor,
          title: Text("Result Details",style: GoogleFonts.lato(color:Colors.white),)),
      body: ListView.builder(
        itemBuilder: (context, i) {
          print(widget.response["options"]["${i + 1}"]);
          return widget.response["options"]["${i + 1}"] == null
              ? Container()
              : questionCard(
                  i + 1,
                  widget.response["options"]["${i + 1}"]["correctChoice"],
                  widget.response["options"]["${i + 1}"]["selectedChoice"],
                  widget.response["options"]["${i + 1}"]["answerOutcome"]);
        },
        itemCount: widget.response["options"].length,
      ),
    );
  }

  questionCard(int questionNo, String correctOption, String selectedOption,
      String verdict) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Q $questionNo', style: textStyle),
              Text('Correct Choice : $correctOption', style: textStyle),
              Text('Selected Choice : $selectedOption', style: textStyle),
              Text('Outcome : $verdict', style: textStyle)
            ],
          ),
        ),
      ),
    );
  }
}
