import 'dart:convert';
import 'dart:io';
import 'custom_dialogue_box.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class MyGallery extends StatefulWidget {
  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  //File our_image;

  /*for_gallery_image() async {
    var temp = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      our_image = File(temp.path);
      isloaded = true;
      applymodeltoimage(our_image);
    });
  }*/
  String token="66be94c19b9bff1b6408359d5304b75194c3cce0";
  String url="https://owlbot.info/api/v4/dictionary/";
  String head="Authorization: Token 66be94c19b9bff1b6408359d5304b75194c3cce0";
  File imageFile;
  var picker = ImagePicker();
  bool isloaded = false;
  List ls;
  String name;
  String accuracy;
  Map<String, dynamic> details;
  final FlutterTts flutterTts=FlutterTts();
  bool flag=false;
  GoogleTranslator translator=GoogleTranslator();

  Future _speak ()
  async {
    
    await flutterTts.setLanguage("en-IN");
    await flutterTts.speak(name);
    
  }
  Future _speak1 ()
  async {
    
    
    var translation = await translator.translate(name, to: 'hi');
    print(translation);
    
    //await flutterTts.speak(translation);
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.speak(translation.text);
  } 
   _search()
  async {
    Response response=await http.get(url+name.trim(),headers:{'Authorization':"Token "+token });
     details=json.decode(response.body);
    print(details);
   
  }
  
  showAlertDialog(BuildContext context) {

  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState)
      {
        return AlertDialog(
    
              content:(flag?Icon(Icons.volume_up):Icon(Icons.volume_down)),
              actions: [
                FlatButton(
                    child: Text("English"),
                    onPressed:  () {
                        setState(() {
                          flag=true;
                        });
                        _speak();
                    },
                  ),
                   
                FlatButton(
                  child: Text("Hindi"),
                  onPressed:  () {
                    setState(() {
                      flag=true;
                    });
                      _speak1();
                  },
                ),

                FlatButton(
                  child: Text("Cancel"),
                  onPressed:  () {
                    Navigator.of(context).pop();
                  },
                ),


    ],
  );

      });
    },
  );
}
 

  Future openGallery() async {
    var picture = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture.path);
      isloaded = true;
      applymodeltoimage(imageFile);
    });
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

  cancelpic() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff885566),
        title: Text("Gallery"),
      ),
      body:Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/Gallery.jpg'),
          fit: BoxFit.cover)),
          child: Center(
            child: Column(
      children: [
        Container(
          height: 350,
          width: MediaQuery.of(context).size.width * 0.7,
          child: imageFile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No image selected.',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(
                        Icons.photo,
                        size: 150,
                        color: Colors.black26,
                      )
                    ],
                  ),
                )
              : Image.file(imageFile),
        ),
        SizedBox(
          height: 5,
        ),
        //here we have to add prediction
        Column(
          children: [
            Container(
              width: 300,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(100),
              ),
              child: name != null
                  ? Text(
                      "Name  - ${name}",
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
                color: Colors.green[300],
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
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 60,
                height: 70,
                child: RaisedButton(
                  child: Icon(
                    Icons.photo_library,
                    size: 50,
                  ),
                  onPressed: openGallery,
                )),
            SizedBox(
              width: 20,
            ),
            Container(
                child: FloatingActionButton.extended(
              icon: Icon(
                Icons.cancel,
                size: 10,
              ),
              onPressed: cancelpic,
              label: Text("cancel"),
              backgroundColor: Colors.pink,
            ))
          ],
        ),
        RaisedButton(
          child:Text("Voice"),
          onPressed:(){
              showAlertDialog(context);
          } ,
          ),
        RaisedButton(
        child:Text("Definition"),  
        onPressed:()
        {
              _search();
              showDialog(context: context,
                  builder: (BuildContext context){
                  return CustomDialogBox(
                    details: details,
                   
                  );
                  }
                );
        })

      ],
            ),
          ),
        ),
    );
  }
}
