import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../archived_tasks/arcived_tasks_screen.dart';
import '../done_tasks/done_tasks_screen.dart';
import '../new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);


  int currentIndex = 0;
  Database? database;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archiveTasks=[];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }


  void createDatabase(){
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('error is${error.toString()}');
          });
        }, onOpen: (database) {
          getFromDatabase(database);
          print('database opened');
        }).then((value){
          database=value;
          emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database!.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataBaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('error is${error.toString()}');
      });
    });
  }


  void getFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) {
        if(element['status']=='new')
        {
          newTasks.add(element);
        }else if(element['status']=='done')
        {
          doneTasks.add(element);
        }else
          {
            archiveTasks.add(element);
          }
      });
      emit(AppGetDataBaseState());
    });
  }


  // Update some record
  void updateData({
  required String status ,
  required int id ,
}) async
  {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id ],
    ).then((value){
      getFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  // Delete some record
  void deleteData({
    required int id ,
  }) async
  {
    database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value){
      getFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }



}