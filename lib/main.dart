import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reddit_slideshow/favorites.dart';
import 'package:reddit_slideshow/history.dart';
import 'package:reddit_slideshow/more.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AppCore());
  }
}

class AppCore extends StatefulWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  State<AppCore> createState() => _AppCoreState();
}

class _AppCoreState extends State<AppCore> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Favorites(),
    History(),
    More(),
  ];

  void _onNavTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBarTheme(
          data: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromARGB(255, 32, 32, 32),
              selectedItemColor: Color.fromARGB(255, 255, 255, 255),
              unselectedItemColor: Color.fromARGB(255, 204, 204, 204)),
          child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'favorite'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'history'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz), label: 'more'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onNavTap,
              selectedLabelStyle:
                  const TextStyle(inherit: true, color: Color(0xFFFFFFFF))),
        ));
  }
}
