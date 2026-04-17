import 'package:app_lojajj/class_produto.dart';
import 'package:app_lojajj/tela_cadastro.dart';
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
              NomeProduto: produtoSupabase["NomeProduto"],
              DescricaoProduto: produtoSupabase["DescricaoProduto"],
              PrecoProduto: produtoSupabase["PrecoProduto"],
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" ♨️ - Produtos")),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return Card(
            elevation: 9.0,
            child: ListTile(
              title: Text(produto.DescricaoProduto),
              subtitle: Text(
                "Preço: R\$ ${produto.PrecoProduto.toStringAsFixed(2)}",
              ),
              leading: Icon(Icons.shopping_bag),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return TelaCadastro();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
