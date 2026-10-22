import 'package:flutter/material.dart';

// Classe qui représente un menu
class Menu {
  final String title, description, icon;

  // Constructeur : initialise les informations du menu
  const Menu(this.title, this.description, this.icon);
}

// Page principale de l'application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Création de l'état de la page
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0; // Index de l'élément sélectionné

  // Liste des menus affichés au démarrage
  final List<Menu> menus = [
    Menu('Petit déjeuner', 'Lait, céréales et fruits', '🥣'),
    Menu('Déjeuner', 'Poulet, riz et légumes', '🍲'),
    Menu('Goûter', 'Biscuit et compote', '🍪'),
    Menu('Jus de fruits', "Jus d'orange naturel", '🍊'),
    Menu('Fruits frais', 'Fruits de saison', '🍎'),
  ];

  // Affiche un message en bas de l'écran
  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // Ouvre le formulaire pour ajouter un menu
  Future<void> addMenu() async {
    showMessage('Ajouter un menu');
    final result = await showDialog<Menu>(
      context: context,
      builder: (_) => const AddMenuDialog(),
    );

    // Si un menu est ajouté, on actualise la liste
    if (result != null && mounted) {
      setState(() => menus.add(result));
      showMessage('Menu ajouté');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre supérieure
      appBar: AppBar(
        title: const Text('Ma Garderie'),
        actions: [
          IconButton(
            tooltip: 'Rechercher un menu',
            icon: const Icon(Icons.search),
            onPressed: () => showMessage('Rechercher un menu'),
          ),
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications),
            onPressed: () => showMessage('Aucune notification'),
          ),
        ],
      ),

      // Menu latéral de navigation
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Ma Garderie',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // Création des trois éléments de navigation
            ...['Accueil', 'Menus', 'À propos'].asMap().entries.map(
              (e) => ListTile(
                leading: Icon(
                  e.key == 0
                      ? Icons.home
                      : e.key == 1
                      ? Icons.restaurant_menu
                      : Icons.info,
                ),
                title: Text(e.value),
                selected: selected == e.key,

                // Action lors du clic
                onTap: () {
                  setState(() => selected = e.key);
                  Navigator.pop(context); // Ferme le menu

                  // Ouvre la page À propos
                  if (e.key == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutPage()),
                    );
                  } else {
                    showMessage('${e.value} sélectionné');
                  }
                },
              ),
            ),
          ],
        ),
      ),

      // Bouton flottant pour ajouter un menu
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter un menu',
        onPressed: addMenu,
        child: const Icon(Icons.add),
      ),

      // Corps principal de la page
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Menus du jour',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Affichage dynamique de la liste des menus
          Expanded(
            child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: Text(
                    menus[i].icon,
                    style: const TextStyle(fontSize: 30),
                  ),
                  title: Text(menus[i].title),
                  subtitle: Text(menus[i].description),

                  // Affiche le nom du menu sélectionné
                  onTap: () => showMessage(menus[i].title),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fenêtre de dialogue pour ajouter un menu
class AddMenuDialog extends StatefulWidget {
  const AddMenuDialog({super.key});

  @override
  State<AddMenuDialog> createState() => _AddMenuDialogState();
}

class _AddMenuDialogState extends State<AddMenuDialog> {
  // Clé permettant de valider le formulaire
  final formKey = GlobalKey<FormState>();

  // Contrôleurs des champs de saisie
  final title = TextEditingController();
  final description = TextEditingController();

  // Libère les ressources des contrôleurs
  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un menu'),

      // Formulaire avec validation
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Champ du nom du menu
            TextFormField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Nom du menu'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Champ obligatoire' : null,
            ),

            // Champ de description
            TextFormField(
              controller: description,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Champ obligatoire' : null,
            ),
          ],
        ),
      ),

      // Boutons du formulaire
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),

        FilledButton(
          onPressed: () {
            // Vérifie que les champs sont remplis
            if (formKey.currentState!.validate()) {
              // Retourne le nouveau menu à la page principale
              Navigator.pop(
                context,
                Menu(title.text.trim(), description.text.trim(), '🍽️'),
              );
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}

// Page contenant les informations de l'application
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),

      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),

          // Organisation verticale des éléments
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.child_care, size: 70, color: Colors.orange),
              SizedBox(height: 16),

              Text(
                'Ma Garderie',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12),

              Text(
                'Application de gestion des menus d’une garderie.',
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Liste des fonctionnalités
              Text(
                'Fonctionnalités',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '• Consultation des menus de la journée',
                textAlign: TextAlign.center,
              ),
              Text('Ajout de menus personnalisés'),
              Text('Navigation simple et accessible'),
              SizedBox(height: 20),
              Text('Version 1.0.0'),
            ],
          ),
        ),
      ),
    );
  }
}
