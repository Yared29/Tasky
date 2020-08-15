import 'package:flutter/material.dart';
import 'package:Tasky/models/Task.dart';
import 'package:Tasky/services/taskService.dart';
import 'package:snack/snack.dart';
import 'package:intl/intl.dart';
import 'package:Tasky/services/localizations.dart';

class ActiveTasks extends StatefulWidget {
  ActiveTasks({Key key}) : super(key: key);
  @override
  _ActiveTasksState createState() => _ActiveTasksState();
}

class _ActiveTasksState extends State<ActiveTasks> {
  var _taskService = TaskService();
  var task;
  final _taskTitleController = new TextEditingController();
  final _taskDescriptionController = new TextEditingController();
  final _taskDateController = new TextEditingController();
  final _taskTimeController = new TextEditingController();
  final _editTaskTitleController = new TextEditingController();
  final _editTaskDescriptionController = new TextEditingController();
  final _editTaskDateController = new TextEditingController();
  final _editTaskTimeController = new TextEditingController();
  bool _validate = false; //Empty TextField Validator
  DateTime _dateTime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  List<Task> _taskList = List<Task>();

  @override
  void initState() {
    super.initState();
    getAllActiveTasks();
  }

  getAllActiveTasks() async {
    _taskList = List<Task>();
    var tasks = await _taskService.readActiveTasks();
    tasks.forEach((task) {
      setState(() {
        var taskModel = Task();
        taskModel.title = task['title'];
        taskModel.description = task['description'];
        taskModel.taskDate = task['taskDate'];
        taskModel.taskTime = task['taskTime'];
        taskModel.id = task['id'];
        _taskList.add(taskModel);
      });
    });
  }

