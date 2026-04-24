import 'package:app_lojajj/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaCadastroUsuario extends StatefulWidget {
  const TelaCadastroUsuario({super.key});

  @override
  State<TelaCadastroUsuario> createState() => _TelaCadastroUsuarioState();
}

class _TelaCadastroUsuarioState extends State<TelaCadastroUsuario> {
  var obscureText = true;
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var userType = "Cliente";

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório!';
    }

    // Regex para validação
    final regex = RegExp(
      r'^(?=.*[a-z])' // pelo menos 1 letra minúscula
      r'(?=.*[A-Z])' // pelo menos 1 letra maiúscula
      r'(?=.*\d)' // pelo menos 1 número
      r'(?=.*[@$!%*?&\-_#])' // pelo menos 1 caractere especial
      r'[A-Za-z\d@$!%*?&\-_#]{12,}$', // mínimo de 12 caracteres
    );

    if (!regex.hasMatch(value)) {
      return 'A senha deve ter no mínimo 12 caracteres, incluindo maiúsculas, minúsculas, números e caracteres especiais';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastro de usuário",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 500, maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome completo",
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: obscureText == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    obscureText: obscureText,
                    validator: passwordValidator,

                    // obscuringCharacter: "#",
                  ),
                  RadioGroup(
                    groupValue: userType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          userType = value;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio.adaptive(
                              value: "Cliente",
                              activeColor: Colors.blue,
                            ),
                            Text("Cliente"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio.adaptive(
                              value: "Funcionário",
                              activeColor: Colors.blue,
                            ),
                            Text("Funcionário"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          final supabase = Supabase.instance.client;
                          await supabase.from('usuario').insert({
                            'nomeusuario': nameController.text,

                            'senhausuario': Utils.gerarMd5(
                              passwordController.text,
                            ),
                            'tipousuario': userType,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Cadastro realizado com sucesso!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        } on PostgrestException catch (e) {
                          print(e);
                          if (e.code != null && e.code == "23505") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login já está em uso"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Falha ao realizar cadastro"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text("Cadastrar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
