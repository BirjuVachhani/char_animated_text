import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'char_animated_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cursor Blob',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
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
  int selectedIndex = 0;

  static const List<String> items = [
    'Story  CN',
    'Protocol',
    'Journal',
    'Media',
    'Gallery',
    'About',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purpleAccent,
                Colors.indigoAccent,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    launchUrlString(
                        'https://github.com/BirjuVachhani/char_animated_text');
                  },
                  child: const Text('View on GitHub'),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Text.rich(
                  TextSpan(
                    text: 'Inspired by ',
                    children: [
                      TextSpan(
                        text: 'kprverse.com',
                        mouseCursor: SystemMouseCursors.click,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString('https://kprverse.com');
                          },
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    width: 450,
                    height: 800,
                    margin: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24, left: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 3,
                                  height: 3,
                                  margin: const EdgeInsets.only(top: 4),
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: CharAnimatedText(
                                    'DISCOVER',
                                    textAlign: TextAlign.start,
                                    progressive: false,
                                    style: GoogleFonts.spaceMono(
                                      fontSize: 6,
                                      height: 1,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white,
                                      fontFeatures: [
                                        const FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 48),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: 6,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final text = items[index];
                                      return Item(
                                        key: ValueKey(text),
                                        text: text,
                                        selected: selectedIndex == index,
                                        onSelected: () => setState(
                                            () => selectedIndex = index),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFF333333),
                        ),
                        SizedBox(
                          width: 72,
                          child: Column(
                            children: const [
                              SizedBox(height: 14),
                              Center(
                                child: Icon(
                                  Icons.close,
                                ),
                              ),
                              SizedBox(height: 14),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFF333333),
                              ),
                              Spacer(),
                              Center(
                                child: Icon(
                                  Icons.more_horiz_rounded,
                                  size: 20,
                                ),
                              ),
                              SizedBox(height: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String text;
  final bool selected;
  final VoidCallback onSelected;

  const Item({
    Key? key,
    required this.text,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: widget.onSelected,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
            decoration: ShapeDecoration(
              color: widget.selected
                  ? const Color(0xFFC0FB51)
                  : hovering
                      ? Colors.white
                      : Colors.transparent,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => hovering = true),
              onExit: (_) => setState(() => hovering = false),
              child: CharAnimatedText(
                widget.text.toUpperCase(),
                textAlign: TextAlign.start,
                progressive: false,
                style: GoogleFonts.azeretMono(
                  fontSize: 42,
                  letterSpacing: -2,
                  height: 0.8,
                  fontWeight: FontWeight.bold,
                  color:
                      widget.selected || hovering ? Colors.black : Colors.white,
                  fontFeatures: [
                    const FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
