import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manipular arquivos de imagem

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialScreen(),
      routes: {
        '/resorts': (context) => ResortsScreen(),
        '/cadastro': (context) => CadastroScreen(),
        '/confirmacao': (context) => ConfirmacaoScreen(),
      },
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
  const ResortsScreen({super.key});

  @override
  _ResortsScreenState createState() => _ResortsScreenState();
}

class _ResortsScreenState extends State<ResortsScreen> {
  List<Map<String, dynamic>> resorts = [
    {
      'nome': 'Hotel Caballero',
      'localizacao': 'Madrid, ESP',
      'preco': r'R$ 780,00 P/dia',
      'estrelas': 4,
      'imagem': 'assets/ic_rs3.png',
      'selected': false,
    },
  ];

  void _adicionarResort(Map<String, dynamic> novoResort) {
    setState(() {
      novoResort['selected'] = false;
      resorts.add(novoResort);
    });
  }

  void _editarResort(int index, Map<String, dynamic> resortAtualizado) {
    setState(() {
      resortAtualizado['selected'] = false;
      resorts[index] = resortAtualizado;
    });
  }

  void _excluirResort(int index) {
    setState(() {
      resorts.removeAt(index);
    });
  }

  void _editarResortCallback(int index) async {
    final resort = resorts[index];
    final resultado = await Navigator.pushNamed(
      context,
      '/cadastro',
      arguments: {
        'resort': resort,
        'isEdit': true,
        'index': index,
      },
    );

    if (resultado != null) {
      _editarResort(index, resultado as Map<String, dynamic>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Resorts'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final selectedResorts =
                  resorts.where((resort) => resort['selected']).toList();
              if (selectedResorts.length == 1) {
                final index = resorts.indexOf(selectedResorts[0]);
                _editarResortCallback(index);
              } else if (selectedResorts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Nenhum resort selecionado para editar')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Selecione apenas um resort para editar')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                resorts.removeWhere((resort) => resort['selected']);
              });
            },
          ),
        ],
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
            isSelected: resort['selected'],
            onSelectedChanged: (bool? value) {
              setState(() {
                resort['selected'] = value!;
              });
            },
            onDelete: () => _excluirResort(index),
            onEdit: () => _editarResortCallback(index),
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
  final bool isSelected;
  final ValueChanged<bool?> onSelectedChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ResortCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.isSelected,
    required this.onSelectedChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imageUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else if (imageUrl.isNotEmpty) {
      imageWidget = Image.file(
        File(imageUrl),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Container(
        width: 80,
        height: 80,
        color: Colors.grey,
        child: const Icon(Icons.image, color: Colors.white),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Card(
        color: Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageWidget,
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
          trailing: Checkbox(
            value: isSelected,
            onChanged: onSelectedChanged,
          ),
        ),
      ),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _estrelasController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _precoController = TextEditingController();
  File? _imagem;

  bool isEdit = false;
  int editIndex = -1;

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      isEdit = args['isEdit'] ?? false;
      if (isEdit) {
        final resort = args['resort'] as Map<String, dynamic>;
        editIndex = args['index'] ?? -1;
        _nomeController.text = resort['nome'];
        _estrelasController.text = resort['estrelas'].toString();
        _localizacaoController.text = resort['localizacao'];
        _precoController.text = resort['preco'].replaceAll('R\$ ', '');
        if (resort['imagem'].toString().startsWith('assets/')) {
          // Imagem é um asset
          _imagem = null;
        } else {
          _imagem = resort['imagem'] != null && resort['imagem'].isNotEmpty
              ? File(resort['imagem'])
              : null;
        }
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagem = File(pickedFile.path);
      });
    }
  }

  void _confirmarCadastro() {
    final novoResort = {
      'nome': _nomeController.text,
      'estrelas': int.tryParse(_estrelasController.text) ?? 0,
      'localizacao': _localizacaoController.text,
      'preco': 'R\$ ${_precoController.text}',
      'imagem': _imagem?.path ?? 'assets/ic_rs3.png',
      'selected': false,
    };

    Navigator.pop(context, novoResort);
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (_imagem != null) {
      imageWidget = Image.file(_imagem!, fit: BoxFit.cover);
    } else {
      imageWidget = const Center(child: Icon(Icons.add_a_photo));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Resort' : 'Cadastrar Resort'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Resort'),
            ),
            TextField(
              controller: _estrelasController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Quantidade de Estrelas'),
            ),
            TextField(
              controller: _localizacaoController,
              decoration: const InputDecoration(labelText: 'Localização'),
            ),
            TextField(
              controller: _precoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor do Resort'),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmarCadastro,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(isEdit ? 'Salvar Alterações' : 'Cadastrar'),
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
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Widget imageWidget;
    if (args['imagem'].toString().startsWith('assets/')) {
      imageWidget = Image.asset(args['imagem'], height: 150);
    } else if (args['imagem'] != null && args['imagem'].isNotEmpty) {
      imageWidget = Image.file(File(args['imagem']), height: 150);
    } else {
      imageWidget = Container(
        height: 150,
        color: Colors.grey,
        child: const Icon(Icons.image, color: Colors.white),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação do Resort'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            imageWidget,
            const SizedBox(height: 20),
            Text('Nome: ${args['nome']}'),
            Text('Localização: ${args['localizacao']}'),
            Text('Estrelas: ${args['estrelas']}'),
            Text('Valor: ${args['preco']}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pop(context, {'edit': true});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context, {'delete': true});
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {'confirm': true});
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
