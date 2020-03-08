import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/models/note.dart';

class Databasehelper {
  static Databasehelper _db; //singleton helper
  static Database _dbs;

  String table = 'note_table';
  String colid = 'id';
  String coldesc = 'desc';
  String coltitle = 'title';
  String colpr = 'priority';
  String coldate = 'date';

  Databasehelper._createInstance();

  factory Databasehelper() //constructor will return some value when we write factory befire constructor
  {
    if (_db == null) {
      _db = Databasehelper._createInstance();
    }
    return _db;
  }

  Future<Database> get database async {
    if (_dbs == null) {
      _dbs = await initializeDatabase();
    }
    return _dbs;
  }

  Future<Database> initializeDatabase() async {
    //get the folder path for both android and ios to store database
    Directory dr = await getApplicationDocumentsDirectory();
    String path = dr.path + 'notes.db';

    //open or create database at given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createdb);
    return notesDatabase;
  }

  void _createdb(Database dbs, int newVersion) async {
    await dbs.execute(
        'CREATE TABLE $table($colid INTEGER PRIMARY KEY AUTOINCREMENT, $coltitle TEXT, $coldesc TEXT, $colpr INTEGER, $coldate TEXT)');
  }

  //fetch operation: get all note objects from database
  Future<List<Map<String, dynamic>>> getNotemaplist() async {
    Database db = await this.database;
    // var result=await db.rawQuery('SELECT * FROM $table order by $colpr ASC');
    var result = await db.query(table, orderBy: '$colpr ASC');
    return result;
  }

//insert operation
  Future<int> insert(note n) async {
    Database db = await this.database;
    var result = await db.insert(table, n.toMap());
    return result;
  }

  //update operation
  Future<int> update(note n) async {
    var db = await this.database;
    var result = await db
        .update(table, n.toMap(), where: '$colid = ?', whereArgs: [n.id]);
    return result;
  }

//delete operation
  Future<int> deletenote(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $table WHERE $colid = $id');
    return result;
  }

  //get the no. of objects in database
  Future<int> getcount() async {
    var db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get the map list and convert it to Notelist
Future<List<note>> getNoteList() async{
    var notemap=await getNotemaplist();  //get mapmlist from database
    int count=notemap.length;  // count number of map entries in database
    List<note> noteslist=List<note>();
    //for loop to create note list from map list
  for(int i=0;i<count;i++)
    {
      noteslist.add(note.fromMapObject(notemap[i]));
    }
  return noteslist;
}
}
