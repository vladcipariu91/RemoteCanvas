import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remote_canvas/main.dart';

class RemoteDrawingWidget extends StatefulWidget {
  final Stream stream;
  final double width;
  final double height;

  const RemoteDrawingWidget({Key key, this.width, this.height, this.stream}) : super(key: key);

  @override
  State createState() => RemoteDrawingState();
}

class RemoteDrawingState extends State<RemoteDrawingWidget> {
  final points = <Offset>[];

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      if (event != "null") {
        Map<String, dynamic> offsetJson = jsonDecode(event);
        final dx = offsetJson['x'];
        final dy = offsetJson['y'];
        setState(() {
          points.add(Offset(dx, dy));
        });
      } else {
        setState(() {
          points.add(null);
        });
      }
    }, onError: (error) {
      debugPrint("Error $error");
    }, onDone: () {
      debugPrint("Done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.purple,
      child: ClipRect(
        child: CustomPaint(
          painter: DrawingPainter(points),
        ),
      ),
    );
  }
}
