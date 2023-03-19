import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'char_animated_text.dart';

/// A [CharAnimatedText] widget that doesn't use [AnimationController] to
/// animate the text but instead uses a for loop to generate random characters
/// for each character in the text and then replacing them with the actual
/// character one by one in a progressive manner.
class RawCharAnimatedText extends StatefulWidget {
  /// The text to animate.
  final String text;

  /// The style to use for the text. [style] is ignored when
  /// [builder] is provided.
  final TextStyle? style;

  /// The alignment of the text. [textAlign] is ignored when
  /// [builder] is provided.
  final TextAlign? textAlign;

  /// The builder for the text. This can be used to provide a custom builder
  /// for the text.[style] and [textAlign] are ignored when
  /// [builder] is provided.
  final CharAnimatedTextBuilder? builder;

  /// The time between each new progressive string generation.
  final Duration interval;

  /// Whether to show the text progressively or not. Setting this to true
  /// will show partial text progressively.
  final bool progressive;

  /// Creates a [RawCharAnimatedText] widget.
  const RawCharAnimatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.interval = const Duration(milliseconds: 30),
    this.progressive = false,
  }) : builder = null;

  /// Creates a [RawCharAnimatedText] widget with a custom builder.
  const RawCharAnimatedText.builder({
    required this.text,
    required CharAnimatedTextBuilder this.builder,
    super.key,
    this.interval = const Duration(milliseconds: 30),
    this.progressive = false,
  })  : style = null,
        textAlign = null;

  @override
  State<RawCharAnimatedText> createState() => _RawCharAnimatedTextState();
}

class _RawCharAnimatedTextState extends State<RawCharAnimatedText> {
  String text = '';

  bool isAnimating = false;

  bool isHovering = false;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  void didUpdateWidget(covariant RawCharAnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !isAnimating) {
      text = widget.text;
      // TODO: restart animation.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (isAnimating) return;
        isHovering = true;
        animate();
      },
      onExit: (_) {
        if (isAnimating) return;
        isHovering = false;
      },
      child: widget.builder?.call(context, text) ??
          Text(
            text,
            textAlign: widget.textAlign,
            style: widget.style!.copyWith(
              fontFeatures: [
                const FontFeature.tabularFigures(),
              ],
            ),
          ),
    );
  }

  Future<void> animate() async {
    isAnimating = true;
    final initialText = text;

    for (int iteration = 0; iteration < initialText.length * 3; iteration++) {
      text = initialText.characters
          .mapIndexed((index, character) => randomizer(index, iteration / 3))
          .join();
      if (widget.progressive) {
        text = text.substring(0, min(iteration + 1, initialText.length));
      }
      setState(() {});
      await Future.delayed(widget.interval);
    }
    isAnimating = false;
  }

  String randomizer(int position, double iteration) {
    if (iteration > position) return widget.text.characters.elementAt(position);
    return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(random.nextDouble() * 25).round()];
  }
}
