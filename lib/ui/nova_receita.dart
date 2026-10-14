import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class NovaReceita extends StatefulWidget {
  final VoidCallback onSave;

  const NovaReceita({super.key, required this.onSave});

  @override
  State<NovaReceita> createState() => _NovaReceitaState();
}

class _NovaReceitaState extends State<NovaReceita> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final ingredientesCtrl = TextEditingController();
  final modoFazerCtrl = TextEditingController();
  final imgCtrl = TextEditingController();

  bool enviando = false;

  static const Color preto = Color(0xFF222222);
  static const Color cinza = Color(0xFFBDBDBD);

  @override
  void dispose() {
    nomeCtrl.dispose();
    ingredientesCtrl.dispose();
    modoFazerCtrl.dispose();
    imgCtrl.dispose();
    super.dispose();
  }

  bool get imagemValida {
    final url = imgCtrl.text.trim();

    if (url.isEmpty) return false;

    final uri = Uri.tryParse(url);

    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> salvarReceita() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      enviando = true;
    });

    final url = Uri.parse(Api.getEndPoint('receitas'));

    final body = {
      'nome': nomeCtrl.text.trim(),
      'tipo': 'SALGADA',
      'ingredientes': ingredientesCtrl.text.trim(),
      'modoFazer': modoFazerCtrl.text.trim(),
      'img': imgCtrl.text.trim(),
      'custoAproximado': 0.0,
    };

    try {
      final resposta = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint('URL: $url');
      debugPrint('Status: ${resposta.statusCode}');
      debugPrint('Resposta da API: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        widget.onSave();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receita cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        String mensagem = 'Não foi possível cadastrar a receita.';

        try {
          final dados = jsonDecode(resposta.body);

          if (dados is Map) {
            mensagem =
                dados['message']?.toString() ??
                dados['mensagem']?.toString() ??
                dados['error']?.toString() ??
                dados['erro']?.toString() ??
                mensagem;
          } else if (dados is String && dados.isNotEmpty) {
            mensagem = dados;
          }
        } catch (_) {
          if (resposta.body.trim().isNotEmpty) {
            mensagem = resposta.body;
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ${resposta.statusCode}: $mensagem'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A API demorou para responder. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao salvar receita: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de conexão: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          enviando = false;
        });
      }
    }
  }

  InputDecoration campo(String texto) {
    return InputDecoration(
      labelText: texto,
      labelStyle: const TextStyle(color: preto, fontSize: 12),
      floatingLabelStyle: const TextStyle(color: preto, fontSize: 12),
      hintStyle: const TextStyle(color: Color(0xFF777777), fontSize: 10),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 11),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: preto),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: preto),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: preto, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget previewImagem() {
    final url = imgCtrl.text.trim();

    if (url.isEmpty) {
      return Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          border: Border.all(color: cinza),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 36, color: cinza),
            SizedBox(height: 5),
            Text(
              'Prévia da imagem',
              style: TextStyle(color: cinza, fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (!imagemValida) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3F3),
          border: Border.all(color: Colors.red.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Informe uma URL válida (http ou https).',
          style: TextStyle(color: Colors.red, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return Container(
            height: 150,
            alignment: Alignment.center,
            color: const Color(0xFFF7F7F7),
            child: const CircularProgressIndicator(color: preto),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              border: Border.all(color: cinza),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_outlined, color: cinza, size: 30),
                SizedBox(height: 4),
                Text(
                  'Não foi possível carregar a imagem.',
                  style: TextStyle(color: cinza, fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: cinza,
        elevation: 0,
        title: const Text(
          'Receitas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: preto,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: null,
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
          child: Divider(height: 1, color: Color(0xFFDDDDDD)),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF333333), width: 1.2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Nova Receita',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: preto,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Preencha os campos para cadastrar sua receita.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF777777)),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: nomeCtrl,
                    style: const TextStyle(color: preto, fontSize: 14),
                    cursorColor: preto,
                    decoration: campo('Nome:'),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe o nome';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: ingredientesCtrl,
                    style: const TextStyle(color: preto, fontSize: 14),
                    cursorColor: preto,
                    decoration: campo('Ingredientes:'),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: 5,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe os ingredientes';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: modoFazerCtrl,
                    style: const TextStyle(color: preto, fontSize: 14),
                    cursorColor: preto,
                    decoration: campo('Modo de Preparo:'),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: 5,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe o modo de preparo';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: imgCtrl,
                    style: const TextStyle(color: preto, fontSize: 14),
                    cursorColor: preto,
                    decoration: campo('URL da imagem:')
                        .copyWith(hintText: 'https://exemplo.com/imagem.jpg'),
                    keyboardType: TextInputType.url,
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 10),

                  previewImagem(),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: enviando ? null : salvarReceita,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: cinza,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: enviando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Enviar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: cinza,
        unselectedItemColor: cinza,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
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
