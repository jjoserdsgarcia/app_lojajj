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
  late TextEditingController nomeProdutoController;
  late TextEditingController precoProdutoController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.produto.descricaoProduto);
    descricaoProdutoController = TextEditingController(
      text: widget.produto.descricaoProduto,
    );
    nomeProdutoController = TextEditingController(
      text: widget.produto.nomeProduto,
    );
    precoProdutoController = TextEditingController(
      text: widget.produto.precoProduto.toString(),
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
                  controller: nomeProdutoController,
                  decoration: InputDecoration(
                    labelText: "Nome do Produto",
                    border: OutlineInputBorder(),
                  ),
                ),

                TextFormField(
                  controller: precoProdutoController,
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
            onPressed: () async {
              final supabase = Supabase.instance.client;
              await supabase
                  .from("produtos")
                  .update({
                    "DescricaoProduto": descricaoProdutoController.text,
                    "NomeProduto": nomeProdutoController.text,
                    "PrecoProduto": double.parse(precoProdutoController.text),
                  })
                  .eq("id", widget.produto.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Produto atualizado com sucesso!")),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erro ao atualizar o produto!")),
                );
              }
            },
            child: Icon(Icons.save),
          ),
          FloatingActionButton(
            heroTag: "btnExcluir",
            onPressed: () async {
              final supabase = Supabase.instance.client;
              await supabase
                  .from("produtos")
                  .delete()
                  .eq("id", widget.produto.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Produto excluído com sucesso!")),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erro ao excluir o produto!")),
                );
              }
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
