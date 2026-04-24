import 'package:app_lojajj/tela_cadastro_usuario.dart';
import 'package:app_lojajj/tela_produtos.dart';
import 'package:app_lojajj/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  var obscureText = true;
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      // )
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nome de usuário",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Senha",
                    // suffixIcon: obscureText == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: obscureText == true
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório!";
                    }
                    return null;
                  },
                  obscureText: obscureText,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (formKey.currentState!.validate()) {
                      final supabase = Supabase.instance.client;
                      final usuarios = await supabase
                          .from("usuario") //
                          .select()
                          .eq("nomeusuario", nameController.text)
                          .eq(
                            "senhausuario",
                            Utils.gerarMd5(passwordController.text),
                          );
                      if (usuarios.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Credenciais inválidas"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Usuário autenticado com sucesso"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (usuarios.first["tipousuario"] == "Funcionário") {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return TelaProdutos();
                              },
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return TelaProdutos();
                              },
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.blueGrey)
                      : Text("Entrar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return TelaCadastroUsuario();
                        },
                      ),
                    );
                  },
                  child: Text("Cadastre-se"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
