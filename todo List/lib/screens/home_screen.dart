import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:betakty/cubit/cubit.dart';
import 'package:betakty/cubit/states.dart';
import 'package:betakty/screens/add_task_screen.dart';
import 'package:betakty/widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShow = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color.fromARGB(255, 15, 106, 181),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromARGB(255, 15, 106, 181),
              title: const Row(
                children: [
                  Icon(
                    Icons.task_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    ' All Tasks',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            endDrawer: Drawer(
              backgroundColor: Colors.black,
              child: BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {
                  // أي عملية إضافية يمكنك تنفيذها بناءً على الحالة الجديدة
                },
                builder: (context, state) {
                  var cubit = AppCubit.get(context);
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Tasks Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.list, color: Colors.white),
                        title: const Text(
                          'All Tasks',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${cubit.tasks.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.archive, color: Colors.white),
                        title: const Text(
                          'Archived Tasks',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${cubit.archiveTasks.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.check_box, color: Colors.white),
                        title: const Text(
                          'Done Tasks',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${cubit.doneTasks.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                  cubit.screens.length, (index) => cubit.screens[index]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                            status: 'new')
                        .then((value) {
                      Navigator.pop(context);
                      isBottomSheetShow = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          action: SnackBarAction(
                            label: "OK",
                            onPressed: () {},
                          ),
                          content:
                              Text("The task has been added successfully")));
                    });
                  }
                } else {
                  _scaffoldKey.currentState!
                      .showBottomSheet((context) => AddTasksScreen(
                          formKey: formKey,
                          titleController: titleController,
                          timeController: timeController,
                          dateController: dateController))
                      .closed
                      .then((value) {
                    isBottomSheetShow = false;
                  });
                  isBottomSheetShow = true;
                }
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            bottomNavigationBar: AnimatedNotchBottomBar(
              color: Color.fromARGB(255, 6, 37, 62),
              notchBottomBarController: _controller,
              notchColor: Color.fromARGB(169, 47, 36, 36),
              elevation: 1,
              showLabel: true,
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              bottomBarItems: [
                bottomBarItem(
                  icon: Icons.home,
                  text: 'Tasks',
                ),
                bottomBarItem(icon: Icons.archive, text: 'Archive'),
                bottomBarItem(icon: Icons.check_box, text: 'Done'),
              ],
              onTap: (value) {
                _pageController.jumpToPage(value);
              },
              kIconSize: 24,
              kBottomRadius: 28,
            ),
          );
        },
      ),
    );
  }
}
