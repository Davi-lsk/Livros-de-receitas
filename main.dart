import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'adicionar_receita.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Receitas',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class ListaReceitas extends StatefulWidget {
  @override
  _ListaReceitasState createState() => _ListaReceitasState();
}

class _ListaReceitasState extends State<ListaReceitas> {
  List<Map<String, dynamic>> receitas = [];

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  void _carregarReceitas() async {
    final snapshot = await FirebaseFirestore.instance.collection('receitas').get();

    List<Map<String, dynamic>> tempReceitas = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>; 

      final nomeReceita = data['nome'] as String;
      final ingredientesLista = List<String>.from(data['ingredientes']); 

      tempReceitas.add({
        'id': doc.id,
        'nome': nomeReceita,
        'ingredientes': ingredientesLista,
      });
    }

    setState(() {
      receitas = tempReceitas;
    });
  }

  void _adicionarNovaReceita(Map<String, dynamic> novaReceita) async {
    await FirebaseFirestore.instance.collection('receitas').add(novaReceita);
    _carregarReceitas();
  }

  void _removerReceita(String id) async {
    await FirebaseFirestore.instance.collection('receitas').doc(id).delete();
    _carregarReceitas();
  }

  void _irParaAdicionarReceita() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdicionarReceita()),
    );

    
    if (resultado != null) {
      _adicionarNovaReceita(resultado as Map<String, dynamic>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Receitas'),
        backgroundColor: const Color(0xC587D2E3),
      ),
      body: receitas.isEmpty
          ? Center(child: Text('Nenhuma receita adicionada'))
          : ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                final receita = receitas[index];
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          receita['nome'], 
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerReceita(receita['id']),
                      ),
                    ],
                  ),
                  children: (receita['ingredientes'] as List<String>) 
                      .map((ingrediente) => ListTile(title: Text(ingrediente)))
                      .toList(),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irParaAdicionarReceita,
        child: Icon(
          Icons.add,
          color: const Color(0xC587D2E3),
        ),
        tooltip: 'Adicionar Receita',
        backgroundColor: const Color(0xC53D86A7),
      ),
    );
  }
}