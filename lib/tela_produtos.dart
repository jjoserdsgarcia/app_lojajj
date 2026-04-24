import 'package:app_lojajj/class_produto.dart';
import 'package:app_lojajj/tela_cadastro.dart';
import 'package:app_lojajj/tela_edicao.dart';
import 'package:app_lojajj/tela_login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  List<Produto> produtos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarProdutos();
  }

  void consultarProdutos() async {
    final supabase = Supabase.instance.client;
    final produtoSupabase = await supabase.from("produtos").select();
    setState(() {
      produtos = produtoSupabase
          .map(
            (produtoSupabase) => Produto(
              id: produtoSupabase["id"],
              nomeProduto: produtoSupabase["NomeProduto"],
              descricaoProduto: produtoSupabase["DescricaoProduto"],
              precoProduto: produtoSupabase["PrecoProduto"],
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ♨️ - Produtos"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text("Menu"),
            ),
            ListTile(
              title: Text("Produtos"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Sair"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return TelaLogin();
                    },
                  ),
                );

                Supabase.instance.client.auth.signOut();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) {
                              return TelaEdicao(produto: produto);
                            },
                          ),
                        )
                        .then((_) => consultarProdutos());
                  },
                  child: Card(
                    elevation: 9.0,
                    child: ListTile(
                      title: Text(produto.nomeProduto),
                      subtitle: Text(
                        "Preço: R\$ ${produto.precoProduto.toStringAsFixed(2)}",
                      ),
                      leading: Icon(Icons.shopping_bag),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return TelaCadastro();
                  },
                ),
              )
              .then((_) => consultarProdutos());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
