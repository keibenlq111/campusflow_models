// ═════════════════════════════════════════════════════════════
// campusflow_models.dart — Point d'entrée PUBLIC du package
// (on appelle ce fichier un "barrel" ou "baril").
//
// Convention Dart : le code vit dans lib/src/ (privé) et ce fichier
// choisit ce qui est exposé. Les utilisateurs du package écrivent
// simplement :  import 'package:campusflow_models/campusflow_models.dart';
// ═════════════════════════════════════════════════════════════

// "library" (sans nom en Dart 3) : permet d'attacher la doc au package.
library;

// "export" ré-expose les classes de ces fichiers à quiconque importe ce fichier.
export 'src/models/course.dart';
export 'src/models/task.dart';
export 'src/models/user.dart';
export 'src/data/campus_repository.dart';
