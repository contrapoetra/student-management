import 'dart:async';
import 'student.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void dbsms() async {
}

class DatabaseHelper {
  Future<Database> getDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'student.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE students(id TEXT PRIMARY KEY, name TEXT, nis TEXT, grade TEXT, address TEXT, birthdate TEXT, bloodtype TEXT, sex TEXT, hobby TEXT, father TEXT, mother TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertStudent(Student student) async {
    final db = await getDB();

    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Student>> students() async {
    final db = await getDB();

    final List<Map<String, Object?>> studentMaps = await db.query('students');

    return [
      for (final {
            'id': id as String,
            'name': name as String,
            'nis': nis as String,
            'grade': grade as String,
            'address': address as String,
            'birthdate': birthdate as String,
            'bloodtype': bloodtype as String,
            'sex': sex as String,
            'hobby': hobby as String,
            'father': father as String,
            'mother': mother as String,
          }
          in studentMaps)
        Student(
          id: id,
          name: name,
          nis: nis,
          grade: grade,
          address: address,
          birthdate: birthdate,
          bloodtype: bloodtype,
          sex: sex,
          hobby: hobby,
          father: father,
          mother: mother,
        ),
    ];
  }

  Future<void> updateStudent(Student student) async {
    final db = await getDB();

    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<void> deleteStudent(String id) async {
    final db = await getDB();

    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
