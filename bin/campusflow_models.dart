// ═════════════════════════════════════════════════════════════
// bin/campusflow_models.dart — Petit programme de démonstration.
// Lancer avec :  dart run
// ═════════════════════════════════════════════════════════════

// On importe TOUT le package via son fichier public (barrel).
import 'package:campusflow_models/campusflow_models.dart';

/// main est le point de départ du programme.
/// Il est "async" car on attend (await) les Future du dépôt.
Future<void> main() async {
  // Création du dépôt simulé (latence par défaut : 500 ms).
  const repo = CampusRepository();

  print('Chargement des données...');

  // Future.wait lance les 3 chargements EN PARALLÈLE et attend qu'ils
  // soient tous finis (~500 ms au total au lieu de ~1500 ms).
  final results = await Future.wait([
    repo.fetchCourses(),
    repo.fetchTasks(),
    repo.fetchUsers(),
  ]);

  // results est une List<List<Object>> ; on re-type chaque élément.
  final courses = results[0] as List<Course>;
  final tasks = results[1] as List<Task>;
  final users = results[2] as List<User>;

  // Affichage : for-in parcourt chaque élément de la liste.
  print('\n— Cours —');
  for (final c in courses) {
    print(c); // appelle automatiquement c.toString()
  }

  print('\n— Tâches —');
  for (final t in tasks) {
    print(t);
  }

  print('\n— Utilisateurs —');
  for (final u in users) {
    print(u);
  }

  // Démonstration de copyWith : on "termine" la première tâche.
  final first = tasks.first;
  final done = first.copyWith(isDone: true);
  print('\nAvant : isDone=${first.isDone} | Après copyWith : isDone=${done.isDone}');
  // L'original n'a PAS changé : c'est le principe de l'immuabilité.

  // Démonstration de la gestion d'erreur asynchrone.
  try {
    await repo.fetchBrokenTask(); // ce Future échoue...
  } on FormatException catch (e) {
    // ...et l'exception est attrapée ici comme une erreur synchrone.
    print('\nErreur attendue attrapée : ${e.message}');
  }
}