  _selectTaskDate(BuildContext context) async {
    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickDate != null) {
      setState(() {
        _taskDateController.text = DateFormat('dd/MM/yyy').format(_pickDate);
      });
    }
  }

  _selectTaskTime(contextt) async {
    var _pickTime = await showTimePicker(context: context, initialTime: _time);
    if (_pickTime != null) {
      setState(() {
        _taskTimeController.text =
            TimeOfDay(hour: _pickTime.hour, minute: _pickTime.minute)
                .format(contextt);
      });
    }
  }

  _selectEditTaskDate(BuildContext context) async {
    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickDate != null) {
      setState(() {
        _editTaskDateController.text =
            DateFormat('dd/MM/yyy').format(_pickDate);
      });
    }
  }

  _selectEditTaskTime(contextt) async {
    var _pickTime = await showTimePicker(context: context, initialTime: _time);
    if (_pickTime != null) {
      setState(() {
        _editTaskTimeController.text =
            TimeOfDay(hour: _pickTime.hour, minute: _pickTime.minute)
                .format(contextt);
      });
    }
  }

  _showAddTaskDialog(contextt) async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            insetPadding: EdgeInsets.fromLTRB(8, 1, 8, 10),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.instance.text('cancel')),
                onPressed: () {
                  _taskTitleController.clear();
                  _taskDescriptionController.clear();
                  _taskDateController.clear();
                  _taskTimeController.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(AppLocalizations.instance.text('add')),
                  onPressed: () async {
                    setState(() {
                      _taskTitleController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });

                    if (!_validate) {
                      var taskObject = Task();
                      taskObject.title = _taskTitleController.text;
                      taskObject.description = _taskDescriptionController.text;
                      taskObject.taskDate = _taskDateController.text;
                      taskObject.taskTime = _taskTimeController.text;
                      taskObject.isDone = 0;
                      var result = await _taskService.saveTask(taskObject);
                      _taskTitleController.clear();
                      _taskDescriptionController.clear();
                      _taskDateController.clear();
                      _taskTimeController.clear();
                      if (result > -1) {
                        getAllActiveTasks();
                        Navigator.pop(context);
                      }
                      _snackBar(contextt,
                          AppLocalizations.instance.text('successfullyAdded'));
                    }
                  }),
            ],
            title: Text(AppLocalizations.instance.text('addNewTask'),
                style: TextStyle(fontSize: 13)),
            content: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Column(children: <Widget>[
                TextField(
                    controller: _taskTitleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      helperText: AppLocalizations.instance
                          .text('thisFieldCantBeEmpty'),
                      hintText: AppLocalizations.instance.text('writeATitle'),
                      labelText: AppLocalizations.instance.text('title'),
                    )),
                TextField(
                    controller: _taskDescriptionController,
                    decoration: InputDecoration(
                        hintText:
                            AppLocalizations.instance.text('writeADescription'),
                        labelText:
                            AppLocalizations.instance.text('description'))),
                TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: _taskDateController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.instance.text('date'),
                        hintText: AppLocalizations.instance.text('pickADate'),
                        prefixIcon: InkWell(
                            onTap: () {
                              _selectTaskDate(context);
                            },
                            child: Icon(Icons.calendar_today)))),
                TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: _taskTimeController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.instance.text('time'),
                        hintText: AppLocalizations.instance.text('pickATime'),
                        prefixIcon: InkWell(
                            onTap: () {
                              _selectTaskTime(context);
                            },
                            child: Icon(Icons.access_alarm)))),
              ]),
            )));
      },
    );
  }

  _showEditTaskDialog(contextt, taskId) async {
    task = await _taskService.readTaskById(taskId);
    setState(() {
      _editTaskTitleController.text = task[0]['title'];
      _editTaskDescriptionController.text = task[0]['description'];
      _editTaskDateController.text = task[0]['taskDate'];
      _editTaskTimeController.text = task[0]['taskTime'];
    });

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            insetPadding: EdgeInsets.fromLTRB(8, 1, 8, 10),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.instance.text('cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(AppLocalizations.instance.text('edit')),
                  onPressed: () async {
                    setState(() {
                      _editTaskTitleController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                    if (!_validate) {
                      var taskObject = task();
                      taskObject.id = task[0]['id'];
                      taskObject.title = _editTaskTitleController.text;
                      taskObject.description =
                          _editTaskDescriptionController.text;
                      taskObject.taskDate = _editTaskDateController.text;
                      taskObject.taskTime = _editTaskTimeController.text;
                      taskObject.isDone = 0;
                      var result = await _taskService.editTask(taskObject);
                      _editTaskTitleController.clear();
                      _editTaskDescriptionController.clear();
                      _editTaskDateController.clear();
                      _editTaskTimeController.clear();
                      if (result > -1) {
                        getAllActiveTasks();
                        Navigator.pop(context);
                      }
                      _snackBar(contextt,
                          AppLocalizations.instance.text('successfullyEdited'));
                    }
                  }),
            ],
            title: Text(AppLocalizations.instance.text('editTask')),
            content: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Column(children: <Widget>[
                TextField(
                    controller: _editTaskTitleController,
                    decoration: InputDecoration(
                      helperText: AppLocalizations.instance
                          .text("thisFieldCantBeEmpty"),
                      hintText: AppLocalizations.instance.text("writeATitle"),
                      labelText: AppLocalizations.instance.text("title"),
                    )),
                TextField(
                    controller: _editTaskDescriptionController,
                    decoration: InputDecoration(
                        hintText:
                            AppLocalizations.instance.text("writeADescription"),
                        labelText:
                            AppLocalizations.instance.text("description"))),
                TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: _editTaskDateController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.instance.text("date"),
                        hintText: AppLocalizations.instance.text("pickADate"),
                        prefixIcon: InkWell(
                            onTap: () {
                              _selectEditTaskDate(context);
                            },
                            child: Icon(Icons.calendar_today)))),
                TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: _editTaskTimeController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.instance.text("time"),
                        hintText: AppLocalizations.instance.text("pickATime"),
                        prefixIcon: InkWell(
                            onTap: () {
                              _selectEditTaskTime(context);
                            },
                            child: Icon(Icons.access_alarm)))),
              ]),
            )));
      },
    );
  }

  _updateTaskFromActiveToDone(BuildContext context, taskId) async {
    await _taskService.updateTask(taskId);
    var activeTasksCount = await _taskService.countActiveTasks();
    int aa = activeTasksCount[0]['COUNT(*)'];
    if (aa == 0) {
      setState(() {
        getAllActiveTasks();
      });
    }
    _snackBar(
        context, AppLocalizations.instance.text('successfullyUpdatedToDone'));
  }

  _showActiveTaskDetailDialog(contextt, taskId) async {
    task = await _taskService.readTaskById(taskId);

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
                  child: Text(AppLocalizations.instance.text('cancel')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: Text(AppLocalizations.instance.text('activeTask')),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(AppLocalizations.instance.text('title'),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
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
                        Text('Date',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          ((task[0]['taskDate'] == '' ||
                                      task[0]['taskDate'] == null) &&
                                  (task[0]['taskTime'] == '' ||
                                      task[0]['taskTime'] == null))
                              ? AppLocalizations.instance.text('noDateAndTime')
                              : ("${task[0]['taskDate']} ${task[0]['taskTime']}"),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  _snackBar(context, message) {
    var _bar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _bar.show(context);
  }

  _deleteActivetask(contextt, taskId) async {
    var result = await _taskService.deleteTask(taskId);
    if (result > 0) {
      _snackBar(
        contextt,
        AppLocalizations.instance.text('successfullyDeleted'),
      );
      setState(() {
        getAllActiveTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.instance.text('activeTasks'),
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: IconButton(
                tooltip: AppLocalizations.instance.text('addNewTask'),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  _showAddTaskDialog(context);
                },
              ),
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
                  direction: DismissDirection.startToEnd,
                  key: Key(_taskList[index].id.toString()),
                  onDismissed: (direction) {
                    _deleteActivetask(context, _taskList[index].id);
                    setState(() {
                      _taskList.removeAt(index);
                    });
                  },
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onLongPress: () {
                            _showEditTaskDialog(context, _taskList[index].id);
                          },
                          onTap: () {
                            _showActiveTaskDetailDialog(
                                context, _taskList[index].id);
                          },
                          title: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                            child: Text(
                              _taskList[index].title == ''
                                  ? AppLocalizations.instance.text('noTitle')
                                  : _taskList[index].title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          trailing: IconButton(
                              tooltip: AppLocalizations.instance
                                  .text('makeTaskDone'),
                              color: Colors.blue,
                              icon: Icon(Icons.done),
                              splashColor: Colors.amber,
                              onPressed: () {
                                _updateTaskFromActiveToDone(
                                    context, _taskList[index].id);
                                getAllActiveTasks();
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
                                      ? 12
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
