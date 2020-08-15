import 'package:Tasky/models/Task.dart';
import 'package:Tasky/database/repository.dart';

class TaskService {
  Repository _repository;

  TaskService() {
    _repository = Repository();
  }
  // Create Task
  saveTask(Task task) async {
    return await _repository.insertData('tasks', task.taskMap());
  }

  // Read all active tasks
  readActiveTasks() async {
    return await _repository.readActiveData('tasks');
  }

  // Count all active tasks
  countActiveTasks() async {
    return await _repository.countActiveData('tasks');
  }

  // Read task by ID
  readTaskById(taskId) async {
    return await _repository.readDataById('tasks', taskId);
  }

  // Edit task by ID
  editTask(Task task) async {
    return await _repository.editData('tasks', task.taskMap());
  }

  // Update task from active to done
  updateTask(taskId) async {
    return await _repository.updateData('tasks', taskId);
  }

  // Update task from done to active
  updateTaskFromDoneToActive(taskId) async {
    return await _repository.updateDataFromDoneToActive('tasks', taskId);
  }

  // Read all done tasks
  readDoneTasks() async {
    return await _repository.readDoneData('tasks');
  }

  // Count all done tasks
  countDoneTasks() async {
    return await _repository.countDoneData('tasks');
  }

  // Delete task by ID
  deleteTask(taskId) async {
    return await _repository.deletData('tasks', taskId);
  }

  // Delete all done tasks
  deleteDoneTasks() async {
    return await _repository.deletAllDoneData('tasks');
  }
}
