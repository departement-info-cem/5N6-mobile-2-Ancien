import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// TODO IOS necessite d'indiquer pourquoi on utilise les photos
// le fichier a modifier est dans ios/Runner/Info.plist
//
// suivre https://stackoverflow.com/questions/39519773/nsphotolibraryusagedescription-key-must-be-present-in-info-plist-to-use-camera-r

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final picker = ImagePicker();

  var _imageFile = null;

  Future<String> sendPicture(int babyID, File file) async {
    FormData formData = FormData.fromMap({
      "babyID": babyID,
      "file" : await MultipartFile.fromFile(file.path ,filename: "image.jpg")
    });
    var url = "https://localhost:8080/file";
    var response = await Dio().post(url, data: formData);
    print(response.data);
    return "";
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        setState(() {});
        // TODO envoi au server
        sendPicture(12, _imageFile).then(
                (res) {
              setState(() {
                // TODO mettre a jour interface graphique
              });
            }
        ).catchError(
                (err) {
              print(err);
            }
        );

      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('envoi image'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            _imageFile == null ?
              Container(color: Colors.red, height: 50,) :
              SizedBox(
                child: Image.file(_imageFile),
                height: 250,
              ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
