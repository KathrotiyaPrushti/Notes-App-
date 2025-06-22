import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime date;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    required this.isPinned,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? date,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      date: date ?? this.date,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'date': date.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      isPinned: json['isPinned'] ?? false,
    );
  }
} 