import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selected = 0;

  final List<Map<String, dynamic>> menus = [
    {"id": 1, "titre": "Petit déjeuner", "description": "Lait, céréales et fruits", "icone": "🥣"},
    {"id": 2, "titre": "Déjeuner", "description": "Poulet, riz et légumes", "icone": "🍲"},
    {"id": 3, "titre": "Goûter", "description": "Biscuit et compote de pomme", "icone": "🍪"},
    {"id": 4, "titre": "Jus de fruits", "description": "Jus d'orange naturel", "icone": "🍊"},
    {"id": 5, "titre": "Fruits frais", "description": "Une sélection de fruits de saison", "icone": "🍎"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Garderie'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text('Ma Garderie',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
            _drawerItem(0, Icons.home, 'Accueil'),
            _drawerItem(1, Icons.restaurant_menu, 'Menus'),
            _drawerItem(2, Icons.info, 'À propos'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Menus du jour',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, i) {
                final m = menus[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Text(m['icone'], style: const TextStyle(fontSize: 32)),
                    title: Text(m['titre']),
                    subtitle: Text(m['description']),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(int index, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selected == index,
      onTap: () {
        setState(() => _selected = index);
        Navigator.pop(context);
      },
    );
  }
}
