import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/workout.dart';
import 'add_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Workout> _workouts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() => _loading = true);
    final workouts = await DatabaseHelper.instance.getAllWorkouts();
    setState(() {
      _workouts = workouts;
      _loading = false;
    });
  }

  Future<void> _deleteWorkout(int id) async {
    await DatabaseHelper.instance.deleteWorkout(id);
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _workouts.isEmpty
              ? const Center(
                  child: Text(
                    'No workouts logged yet.\nTap + to add your first one!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final w = _workouts[index];
                    return Dismissible(
                      key: Key(w.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteWorkout(w.id!),
                      child: Card(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(w.exerciseName.isNotEmpty
                                ? w.exerciseName[0].toUpperCase()
                                : '?'),
                          ),
                          title: Text(w.exerciseName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${w.sets} sets x ${w.reps} reps @ ${w.weight}kg\n${DateFormat.yMMMd().format(w.date)}'),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWorkoutScreen()),
          );
          _loadWorkouts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
