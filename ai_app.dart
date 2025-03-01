import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AiApp extends StatefulWidget {
  const AiApp({super.key});

  @override
  State<AiApp> createState() => _AiAppState();
}

class _AiAppState extends State<AiApp> {
  TextEditingController controller = TextEditingController();
  bool estaCarregando = false;
  String textoGerado = "";

  Future<void> gerarConteudo() async {
    setState(() {
      estaCarregando = true;
    });
    print(controller.text);
    String prompt = (controller.text);
    String key = "AIzaSyDSKvn1049-O2NyaYZglNw5jjVwGmqPN3E";
    String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$key";

    var data = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    };
    try {
      var resposta = await Dio().post(url, data: data);
      if (resposta.statusCode == 200) {
        print(resposta.data);
        setState(() {
          textoGerado =
              resposta.data['candidates'][0]['content']['parts'][0]['text'];
        });
      }
    } catch (erro) {
      print(erro);
    } finally {
      setState(() {
        estaCarregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double larguraDaTela = MediaQuery.of(context).size.width;
    double alturaDaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/bg.png"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      estaCarregando
                          ? CircularProgressIndicator()
                          : Column(
                            children: [
                              Text("Texto gerado:"),
                               Text(textoGerado),
                            ],
                          ),
                     
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: alturaDaTela * 0.15,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: larguraDaTela * 0.65,
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: gerarConteudo,
                      child: Container(
                        height: larguraDaTela * 0.3,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
