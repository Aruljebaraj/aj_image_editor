import 'dart:developer';
import 'package:aj_image_editor/src/Enum/image_type.dart';
import 'package:aj_image_editor/src/image_editor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AjEditor(),
  ));
}

class AjEditor extends StatelessWidget {
  const AjEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageEditor(
      onSave: (path) {
        log(path);
      },
      imagePathOrUrl:
          'https://images.pexels.com/photos/1103971/pexels-photo-1103971.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      imageType: ImageType.network,
    );
  }
}
