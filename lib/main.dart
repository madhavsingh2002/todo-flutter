import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Todo List',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> tasks = [];
  List<String> filteredTasks = [];
  TextEditingController taskController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (text) {
                _searchTasks(text);
              },
              decoration: InputDecoration(
                labelText: 'Search tasks',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredTasks[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editTask(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Enter task',
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _addTask();
                },
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () {
                  _clearTasks();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _searchTasks(String query) {
    setState(() {
      filteredTasks = tasks
          .where((task) => task.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
        _searchTasks(searchController.text);
      });
    }
  }

  void _editTask(int index) async {
    TextEditingController editingController =
    TextEditingController(text: filteredTasks[index]);

    String editedTask = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: editingController,
          decoration: const InputDecoration(labelText: 'Task'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, editingController.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (editedTask != null && editedTask.isNotEmpty) {
      setState(() {
        tasks[tasks.indexOf(filteredTasks[index])] = editedTask;
        _searchTasks(searchController.text);
      });
    }
  }

  void _showDeleteConfirmationDialog(int index) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      _deleteTask(index);
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.remove(filteredTasks[index]);
      _searchTasks(searchController.text);
    });
  }

  void _clearTasks() {
    setState(() {
      tasks.clear();
      _searchTasks(searchController.text);
    });
  }
}
