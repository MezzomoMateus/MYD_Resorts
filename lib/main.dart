import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResortsScreen(),
    );
  }
}

class ResortsScreen extends StatelessWidget {
  const ResortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderSection(),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  ResortCard(
                    imageUrl: 'assets/ic_rs1.png',
                    name: 'Resort Lagoas',
                    location: 'Lisboa, PORT',
                    price: r'$ 500,00 P/dia',
                    rating: 5,
                  ),
                  ResortCard(
                    imageUrl: 'assets/ic_rs2.png',
                    name: 'Resort Olimpo',
                    location: 'Florida, EUA',
                    price: r'$ 835,00 P/dia',
                    rating: 4,
                  ),
                  ResortCard(
                    imageUrl: 'assets/ic_rs3.png',
                    name: 'Hotel Caballero',
                    location: 'Madrid, ESP',
                    price: r'$ 780,00 P/dia',
                    rating: 4,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Ação do botão "CADASTRAR"
              },
              child: const Text(
                'CADASTRAR NOVO RESORT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Image.asset(
            'assets/ic_logo.png',
            height: 164,
          ),
          const SizedBox(height: 10),
          const Text(
            'RESORTS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
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

  const ResortCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
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
          trailing: const Icon(Icons.check_box_outline_blank),
        ),
      ),
    );
  }
}
