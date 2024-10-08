import 'package:flutter/material.dart';
import 'package:std_flutter_animations/screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Animations",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
        navigationBarTheme:
            const NavigationBarThemeData(indicatorColor: Colors.amber),
      ),
      home: const MenuScreen(),
    );
  }
}
