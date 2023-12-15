import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TODO notepad',
      home: MainPage(),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);

    final firstControlPoint = Offset(size.width / 4, size.height * 0.45);
    final firstEndPoint = Offset(size.width / 2.25, size.height * 0.9);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height * 1.3);
    final secondEndPoint = Offset(size.width, size.height * 0.9);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        toolbarHeight: 80.0,
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Friday",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    "September 2",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              Icon(
                Icons.settings,
                size: 40,
                color: Colors.blueGrey,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 12.0,
                color: Colors.blueGrey[50],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 80.0),
              width: 2.0,
              height: screenHeight,
              color: Colors.red[200],
            ),
          ],
        ),
      ),
    );
  }
}
