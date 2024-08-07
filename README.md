
Image Editor

Welcome to the Image Editor - your go-to tool for unleashing your creativity and enhancing your photos effortlessly!

Overview

The Image Editor is a feature-rich application designed to make photo editing a breeze. Whether you're a photography enthusiast or a casual user, our intuitive interface and powerful editing tools cater to your needs. With the ability to crop, rotate, adjust colors, and more, the Image Editor puts the power of professional photo editing in the palm of your hands.

Features

Basic Editing Tools:  fine-tune your images to perfection.
Intuitive User Interface: A user-friendly design ensures a seamless and enjoyable editing experience.
Undo/Redo Functionality: Experiment fearlessly with the ability to undo or redo any step in your editing process.

example :
provide Image file 
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


<img src="https://private-user-images.githubusercontent.com/34904782/350250623-9348a9ed-5cb7-4393-87a0-3b008283630a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjEzNjgwNzIsIm5iZiI6MTcyMTM2Nzc3MiwicGF0aCI6Ii8zNDkwNDc4Mi8zNTAyNTA2MjMtOTM0OGE5ZWQtNWNiNy00MzkzLTg3YTAtM2IwMDgyODM2MzBhLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzE5VDA1NDI1MlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWIzZjVkMTQ1M2U2N2RiYjVjODBiMjRmZDYyYzVjOTAzMjUzYmIxNjYyYmQxYzRkZTRkNTNiMmI5YjFkNGQ3ODEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.He1iodYRFpy0uzeeAXvHZgdOgsSvVPRmMhpQLjopLKI" alt="How example looks" width="300" height="540">

<img src="https://private-user-images.githubusercontent.com/34904782/350250643-49378f10-4f62-4c91-ae5b-f4be4797c952.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjEzNjgwNzIsIm5iZiI6MTcyMTM2Nzc3MiwicGF0aCI6Ii8zNDkwNDc4Mi8zNTAyNTA2NDMtNDkzNzhmMTAtNGY2Mi00YzkxLWFlNWItZjRiZTQ3OTdjOTUyLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzE5VDA1NDI1MlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWE4MDk4MmI1NGZlNDI4MzBiMzViNWNhZGUwMDQyMGM5ZWU0MDJiZTYzMzU0MTRiYTFjOTI4ZjYwYjIwMmMzMDQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.u5CrHUgsS77TEzxoE6EoZlwg80nULCYMt1fCMx8fL9M" alt="Success Status" width="300" height="540">
<img src="https://private-user-images.githubusercontent.com/34904782/350250656-22e88667-155f-4bc3-9e00-8a19e153f0f1.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjEzNjgwNzIsIm5iZiI6MTcyMTM2Nzc3MiwicGF0aCI6Ii8zNDkwNDc4Mi8zNTAyNTA2NTYtMjJlODg2NjctMTU1Zi00YmMzLTllMDAtOGExOWUxNTNmMGYxLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzE5VDA1NDI1MlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTZlMTRjYzFkMTlkODRhOGYwNjE0YmVlZDBiOTNiN2JhYTY3YzYwZWQ0YmFjZWZkMzA5MzhjNmNhMDU5MzMyM2QmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.TEtsIlQSfqspPvlxrfnmCpn4w5sQmeTVvRL5hFOSYKw" alt="Success Status" width="300" height="540">
