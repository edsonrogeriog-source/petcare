import 'package:flutter/material.dart';

void main() {
  runApp(const PetCareApp());
}

class Pet {
  final String name;
  final String type;
  final String nextVisit;

  const Pet({
    required this.name,
    required this.type,
    required this.nextVisit,
  });
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PetCareHomePage(),
    );
  }
}

class PetCareHomePage extends StatefulWidget {
  const PetCareHomePage({super.key});

  @override
  State<PetCareHomePage> createState() => _PetCareHomePageState();
}

class _PetCareHomePageState extends State<PetCareHomePage> {
  final List<Pet> _pets = [
    const Pet(
      name: 'Luna',
      type: 'Cachorro',
      nextVisit: 'Vacina em 4 dias',
    ),
    const Pet(
      name: 'Mimi',
      type: 'Gato',
      nextVisit: 'Banho em 2 dias',
    ),
  ];

  Future<void> _addPet() async {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final nextVisitController = TextEditingController();

    final pet = await showDialog<Pet>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo pet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  hintText: 'Cachorro, gato...',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              TextField(
                controller: nextVisitController,
                decoration: const InputDecoration(
                  labelText: 'Próximo lembrete',
                  hintText: 'Vacina em 7 dias',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final type = typeController.text.trim();
                final nextVisit = nextVisitController.text.trim();

                if (name.isEmpty || type.isEmpty || nextVisit.isEmpty) {
                  return;
                }

                Navigator.of(context).pop(
                  Pet(name: name, type: type, nextVisit: nextVisit),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    typeController.dispose();
    nextVisitController.dispose();

    if (pet == null) {
      return;
    }

    setState(() {
      _pets.add(pet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetCare'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo ao PetCare',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize o cuidado dos seus pets com lembretes, informações de saúde e mais.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _pets.length,
                itemBuilder: (context, index) {
                  final pet = _pets[index];
                  return PetCard(
                    name: pet.name,
                    type: pet.type,
                    nextVisit: pet.nextVisit,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${pet.name} • ${pet.nextVisit}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPet,
        tooltip: 'Adicionar pet',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String name;
  final String type;
  final String nextVisit;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.name,
    required this.type,
    required this.nextVisit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.pets)),
        title: Text(name),
        subtitle: Text('$type • $nextVisit'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
