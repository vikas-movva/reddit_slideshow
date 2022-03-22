import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reddit_slideshow/providers/reddit_auth_provider.dart';
import 'package:reddit_slideshow/providers/user_settings_provider.dart';
import 'package:reddit_slideshow/screens/favorites.dart';
import 'package:reddit_slideshow/screens/home.dart';
import 'package:reddit_slideshow/screens/more.dart';
import 'package:provider/provider.dart';
import 'package:reddit_slideshow/screens/viewer.dart';
import 'providers/reddit_auth_provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
    ChangeNotifierProvider(create: (_) => RedditAuthProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<UserSettingsProvider>().getUserSettings();
    context
        .read<RedditAuthProvider>()
        .redditAuth(context.read<UserSettingsProvider>().uuid);
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/favorites': (context) => const Favorites(),
        '/more': (context) => const More(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 32, 32, 32),
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: Color.fromARGB(255, 204, 204, 204),
        ),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, brightness: Brightness.dark),
      ),
    );
  }
}

class AppCore extends StatefulWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  State<AppCore> createState() => _AppCoreState();
}

class _AppCoreState extends State<AppCore> {
  int _selectedIndex = 0;
  static const List _widgetOptions = <String>[
    '/favorites',
    '/home',
    '/more',
  ];

  void _onNavTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _widgetOptions.elementAt(_selectedIndex),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.favorite), label: 'favorite'),
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'more'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onNavTap,
      // ),
    );
  }
}
