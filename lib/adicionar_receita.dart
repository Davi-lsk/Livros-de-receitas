import 'package:flutter/material.dart';

class AdicionarReceita extends StatefulWidget {
  @override
  _AdicionarReceitaState createState() => _AdicionarReceitaState();
}

class _AdicionarReceitaState extends State<AdicionarReceita> {
  final TextEditingController _nomeController = TextEditingController();
  final List<TextEditingController> _ingredienteControllers = [
    TextEditingController()
  ];

  void _adicionarCampoIngrediente() {
    setState(() {
      _ingredienteControllers.add(TextEditingController());
    });
  }

  void _salvarReceita() {
    final nome = _nomeController.text.trim();
    final ingredientes = _ingredienteControllers
        .map((c) => c.text.trim())
        .where((texto) => texto.isNotEmpty)
        .toList();

    if (nome.isNotEmpty && ingredientes.isNotEmpty) {
      Navigator.pop(context, {
        'nome': nome,
        'ingredientes': ingredientes,
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Receita')),
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
              child: Text('Salvar'),
              onPressed: _salvarReceita,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
            child: Text('Voltar')
            )
          ],
        ),
      ),
    );
  }
}
