import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarReceita extends StatefulWidget {
  @override
  _AdicionarReceitaState createState() => _AdicionarReceitaState();
}

class _AdicionarReceitaState extends State<AdicionarReceita> {
  final TextEditingController _nomeController = TextEditingController();
  final List<TextEditingController> _ingredienteControllers = [
    TextEditingController()
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _adicionarCampoIngrediente() {
    setState(() {
      _ingredienteControllers.add(TextEditingController());
    });
  }

  Future<void> _salvarReceita() async {
    final String nome = _nomeController.text.trim();
    final List<String> ingredientes = _ingredienteControllers
        .map((c) => c.text.trim())
        .where((texto) => texto.isNotEmpty)
        .toList();

    if (nome.isNotEmpty && ingredientes.isNotEmpty) {
      try {
        await _firestore.collection('receitas').add({
          'nome': nome,
          'ingredientes': ingredientes,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receita salva com sucesso!')),
        );

        Navigator.pop(context); // volta para tela principal
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    for (var controller in _ingredienteControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Receita'),
        backgroundColor: const Color.fromARGB(200, 127, 176, 255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da Receita',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ingredientes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._ingredienteControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Ingrediente ${index + 1}',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }),
            TextButton.icon(
              onPressed: _adicionarCampoIngrediente,
              icon: Icon(Icons.add),
              label: Text('Adicionar Ingrediente'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarReceita,
              child: Text('Salvar'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
