// ═════════════════════════════════════════════════════════════
// test/models_test.dart — Étape 4 : les tests unitaires.
// Lancer avec :  dart test
// Les 3 tests demandés : copyWith, fromJson, erreur attendue.
// (+ un bonus sur le dépôt simulé.)
// ═════════════════════════════════════════════════════════════

// Le framework de test (fonctions test, group, expect, matchers...).
import 'package:test/test.dart';

// Le code à tester.
import 'package:campusflow_models/campusflow_models.dart';

void main() {
  // Une tâche de référence réutilisée par plusieurs tests.
  // "final" (et non const) car DateTime(...) n'est pas constant.
  final task = Task(
    id: 't1',
    title: 'TP Dart',
    courseId: 'c1',
    dueDate: DateTime(2026, 11, 2, 8),
  );

  // group regroupe des tests liés ; le nom s'affiche dans le rapport.
  group('Modèles CampusFlow', () {
    // ── Test 1 : copyWith ─────────────────────────────────
    test('copyWith modifie seulement le champ demandé', () {
      // Act : on crée une copie avec isDone = true.
      final updated = task.copyWith(isDone: true);

      // Assert : expect(valeurRéelle, valeurAttendue).
      expect(updated.isDone, isTrue); // le champ a changé
      expect(updated.title, task.title); // les autres sont identiques
      expect(updated.id, task.id);
      expect(task.isDone, isFalse); // l'original est intact (immuable)
    });

    // ── Test 2 : fromJson ─────────────────────────────────
    test('fromJson construit une Task correcte', () {
      // Arrange : une Map qui ressemble à du JSON décodé.
      final json = {
        'id': 't1',
        'title': 'TP Dart',
        'courseId': 'c1',
        'dueDate': '2026-11-02T08:00:00',
      };

      // Act
      final parsed = Task.fromJson(json);

      // Assert : grâce à l'opérateur == redéfini, on compare les valeurs.
      expect(parsed, equals(task));
      // isDone absent du JSON → valeur par défaut false.
      expect(parsed.isDone, isFalse);
    });

    // ── Test 3 : erreur attendue ──────────────────────────
    test('fromJson lève FormatException si un champ manque', () {
      // JSON incomplet : pas de "title" ni de "dueDate".
      final badJson = {'id': 't1', 'courseId': 'c1'};

      // On passe une FONCTION (() => ...) à expect, pas le résultat :
      // ainsi expect peut l'exécuter et capturer l'exception.
      // throwsFormatException vérifie le type de l'erreur levée.
      expect(() => Task.fromJson(badJson), throwsFormatException);
    });
  });

  // ── Bonus : le dépôt simulé avec Future.delayed ─────────
  group('CampusRepository', () {
    // Latence nulle pour que les tests restent rapides.
    const repo = CampusRepository(latency: Duration.zero);

    // Un test peut être async : dart test attend la fin du Future.
    test('fetchCourses renvoie 2 cours', () async {
      final courses = await repo.fetchCourses();
      expect(courses, hasLength(2));
      expect(courses.first.name, 'Développement mobile');
    });

    test('fetchBrokenTask échoue avec FormatException', () {
      // throwsA(isA<...>()) fonctionne aussi pour un Future qui échoue.
      expect(repo.fetchBrokenTask(), throwsA(isA<FormatException>()));
    });
  });
}
