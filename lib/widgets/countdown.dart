import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/stopwatch_button.dart';

class AnimatedCountdown extends StatefulWidget {
  final UniqueKey key;
  final Duration duration;
  final Function onComplete;
  final String title;
  final String subtitle;
  final Color color;

  AnimatedCountdown({
    this.key,
    this.duration,
    this.title,
    this.subtitle,
    this.color,
    this.onComplete,
  });

  @override
  _AnimatedCountdownState createState() => _AnimatedCountdownState();
}

class _AnimatedCountdownState extends State<AnimatedCountdown>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool isRunning = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addStatusListener(this.statusListener);
    _controller.forward();
  }

  statusListener(status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(this.statusListener);
    _controller.dispose();
    super.dispose();
  }

  void onPause() {
    if (_controller.isAnimating) {
      _controller.stop(canceled: false);
      setState(() => isRunning = false);
    } else {
      _controller.forward();
      setState(() => isRunning = true);
    }
  }

  void onReset() {
    _controller.reset();
    setState(() => isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subtitle, style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 56),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: Countdown(
                duration: widget.duration,
                animation: StepTween(
                  begin: widget.duration.inMilliseconds,
                  end: 0,
                ).animate(_controller),
                color: widget.color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 40,
                      child: StopwatchButton(
                        icon: isRunning ? Icons.pause : Icons.play_arrow,
                        label: isRunning ? 'PAUSE' : 'RESUME',
                        onPressed: onPause,
                      ),
                    ),
                    SizedBox(width: 24.0),
                    SizedBox(
                      width: 140,
                      height: 40,
                      child: StopwatchButton(
                        icon: Icons.restore,
                        label: 'RESET',
                        onPressed: onReset,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  final Duration duration;
  final Animation<int> animation;
  final Color color;

  const Countdown({
    Key key,
    this.duration,
    this.animation,
    this.color,
  }) : super(key: key, listenable: animation);

  String _timerText() {
    Duration clockTimer = Duration(milliseconds: animation.value);

    String min = clockTimer.inMinutes.remainder(60).toString();
    String sec = clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CircularPercentIndicator(
      radius: size.width * 0.80,
      animation: true,
      animateFromLastPercent: true,
      addAutomaticKeepAlive: false,
      lineWidth: 20.0,
      percent:
          (duration.inMilliseconds - animation.value) / duration.inMilliseconds,
      center: Text(
        _timerText(),
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 80),
      ),
      backgroundColor: Colors.grey[300],
      circularStrokeCap: CircularStrokeCap.round,
      linearGradient: LinearGradient(
        colors: [Color.fromRGBO(190, 130, 255, 1.0), color],
      ),
    );
  }
}
