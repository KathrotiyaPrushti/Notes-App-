import 'dictionary_loader.dart';

class GrammarIssue {
  final int start;
  final int end;
  final String message;
  final String suggestion;

  GrammarIssue({
    required this.start,
    required this.end,
    required this.message,
    required this.suggestion,
  });
}

List<String> _suggestWords(String word) {
  final loader = DictionaryLoader();
  List<String> suggestions = [];
  for (final dictWord in loader.words) {
    if (_levenshtein(word.toLowerCase(), dictWord.toLowerCase()) <= 2) {
      suggestions.add(dictWord);
    }
    if (suggestions.length >= 5) break;
  }
  return suggestions.take(3).toList();
}

int _levenshtein(String s, String t) {
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;
  List<List<int>> d = List.generate(s.length + 1, (_) => List.filled(t.length + 1, 0));
  for (int i = 0; i <= s.length; i++) d[i][0] = i;
  for (int j = 0; j <= t.length; j++) d[0][j] = j;
  for (int i = 1; i <= s.length; i++) {
    for (int j = 1; j <= t.length; j++) {
      int cost = s[i - 1] == t[j - 1] ? 0 : 1;
      d[i][j] = [
        d[i - 1][j] + 1,
        d[i][j - 1] + 1,
        d[i - 1][j - 1] + cost
      ].reduce((a, b) => a < b ? a : b);
    }
  }
  return d[s.length][t.length];
}
List<GrammarIssue> checkGrammar(String text) {
  final issues = <GrammarIssue>[];
  final loader = DictionaryLoader();
  final doubleSpace = RegExp(r'  +');
  for (final match in doubleSpace.allMatches(text)) {
    issues.add(GrammarIssue(
      start: match.start,
      end: match.end,
      message: 'Double space',
      suggestion: 'Replace with single space',
    ));
  }
  final repeatedWord = RegExp(r'\b(\w+)\s+\1\b', caseSensitive: false);
  for (final match in repeatedWord.allMatches(text)) {
    issues.add(GrammarIssue(
      start: match.start,
      end: match.end,
      message: 'Repeated word',
      suggestion: 'Remove duplicate',
    ));
  }
  final yourYoure = RegExp(r"\byour\s+welcome\b", caseSensitive: false);
  for (final match in yourYoure.allMatches(text)) {
    issues.add(GrammarIssue(
      start: match.start,
      end: match.end,
      message: 'Did you mean "you\'re welcome"?',
      suggestion: "you're welcome",
    ));
  }
  final wordRegex = RegExp(r'\b\w+\b');
  for (final match in wordRegex.allMatches(text)) {
    final word = match.group(0)!;
    if (!loader.contains(word)) {
      final suggestions = _suggestWords(word);
      issues.add(GrammarIssue(
        start: match.start,
        end: match.end,
        message: 'Possible spelling mistake',
        suggestion: suggestions.isNotEmpty ? suggestions.join(', ') : 'No suggestions',
      ));
    }
  }
  return issues;
} 