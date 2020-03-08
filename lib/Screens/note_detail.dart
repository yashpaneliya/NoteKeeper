import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/models/note.dart' as prefix0;
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notekeeper/Screens/notes.dart';

class notedetail extends StatefulWidget {
  String appBarTitle;
  final note nt;

  notedetail(this.nt, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return notedetailstate(this.nt, this.appBarTitle);
  }
}

class notedetailstate extends State<notedetail> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  String appBartitle;
  note nt;
  Databasehelper dbh = Databasehelper();
  notedetailstate(this.nt, this.appBartitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle ts = Theme.of(context).textTheme.subhead;
    t1.text = nt.title;
    t2.text = nt.desc;
    return WillPopScope(
        //widget to control the action for back and other buttons
        onWillPop: () {
          // will execute when back button of mobile is pressed
          lastPage();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBartitle),
            leading: IconButton(
              onPressed: () {
                lastPage();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: ["High", "Low"].map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  style: ts,
                  value: updateprAsstring(nt.priority),
                  onChanged: (selval) {
                    setState(() {
                      updateprAsint(selval);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: t1,
                  style: ts,
                  onChanged: (value) {
                    debugPrint("Textfield 1");
                    updatetitle();
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      hintText: "Enter Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: t2,
                  style: ts,
                  onChanged: (value) {
                    debugPrint("Textfield 2");
                    updatedesc();
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Enter Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 10.0),
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            _savedata();
                          },
                        ),
                      )),
                      Container(width: 5.0),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Delete",
                            style: TextStyle(fontSize: 10.0),
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            _delete();
                          },
                        ),
                      ))
                    ],
                  ))
            ],
          ),
        ));
  }

  //conver string priority to int
  void updateprAsint(String val) {
    switch (val) {
      case 'High':
        nt.priority = 1;
        break;
      case 'Low':
        nt.priority = 2;
        break;
    }
  }

  //convert int pr to string pr
  String updateprAsstring(int val) {
    String priority;
    switch (val) {
      case 1:
        priority = 'High';
        break;
      case 2:
        priority = 'Low';
        break;
    }
    return priority;
  }

  //update title
  void updatetitle() {
    nt.title = t1.text;
  }

  //update description
  void updatedesc() {
    nt.desc = t2.text;
  }

  //save data to base
  void _savedata() async {
    lastPage();
    nt.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (nt.id != null) //update operation
    {
      result = await dbh.update(nt);
    } else //insert operation
    {
      result = await dbh.insert(nt);
    }

    if (result != 0) {
      showAlter('Status', 'Note saved successfully');
    } else {
      showAlter('Status', 'Problem saving note');
    }
  }

  void _delete() async {
    lastPage();
    //case 1=user want to delete new note
    if (nt.id == null) {
      showAlter('Status', 'No note was deleted');
      return;
    }
    //case 2=user try to delete older note
    int result = await dbh.deletenote(nt.id);
    if (result != 0) {
      showAlter('Status', 'Note deleted successfully');
    } else {
      showAlter('Status', 'Problem deleting note');
    }
  }

  void lastPage() {
    Navigator.pop(context, true);
  }

  void showAlter(String s, String t) {
    AlertDialog ald = AlertDialog(
      title: Text(s),
      content: Text(t),
    );
    showDialog(context: context, builder: (_) => ald); //??????
  }
}
