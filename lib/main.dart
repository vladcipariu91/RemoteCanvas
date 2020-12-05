import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:remote_canvas/local.dart';
import 'package:remote_canvas/remote.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(RemoteCanvas());
}

class RemoteCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RemoteCanvasWidget(),
    );
  }
}

class RemoteCanvasWidget extends StatefulWidget {

  @override
  State createState() => RemoteCanvasState();
}

class RemoteCanvasState extends State<RemoteCanvasWidget> {

  IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    openSocket();
  }

  openSocket() {
    channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          LocalDrawingWidget(
            sink: channel.sink,
            width: 400,
            height: 400,
          ),
          RemoteDrawingWidget(
            stream: channel.stream,
            width: 400,
            height: 400,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Paint drawingPaint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.blue
    ..strokeWidth = 10
    ..style = PaintingStyle.fill;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (var i = 0; i < points.length - 1; i++) {
      final thisPoint = points[i];
      final nextPoint = points[i + 1];
      if (thisPoint != null && nextPoint != null) {
        canvas.drawLine(thisPoint, nextPoint, drawingPaint);
      } else if (thisPoint != null && nextPoint == null) {
        canvas.drawPoints(PointMode.lines, [thisPoint], drawingPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
