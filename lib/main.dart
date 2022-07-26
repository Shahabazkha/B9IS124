import 'package:english_words/english_words.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: Splash2(), // And add the const back here.
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: const RandomWords(),
      title: const Text('Startup Name Generator',textScaleFactor: 2,),
      image: Image.asset('assets/images/logo.png'),
      loadingText: const Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    void _pushSaved() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            final tiles = _saved.map(
                  (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            final divided = tiles.isNotEmpty
                ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
                : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
        body:  ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();

            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            final alreadySaved = _saved.contains(_suggestions[index]);
            return ListTile(
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              onTap: () {
                _getVibration(FeedbackType.selection);// NEW from here ...
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                });
              },
            );
          },
        ),
    );
  }
  _getVibration(feedbackType) async {
      Vibrate.feedback(feedbackType);
      Vibrate.vibrate();   // Try this too!
  }
}