import 'package:flutter/material.dart';
import 'package:notekeeper/Screens/note_detail.dart';
import 'dart:async';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return notelist();
  }
}

class notelist extends State<notes> {
  int cnt = 0;
  Databasehelper dbh1 = Databasehelper();
  List<note> Noteslist;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    updatelistview();
    if (Noteslist == null) {
      Noteslist = List<note>();
      updatelistview();
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNotes(),
      floatingActionButton: FloatingActionButton(
        //for add button
        foregroundColor: Colors.white,
        onPressed: () {
          debugPrint("floating button pressed");
          navigation(note('','',2),'Add Note');
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNotes() {
    TextStyle ts = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int pos) {
        return Card(
          //card like structure
          color: Colors.white,
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              //circular icon on starting
              backgroundColor: getprcolor(this.Noteslist[pos].priority),
              child: getpricon(this.Noteslist[pos].priority),
            ),
            title: Text(
              this.Noteslist[pos].title,
              style: ts,
            ),
            subtitle: Text(this.Noteslist[pos].date),
            trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  delete(context, Noteslist[pos]);
                }),
            //ending icon
            onTap: () {
              debugPrint("list tapped");
              navigation(this.Noteslist[pos],'Edit Note');
            },
          ),
        );
      },
    );
  }

  //return priority color
  Color getprcolor(int pr) {
    switch (pr) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  //return the priority icon
  Icon getpricon(int pr) {
    switch (pr) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void delete(BuildContext, note n) async {
    int result = await dbh1.deletenote(n.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updatelistview();
    }
  }

  void _showSnackBar(BuildContext context, String str) {
    final sb = SnackBar(
      content: Text(str),
    );
    Scaffold.of(context).showSnackBar(sb);
  }

  void navigation(note n,String title) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return notedetail(n,title);
    }));
    if(result==true) {
      updatelistview();
    }
  }

  void updatelistview() {
    final Future<Database> dbfuture = dbh1.initializeDatabase();
    dbfuture.then((database) {
      Future<List<note>> notelistfuture = dbh1.getNoteList();
      notelistfuture.then((Noteslist) {
        setState(() {
          this.Noteslist = Noteslist;
          this.count = Noteslist.length;
        });
      });
    });
  }
}
