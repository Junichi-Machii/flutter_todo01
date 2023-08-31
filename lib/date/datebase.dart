import 'package:hive_flutter/hive_flutter.dart';

class ToDoDateBase {
  List todoList = [];

  //referece our box
  final _myBox = Hive.box("myBox");

  void createInitialData() {
    todoList = [
      ["Date", false]
    ];
  }

  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", todoList);
  }
}
