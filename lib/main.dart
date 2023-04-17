import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _numberToGuess = Random().nextInt(100) + 1;
  int? _numberTried;
  late String _textHint = '';
  late String _buttonText = 'Guess';
  final TextEditingController _controller = TextEditingController();
  bool _textEnabled = true;

  void _startGame() {
    _numberToGuess = Random().nextInt(100) + 1;
    _textHint = '';
    _buttonText = 'Guess';
    _numberTried = null;
    _textEnabled = true;
  }

  void _showAlertDialog(BuildContext context) {
    final AlertDialog alert = AlertDialog(
      title: const Text(
        'You guessed right',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      content: Text(
        'It was $_numberTried',
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Try again!',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          onPressed: () {
            setState(() {
              _startGame();
            });
            Navigator.of(context).pop(); // Close the alert dialog
          },
        ),
        TextButton(
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close the alert dialog
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Guess my number')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            const Text(
              "I'm thinking of a number between 1 and 100.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const Text(
              "It's your turn to guess my number!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                _textHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Try a number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: _controller,
                        enabled: _textEnabled,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        onChanged: (String value) {
                          _numberTried = int.tryParse(value);
                        },
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (_numberTried != null) {
                              if (_numberTried == _numberToGuess) {
                                if (_buttonText == 'Restart') {
                                  _startGame();
                                } else {
                                  _textHint = 'You tried $_numberTried\nYou guessed right';
                                  _buttonText = 'Restart';
                                  _controller.clear();
                                  _textEnabled = false;
                                  _showAlertDialog(context);
                                }
                              } else if (_numberTried! > _numberToGuess) {
                                _textHint = 'You tried $_numberTried\nTry lower';
                              } else {
                                _textHint = 'You tried $_numberTried\nTry higher';
                              }
                            }
                          });
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                        child: Text(_buttonText))
                  ],
                ))
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
