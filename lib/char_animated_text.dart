import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Represents custom builder for the text.
typedef CharAnimatedTextBuilder = Widget Function(
    BuildContext context, String text);

/// A widget that animates a text when hovered by generating random characters
/// for each character in the text and then replacing them with the actual
/// character one by one in a progressive manner.
///
/// Uses [AnimationController] to animate the text.
///
/// Use [CharAnimatedText.builder] to provide a custom builder for the text.
/// Otherwise, uses [Text] widget to render the text. [style] and [textAlign]
/// are ignored when [builder] is provided.
///
/// [interval] is the time between each new progressive string generation.
///
/// Setting [progressive] to true will show partial text progressively.
class CharAnimatedText extends StatefulWidget {
  /// The text to animate.
  final String text;

  /// The style to use for the text. [style] is ignored when
  /// [builder] is provided.
  final TextStyle? style;

  /// The alignment of the text. [textAlign] is ignored when
  /// [builder] is provided.
  final TextAlign? textAlign;

  /// Whether to show the text progressively or not. Setting this to true
  /// will show partial text progressively.
  final bool progressive;

  /// The time between each new progressive string generation.
  final Duration interval;

  /// The builder for the text. This can be used to provide a custom builder
  /// for the text.[style] and [textAlign] are ignored when
  /// [builder] is provided.
  final CharAnimatedTextBuilder? builder;

  /// Creates a [CharAnimatedText] widget.
  const CharAnimatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.progressive = false,
    this.interval = const Duration(milliseconds: 100),
  }) : builder = null;

  /// Creates a [CharAnimatedText] widget with a custom builder.
  const CharAnimatedText.builder({
    super.key,
    required this.text,
    required CharAnimatedTextBuilder this.builder,
    this.progressive = false,
    this.interval = const Duration(milliseconds: 100),
  })  : style = null,
        textAlign = null;

  @override
  State<CharAnimatedText> createState() => _GeneratingAnimatedTextState2();
}

class _GeneratingAnimatedTextState2 extends State<CharAnimatedText>
    with SingleTickerProviderStateMixin {
  /// Whether the text is currently animating.
  bool get isAnimating => controller.isAnimating;

  /// Whether the mouse is hovering over the text.
  bool isHovering = false;

  /// The random number generator.
  final Random random = Random();

  /// The animation controller.
  late final AnimationController controller;

  /// Tracks random characters generated for each character in the text for
  /// each iteration.
  final Map<String, String> iterations = {};

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    updateAnimationDuration();
  }

  @override
  void didUpdateWidget(covariant CharAnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !isAnimating) {
      updateAnimationDuration();
      if (isAnimating) animate();
    }
    if (oldWidget.interval != widget.interval) {
      updateAnimationDuration();
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
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final text = buildText(controller.value);

          if (widget.builder != null) {
            return widget.builder!(context, text);
          }

          return Text(
            text,
            textAlign: widget.textAlign,
            style: widget.style,
          );
        },
      ),
    );
  }

  /// Updates the animation duration based on the text length and interval.
  void updateAnimationDuration() {
    controller.duration = Duration(
        milliseconds: widget.interval.inMilliseconds * widget.text.length);
  }

  /// Animates the text.
  Future<void> animate() async {
    if (isAnimating) return;
    iterations.clear();
    controller.reset();
    await controller.forward();
  }

  /// Builds the text to show based on the animation value.
  String buildText(double animationValue) {
    if (!controller.isAnimating) return widget.text;

    final int iteration = ((animationValue * widget.text.length)).floor();

    final String key = animationValue.toStringAsFixed(2);

    final value =
        iterations.putIfAbsent(key, () => randomize(widget.text, iteration));

    if (widget.progressive) {
      return value
          .substring(0, min(iteration + 1, widget.text.length))
          .padRight(widget.text.length, ' ');
    }

    return value;
  }

  /// Generates random characters for each character in the text.
  String randomize(String text, num animationValue) {
    return text.characters
        .mapIndexed((index, character) => randomChar(index, animationValue))
        .join();
  }

  /// Generates a random character for the character at the given position.
  String randomChar(int position, num iteration) {
    if (iteration > position) return widget.text.characters.elementAt(position);
    return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[(random.nextDouble() * 25).round()];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
