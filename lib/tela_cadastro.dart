import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final formkey = GlobalKey<FormState>();
  final nomeProdutoController = TextEditingController();
  final descricaoProdutoController = TextEditingController();
  final precoProdutoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro De Produtos")),
      body: Form(
        key: formkey,
        child: Column(
          spacing: 20,
          children: [
            TextFormField(
              controller: nomeProdutoController,
              decoration: InputDecoration(
                labelText: "Nome do Produto",
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: descricaoProdutoController,
              decoration: InputDecoration(
                labelText: "Descrição do Produto",
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: precoProdutoController,
              decoration: InputDecoration(
                labelText: "Preço do Produto",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, insira o preço do produto";
                }
                if (double.tryParse(value) == null) {
                  return "Por favor, insira um número válido para o preço";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  final supabase = Supabase.instance.client;
                  try {
                    await supabase.from("produtos").insert({
                      "NomeProduto": nomeProdutoController.text,
                      "DescricaoProduto": descricaoProdutoController.text,
                      "PrecoProduto": double.parse(precoProdutoController.text),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Produto cadastrado com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  } on PostgrestException catch (e) {
                    if (!mounted) return;
                    if (e.code != null && e.code == "23505") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Produto já existe!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erro ao cadastrar produto!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
