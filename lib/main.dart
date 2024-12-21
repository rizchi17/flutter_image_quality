import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  String? localStoragePath;
  File? file;
  Image? image;
  int quality = 100;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final Directory tempDir = await getApplicationDocumentsDirectory();
      localStoragePath = tempDir.path;
      if (File('$localStoragePath/original.jpg').existsSync()) {
        file = File('$localStoragePath/original.jpg');
      }
      setState(() {});
    });
  }

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
            (File('$localStoragePath/original.jpg').existsSync())
                ? Image.file(
                    File('$localStoragePath/original.jpg'),
                  )
                : const Icon(Icons.no_photography),
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
                if (image != null) {
                  quality = 100;
                  file = File(image.path);
                  final Uint8List data = await file!.readAsBytes();
                  await File('$localStoragePath/original${extension(image.path)}').writeAsBytes(data);
                }
              },
              child: const Text('pick image'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (file != null) {
                  late Uint8List compressedData;
                  quality -= 10;
                  final Uint8List data = file!.readAsBytesSync();
                  final img.Image? image = img.decodeImage(data);
                  if (extension(file!.path) == '.png') {
                    compressedData = img.encodePng(image!, level: 9);
                  } else if (extension(file!.path) == '.jpg') {
                    compressedData = img.encodeJpg(image!, quality: quality);
                  } else {
                    return;
                  }
                  file = await File('$localStoragePath/encode${extension(file!.path)}').writeAsBytes(compressedData);
                }
              },
              child: const Text('encode: quality down'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (file != null) {
                  quality -= 10;
                  final compressedData = await FlutterImageCompress.compressWithFile(
                    file!.absolute.path,
                    quality: quality,
                  );
                  if (compressedData != null) {
                    file = await File('$localStoragePath/flutter_image_compress${extension(file!.path)}').writeAsBytes(compressedData);
                  }
                }
              },
              child: const Text('flutter_image_compress'),
            ),
          ],
        ),
      ),
    );
  }
}
