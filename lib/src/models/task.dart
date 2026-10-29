// ═════════════════════════════════════════════════════════════
// task.dart — Modèle "Task" : une tâche/devoir à rendre pour un cours.
// ═════════════════════════════════════════════════════════════

/// Représente une tâche (devoir, TP, exposé...) liée à un cours.
/// La classe est IMMUABLE : une fois créée, on ne modifie jamais
/// ses attributs ; on crée une nouvelle copie avec copyWith().
class Task {
  // ── Attributs ─────────────────────────────────────────────
  // "final" = la valeur est fixée une seule fois (dans le constructeur)
  // et ne peut plus changer ensuite → objet immuable.

  /// Identifiant unique de la tâche (ex. "t1").
  final String id;

  /// Titre lisible de la tâche (ex. "TP Dart n°1").
  final String title;

  /// Identifiant du cours auquel la tâche appartient (clé étrangère vers Course.id).
  final String courseId;

  /// Date limite de rendu.
  final DateTime dueDate;

  /// true si la tâche est terminée, false sinon.
  final bool isDone;

  // ── Constructeur ──────────────────────────────────────────
  // "const" : permet de créer des instances constantes à la compilation
  //           (possible car tous les attributs sont final).
  // { ... }  : paramètres NOMMÉS → on écrit Task(id: 't1', title: ...)
  //           ce qui rend l'appel lisible et l'ordre sans importance.
  // required : le paramètre est obligatoire (null-safety).
  // this.x   : raccourci Dart qui affecte directement le paramètre à l'attribut.
  // = false  : valeur par défaut → isDone devient optionnel.
  const Task({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    this.isDone = false,
  });

  // ── copyWith ──────────────────────────────────────────────
  /// Retourne une NOUVELLE Task identique à celle-ci, sauf pour les
  /// champs fournis. Indispensable avec des objets immuables.
  /// Exemple : task.copyWith(isDone: true)
  Task copyWith({
    // Chaque paramètre est nullable (String?) : s'il n'est pas fourni,
    // il vaut null, ce qui veut dire "garde l'ancienne valeur".
    String? id,
    String? title,
    String? courseId,
    DateTime? dueDate,
    bool? isDone,
  }) {
    // On construit un nouvel objet Task...
    return Task(
      // "??" = opérateur "si null alors" : id s'il est fourni, sinon this.id.
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }

  // ── fromJson ──────────────────────────────────────────────
  /// Constructeur "factory" : fabrique une Task à partir d'une Map JSON
  /// (le résultat de jsonDecode). Lève une FormatException si le JSON
  /// est invalide → c'est "l'erreur attendue" testée à l'étape 4.
  factory Task.fromJson(Map<String, dynamic> json) {
    // "is!" teste que la valeur N'EST PAS du type attendu.
    // Si un champ manque, json['id'] vaut null → null n'est pas un String → erreur.
    if (json['id'] is! String ||
        json['title'] is! String ||
        json['courseId'] is! String ||
        json['dueDate'] is! String) {
      // throw interrompt la fonction et propage l'exception à l'appelant.
      throw FormatException('JSON Task invalide : $json');
    }
    // Tous les champs obligatoires sont présents et bien typés : on construit l'objet.
    return Task(
      // "as String" : conversion de type (cast) ; sûre ici grâce au test au-dessus.
      id: json['id'] as String,
      title: json['title'] as String,
      courseId: json['courseId'] as String,
      // DateTime.parse transforme "2026-11-02T08:00:00" en objet DateTime
      // (et lève elle-même une FormatException si la date est mal écrite).
      dueDate: DateTime.parse(json['dueDate'] as String),
      // "as bool?" accepte true/false/null ; "?? false" remplace l'absence par false.
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  // ── toJson ────────────────────────────────────────────────
  /// Opération inverse : transforme l'objet en Map prête pour jsonEncode.
  Map<String, dynamic> toJson() => {
        // "=>" = fonction fléchée : retourne directement l'expression.
        'id': id,
        'title': title,
        'courseId': courseId,
        // toIso8601String produit le format standard "2026-11-02T08:00:00.000".
        'dueDate': dueDate.toIso8601String(),
        'isDone': isDone,
      };

  // ── Égalité par valeur ────────────────────────────────────
  // Par défaut, deux objets Dart sont égaux seulement s'ils sont la même
  // instance en mémoire. On redéfinit == pour comparer les VALEURS :
  // très utile dans les tests (expect(a, equals(b))).
  @override // indique qu'on redéfinit une méthode héritée de Object.
  bool operator ==(Object other) =>
      identical(this, other) || // même instance → forcément égaux
      (other is Task && // l'autre objet doit être une Task...
          other.id == id && // ...et avoir les mêmes valeurs partout.
          other.title == title &&
          other.courseId == courseId &&
          other.dueDate == dueDate &&
          other.isDone == isDone);

  // Règle Dart : si on redéfinit ==, on DOIT redéfinir hashCode
  // (deux objets égaux doivent avoir le même hashCode, ex. dans un Set/Map).
  @override
  int get hashCode => Object.hash(id, title, courseId, dueDate, isDone);

  // ── toString ──────────────────────────────────────────────
  // Texte affiché par print(task) : pratique pour déboguer.
  // $variable / ${expression} = interpolation de chaînes en Dart.
  @override
  String toString() =>
      'Task(id: $id, title: $title, courseId: $courseId, dueDate: ${dueDate.toIso8601String()}, isDone: $isDone)';
}
