import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pomodoro_timer_app/Pages/Pomo/Tasks/task.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:styled_widget/styled_widget.dart';

class TaskInput extends StatefulWidget {
  const TaskInput({Key? key, required this.taskListFunction}) : super(key: key);
  final Function(Task) taskListFunction;

  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  TextEditingController textEditingController = TextEditingController();

  // the hint text in the text field is gonna be random on each reload, it adds a nice touch to it imo
  List<String> hintTexts = [
    "Study discrete math",
    "Finish pomodoro app",
    "Clean the apartment",
    "Study history",
    "Meetings",
    "Walk the dog",
    "Finish presentation"
  ];
  Random random = Random();
  late int hintIdx;
  GetStorage box = GetStorage();
  int numberOfPomos = 0;

  @override
  void initState() {
    hintIdx = random.nextInt(hintTexts.length);
    super.initState();
  }

  Task createTask(String textFieldValue) {
    List<dynamic> tasksJson = box.read("Tasks") ?? [];

    Task newTask = Task(
      id: tasksJson.isNotEmpty ? tasksJson.last["id"] + 1 : 0,
      content: textFieldValue,
      taskType: TaskType.notStarted,
      plannedPomos: numberOfPomos,
      pomosDone: 0,
    );

    // add the new task to the list in the 'json' format and write that to the box
    tasksJson.add(newTask.toJson());
    box.write("Tasks", tasksJson);

    setState(() {
      numberOfPomos = 0;
    });

    return newTask;
  }

  void incrementNumberOfPomos(int number) {
    setState(() {
      numberOfPomos += number;
    });
  }

  void decrementNumberOfPomos(int number) {
    if (numberOfPomos > 0) {
      incrementNumberOfPomos(-number);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              onTap: () {
                setState(() {
                  hintIdx = random.nextInt(hintTexts.length);
                });
              },
              onSubmitted: (String value) {
                Task task = createTask(value);
                widget.taskListFunction(task);
                textEditingController.clear();
              },
              decoration: InputDecoration(
                // prefixIcon: const Icon(Icons.add),
                border: const OutlineInputBorder(),
                hintText: hintTexts[hintIdx],
                labelText: "Enter a task",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              children: [
                const Text("N° of pomos"),
                [
                  InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: const Icon(Icons.arrow_drop_down),
                    onTap: () => decrementNumberOfPomos(1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("$numberOfPomos"),
                  ),
                  InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: const Icon(Icons.arrow_drop_up),
                      onTap: () => incrementNumberOfPomos(1),
                  ),

                ].toRow(
                    mainAxisAlignment: MainAxisAlignment.center,
                    separator: const Padding(padding: EdgeInsets.all(0))
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                Task task = createTask(textEditingController.text);
                widget.taskListFunction(task);
                textEditingController.clear();
              }
            },

          ),
        ],
      ),
    );
  }
}