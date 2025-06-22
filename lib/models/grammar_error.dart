class GrammarError {
  final int startIndex;
  final int endIndex;
  final String suggestion;
  GrammarError({
    required this.startIndex,
    required this.endIndex,
    required this.suggestion,
  });
} 