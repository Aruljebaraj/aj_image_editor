
Image Editor

Welcome to the Image Editor - your go-to tool for unleashing your creativity and enhancing your photos effortlessly!

Overview

The Image Editor is a feature-rich application designed to make photo editing a breeze. Whether you're a photography enthusiast or a casual user, our intuitive interface and powerful editing tools cater to your needs. With the ability to crop, rotate, adjust colors, and more, the Image Editor puts the power of professional photo editing in the palm of your hands.

Features

Basic Editing Tools:  fine-tune your images to perfection.
Intuitive User Interface: A user-friendly design ensures a seamless and enjoyable editing experience.
Undo/Redo Functionality: Experiment fearlessly with the ability to undo or redo any step in your editing process.

# Examples

### Quick Example

```dart
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
```
