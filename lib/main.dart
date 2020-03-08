import 'package:flutter/material.dart';
import 'package:notekeeper/Screens/note_detail.dart';

import 'Screens/notes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NoteKeeper',
    home: notes(),
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
  ));
}
