import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;

  Reminder({
    @required this.id,
    @required this.title,
    @required this.date,
    @required this.time,
  });
}
