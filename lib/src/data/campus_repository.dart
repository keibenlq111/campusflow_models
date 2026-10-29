// ═════════════════════════════════════════════════════════════
// campus_repository.dart — "Dépôt simulé" (étape 3).
// Simule un appel réseau (API) : les données JSON sont en dur dans le
// code et la réponse arrive après un délai grâce à Future.delayed.
// Plus tard, dans Flutter, on remplacera ce dépôt par un vrai appel HTTP
// sans changer le reste de l'application.
// ═════════════════════════════════════════════════════════════

// dart:convert fournit jsonDecode (texte JSON → objets Dart).
import 'dart:convert';

// Imports relatifs vers nos trois modèles.
import '../models/course.dart';
import '../models/task.dart';
import '../models/user.dart';

/// Faux serveur : renvoie des listes de modèles de façon asynchrone.
class CampusRepository {
  /// Délai simulé d'une requête réseau. Paramétrable pour que les
  /// tests puissent le mettre à Duration.zero et s'exécuter vite.
  final Duration latency;

  /// Constructeur : par défaut 500 ms de "latence réseau".
  const CampusRepository({this.latency = const Duration(milliseconds: 500)});

  // ── Données brutes, comme si elles venaient d'une API REST ──
  // "static const" : une seule copie partagée, connue à la compilation.
  // Les triples guillemets ''' ''' permettent une chaîne sur plusieurs lignes.
  static const String _coursesJson = '''
[
  {"id": "c1", "name": "Développement mobile", "teacher": "M. Ouédraogo", "credits": 4},
  {"id": "c2", "name": "Bases de données", "teacher": "Mme Kaboré", "credits": 3}
]
''';

  static const String _tasksJson = '''
[
  {"id": "t1", "title": "TP Dart : modèles", "courseId": "c1", "dueDate": "2026-11-02T08:00:00", "isDone": false},
  {"id": "t2", "title": "Schéma relationnel", "courseId": "c2", "dueDate": "2026-11-09T08:00:00", "isDone": true}
]
''';

  static const String _usersJson = '''
[
  {"id": "u1", "fullName": "Awa Traoré", "email": "awa@campus.bf", "role": "student", "courseIds": ["c1", "c2"]},
  {"id": "u2", "fullName": "Issa Ouédraogo", "email": "issa@campus.bf", "role": "teacher", "courseIds": ["c1"]}
]
''';
  // Le "_" devant le nom rend le membre PRIVÉ à ce fichier (bibliothèque).

  /// Charge la liste des cours.
  /// "Future<List<Course>>" : la liste sera disponible PLUS TARD.
  /// "async" autorise l'utilisation de "await" dans la fonction.
  Future<List<Course>> fetchCourses() async {
    // await met la fonction en pause pendant "latency" sans bloquer le programme.
    await Future.delayed(latency);
    // jsonDecode renvoie un dynamic ; on sait que c'est une liste JSON.
    final list = jsonDecode(_coursesJson) as List<dynamic>;
    // map applique Course.fromJson à chaque élément, toList matérialise le résultat.
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Charge la liste des tâches (même principe).
  Future<List<Task>> fetchTasks() async {
    await Future.delayed(latency);
    final list = jsonDecode(_tasksJson) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Charge la liste des utilisateurs (même principe).
  Future<List<User>> fetchUsers() async {
    await Future.delayed(latency);
    final list = jsonDecode(_usersJson) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Exemple de "chargement simulé" qui ÉCHOUE : utile pour montrer
  /// comment une erreur se propage dans un Future (try/catch + await).
  Future<Task> fetchBrokenTask() async {
    await Future.delayed(latency);
    // Il manque "title" et "dueDate" → Task.fromJson lèvera FormatException.
    final json = jsonDecode('{"id": "t9", "courseId": "c1"}') as Map<String, dynamic>;
    return Task.fromJson(json);
  }
}
