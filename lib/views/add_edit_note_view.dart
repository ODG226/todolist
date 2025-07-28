import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class AddEditNoteView extends StatefulWidget {
  final Note? note;
  const AddEditNoteView({super.key, this.note});

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    final now = DateTime.now().toIso8601String();
    final newNote = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      date: now,
    );

    if (widget.note == null) {
      await DatabaseService.insertNote(newNote);
    } else {
      await DatabaseService.updateNote(newNote);
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? 'Ajouter' : 'Modifier')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Contenu'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(),
            ),
            ElevatedButton(onPressed: _saveNote, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}

