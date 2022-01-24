import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import "package:path_provider/path_provider.dart" as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _storedImage = File(imageFile!.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera),
          label: Text('Take Picture'),
          style: TextButton.styleFrom(primary: Colors.red),
        ))
      ],
    );
  }
}
