import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AddPicCircle extends StatelessWidget {
  final double size;
  final Function onPressed;
  final File image;
  final String imgUrl;
  const AddPicCircle({
    Key key,
    this.size = 100.0,
    this.onPressed,
    this.image,
    this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border:
            image != null ? Border.all(color: Colors.orange, width: 3.0) : null,
            shape: BoxShape.circle,
          ),
          child: CustomPaint(
            painter: DashedPainter(
              color: image == null && imgUrl == null
                  ? Colors.grey
                  : Colors.grey,
            ),
            child: image == null && imgUrl.isEmpty
                ? Icon(
              Icons.add,
              size: 50.0,
              color: Colors.grey,
            )
                : ClipOval(
              child: image != null
                  ? Image.file(
                image,
                fit: BoxFit.cover,
              )
                  : Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.black45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          size: 30.0,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        Text(
                          'Pick photo',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedPainter extends CustomPainter {
  final double dashOffset;
  final double dashWidth;
  final Color color;

  DashedPainter({
    this.dashOffset = 10.0,
    this.dashWidth = 3.0,
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double angle = (dashOffset / radius);

    for (var i = 0; i < math.pi * 2 * radius / dashOffset; i++) {
      final c = i % 2 == 0 ? Colors.transparent : color;
      canvas.drawArc(
        Offset.zero & size,
        0.0 + (angle * i),
        angle,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = dashWidth
          ..color = c,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
