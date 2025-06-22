import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/notes_home_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF23223A),
        cardColor: Color(0xFF2D2C3C),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF7B6EF6),
          secondary: Color(0xFFF6C768),
          background: Color(0xFF23223A),
          surface: Color(0xFF2D2C3C),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7B6EF6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF7B6EF6),
            shape: StadiumBorder(),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/notes': (context) => NotesHomeScreen(),
      },
    );
  }
}
