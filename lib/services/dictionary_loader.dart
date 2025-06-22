import 'dart:io';
import 'package:flutter/services.dart';

class DictionaryLoader {
  final Set<String> dictionary = {};

  Future<void> loadDictionary() async {
    if (dictionary.isNotEmpty) return;

    try {
      final String content = await rootBundle.loadString('assets/word.txt');
      final List<String> words = content.split('\n');
      dictionary.addAll(words.map((word) => word.trim().toLowerCase()));
    } catch (e) {
      print('Error loading dictionary: $e');
      // Add some common words as fallback
      dictionary.addAll([
        'the', 'be', 'to', 'of', 'and', 'a', 'in', 'that', 'have', 'i',
        'it', 'for', 'not', 'on', 'with', 'he', 'as', 'you', 'do', 'at',
        'this', 'but', 'his', 'by', 'from', 'they', 'we', 'say', 'her', 'she',
        'or', 'an', 'will', 'my', 'one', 'all', 'would', 'there', 'their', 'what',
        'so', 'up', 'out', 'if', 'about', 'who', 'get', 'which', 'go', 'me',
      ]);
    }
  }
} 