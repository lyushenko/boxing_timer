import 'package:flutter/material.dart';

class StopwatchButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData icon;

  const StopwatchButton({
    Key key,
    @required this.label,
    @required this.onPressed,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return OutlineButton.icon(
      icon: Icon(icon, color: primaryColor),
      color: Colors.white,
      borderSide: BorderSide(
        color: primaryColor,
        width: 2,
        style: BorderStyle.solid,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      label: Text(
        label,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
