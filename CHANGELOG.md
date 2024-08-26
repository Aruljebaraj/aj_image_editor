## 0.0.5

* TODO:  initial release.
* Image Editor Initial Release Notes - Version 0.0.10
  We are thrilled to announce the initial release of our Image Editor! This powerful tool allows you
  to unleash your creativity and elevate your photos with a range of editing features.
  Key Features
  Basic Editing Tools
  Intuitive User Interface
  A user-friendly interface designed for both beginners and advanced users.
  Easily navigate through tools and options for a seamless editing experience.
  Undo/Redo Functionality
  Made a mistake? No worries! The undo/redo feature lets you step back and forth through your
  editing history.

example :

void main() {
runApp(MaterialApp(home: Editor()));
}
class Editor extends StatelessWidget {
const Editor({super.key});

@override
Widget build(BuildContext context) {
return ImageEditorScreen(image:file,onSave: (val){
print(val);
});
}
}

