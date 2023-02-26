// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/screens/add_screen.dart';
import 'package:todo/model/database_helper.dart';

enum PriorityLevel {
  high,
  normal,
  low,
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDo> allTodos = [];
  getAllData() async {
    var todos = await DatabaseHelper.instance.getAllToDos();
    setState(() {
      allTodos = todos;
    });
  }

  Color checkPriorityLevel(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Normal':
        return Colors.lightGreen;
      case 'Low':
        return Colors.lightBlue;
      default:
        return Colors.lightBlue;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
            )),
        title: Text(
          'ToDo',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          itemCount: allTodos.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                child: Center(
                    child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onDismissed: (direction) async {
                await DatabaseHelper.instance.deleteToDo(allTodos[index].id!);
              },
              child: ListTile(
                style: ListTileStyle.list,
                minLeadingWidth: 10,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CircleAvatar(
                      radius: 8.0,
                      backgroundColor:
                          checkPriorityLevel(allTodos[index].priority),
                    ),
                  ],
                ),
                title: Text(allTodos[index].task),
                trailing: Text(allTodos[index].priority),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddScreen(
                      idReciever: allTodos[index].id,
                      taskReciever: allTodos[index].task,
                      priorityReciever: allTodos[index].priority,
                    );
                  })).then((data) {
                    if (data != null) {
                      getAllData();
                    }
                  });
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        highlightElevation: 1.0,
        elevation: 0.5,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddScreen();
          })).then((data) {
            if (data != null) {
              getAllData();
            }
          });
        },
        child: Icon(
          Icons.add_rounded,
          size: 32,
        ),
      ),
    );
  }
}
