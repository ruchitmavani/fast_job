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

      if (kDebugMode) {
        return;
      }
      Future.delayed(
          const Duration(
            milliseconds: 2000,
          ),
          heavyTask);
    });
  }

  bool isLoad = false;

  bool isLoadImage = false;

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
        ..download = "${userData?['noc'] ?? "image"}.png"
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
                              child: Image.network(
                                "https://fastemployee.web.app/assets/assets/images/placement_logo.jpg",
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox();
                                },
                                loadingBuilder: (
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress,
                                ) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )),
                        Column(
                          children: [
                            Image.network(
                              "https://fastemployee.web.app/assets/assets/images/logo.jpg",
                              width: 649,
                              height: 185,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                              loadingBuilder: (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  print(loadingProgress.expectedTotalBytes);
                                  print(
                                      "l-${loadingProgress.cumulativeBytesLoaded}");

                                  return Center(
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  color: const Color(0xffFDF0CF)),
                              child: const Column(
                                children: [
                                  Text(
                                    'CANDIDATE FOR GET FREE JOB VACANCY NOTIFICATION AND\nCOMPANY FOR PUBLISH STAFF VACANCY POST CONTACT TO : ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w800),
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
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w800),
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
                                    vertical: BorderSide(width: 2),
                                  ),
                                  color: Color(0xffB4E0FC)),
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide())),
                                child: Text(
                                  'JOB VACANCY',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'DMSans',
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            Table(
                              border: TableBorder.all(width: 2),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {0: FixedColumnWidth(420)},
                              children: [
                                TableRow(children: [
                                  const TableCell(
                                    "DATE OF JOB VACANCY:",
                                  ),
                                  TableCell(userData?['date'] ?? "")
                                ]),
                                TableRow(children: [
                                  const TableCell('COMPANY NAME:'),
                                  TableCell(userData?['noc'] ?? "")
                                ]),
                                TableRow(children: [
                                  const TableCell('JOB LOCATION:'),
                                  TableCell(userData?['jobAdd'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('JOB POSITION:'),
                                  TableCell(userData?['jobPos'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('NO. OF VACANCY:'),
                                  TableCell(userData?['nov'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('EDUCATION QUALIFICATION:'),
                                  TableCell(userData?['eq'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('EXPERIENCE:'),
                                  TableCell(userData?['je'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('REQUIRED SKILL:'),
                                  TableCell(userData?['keySkill'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('SALARY PER MONTH:'),
                                  TableCell(userData?['spm'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('CONTACT PERSON NAME:'),
                                  TableCell(userData?['cpname'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('CONTACT PERSON MOBILE NO:'),
                                  TableCell(userData?['cpmn'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('CONTACT PERSON EMAIL:'),
                                  TableCell(userData?['email'] ?? '')
                                ]),
                                TableRow(children: [
                                  const TableCell('TIMING OF CONTACT:'),
                                  TableCell(userData?['ctfcon'] ?? '')
                                ]),
                              ],
                            ),
                            Container(
                              width: 1080,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(width: 2),
                                      bottom: BorderSide(width: 2),
                                      right: BorderSide(width: 2)),
                                  color: Color(0xffFDF0CF)),
                              child: const Text(
                                'PLEASE SHARE THIS JOB POST WITH YOUR FRIENDS AND FAMILY MEMBERS.\nSO THE RELEVANT PERSON OF THIS JOB POST CAN GET A JOB EASILY.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'DMSans'),
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
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Incase didn't download , press download button",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'DMSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: heavyTask, child: const Text('Download'))),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Text(
        text.trim(),
        style: const TextStyle(
            fontSize: 22,
            fontFamily: 'DMSans',
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            shadows: [
              BoxShadow(color: Colors.black, spreadRadius: 0.1, blurRadius: 0.2)
            ]),
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
