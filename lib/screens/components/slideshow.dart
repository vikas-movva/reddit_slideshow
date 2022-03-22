import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Slideshow extends StatefulWidget {
  const Slideshow({
    Key? key,
    required this.children,
    this.width = double.infinity,
    this.height = 200,
    this.initialPage = 0,
    this.onPageChanged,
    this.autoPlayInterval,
  }) : super(key: key);

  final List<Widget> children;
  final double width;
  final double height;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;
  final int? autoPlayInterval;

  @override
  _SlideshowState createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final _currentPageNotifier = ValueNotifier(0);
  late PageController _pageController;

  void _onPageChanged(int index) {
    _currentPageNotifier.value = index;
    if (widget.onPageChanged != null) {
      final correctIndex = index % widget.children.length;
      widget.onPageChanged!(correctIndex);
    }
  }

  void _autoPlayTimerStart() {
    Timer.periodic(
      Duration(milliseconds: widget.autoPlayInterval!),
      (timer) {
        int nextPage;
        if (_currentPageNotifier.value < widget.children.length - 1) {
          nextPage = _currentPageNotifier.value + 1;
        } else {
          return;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );
    _currentPageNotifier.value = widget.initialPage;

    if (widget.autoPlayInterval != null && widget.autoPlayInterval != 0) {
      _autoPlayTimerStart();
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            scrollBehavior: const ScrollBehavior().copyWith(
              scrollbars: false,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            onPageChanged: _onPageChanged,
            itemCount: widget.children.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final correctIndex = index % widget.children.length;
              return widget.children[correctIndex];
            },
          ),
        ],
      ),
    );
  }
}
