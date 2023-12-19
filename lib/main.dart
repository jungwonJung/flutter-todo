import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class TodoItem {
  String title;
  bool isChecked;

  TodoItem({required this.title, this.isChecked = false});
}

class _MainPageState extends State<MainPage> {
  late String dow;
  late String month;
  late String day;
  late TextEditingController _todoController;
  late SharedPreferences _preferences;

  List<TodoItem> todoList = [];

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController();
    _loadData();
    updateDay();
    _initializeTimer();
  }

  void updateDay() {
    setState(() {
      dow = DateFormat('EEEE').format(DateTime.now());
      month = DateFormat('MMMM').format(DateTime.now());
      day = DateFormat('dd').format(DateTime.now());
    });
  }

  void _initializeTimer() {
    DateTime now = DateTime.now();
    DateTime tomorrowSixAM =
        DateTime(now.year, now.month, now.day + 1, 6, 0, 0);

    Duration timeUntilSixAM = tomorrowSixAM.difference(now);

    Timer.periodic(timeUntilSixAM, (Timer timer) {
      _clearTodoList();
    });
  }

  Future<void> _loadData() async {
    _preferences = await SharedPreferences.getInstance();
    List<String>? savedList = _preferences.getStringList('todoList');

    if (savedList != null) {
      setState(() {
        todoList = savedList.map((item) => TodoItem(title: item)).toList();
      });
    }
  }

  Future<void> _saveData() async {
    List<String> stringList = todoList.map((item) => item.title).toList();
    await _preferences.setStringList('todoList', stringList);
  }

  void _clearTodoList() {
    setState(() {
      todoList.clear();
      _saveData();
    });
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
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
              if (todoList.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 40,
                    color: Colors.blueGrey,
                  ),
                ),
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
                    left: 16.0,
                    top: 16.0,
                    right: 16.0,
                    bottom: 100.0,
                    child: ListView.builder(
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(todoList[index].title),
                            leading: Checkbox(
                              value: todoList[index].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  todoList[index].isChecked = value ?? false;
                                });
                                _saveData();
                              },
                              activeColor: Colors.blue,
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue.withOpacity(0.85);
                                  }

                                  return Colors.blue.withOpacity(0.2);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    bottom: 16.0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      onPressed: () {
                        _showAddTodoDialog(context);
                      },
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

  Future<void> _showAddTodoDialog(BuildContext context) async {
    String newTodo = '';
    _todoController.clear();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add TODO',
            style: TextStyle(color: Colors.blue),
          ),
          content: TextField(
            controller: _todoController,
            onChanged: (value) {
              newTodo = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your TODO',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  setState(() {
                    todoList.add(TodoItem(title: newTodo));
                  });
                  _saveData(); // 변경된 리스트를 저장
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    if (todoList.isEmpty) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All TODOs'),
          content: const Text('Are you sure you want to delete all TODOs?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todoList.clear();
                });
                _saveData();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
