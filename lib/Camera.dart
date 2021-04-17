import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';
import 'package:translator/translator.dart';

import 'constants.dart';
import 'custom_dialogue_box.dart';

class MyCamera extends StatefulWidget {
  @override
  _MyCameraState createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {
  //File our_image;

  /*for_gallery_image() async {
    var temp = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      our_image = File(temp.path);
      isloaded = true;
      applymodeltoimage(our_image);
    });
  }*/

  File imageFile;
  var picker = ImagePicker();
  bool isloaded = false;
  List ls;
  String name;
  String accuracy;
  String token = "66be94c19b9bff1b6408359d5304b75194c3cce0";
  String url = "https://owlbot.info/api/v4/dictionary/";
  String head = "Authorization: Token 66be94c19b9bff1b6408359d5304b75194c3cce0";

  Map<String, dynamic> details;
  final FlutterTts flutterTts = FlutterTts();
  bool flag = false;
  GoogleTranslator translator = GoogleTranslator();
  bool check = true;

  Future openCamera() async {
    var picture = await picker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(picture.path);
      isloaded = true;
      applymodeltoimage(imageFile);
    });
  }

  Future _speak() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.speak(name);
  }

  Future _speak1() async {
    var translation = await translator.translate(name, to: 'hi');
    print(translation);

    //await flutterTts.speak(translation);
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.speak(translation.text);
  }

  Future _speak2() async {
    var translation = await translator.translate(name, to: 'mr');
    print(translation);

    //await flutterTts.speak(translation);
    await flutterTts.setLanguage("mr-IN");
    await flutterTts.speak(translation.text);
  }

  _search() async {
    Response response = await http
        .get(url + name.trim(), headers: {'Authorization': "Token " + token});
    details = json.decode(response.body);
    setState(() {
      check = false;
    });
    print(details);
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: (flag
                ? IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {},
                    iconSize: 30,
                  )
                : IconButton(
                    icon: Icon(Icons.volume_down),
                    onPressed: () {},
                    iconSize: 30,
                  )),
            actions: [
              Card(
                color: kBlueColor,
                child: FlatButton(
                  child: Text(
                    "English",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      flag = true;
                    });
                    _speak();
                  },
                ),
              ),
              Card(
                color: kBlueColor,
                child: FlatButton(
                  child: Text(
                    "Hindi",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      flag = true;
                    });
                    _speak2();
                  },
                ),
              ),
              Card(
                color: kActiveIconColor,
                child: FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }

  load_model() async {
    var result = await Tflite.loadModel(
        labels: "assets/labels.txt", model: "assets/model_unquant.tflite");
    print("Our result ${result}");
  }

  applymodeltoimage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 1,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      ls = res;
      print(ls);
      String str = ls[0]['label'];
      name = str.substring(0);
      accuracy = ls != null
          ? (ls[0]['confidence'] * 100).toString().substring(0, 2) + "%"
          : " ";
    });
  }

  @override
  void initState() {
    super.initState();
    load_model().then((val) {
      setState(() {});
    });
  }

  cancel() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Color(0xff885566),
        title: Text("Camera"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: imageFile == null
                    ? Container(
                        height: 50, //MediaQuery.of(context).size.height *0.2,
                        width: 50,
                        child: Lottie.asset('assets/camera.json',
                            repeat: true, reverse: true, animate: true))

                    /* Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No image selected.',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )*/

                    : Image.file(imageFile),
              ),
              SizedBox(
                height: 5,
              ),

              //here we have to add prediction text
              Column(
                children: [
                  Container(
                    width: 300,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: name != null
                        ? Text(
                            "Name -${name}",
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            "Name - ",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: accuracy != null
                        ? Text(
                            " Confidence  - ${accuracy}",
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            "Confidence  -  ",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              ),
              //end prediction
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 80,
                      height: 70,
                      child: RaisedButton(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ),
                        onPressed: openCamera,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      child: FloatingActionButton.extended(
                    icon: Icon(
                      Icons.cancel,
                      size: 30,
                    ),
                    onPressed: cancel,
                    label: Text("cancel"),
                    backgroundColor: Colors.pink,
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*(RaisedButton(
                    child: Text("Voice"),
                    onPressed: () {
                      showAlertDialog(context);
                    },
                  ),*/
                  InkWell(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: Card(
                        color: kActiveIconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          width: 100,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Voice'), Icon(Icons.volume_up)],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  InkWell(
                    child: Card(
                        color: kActiveIconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          width: 100,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Defination'),
                              Icon(Icons.volume_up)
                            ],
                          ),
                        )),
                    onTap: () {
                      _search();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return check
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    child: CircularProgressIndicator(
                                      value: 10,
                                    ),
                                  )
                                : CustomDialogBox(
                                    details: details,
                                  );
                          });
                    },
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
