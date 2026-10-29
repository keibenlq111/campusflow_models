// ═════════════════════════════════════════════════════════════
// user.dart — Modèle "User" : un utilisateur de CampusFlow.
// Nouveauté par rapport à Task/Course : un champ de type ENUM
// et un champ LISTE (immuable).
// ═════════════════════════════════════════════════════════════

/// Les rôles possibles. Un enum limite les valeurs autorisées :
/// impossible d'avoir un rôle "profesor" mal orthographié.
enum UserRole { student, teacher, admin }

/// Un utilisateur (étudiant, enseignant ou administrateur).
class User {
  /// Identifiant unique (ex. "u1").
  final String id;

  /// Nom complet affiché.
  final String fullName;

  /// Adresse e-mail (sert d'identifiant de connexion).
  final String email;

  /// Rôle de l'utilisateur (valeur de l'enum UserRole).
  final UserRole role;

  /// Liste des identifiants de cours suivis (références vers Course.id).
  /// "final" empêche de réaffecter la liste, mais pas de la modifier :
  /// c'est pourquoi on la rend non modifiable dans le constructeur.
  final List<String> courseIds;

  /// Constructeur. Il n'est pas "const" car on appelle List.unmodifiable
  /// (un appel de fonction n'est pas autorisé dans un constructeur const).
  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.role = UserRole.student, // par défaut : étudiant
    List<String> courseIds = const [], // par défaut : aucun cours
  }) : courseIds = List.unmodifiable(courseIds);
  // ↑ "liste d'initialisation" (après les ":") : exécutée avant le corps
  //   du constructeur. On y copie la liste dans une version non modifiable
  //   → user.courseIds.add('x') lèvera une UnsupportedError.

  /// Copie modifiée de l'utilisateur.
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    UserRole? role,
    List<String>? courseIds,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      courseIds: courseIds ?? this.courseIds,
    );
  }

  /// Construit un User depuis une Map JSON ; FormatException si invalide.
  factory User.fromJson(Map<String, dynamic> json) {
    // Champs texte obligatoires.
    if (json['id'] is! String ||
        json['fullName'] is! String ||
        json['email'] is! String) {
      throw FormatException('JSON User invalide : $json');
    }
    // Validation minimale de l'e-mail : il doit contenir un "@".
    if (!(json['email'] as String).contains('@')) {
      throw FormatException('email invalide : ${json['email']}');
    }

    // Le rôle arrive en texte ("teacher") ; on le convertit en UserRole.
    // Si absent → "student". UserRole.values = [student, teacher, admin].
    final roleName = json['role'] as String? ?? 'student';
    // firstWhere cherche le premier rôle dont le nom (.name) correspond ;
    // orElse est appelé si aucun ne correspond → on lève une erreur claire.
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => throw FormatException('role inconnu : $roleName'),
    );

    // courseIds est une liste JSON (List<dynamic>) ; on la convertit
    // en List<String>. "?? []" si le champ est absent.
    final rawIds = json['courseIds'] as List<dynamic>? ?? [];
    // .cast<String>() vérifie que chaque élément est bien un String.
    final courseIds = rawIds.cast<String>().toList();

    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: role,
      courseIds: courseIds,
    );
  }

  /// Sérialisation : l'enum est stocké sous forme de texte (role.name).
  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role.name, // UserRole.teacher → "teacher"
        'courseIds': courseIds,
      };

  /// Égalité par valeur. Attention : deux listes ne sont pas égales avec ==
  /// en Dart (comparaison d'instances), on compare donc élément par élément.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // même instance
    if (other is! User) return false; // pas un User
    if (other.courseIds.length != courseIds.length) return false; // tailles différentes
    for (var i = 0; i < courseIds.length; i++) {
      if (other.courseIds[i] != courseIds[i]) return false; // un élément diffère
    }
    // Enfin on compare les champs simples.
    return other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.role == role;
  }

  /// Object.hashAll calcule un hash à partir de tous les éléments de la liste.
  @override
  int get hashCode =>
      Object.hash(id, fullName, email, role, Object.hashAll(courseIds));

  @override
  String toString() =>
      'User(id: $id, fullName: $fullName, email: $email, role: ${role.name}, courseIds: $courseIds)';
}
