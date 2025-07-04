import 'package:flutter/material.dart';
import 'adicionar_receita.dart'; // Tela de adicionar

void main() {
  runApp(MaterialApp(
    home: ListaReceitas(),
  ));
}

class ListaReceitas extends StatefulWidget {
  @override
  _ListaReceitasState createState() => _ListaReceitasState();
}

class _ListaReceitasState extends State<ListaReceitas> {
  // Lista de receitas: cada receita é um mapa com nome e ingredientes
  List<Map<String, dynamic>> receitas = [];

  // Adiciona uma nova receita à lista
  void _adicionarNovaReceita(Map<String, dynamic> novaReceita) {
    setState(() {
      receitas.add(novaReceita);
    });
  }

  // Abre a tela de adicionar receita e aguarda o retorno
  void _irParaAdicionarReceita() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdicionarReceita()),
    );

    if (resultado != null && resultado is Map<String, dynamic>) {
      _adicionarNovaReceita(resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Receitas'),
        backgroundColor: const Color.fromARGB(200, 127, 176, 255),
        ),
      body: receitas.isEmpty
          ? Center(child: Text('Nenhuma receita adicionada'))
          : ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                final receita = receitas[index];
                return ExpansionTile(
                  title: Text(receita['nome']),
                  children: (receita['ingredientes'] as List<String>)
                      .map((ingrediente) => ListTile(title: Text(ingrediente)))
                      .toList(),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irParaAdicionarReceita,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Receita',
        backgroundColor: const Color.fromARGB(200, 127, 176, 255),
      ),
    );
  }
}
