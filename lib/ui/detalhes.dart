import 'package:flutter/material.dart';

const Color pretoDetalhes = Color(0xFF222222);
const Color cinzaDetalhes = Color(0xFFBDBDBD);
const Color fundoDetalhes = Color(0xFFF8F8F8);

class Detalhes extends StatelessWidget {
  final Map receita;

  const Detalhes({super.key, required this.receita});

  String obterTexto(List<String> campos, String padrao) {
    for (final campo in campos) {
      final valor = receita[campo];

      if (valor != null && valor.toString().trim().isNotEmpty) {
        return valor.toString().trim();
      }
    }

    return padrao;
  }

  Widget imagemReceita(String imagem) {
    if (imagem.isEmpty) {
      return _imagemIndisponivel();
    }

    final uri = Uri.tryParse(imagem);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return _imagemIndisponivel();
    }

    return Image.network(
      imagem,
      width: double.infinity,
      height: 210,
      fit: BoxFit.cover,
      headers: const {
        'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return Container(
          height: 210,
          width: double.infinity,
          color: fundoDetalhes,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: pretoDetalhes,
            strokeWidth: 2,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Erro ao carregar imagem: $imagem');
        debugPrint('Detalhes do erro: $error');

        return _imagemIndisponivel();
      },
    );
  }

  Widget _imagemIndisponivel() {
    return Container(
      height: 210,
      width: double.infinity,
      color: fundoDetalhes,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_outlined, size: 48, color: cinzaDetalhes),
          SizedBox(height: 8),
          Text(
            'Imagem indisponível',
            style: TextStyle(color: cinzaDetalhes, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget secaoTexto({
    required String titulo,
    required String texto,
    required IconData icone,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 20, color: pretoDetalhes),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: pretoDetalhes,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            texto,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = obterTexto(['nome', 'titulo'], 'Sem nome');

    final ingredientes = obterTexto([
      'ingredientes',
    ], 'Ingredientes não informados');

    final preparo = obterTexto([
      'modoPreparo',
      'modoFazer',
      'modo_preparo',
      'preparo',
    ], 'Modo de preparo não informado');

    final imagem = obterTexto([
      'urlImagem',
      'img',
      'imagem',
      'image',
      'foto',
      'url_imagem',
    ], '');

    debugPrint('Receita aberta: $nome');
    debugPrint('URL da imagem: $imagem');

    return Scaffold(
      backgroundColor: fundoDetalhes,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: pretoDetalhes,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes da receita',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEAEAEA)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imagemReceita(imagem),
            ),
            const SizedBox(height: 20),
            Text(
              nome,
              style: const TextStyle(
                color: pretoDetalhes,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 45,
              height: 3,
              decoration: BoxDecoration(
                color: pretoDetalhes,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 22),
            secaoTexto(
              titulo: 'Ingredientes',
              texto: ingredientes,
              icone: Icons.restaurant_menu,
            ),
            const SizedBox(height: 14),
            secaoTexto(
              titulo: 'Modo de preparo',
              texto: preparo,
              icone: Icons.menu_book_outlined,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: pretoDetalhes,
        unselectedItemColor: cinzaDetalhes,
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline, size: 28),
            label: 'Detalhes',
          ),
        ],
      ),
    );
  }
}
