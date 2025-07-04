import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adicionar_receita.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: ListaReceitas(),
    debugShowCheckedModeBanner: false,
  ));
}

class ListaReceitas extends StatefulWidget {
  @override
  _ListaReceitasState createState() => _ListaReceitasState();
}

class _ListaReceitasState extends State<ListaReceitas> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> receitas = [];

  @override
  void initState() {
    super.initState();
    _carregarReceitasDoFirebase();
  }

  // Carrega todas as receitas do Firestore
  Future<void> _carregarReceitasDoFirebase() async {
    final snapshot = await _firestore.collection('receitas').get();
    setState(() {
      receitas = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  // Vai para a tela de adicionar e recarrega as receitas ao voltar
  void _irParaAdicionarReceita() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdicionarReceita()),
    );
    _carregarReceitasDoFirebase(); // Recarrega após retorno
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
                  children: (receita['ingredientes'] as List<dynamic>)
                      .map((ingrediente) => ListTile(
                            title: Text(ingrediente),
                          ))
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
