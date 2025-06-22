import 'package:flutter/material.dart';

class ParsedRichText {
  final TextSpan textSpan;
  final TextAlign textAlign;

  ParsedRichText({required this.textSpan, this.textAlign = TextAlign.left});
}

ParsedRichText parseRichText(String text, BuildContext context) {
  final defaultStyle = Theme.of(context).textTheme.bodyMedium!;
  return ParsedRichText(
    textSpan: TextSpan(text: text, style: defaultStyle),
    textAlign: TextAlign.left
  );
} 