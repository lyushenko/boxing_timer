import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'models/workout.dart';
import 'screens/timer.dart';
import 'widgets/filled_button.dart';
import 'widgets/blink.dart';

void main() {
  runApp(BoxingTimer());
}

class BoxingTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boxing Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        primaryColor: Color.fromRGBO(22, 100, 253, 1),
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              brightness: Brightness.light,
              elevation: 0,
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // TODO: swap with SingleTickerProviderStateMixin?
  AnimationController _animationController;
  Animation<int> _characterCount;
  String _currentString = 'Minimalist Boxing Timer';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    setState(() {
      _characterCount = StepTween(begin: 0, end: _currentString.length)
          .animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ));
    });

    _animationController.forward();

    Timer(
      Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => TimerSettings(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      decoration: TextDecoration.none,
    );

    if (_characterCount == null) return SizedBox.shrink();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _characterCount,
            builder: (context, child) {
              String text = _currentString.substring(0, _characterCount.value);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text, style: textStyle),
                  Blink(
                    child: Text(
                      '_',
                      style: textStyle.apply(color: Color(0xFF007AFF)),
                    ),
                    duration: const Duration(milliseconds: 250),
                  )
                ],
              );
            },
          ),
          SizedBox(height: 24),
          Icon(Icons.timer, size: 64),
        ],
      ),
    );
  }
}

class TimerSettings extends StatefulWidget {
  @override
  _TimerSettingsState createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration _roundLength = Duration(minutes: 2);
  Duration _breakLength = Duration(seconds: 30);
  Duration _preparationLength = Duration(seconds: 30);
  int _numOfRounds = 12;

  void _pickRoundLength(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 0,
          end: 10,
          initValue: _roundLength.inMinutes.remainder(60),
          jump: 1,
        ),
        NumberPickerColumn(
          begin: 0,
          end: 45,
          initValue: _roundLength.inSeconds.remainder(60),
          jump: 15,
        ),
      ]),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      title: Text('Round Length'),
      onConfirm: (Picker picker, List value) {
        final List<int> values = picker.getSelectedValues();
        setState(() {
          _roundLength = Duration(minutes: values[0], seconds: values[1]);
        });
      },
    ).showDialog(context);
  }

  void _pickBreakLength(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 0,
          end: 10,
          initValue: _breakLength.inMinutes.remainder(60),
          jump: 1,
        ),
        NumberPickerColumn(
          begin: 0,
          end: 55,
          initValue: _breakLength.inSeconds.remainder(60),
          jump: 5,
        ),
      ]),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      title: Text('Break Length'),
      onConfirm: (Picker picker, List value) {
        final List<int> values = picker.getSelectedValues();
        setState(() {
          _breakLength = Duration(minutes: values[0], seconds: values[1]);
        });
      },
    ).showDialog(context);
  }

  void _pickGetReadyLength(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: 0),
        NumberPickerColumn(
          begin: 0,
          end: 60,
          initValue: _preparationLength.inSeconds.remainder(60),
          jump: 5,
        ),
      ]),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      title: Text('Get Ready'),
      onConfirm: (Picker picker, List value) {
        final List<int> values = picker.getSelectedValues();
        setState(() {
          _preparationLength = Duration(minutes: values[0], seconds: values[1]);
        });
      },
    ).showDialog(context);
  }

  void _pickNumOfRounds(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(
        data: [
          NumberPickerColumn(
            begin: 1,
            end: 100,
            initValue: _numOfRounds,
            jump: 1,
          ),
        ],
      ),
      hideHeader: true,
      title: new Text('Number Of Rounds'),
      onConfirm: (Picker picker, List value) {
        setState(() {
          _numOfRounds = picker.getSelectedValues()[0];
        });
      },
    ).showDialog(context);
  }

  String _formatTime(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String mm = twoDigits(time.inMinutes.remainder(60));
    String ss = twoDigits(time.inSeconds.remainder(60));
    return "$mm:$ss";
  }

  String _workoutLengthLabel() {
    final int workoutLengthInSeconds = _preparationLength.inSeconds +
        _roundLength.inSeconds * _numOfRounds +
        _breakLength.inSeconds * (_numOfRounds - 1);
    return _formatTime(Duration(seconds: workoutLengthInSeconds));
  }

  String _secondaryLabel() {
    final rest = _breakLength.inSeconds > 0
        ? "${_breakLength.inSeconds} seconds rest"
        : 'No rest';
    final rounds = "$_numOfRounds ${_numOfRounds == 1 ? 'round' : 'rounds'}";
    return "$rest, $rounds";
  }

  void startWorkout() {
    final workout = WorkoutModel(
      roundLength: _roundLength,
      breakLength: _breakLength,
      preparationLength: _preparationLength,
      numOfRounds: _numOfRounds,
    );

    if (!workout.isValid()) {
      Widget okButton = FlatButton(
        child: Text('OK'),
        onPressed: () => Navigator.pop(context),
      );

      AlertDialog alert = AlertDialog(
        title: Text('Round Length'),
        content: Text('Please select round length'),
        actions: [
          okButton,
        ],
      );

      showDialog(context: context, builder: (_) => alert);

      return;
    }

    // Start the workout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerScreen(workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Boxing Timer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Round Length', style: labelStyle),
                  PickerButton(
                    onPressed: () {
                      _pickRoundLength(context);
                    },
                    child: Text(_formatTime(_roundLength)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Break Length', style: labelStyle),
                  PickerButton(
                    onPressed: () {
                      _pickBreakLength(context);
                    },
                    child: Text(_formatTime(_breakLength)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Preparation Time', style: labelStyle),
                  PickerButton(
                    onPressed: () {
                      _pickGetReadyLength(context);
                    },
                    child: Text(_formatTime(_preparationLength)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Number Of Rounds', style: labelStyle),
                  PickerButton(
                    onPressed: () {
                      _pickNumOfRounds(context);
                    },
                    child: Text(_numOfRounds.toString()),
                  ),
                ],
              ),
              Spacer(flex: 1),
              Text(
                'Workout',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
              ),
              Text(
                _workoutLengthLabel(),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 80),
              ),
              Text(
                _secondaryLabel(),
                style: TextStyle(fontSize: 20),
              ),
              Spacer(flex: 1),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: FilledButton(
                    label: 'START',
                    color: Theme.of(context).primaryColor,
                    onPressed: startWorkout,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const labelStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
);

class PickerButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  const PickerButton({Key key, @required this.onPressed, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: child,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
