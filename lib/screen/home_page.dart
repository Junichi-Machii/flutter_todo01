import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_flutter01/date/datebase.dart';
import 'package:todo_flutter01/util/dialog_box.dart';
import 'package:todo_flutter01/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('myBox');
  ToDoDateBase db = ToDoDateBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then crete default date.

    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists date
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  void checkboxChanged(bool? value, int index) {
    setState(() {
      // todoList[index] = [todoList[index][0], value!];
      // todoList[index][1] = value!;
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task l
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveNewTask,
        );
      },
    );
  }

  // delete a task
  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add_rounded),
      ),
      backgroundColor: Colors.lightBlue,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ToDoTile(
            onChanged: (value) => checkboxChanged(value, index),
            taskCompleted: db.todoList[index][1],
            taskName: db.todoList[index][0],
            deleteFunction: (context) => deleteTask(index),
          );
        },
        itemCount: db.todoList.length,
      ),
    );
  }
}
