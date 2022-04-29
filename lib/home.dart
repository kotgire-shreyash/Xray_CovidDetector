import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:tflite/tflite.dart';
import 'package:xray_detection/analyze.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _imageFile;

  bool isFileSelected = false;
  var fileName;
  _pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (xFile != null) {
      setState(() {
        _imageFile = File(xFile.path);
        fileName = xFile.name;
        isFileSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/chooseVector.jpg',
                fit: BoxFit.fill,
              ),
              height: 360,
              padding: EdgeInsets.all(15),
              color: Colors.white,
            ),
            Text(
              'choose file to \n complete action',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: SizedBox(
                    child: Image.asset('assets/folder.png'),
                    height: 80,
                    width: 80,
                  ),
                ),
                InkWell(
                  onTap: _pickImage,
                  child: SizedBox(
                    child: Image.asset(
                      'assets/camera.png',
                      height: 70,
                      width: 80,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            isFileSelected
                ? Text(fileName)
                : Container(
                    height: 10,
                  ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 270,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnalyzePage(imageFile: _imageFile)));
                },
                // style: TextButton.styleFrom(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Analyze',
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
