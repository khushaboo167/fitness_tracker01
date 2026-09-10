class Workout {
  final int? id;
  final String exerciseName;
  final int sets;
  final int reps;
  final double weight; // kg
  final DateTime date;

  Workout({
    this.id,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.date,
  });

  // Convert a Workout into a Map for storing in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }

  // Create a Workout from a database row
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int?,
      exerciseName: map['exerciseName'] as String,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      weight: (map['weight'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  // Total weight moved in this session (useful for progress charts)
  double get totalVolume => sets * reps * weight;
}
