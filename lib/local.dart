import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LocalDrawingWidget extends StatefulWidget {
  final Sink sink;
  final double width;
  final double height;

  const LocalDrawingWidget({Key key, this.width, this.height, this.sink}) : super(key: key);

  @override
  _LocalDrawingState createState() => _LocalDrawingState();
}

class _LocalDrawingState extends State<LocalDrawingWidget> {
  final points = <Offset>[];

  publishPoint(Offset offset) {
    if (offset != null) {
      final json = "{\"x\": ${offset.dx.toStringAsFixed(1)}, \"y\": ${offset.dy.toStringAsFixed(1)}}";
      widget.sink.add(json);
    } else {
      widget.sink.add("null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.green,
      child: GestureDetector(
        onPanStart: (details) {
          publishPoint(details.localPosition);
          setState(() {
            points.add(details.localPosition);
          });
        },
        onPanUpdate: (details) {
          publishPoint(details.localPosition);
          setState(() {
            points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          publishPoint(null);
          setState(() {
            points.add(null);
          });
        },
        child: Container(
          child: ClipRect(
            child: CustomPaint(
              painter: DrawingPainter(points),
            ),
          ),
        ),
      ),
    );
  }
}
