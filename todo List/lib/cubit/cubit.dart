import 'package:betakty/cubit/states.dart';
import 'package:betakty/screens/task_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../screens/archive_screen.dart';
import '../screens/done_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = const [
    TasksScreen(),
    ArchiveScreen(),
    DoneScreen(),
  ];
  late Database database;
  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() async {
    database = await openDatabase('path.db', version: 1,
        onCreate: (database, version) async {
      await database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT , status TEXT)');
    }, onOpen: (database) async {
      getDataFromDatabase(database);
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
    required String status,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date , status) VALUES("$title", "$time", "$date" , "$status")')
          .then((value) {
        getDataFromDatabase(database);
      }).catchError((error) {
        emit(AppInsertDatabaseErrorState(error.toString()));
      });
    });
  }

  /*void getDataFromDatabase(database) async {
    tasks.clear();
    archiveTasks.clear();
    doneTasks.clear();
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((e) {
        if (e['status'] == 'done') {
          doneTasks.add(e);
        } else if (e['status'] == 'archive') {
          archiveTasks.add(e);
        } else if (e['status'] == 'status') {
          tasks.add(e);
        }
      });
      emit(AppGetDatabaseSuccessState());
    });
  }
  */
  void getDataFromDatabase(database) async {
    tasks.clear();
    archiveTasks.clear();
    doneTasks.clear();
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((e) {
        if (e['status'] == 'done') {
          doneTasks.add(e);
        } else if (e['status'] == 'archive') {
          archiveTasks.add(e);
        } else if (e['status'] == 'new') {
          // استبدل "status" بـ "new"
          tasks.add(e);
        }
      });
      emit(AppGetDatabaseSuccessState());
    });
  }

  void deleteFromDatabase(int id) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
    });
  }

  void updateDatabaseState(String status, int id) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      print(status);
    });
  }
}
