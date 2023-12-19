import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String dow;
  late String month;
  late String day;

  @override
  void initState() {
    super.initState();
    updateDay();
  }

  void updateDay() {
    setState(() {
      dow = DateFormat('EEEE').format(DateTime.now());
      month = DateFormat('MMMM').format(DateTime.now());
      day = DateFormat('dd').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        toolbarHeight: 80.0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dow,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    '$month  $day',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const Icon(
                Icons.settings,
                size: 40,
                color: Colors.blueGrey,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 12.0,
                color: Colors.blueGrey[50],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 80.0),
                        width: 2.0,
                        height: screenHeight,
                        color: Colors.red[200],
                      ),
                    ],
                  ),
                  Positioned(
                    child: Column(
                      children: List.generate(
                        8,
                        (index) => SizedBox(
                          height: 70,
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 153, 196, 231),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    bottom: 16.0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      onPressed: () {},
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.create_sharp,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
