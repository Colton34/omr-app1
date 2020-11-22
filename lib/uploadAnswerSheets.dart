import 'dart:ffi';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:omr/color_utils.dart';

class UploadAnswerSheets extends StatefulWidget {
  String subjectCode;

  UploadAnswerSheets(this.subjectCode);

  @override
  _UploadAnswerSheetsState createState() => _UploadAnswerSheetsState();
}

class _UploadAnswerSheetsState extends State<UploadAnswerSheets> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final String imageUploadEndPoint =
      'https://lem0tksic9.execute-api.us-east-1.amazonaws.com/default/upload';
  bool _saving = false;
  List<Asset> images = List<Asset>();
  File ansFile;
  String _error = "No error";
  String _anskey = "No file picked";

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;
    print('in load asset');
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  getImageFromAsset(String path) async {
    final file = File(path);
    return file;
  }

//  loadAnswers() async {
//    FilePickerResult result = await FilePicker.platform.pickFiles();
//
//    if (result != null) {
//      setState(() {
//        ansFile = File(result.files.single.path);
//        _anskey = ansFile.path.split("/").last;
//      });
//    } else {
//      // User canceled the picker
//    }
//  }
//
//  _submitAns() async {
//    if (ansFile == null) return;
//    File textFile = ansFile;
//    String base64Image = base64Encode(textFile.readAsBytesSync());
//
//    http.post(docUploadEndPoint, body: {
//      "doc": base64Image,
//      "name": _anskey,
//    }).then((res) {
//      print(jsonDecode(
//          res.body)['message']); // can use res.statusCode (without jsonDecode)
//    }).catchError((err) {
//      print(err);
//    });
//  }

  _submit() async {
    _saving=true;
    setState(() {

    });
    Map<dynamic, dynamic> myResponse = new Map();
    print("inside submit");
    const headers = {'Content-Type': 'application/jpg'};
    for (int i = 0; i < images.length; i++) {
      var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      print("Path : $path2");

      File file = await getImageFromAsset(path2);

      var response = await http.post(
        imageUploadEndPoint,
        headers: {
          'Content-Type': 'application/jpg',
        },
        body: await file.readAsBytes(),
      );
      if (response.statusCode == 200) {
        Map<dynamic, dynamic> responseMap = json.decode(response.body);
        print(responseMap["body"]["roll"]);
        String roll = responseMap["body"]["roll"];
        Map<dynamic, dynamic> answers = responseMap["body"];
        answers.remove("roll");
        answers.remove("testId");

        await databaseReference
            .child("subjects/${widget.subjectCode}/answers/" + roll)
            .set(answers);
        //print("Body ${json.decode(response.body)['body']['roll']}");
      }
    }
    _saving=false;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: ColorsUtils.SecondaryColor,
        title: const Text('Upload Answer Sheets'),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(),
        inAsyncCall: _saving,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: buildGridView(),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: loadAssets,
                           color: ColorsUtils.SecondaryColor,
                          child: Text(
                            "Pick Images",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Helvetica",
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: _submit,
                          color: ColorsUtils.SecondaryColor,
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Helvetica",
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
