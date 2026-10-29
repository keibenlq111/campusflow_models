// ═════════════════════════════════════════════════════════════
// course.dart — Modèle "Course" : un cours (UE / matière).
// Même structure que Task : attributs final, constructeur,
// copyWith, fromJson, toJson, ==, hashCode, toString.
// ═════════════════════════════════════════════════════════════

/// Un cours suivi par les étudiants dans CampusFlow.
class Course {
  /// Identifiant unique du cours (ex. "c1").
  final String id;

  /// Intitulé du cours (ex. "Développement mobile").
  final String name;

  /// Nom de l'enseignant responsable.
  final String teacher;

  /// Nombre de crédits ECTS (entier).
  final int credits;

  /// Constructeur constant à paramètres nommés (tous obligatoires ici).
  const Course({
    required this.id,
    required this.name,
    required this.teacher,
    required this.credits,
  });

  /// Copie modifiée : seuls les champs passés en argument changent.
  Course copyWith({
    String? id,
    String? name,
    String? teacher,
    int? credits,
  }) {
    return Course(
      id: id ?? this.id, // nouvelle valeur si fournie, sinon l'ancienne
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      credits: credits ?? this.credits,
    );
  }

  /// Construit un Course depuis une Map JSON ; FormatException si invalide.
  factory Course.fromJson(Map<String, dynamic> json) {
    // Vérification des types : un champ absent (null) ou mal typé est refusé.
    if (json['id'] is! String ||
        json['name'] is! String ||
        json['teacher'] is! String ||
        json['credits'] is! int) {
      throw FormatException('JSON Course invalide : $json');
    }
    // Règle métier : un nombre de crédits négatif n'a pas de sens.
    if ((json['credits'] as int) < 0) {
      throw FormatException('credits doit être >= 0 : ${json['credits']}');
    }
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      teacher: json['teacher'] as String,
      credits: json['credits'] as int,
    );
  }

  /// Sérialisation vers une Map (pour jsonEncode).
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'teacher': teacher,
        'credits': credits,
      };

  /// Égalité par valeur (voir explications détaillées dans task.dart).
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Course &&
          other.id == id &&
          other.name == name &&
          other.teacher == teacher &&
          other.credits == credits);

  /// hashCode cohérent avec == .
  @override
  int get hashCode => Object.hash(id, name, teacher, credits);

  /// Représentation texte pour print().
  @override
  String toString() =>
      'Course(id: $id, name: $name, teacher: $teacher, credits: $credits)';
}
