import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum FormType { job, emp }

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  Map<String, dynamic>? userData;
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final uri = Uri.parse(html.window.location.toString());
      userData = uri.queryParameters;
      setState(() {});

      Future.delayed(
          const Duration(
            milliseconds: 200,
          ),
          heavyTask);
    });
  }

  bool isLoad = false;

  void loading(bool value) {
    setState(() {
      isLoad = value;
    });
  }

  Future<void> heavyTask() async {
      await compute(captureAndDownloadImage, key);

  }

  Future<void> captureAndDownloadImage(GlobalKey key) async {
    try {
      loading(true);
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        loading(false);
        print("Failed to capture image data.");
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      String base64Image = base64Encode(pngBytes);

      html.AnchorElement anchor = html.AnchorElement(
        href: 'data:application/octet-stream;base64,$base64Image',
      )
        ..download = "image.png"
        ..target = 'blank';

// Trigger download
      anchor.click();
      anchor.remove();
      loading(false);
    } catch (error) {
      loading(false);
      print("Error capturing and downloading image: $error");
    }
  }

  Future<ui.Image> _resizeImage(
      ui.Image image, double scaleX, double scaleY) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.scale(scaleX, scaleY);

    canvas.drawImage(image, Offset.zero, Paint());

    final ui.Picture picture = recorder.endRecording();
    return picture.toImage(
        (image.width * scaleX).toInt(), (image.height * scaleY).toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          OverflowBox(
            minWidth: 1080,
            maxWidth: 1080,
            child: SingleChildScrollView(
              child: RepaintBoundary(
                key: key,
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            top: 200,
                            child: Opacity(
                                opacity: 0.15,
                                child: Image.asset(
                                    "assets/images/placement_logo.jpg"))),
                        Column(
                          children: [

                            Image.asset(
                              'assets/images/logo.jpg',
                              width: 649,
                              height: 185,

                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: const Color(0xffFDF0CF)),
                              child: const Column(
                                children: [
                                  Text(
                                    'CANDIDATE FOR GET FREE JOB VACANCY NOTIFICATION AND\nCOMPANY FOR PUBLISH STAFF VACANCY POST CONTACT TO : ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Color(0xff54AD3D),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '+91 90817 96019 (ONLY WHATSAPP)',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                    vertical: BorderSide(),
                                  ),
                                  color: Color(0xffB4E0FC)),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide())),
                                child: Text(
                                  'JOB VACANCY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                            Table(
                              border: TableBorder.all(),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: {0: FixedColumnWidth(420)},
                              children: [
                                TableRow(children: [
                                  TableCell("DATE OF JOB VACANCY:"),
                                  TableCell(userData?['date'] ?? "")
                                ]),
                                TableRow(children: [
                                  TableCell('COMPANY NAME:'),
                                  TableCell(userData?['noc'] ?? "")
                                ]),
                                TableRow(children: [
                                  TableCell('JOB LOCATION:'),
                                  TableCell(userData?['jobAdd'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('JOB POSITION:'),
                                  TableCell(userData?['jobPos'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('NO. OF VACANCY:'),
                                  TableCell(userData?['nov'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('EDUCATION QUALIFICATION:'),
                                  TableCell(userData?['eq'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('EXPERIENCE:'),
                                  TableCell(userData?['je'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('REQUIRED SKILL:'),
                                  TableCell(userData?['keySkill'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('SALARY PER MONTH:'),
                                  TableCell(userData?['spm'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('CONTACT PERSON NAME:'),
                                  TableCell(userData?['cpname'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('CONTACT PERSON MOBILE NO:'),
                                  TableCell(userData?['cpmn'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('CONTACT PERSON EMAIL:'),
                                  TableCell(userData?['email'] ?? '')
                                ]),
                                TableRow(children: [
                                  TableCell('TIMING OF CONTACT:'),
                                  TableCell(userData?['ctfcon'] ?? '')
                                ]),
                              ],
                            ),
                            Container(
                              width: 1080,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: const Color(0xffFDF0CF)),
                              child: Text(
                                'PLEASE SHARE THIS JOB POST WITH YOUR FRIENDS AND FAMILY MEMBERS.\nSO THE RELEVANT PERSON OF THIS JOB POST CAN GET A JOB EASILY.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!kDebugMode)
            ColoredBox(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                  child: ElevatedButton(
                      onPressed: heavyTask, child: const Text('Save'))),
            ),
        ],
      ),
    );
  }
}

class TableCell extends StatelessWidget {
  const TableCell(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class CommonTextWidget extends StatelessWidget {
  const CommonTextWidget({
    super.key,
    required this.topPosition,
    required this.text,
    required this.height,
  });

  final double topPosition;
  final String text;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      left: 300,
      width: 372,
      height: height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AutoSizeText(
          text,
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
    );
  }
}

class CommonRowComponent extends StatelessWidget {
  const CommonRowComponent({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FittedBox(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Text(description),
          ),
        )
      ],
    );
  }
}
