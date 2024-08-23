import 'package:flutter/material.dart';

String emogy = "\u{26a0}";

class ShowDialog extends StatefulWidget {
  final int taskId;
  final Function(int) onDelete;

  const ShowDialog({super.key, required this.taskId, required this.onDelete});

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        "Warning $emogy ",
        style: const TextStyle(color: Colors.white),
      ),
      content: const Text(
        "Are you sure you want to delete this task?",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onDelete(widget.taskId);
            Navigator.of(context).pop(); // Close the dialog after deletion
          },
          child: const Text("Delete"),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("back")),
      ],
    );
  }
}

// Usage example
void showDeleteDialog(
    BuildContext context, int taskId, Function(int) onDelete) {
  showDialog(
    context: context,
    builder: (context) {
      return ShowDialog(taskId: taskId, onDelete: onDelete);
    },
  );
}
