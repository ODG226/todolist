import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../models/note.dart';
import '../services/database_service.dart';
import 'add_edit_note_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_searchNotes);
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseService.getNotes();
    notes.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
    });
  }

  void _searchNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
               note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _goToAddNote() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditNoteView()));
    _loadNotes();
  }

  void _goToEditNote(Note note) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditNoteView(note: note)));
    _loadNotes();
  }

  void _deleteNote(int id) async {
    await DatabaseService.deleteNote(id);
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Mes Notes'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black87),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Notes', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.white),
              title: const Text('Notes', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text('Rappels', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RappelView()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label, color: Colors.white),
              title: const Text('Créer un label', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: Colors.white),
              title: const Text('Archives', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white),
              title: const Text('Corbeille', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Paramètres', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: const Text('Aide & feedback', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Rechercher...',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: _filteredNotes.length,
              itemBuilder: (_, i) {
                final note = _filteredNotes[i];
                return GestureDetector(
                  onTap: () => _goToEditNote(note),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                note.content,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _deleteNote(note.id!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 10,
        spaceBetweenChildren: 8,
        childrenButtonSize: const Size(60, 60),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.mic, color: Colors.white),
            backgroundColor: Colors.brown,
            label: 'Audio',
            labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onTap: () {
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.image, color: Colors.white),
            backgroundColor: Colors.deepPurple,
            label: 'Image',
            labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onTap: () {
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.brush, color: Colors.white),
            backgroundColor: Colors.teal,
            label: 'Drawing',
            labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onTap: () {
          
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.list, color: Colors.white),
            backgroundColor: Colors.indigo,
            label: 'List',
            labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onTap: () {
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.text_fields, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'Text',
            labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onTap: _goToAddNote,
          ),
        ],
      ),
    );
  }
}

class RappelView extends StatelessWidget {
  const RappelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Rappels'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            FutureBuilder<List<Note>>(
              future: DatabaseService.getNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                }
                final notes = (snapshot.data ?? [])..sort((a, b) => b.date.compareTo(a.date));
                if (notes.isEmpty) {
                  return const Center(child: Text('Aucune note enregistrée', style: TextStyle(color: Colors.white)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final snippet = note.content.length > 120 ? '${note.content.substring(0, 120)}…' : note.content;
                    return ListTile(
                      title: Text(note.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(snippet, style: const TextStyle(color: Colors.white70)),
                      trailing: IconButton(
                        icon: const Icon(Icons.alarm_add, color: Colors.amber),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(dialogBackgroundColor: Colors.black87), child: child!),
                          );
                          if (pickedDate == null) return;
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(timePickerTheme: TimePickerThemeData(hourMinuteTextColor: Colors.white)), child: child!),
                          );
                          if (pickedTime == null) return;
                          final reminderDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Rappel ajouté pour "${note.title}" le ${reminderDateTime.toLocal()}')),
                          );
                          // TODO: Persister le rappel (ex: DatabaseService.saveReminder(...))
                        },
                      ),
                      onTap: () {
                        // optionnel: ouvrir la note
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditNoteView(note: note)));
                      },
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.amber,
                child: const Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black87,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    builder: (ctx) {
                      return FutureBuilder<List<Note>>(
                        future: DatabaseService.getNotes(),
                        builder: (ctx2, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                          }
                          final notes = (snap.data ?? [])..sort((a, b) => b.date.compareTo(a.date));
                          if (notes.isEmpty) {
                            return const SizedBox(height: 200, child: Center(child: Text('Aucune note disponible', style: TextStyle(color: Colors.white))));
                          }
                          return SizedBox(
                            height: 400,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: notes.length,
                              separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                              itemBuilder: (ctx3, i) {
                                final n = notes[i];
                                return ListTile(
                                  title: Text(n.title, style: const TextStyle(color: Colors.white)),
                                  subtitle: Text(n.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
                                  onTap: () async {
                                    Navigator.pop(ctx); // close sheet
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                      builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(dialogBackgroundColor: Colors.black87), child: child!),
                                    );
                                    if (pickedDate == null) return;
                                    final pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime == null) return;
                                    final reminderDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Rappel ajouté pour "${n.title}" le ${reminderDateTime.toLocal()}')),
                                    );
                                    // TODO: Persister le rappel (ex: DatabaseService.saveReminder(...))
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
