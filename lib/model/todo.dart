class ToDo {
  ToDo({this.id, required this.task, required this.priority});
  int? id;
  String task;
  String priority;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'priority': priority,
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id, task:$task,priority:$priority}';
  }
}
