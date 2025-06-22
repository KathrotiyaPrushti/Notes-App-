import 'package:flutter/material.dart';
import '../widgets/notes_list_view.dart';
import '../models/note.dart';
import 'package:uuid/uuid.dart';
import '../widgets/note_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesHomeScreen extends StatefulWidget {
  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  List<Note> _notes = [];
  final Uuid _uuid = Uuid();
  late TextEditingController _searchController;
  String _selectedCategory = 'All';

  final List<String> _predefinedCategories = [
    '📝 To-Do / Tasks',
    '💼 Work / Projects',
    '📚 Study / Learning',
    '💡 Ideas / Inspirations',
    '📅 Personal / Daily Journal',
    '🛍️ Shopping / Lists',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List<dynamic> notesMap = json.decode(notesJson);
      setState(() {
        _notes = notesMap.map((note) => Note.fromJson(note)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String notesJson = json.encode(_notes.map((note) => note.toJson()).toList());
    await prefs.setString('notes', notesJson);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addNote(Note note) {
    setState(() {
      _notes.add(note);
    });
    _saveNotes();
  }

  void _editNote(Note note) {
    setState(() {
      int index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
      }
    });
    _saveNotes();
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
    _saveNotes();
  }

  void _togglePin(String id) {
    setState(() {
      int index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = Note(
          id: _notes[index].id,
          title: _notes[index].title,
          content: _notes[index].content,
          category: _notes[index].category,
          date: _notes[index].date,
          isPinned: !_notes[index].isPinned,
        );
      }
    });
    _saveNotes();
  }

  void _showAddDialog() async {
    final newNote = await showDialog<Note>(
      context: context,
      builder: (context) => NoteDialog(categories: _predefinedCategories),
    );
    if (newNote != null) {
      _addNote(newNote);
    }
  }

  List<String> get _categories {
    final categories = _notes.map((note) => note.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('notes', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: Theme.of(context).cardColor,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: NotesListView(
              notes: _notes,
              onEditNote: _editNote,
              onDeleteNote: _deleteNote,
              onTogglePin: _togglePin,
              searchQuery: _searchController.text,
              onSearchChanged: (query) {
                setState(() {
                  _searchController.text = query;
                });
              },
              selectedCategory: _selectedCategory,
              categories: _predefinedCategories,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
