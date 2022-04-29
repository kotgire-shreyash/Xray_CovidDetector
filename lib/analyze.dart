import 'dart:io';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';

class AnalyzePage extends StatefulWidget {
  final File imageFile;
  const AnalyzePage({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  bool isModelLoaded = false;
  List<dynamic>? result = [];
  bool isCovidPositive = false;
  loadModel() async {
    try {
      var output = await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
      print(output);
      _runModelOnImage();
      setState(() {
        isModelLoaded = true;
      });
    } catch (e) {
      print('ERROR OCCURED:' + e.toString());
    }
  }

  _runModelOnImage() async {
    try {
      var outputs = await Tflite.runModelOnImage(
        path: widget.imageFile.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5,
      );
      print('#######');
      print(outputs);
      if (outputs![0]['index'] == 0) {
        isCovidPositive = true;
      }
      setState(() {
        result = outputs;
      });
    } catch (e) {
      print('ERROR OCCURED RUN MODEL ' + e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: isModelLoaded
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                image: DecorationImage(
                                    image: FileImage(
                                      widget.imageFile,
                                    ),
                                    fit: BoxFit.fill)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.imageFile.path,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "RESULT:",
                        style: TextStyle(color: Colors.blue, fontSize: 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isCovidPositive
                          ? SizedBox(
                              height: 50,
                              width: 275,
                              child: ElevatedButton(
                                onPressed: null,
                                child: Text('Covid +ve',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, fontSize: 15)),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.shade700),
                              ),
                            )
                          : SizedBox(
                              height: 50,
                              width: 275,
                              child: ElevatedButton(
                                onPressed: null,
                                child: Text('Covid -ve',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, fontSize: 15)),
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.lightGreenAccent.shade700),
                              ),
                            ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Confidence:",
                        style: TextStyle(color: Colors.blue, fontSize: 22),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: result!.first['confidence'],
                        center: Text(
                          double.parse((result!.first['confidence'] * 100)
                                      .toString())
                                  .toStringAsFixed(2) +
                              "%",
                        ),
                        progressColor: Colors.green,
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
