import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  final String label;
  final Color color;
  final Function onPressed;

  const FilledButton({
    Key key,
    @required this.onPressed,
    @required this.label,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 48.0,
      minWidth: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onPressed: this.onPressed,
        color: color,
        textColor: Colors.white,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
