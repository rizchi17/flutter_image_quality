import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Image Quality'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            imagePath != null ? Image.file(File(imagePath!)) : const Icon(Icons.no_photography),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    imagePath = image.path;
                  });
                }
              },
              child: const Text('pick image'),
            ),
          ],
        ),
      ),
    );
  }
}
