import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  Gemini.init(apiKey: const String.fromEnvironment("geminiApi"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemini',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          cardTheme: CardTheme(color: Colors.blue.shade900)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final gemini = Gemini.instance;
  final TextEditingController inputCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Lulu Happy Coding with GEMINI!!!!")),
      body: Column(
        children: [
          Expanded(child: GeminiResponseTypeView(
            builder: (context, child, response, loading) {
              if (loading) {
                return const CircularProgressIndicator();
              } else if (response != null) {
                return Markdown(
                  data: response,
                  selectable: true,
                );
              } else {
                return const Center(child: Text('Search something!'));
              }
            },
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: inputCtrl,
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final String input = inputCtrl.text.trim();
                  if (input.isEmpty) return;
                  inputCtrl.clear();
                  gemini
                      .streamGenerateContent(input)
                      .handleError((e) {})
                      .listen((value) {});
                },
                child: const Text('send'),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/*
Connecting Flutter application to Localhost 

** ios emulator
http://localhost:SPECIFIC_PORT
 or 
http://127.0.0.1:SPECIFIC_PORT

** android emulator
http://10.0.2.2:SPECIFIC_PORT/

 */