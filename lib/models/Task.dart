class Task {
  int id;
  String title;
  String description;
  String taskDate;
  String taskTime;
  int isDone = 0;
  taskMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['taskDate'] = taskDate;
    mapping['taskTime'] = taskTime;
    mapping['isDone'] = isDone;
    return mapping;
  }
}

