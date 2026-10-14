import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detalhes.dart';
import 'nova_receita.dart';
import '../api.dart';

const Color preto = Color(0xFF222222);
const Color cinza = Color(0xFFBDBDBD);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List receitas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarReceitas();
  }

  Future<void> carregarReceitas() async {
    try {
      final url = Uri.parse(Api.getEndPoint('receitas'));
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (mounted) {
          setState(() {
            receitas = dados is List ? dados : [];
            carregando = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => carregando = false);
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar receitas: $e');

      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  void abrirDetalhes(Map receita) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Detalhes(receita: receita)),
    );
  }

  Future<void> abrirNovaReceita() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NovaReceita(onSave: carregarReceitas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: preto,
        elevation: 0,
        title: const Text(
          'Receitas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: abrirNovaReceita,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(color: cinza),
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: preto),
        ),
      ),

      body: carregando
          ? const Center(child: CircularProgressIndicator(color: preto))
          : receitas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma receita cadastrada.',
                style: TextStyle(color: cinza),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                final receita = Map<String, dynamic>.from(
                  receitas[index] as Map,
                );

                final nome = receita['nome']?.toString() ?? 'Sem nome';

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => abrirDetalhes(receita),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: preto, width: 1.2),
                      ),
                      child: Text(
                        nome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: preto, fontSize: 12),
                      ),
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: preto,
        unselectedItemColor: cinza,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Abra uma receita para ver os detalhes.'),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline, size: 32),
            label: 'Detalhes',
          ),
        ],
      ),
    );
  }
}
