# campusflow_models

Modèles de l'application CampusFlow en Dart pur (atelier 90 min, binômes).

## Étape 1 — Créer le projet et le dépôt Git (20 min)

```bash
dart create -t package campusflow_models   # crée le squelette du package
cd campusflow_models
dart pub get                                # télécharge test + lints
git init                                    # initialise le dépôt local
git add .
git commit -m "Initialisation du package campusflow_models"
# Sur GitHub : créer un dépôt vide "campusflow_models", puis :
git branch -M main
git remote add origin https://github.com/<votre-compte>/campusflow_models.git
git push -u origin main
```

Remplacez ensuite les fichiers générés par ceux de ce dossier.

## Arborescence

```
campusflow_models/
├── pubspec.yaml                  # nom, version, dépendances
├── analysis_options.yaml         # règles de dart analyze
├── lib/
│   ├── campusflow_models.dart    # fichier public (exports)
│   └── src/
│       ├── models/
│       │   ├── task.dart         # Étape 2
│       │   ├── course.dart       # Étape 2
│       │   └── user.dart         # Étape 2
│       └── data/
│           └── campus_repository.dart   # Étape 3 (Future.delayed)
├── bin/campusflow_models.dart    # démo : dart run
└── test/models_test.dart         # Étape 4 : dart test
```

## Commandes utiles

```bash
dart analyze   # vérifie le code
dart run       # lance la démo
dart test      # lance les tests (attendu : All tests passed!)
```

## Livrables de l'atelier

| Étape | Livrable | Où |
|---|---|---|
| 1 | Package créé | `pubspec.yaml`, dépôt GitHub |
| 2 | 3 classes | `lib/src/models/` |
| 3 | fromJson + dépôt simulé | `fromJson` dans chaque modèle + `campus_repository.dart` |
| 4 | 3 tests qui passent | `test/models_test.dart` |
