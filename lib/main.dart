import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manipular arquivos de imagem
import 'package:path/path.dart' as p; // Para manipular caminhos de arquivo
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // Para formatação de moeda
import 'package:flutter_masked_text2/flutter_masked_text2.dart'; // Para máscaras de entrada

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseHelper.instance.database;
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialScreen(database: database),
      routes: {
        '/resorts': (context) => ResortsScreen(database: database),
        '/cadastro': (context) => CadastroScreen(database: database),
        '/confirmacao': (context) => const ConfirmacaoScreen(),
      },
    );
  }
}

class InitialScreen extends StatelessWidget {
  final Database database;

  const InitialScreen({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BEM VINDO AO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/ic_logo.png', height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/resorts');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'ENTRAR',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResortsScreen extends StatefulWidget {
  final Database database;

  const ResortsScreen({super.key, required this.database});

  @override
  _ResortsScreenState createState() => _ResortsScreenState();
}

class _ResortsScreenState extends State<ResortsScreen> {
  List<Map<String, dynamic>> resorts = [];

  @override
  void initState() {
    super.initState();
    _carregarResorts();
  }

  Future<void> _carregarResorts() async {
    final resortsCarregados = await DatabaseHelper.instance.getResorts();
    setState(() {
      resorts = resortsCarregados;
    });
  }

  void _adicionarResort(Map<String, dynamic> novoResort) async {
    await DatabaseHelper.instance.insertResort(novoResort);
    _carregarResorts();
  }

  void _editarResort(int index, Map<String, dynamic> resortAtualizado) async {
    final id = resorts[index]['id'];
    await DatabaseHelper.instance.updateResort(id, resortAtualizado);
    _carregarResorts();
  }

  void _excluirResort(int index) async {
    final id = resorts[index]['id'];
    await DatabaseHelper.instance.deleteResort(id);
    _carregarResorts();
  }

  void _editarResortTelaCheia(int index) {
    final resort = resorts[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(database: widget.database, resort: resort),
      ),
    ).then((updatedResort) {
      if (updatedResort != null) {
        _editarResort(index, updatedResort);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Resorts'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: resorts.length,
        itemBuilder: (context, index) {
          final resort = resorts[index];
          return ResortCard(
            imageUrl: resort['imagem'],
            name: resort['nome'],
            location: resort['localizacao'],
            price: resort['preco'],
            rating: resort['estrelas'],
            onDelete: () => _excluirResort(index),
            onEdit: () => _editarResortTelaCheia(index), // Adicionado o método de edição
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoResort = await Navigator.pushNamed(context, '/cadastro');
          if (novoResort != null) {
            _adicionarResort(novoResort as Map<String, dynamic>);
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ResortCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String price;
  final int rating;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ResortCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: imageUrl.isNotEmpty
            ? Image.file(File(imageUrl), width: 80, height: 80, fit: BoxFit.cover)
            : Container(
                width: 80,
                height: 80,
                color: Colors.grey,
                child: const Icon(Icons.image, color: Colors.white),
              ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(location),
            const SizedBox(height: 5),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  final Database database;
  final Map<String, dynamic>? resort;

  const CadastroScreen({super.key, required this.database, this.resort});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _precoController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final _estrelasController = TextEditingController();
  File? _imagem;

  @override
  void initState() {
    super.initState();
    if (widget.resort != null) {
      _nomeController.text = widget.resort!['nome'];
      _localizacaoController.text = widget.resort!['localizacao'];
      _precoController.text = widget.resort!['preco'].replaceAll('R\$ ', ''); // Remove o símbolo da moeda
      _estrelasController.text = widget.resort!['estrelas'].toString();
      _imagem = File(widget.resort!['imagem']);
    }
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final imagemSelecionada = await picker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada != null) {
      setState(() {
        _imagem = File(imagemSelecionada.path);
      });
    }
  }

  void _salvar() {
    if (_nomeController.text.isEmpty ||
        _localizacaoController.text.isEmpty ||
        _precoController.text.isEmpty ||
        _estrelasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos são obrigatórios.')),
      );
      return;
    }

    final novoResort = {
      'nome': _nomeController.text,
      'localizacao': _localizacaoController.text,
      'preco': _precoController.text,
      'estrelas': int.tryParse(_estrelasController.text) ?? 0,
      'imagem': _imagem?.path ?? '',
    };

    Navigator.pop(context, novoResort);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Resort'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Resort'),
            ),
            TextField(
              controller: _localizacaoController,
              decoration: const InputDecoration(labelText: 'Localização'),
            ),
            TextField(
              controller: _precoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preço'),
            ),
            TextField(
              controller: _estrelasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de Estrelas'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selecionarImagem,
              child: const Text('Selecionar Imagem'),
            ),
            const SizedBox(height: 10),
            if (_imagem != null)
              Image.file(_imagem!, width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmacaoScreen extends StatelessWidget {
  const ConfirmacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'Operação realizada com sucesso!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'resorts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE resorts(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, localizacao TEXT, preco TEXT, estrelas INTEGER, imagem TEXT)',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getResorts() async {
    final db = await database;
    return await db.query('resorts');
  }

  Future<int> insertResort(Map<String, dynamic> resort) async {
    final db = await database;
    return await db.insert('resorts', resort);
  }

  Future<int> updateResort(int id, Map<String, dynamic> resort) async {
    final db = await database;
    return await db.update('resorts', resort, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteResort(int id) async {
    final db = await database;
    return await db.delete('resorts', where: 'id = ?', whereArgs: [id]);
  }
}
