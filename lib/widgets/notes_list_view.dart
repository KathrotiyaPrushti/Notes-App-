import 'package:flutter/material.dart';
import '../models/note.dart';
import './note_dialog.dart';
import '../utils/rich_text_parser.dart'; 

class NotesListView extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onEditNote;
  final Function(String) onDeleteNote;
  final Function(String) onTogglePin;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final String selectedCategory;
  final List<String> categories;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onEditNote,
    required this.onDeleteNote,
    required this.onTogglePin,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredNotes = notes.where((note) {
      final matchesSearch = note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || note.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    filteredNotes.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.date.compareTo(a.date);
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search notes...',
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onSearchChanged,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: filteredNotes.isEmpty
              ? Center(
                  child: Text(
                    'No notes found',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return NoteCard(
                      note: note,
                      onEdit: () async {
                        final edited = await showDialog<Note>(
                          context: context,
                          builder: (context) => NoteDialog(
                            note: note,
                            categories: categories,
                          ),
                        );
                        if (edited != null) onEditNote(edited);
                      },
                      onDelete: () => onDeleteNote(note.id),
                      onTogglePin: () => onTogglePin(note.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: note.isPinned ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  onPressed: onTogglePin,
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              note.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${note.date.day}/${note.date.month}/${note.date.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white38),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(note.category, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 