import 'dart:math';
import '../models/grammar_error.dart';
import 'dictionary_loader.dart';

class GrammarChecker {
  final DictionaryLoader _dictionaryLoader;
  final Set<String> _dictionary = {};

  GrammarChecker() : _dictionaryLoader = DictionaryLoader();

  Future<List<GrammarError>> checkGrammar(String text) async {
    if (_dictionary.isEmpty) {
      await _dictionaryLoader.loadDictionary();
      _dictionary.addAll(_dictionaryLoader.dictionary);
    }

    List<GrammarError> errors = [];
    final words = text.split(RegExp(r'\s+'));
    int currentIndex = 0;

    for (int i = 0; i < words.length; i++) {
      final word = words[i].toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
      if (word.isEmpty) continue;
      if (!_dictionary.contains(word)) {
        String? suggestion = _findClosestWord(word);
        if (suggestion != null) {
          errors.add(GrammarError(
            startIndex: currentIndex,
            endIndex: currentIndex + word.length,
            suggestion: 'Did you mean "$suggestion"?',
          ));
        }
      }
      if (i > 0) {
        final prevWord = words[i - 1].toLowerCase();
        if (_isArticle(prevWord) && _isVowel(word[0])) {
          if (prevWord != 'an') {
            errors.add(GrammarError(
              startIndex: currentIndex - prevWord.length,
              endIndex: currentIndex + word.length,
              suggestion: 'Use "an" before words starting with vowels',
            ));
          }
        }
      }
      currentIndex += words[i].length + 1; 
    }

    return errors;
  }

  String? _findClosestWord(String word) {
    String? closestWord;
    int minDistance = 3; 

    for (String dictWord in _dictionary) {
      int distance = _levenshteinDistance(word, dictWord);
      if (distance < minDistance) {
        minDistance = distance;
        closestWord = dictWord;
      }
    }

    return closestWord;
  }

  int _levenshteinDistance(String s1, String s2) {
    if (s1.length < s2.length) {
      return _levenshteinDistance(s2, s1);
    }

    if (s2.isEmpty) {
      return s1.length;
    }

    List<int> previousRow = List.generate(s2.length + 1, (i) => i);

    for (int i = 0; i < s1.length; i++) {
      List<int> currentRow = [i + 1];

      for (int j = 0; j < s2.length; j++) {
        int insertions = previousRow[j + 1] + 1;
        int deletions = currentRow[j] + 1;
        int substitutions = previousRow[j] + (s1[i] == s2[j] ? 0 : 1);

        currentRow.add(min(min(insertions, deletions), substitutions));
      }

      previousRow = currentRow;
    }

    return previousRow[s2.length];
  }

  bool _isArticle(String word) {
    return word == 'a' || word == 'an' || word == 'the';
  }

  bool _isVowel(String char) {
    return 'aeiou'.contains(char.toLowerCase());
  }
} 