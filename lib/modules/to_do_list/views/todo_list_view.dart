import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:to_do_list/modules/to_do_list/controllers/todo_list_controller.dart';
import 'package:to_do_list/routes/app_routes.dart';
import 'package:to_do_list/utils/color_util.dart';
import 'package:to_do_list/widgets/illustration.dart';
import 'package:to_do_list/widgets/todo_card.dart';

import '../../../data/local_storage/shared_preferences.dart';

class ToDoListView extends GetView<ToDoListController> {
  const ToDoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
    return Scaffold(
      backgroundColor: ColorUtil.background,
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: <Widget>[
          IconButton(
            onPressed: () => UserSharedPreferences.clearSharedPreference(),
            icon: const Icon(Icons.delete, color: Colors.black54),
          ),
        ],
      ),
      body: GetBuilder<ToDoListController>(
        builder: (ToDoListController controller) {
          if (controller.toDoList.isEmpty) {
            return const ToDoIllustration();
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: controller.toDoList.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return ToDoCard(
                  title: controller.toDoList[index].title ?? '',
                  endDate: controller.toDoList[index].endDate ?? DateTime.now(),
                  startDate: controller.toDoList[index].startDate ?? DateTime.now(),
                  checkBoxValue: controller.toDoList[index].isDone,
                  onLongPress: () {
                    controller.deleteToDo(controller.toDoList[index].id!);
                  },
                  onTap: () {
                    Get.toNamed(AppRoutes.toDoForm, arguments: controller.toDoList[index]);
                  },
                  onChanged: (bool? value) {
                    controller.toDoList[index].isDone = value!;
                    controller.update();
                    UserSharedPreferences.setToDoList(controller.toDoList);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.toDoForm, arguments: null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}