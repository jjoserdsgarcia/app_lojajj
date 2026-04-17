import 'package:app_lojajj/class_produto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaEdicao extends StatefulWidget {
  const TelaEdicao({super.key, required this.produto});
  final Produto produto;

  @override
  State<TelaEdicao> createState() => _TelaEdicaoState();
}

class _TelaEdicaoState extends State<TelaEdicao> {
  late TextEditingController descricaoProdutoController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.produto.DescricaoProduto);
    descricaoProdutoController = TextEditingController(
      text: widget.produto.DescricaoProduto,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edição De Produtos")),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 900),
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              spacing: 20,
              children: [
                Text("Tela de Edição de Produtos"),

                TextFormField(
                  controller: descricaoProdutoController,
                  decoration: InputDecoration(
                    labelText: "Descrição do Produto",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  initialValue: widget.produto.NomeProduto,
                  decoration: InputDecoration(
                    labelText: "Nome do Produto",
                    border: OutlineInputBorder(),
                  ),
                ),

                TextFormField(
                  initialValue: widget.produto.PrecoProduto.toString(),
                  decoration: InputDecoration(
                    labelText: "Preço do Produto",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 20,
        children: [
          FloatingActionButton(
            heroTag: "btnSalvar",
            onPressed: () {
              final supabase = Supabase.instance.client;
              supabase
                  .from("produtos")
                  .update({"DescricaoProduto": descricaoProdutoController.text})
                  .eq("id", widget.produto.id!);
            },
            child: Icon(Icons.save),
          ),
          FloatingActionButton(
            heroTag: "btnExcluir",
            onPressed: () {
              final supabase = Supabase.instance.client;
              supabase.from("produtos").delete().eq("id", widget.produto.id!);
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
