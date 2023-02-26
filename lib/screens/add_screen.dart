// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/database_helper.dart';
import 'package:todo/model/todo.dart';

class AddScreen extends StatefulWidget {
  AddScreen(
      {super.key, this.idReciever, this.taskReciever, this.priorityReciever});
  int? idReciever;
  String? taskReciever;
  String? priorityReciever;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController taskController = TextEditingController();
  var taskPriority = 'Normal';
  int _currentSelection = 1;
  var data = 'as';
  final Map<int, Text> segmentChildren = {
    0: Text('High'),
    1: Text('Normal'),
    2: Text('Low'),
  };

  void getValueFromText(int id) {
    setState(() {
      taskPriority = segmentChildren[id]?.data as String;
    });
  }

  @override
  void dispose() {
    super.dispose();
    taskController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.idReciever != null) {
        taskController.text = widget.taskReciever.toString();
        taskPriority = widget.priorityReciever.toString();
        widget.priorityReciever == 'High'
            ? _currentSelection = 0
            : widget.priorityReciever == 'Normal'
                ? _currentSelection = 1
                : _currentSelection = 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'New ToDo',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.blue,
                )),
          )
        ],
      ),
      body: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 18.0, right: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: taskController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabled: true,
                    hintText: 'Task...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    filled: false,
                  ),
                  onChanged: (val) {
                    // print(val);
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: MaterialSegmentedControl(
                  horizontalPadding: EdgeInsets.all(0),
                  children: segmentChildren,
                  selectionIndex: _currentSelection,
                  borderColor: Colors.grey.shade300,
                  selectedColor: Colors.white,
                  selectedTextStyle: TextStyle(color: Colors.black),
                  unselectedColor: Colors.grey.shade300,
                  unselectedTextStyle: TextStyle(color: Colors.black),
                  borderRadius: 4.0,
                  onSegmentChosen: (index) {
                    setState(() {
                      _currentSelection = index;
                      getValueFromText(index);
                    });
                    print(taskPriority);
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.5),
                      backgroundColor: MaterialStateProperty.all(
                          widget.idReciever != null
                              ? Colors.green.shade300
                              : Colors.blue.shade300)),
                  onPressed: () async {
                    var result = widget.idReciever != null
                        ? await DatabaseHelper.instance.updateToDo(ToDo(
                            id: widget.idReciever,
                            task: taskController.text,
                            priority: taskPriority))
                        : await DatabaseHelper.instance.insertToDo(ToDo(
                            task: taskController.text, priority: taskPriority));

                    Navigator.pop(context, result);
                    List allTodox = await DatabaseHelper.instance.getAllToDos();
                    print(allTodox);
                  },
                  child: Text(
                    widget.idReciever != null ? "Update" : "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
