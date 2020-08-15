import 'package:flutter/material.dart';
import 'package:Tasky/models/Task.dart';
import 'package:Tasky/services/taskService.dart';
import 'package:snack/snack.dart';
import 'package:Tasky/services/localizations.dart';

class DoneTasks extends StatefulWidget {
  DoneTasks({Key key}) : super(key: key);

  @override
  _DoneTasksState createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> {
  var _taskService = TaskService();
  var task;
  List<Task> _taskList = List<Task>();

  @override
  void initState() {
    super.initState();
    getAllDoneTasks();
  }

  getAllDoneTasks() async {
    _taskList = List<Task>();
    var tasks = await _taskService.readDoneTasks();

    tasks.forEach((task) {
      setState(() {
        var taskModel = Task();
        taskModel.title = task['title'];
        taskModel.description = task['description'];
        taskModel.id = task['id'];
        taskModel.taskDate = task['taskDate'];
        taskModel.taskTime = task['taskTime'];

        _taskList.add(taskModel);
      });
    });
  }

  _showClearAllDoneTaskDialog(contextt) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.instance.text('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text(AppLocalizations.instance.text('delete')),
                onPressed: () async {
                  var result = await _taskService.deleteDoneTasks();
                  Navigator.pop(context);
                  if (result > 0) {
                    setState(() {
                      getAllDoneTasks();
                    });
                    _snackBar(
                        contextt,
                        AppLocalizations.instance
                            .text('successfullyClearedDoneList'));
                  }
                }),
          ],
          title: Text(AppLocalizations.instance.text('clearTasks')),
          content: Text(AppLocalizations.instance
              .text('areYouSureYouWantToClearAllDoneTaskList')),
        );
      },
    );
  }

  _deleteDoneTask(contextt, taskId) async {
    var result = await _taskService.deleteTask(taskId);
    if (result > 0) {
      _snackBar(
          contextt, AppLocalizations.instance.text('successfullyDeleted'));
      setState(() {
        getAllDoneTasks();
      });
    }
  }

  _updateTaskFromDoneToActive(contextt, taskId) async {
    var result = await _taskService.updateTaskFromDoneToActive(taskId);
    if (result > 0) {
      print("result: $result");
      _snackBar(context,
          AppLocalizations.instance.text('successfullyReturnedToActive'));
      setState(() {
        getAllDoneTasks();
      });
    }
  }

  _showDoneTaskDetailDialog(contextt, taskId) async {
    task = await _taskService.readTaskById(taskId);

    print(task);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(2, 4, 5, 9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              scrollable: true,
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    AppLocalizations.instance.text('redoTask'),
                  ),
                  onPressed: () {
                    _updateTaskFromDoneToActive(context, taskId);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.instance.text('cancel')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: Text(AppLocalizations.instance.text('doneTask')),
              content: Container(
                child: Column(
                  children: <Widget>[
                    Text(AppLocalizations.instance.text('title'),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(task[0]['title']),
                    SizedBox(
                      height: 15.0,
                      child: Divider(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(AppLocalizations.instance.text('description'),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      task[0]['description'] == ''
                          ? AppLocalizations.instance.text('noDescription')
                          : task[0]['description'],
                      overflow: TextOverflow.clip,
                    ),
                    SizedBox(
                      height: 15.0,
                      child: Divider(),
                    ),
                    Text(AppLocalizations.instance.text('date'),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      task[0]['date'] == '' || task[0]['date'] == null
                          ? AppLocalizations.instance.text('noDateAndTime')
                          : task[0]['date'],
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  _snackBar(context, message) {
    var _bar = SnackBar(
      content: Text(message),
    );
    _bar.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.instance.text('doneTasks'),
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: IconButton(
                  tooltip: AppLocalizations.instance.text('clearDoneTaskList'),
                  icon: Icon(
                    Icons.delete_sweep,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    _showClearAllDoneTaskDialog(context);
                  }),
            )
          ],
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: ListView.builder(
            itemCount: _taskList.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(_taskList[index].id.toString()),
                    onDismissed: (direction) {
                      _updateTaskFromDoneToActive(context, _taskList[index].id);
                      setState(() {
                        _taskList.removeAt(index);
                      });
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              _showDoneTaskDetailDialog(
                                  context, _taskList[index].id);
                            },
                            title: Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                              child: Text(
                                _taskList[index].title == ''
                                    ? AppLocalizations.instance.text('noTitle')
                                    : _taskList[index].title,
                                style: TextStyle(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            trailing: IconButton(
                                tooltip: AppLocalizations.instance
                                    .text('deleteTask'),
                                color: Colors.blue,
                                icon: Icon(Icons.delete),
                                splashColor: Colors.amber,
                                onPressed: () {
                                  _deleteDoneTask(context, _taskList[index].id);
                                  getAllDoneTasks();
                                }),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                              child: Text(
                                _taskList[index].description == ''
                                    ? AppLocalizations.instance
                                        .text('noDescription')
                                    : _taskList[index].description,
                                style: TextStyle(
                                    fontSize: _taskList[index].description == ''
                                        ? 13
                                        : 14,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 8.0),
                            child: Text(
                              ((_taskList[index].taskDate == '' ||
                                          _taskList[index].taskDate == null) &&
                                      (_taskList[index].taskTime == '' ||
                                          _taskList[index].taskTime == null))
                                  ? AppLocalizations.instance
                                      .text('noDateAndTime')
                                  : ("${_taskList[index].taskDate} ${_taskList[index].taskTime}"),
                              style: TextStyle(
                                  fontSize:
                                      _taskList[index].taskDate == '' ? 13 : 14,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            }));
  }
}
