# Fitness Tracker (Flutter + Dart)

A simple workout tracker: log exercises (sets, reps, weight), view history,
and see a progress chart of weight lifted over time per exercise.

## How it's built
- **UI:** Flutter widgets (Material 3)
- **Storage:** SQLite via the `sqflite` package (fully local, no backend needed)
- **Charts:** `fl_chart` for the line chart on the Progress tab
- **Language:** 100% Dart — no other languages required

## Project structure
```
lib/
  main.dart                  -> app entry point + bottom nav
  models/workout.dart        -> Workout data model
  db/database_helper.dart    -> SQLite read/write logic
  screens/home_screen.dart   -> workout history list (swipe to delete)
  screens/add_workout_screen.dart -> form to log a new workout
  screens/progress_screen.dart    -> dropdown + line chart per exercise
```

## Setup instructions

1. **Install Flutter** (if you haven't already): https://docs.flutter.dev/get-started/install
   Run `flutter doctor` afterward to confirm everything is set up correctly.

2. **Create a new Flutter project** on your machine, or just drop these files
   into a fresh project:
   ```
   flutter create fitness_tracker
   ```
   Then replace the generated `lib/` folder and `pubspec.yaml` with the files
   provided here.

3. **Install dependencies:**
   ```
   cd fitness_tracker
   flutter pub get
   ```

4. **Run it:**
   ```
   flutter run
   ```
   Pick a connected device/emulator, or run `flutter emulators --launch <id>`
   first if you don't have one open.

## How to use the app
- Tap the **+** button on the History tab to log a workout (exercise name, sets, reps, weight, date).
- Swipe a workout left on the History tab to delete it.
- Go to the **Progress** tab, pick an exercise from the dropdown, and see a
  line chart of the weight you've lifted over time for that exercise.
  (You need at least 2 logged entries for a given exercise to see a trend line.)

## Ideas for extending this
- Add a "reps" or "total volume" chart option alongside weight
- Add workout categories/tags (e.g. Push, Pull, Legs)
- Add body-weight tracking as a separate chart
- Add local notifications reminding you to log a workout
- Swap SQLite for `Hive` if you'd rather avoid raw SQL
- Add cloud sync later with Firebase if you want data across devices
