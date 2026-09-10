import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout.dart';

/// Handles all local SQLite storage for workout entries.
/// This is a singleton so the whole app shares one database connection.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workouts.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exerciseName TEXT NOT NULL,
        sets INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<Workout> insertWorkout(Workout workout) async {
    final db = await instance.database;
    final id = await db.insert('workouts', workout.toMap());
    return Workout(
      id: id,
      exerciseName: workout.exerciseName,
      sets: workout.sets,
      reps: workout.reps,
      weight: workout.weight,
      date: workout.date,
    );
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await instance.database;
    final result = await db.query('workouts', orderBy: 'date DESC');
    return result.map((map) => Workout.fromMap(map)).toList();
  }

  Future<List<Workout>> getWorkoutsByExercise(String exerciseName) async {
    final db = await instance.database;
    final result = await db.query(
      'workouts',
      where: 'exerciseName = ?',
      whereArgs: [exerciseName],
      orderBy: 'date ASC',
    );
    return result.map((map) => Workout.fromMap(map)).toList();
  }

  /// Returns the list of unique exercise names the user has logged,
  /// used to populate the dropdown on the Progress screen.
  Future<List<String>> getDistinctExerciseNames() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT DISTINCT exerciseName FROM workouts ORDER BY exerciseName',
    );
    return result.map((row) => row['exerciseName'] as String).toList();
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
