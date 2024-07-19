import 'dart:io';
import 'dart:typed_data';
import 'package:aj_image_editor/src/Enum/ImageType.dart';
import 'package:flutter/material.dart';
import 'Enum/shape_type.dart';
import 'Models/models.dart';
import 'Util/drawing_painter.dart';
import 'Util/shape.dart';
import 'Util/text_overlay.dart';
import 'Util/triangle_painter.dart';
import 'package:convert_widget_to_image/widget_to_image.dart';
import 'package:path_provider/path_provider.dart';

class ImageEditor extends StatefulWidget {
  final String imagePathOrUrl;
  final Function(String) onSave;
  final ImageType imageType;

  const ImageEditor(
      {Key? key,
      required this.imagePathOrUrl,
      required this.onSave,
      required this.imageType})
      : super(key: key);

  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditor> {
  final List<Shape> _shapes = [];
  final List<TextOverlay> _textOverlays = [];
  Color _selectedColor = Colors.red;
  double _selectedSize = 5.0;
  bool _isDrawing = false;
  final List<List<Map<String, dynamic>>> _points = [[]];
  final List<List<TextOverlay>> _textOverlayUndoList = [];
  List<Color> allMaterialColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];
  var undo = <Models>[];
  var redo = <Models>[];
  var editedText = "";
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
        actions: [
          IconButton(
              onPressed: () async {
                var byte = await WidgetToImage.asByteData(key);
                File file = await writeToFile(byte);
                widget.onSave(file.path);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: RepaintBoundary(
        key: key,
        child: Stack(
          children: [
            _buildImage(),
            _buildDrawingCanvas(),
            _buildShapes(),
            _buildTextOverlays(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () {
                _showShapePicker();
              },
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () {
                _showTextPicker();
              },
            ),
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {
                setState(() {
                  _isDrawing = !_isDrawing;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () {
                _showColorPicker();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.linear_scale,
              ),
              onPressed: () {
                _showSlider();
              },
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                _undo();
              },
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () {
                _redo();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: widget.imageType == ImageType.file
          ? Image.file(
              File(widget.imagePathOrUrl),
              fit: BoxFit.contain,
            )
          : Image.network(
              widget.imagePathOrUrl,
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildDrawingCanvas() {
    return GestureDetector(
      onTap: () {},
      onPanDown: (details) {
        setState(() {
          _points.add([]);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _points.last.add(({
            'position': details.localPosition,
            'color': _selectedColor,
            'size': _selectedSize,
          }));
        });
      },
      onPanEnd: (details) {
        setState(() {
          _isDrawing = false;
          undo.add(Models(
              type: "DrawingCanvas",
              value: Offset.infinite,
              color: _selectedColor));
        });
      },
      child: CustomPaint(
        painter: DrawingPainter(
          points: _points,
        ),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildShapes() {
    return Stack(
      children: [
        for (var shape in _shapes)
          Positioned(
            left: shape.left,
            top: shape.top,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (shape.isDraggable) {
                  setState(() {
                    shape.left += details.delta.dx;
                    shape.top += details.delta.dy;
                  });
                }
              },
              child: _buildShapeWidget(shape),
            ),
          ),
      ],
    );
  }

  Widget _buildShapeWidget(Shape shape) {
    switch (shape.type) {
      case ShapeType.rectangle:
        return _buildRectangle(shape);
      case ShapeType.circle:
        return _buildCircle(shape);
      case ShapeType.triangle:
        return _buildTriangle(shape);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextOverlays() {
    return Stack(
      children: [
        for (var overlay in _textOverlays)
          Positioned(
            left: overlay.left,
            top: overlay.top,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  overlay.left += details.delta.dx;
                  overlay.top += details.delta.dy;
                });
              },
              child: _buildTextOverlayWidget(overlay),
            ),
          ),
      ],
    );
  }

  Widget _buildTextOverlayWidget(TextOverlay overlay) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            String editedText = overlay.text;
            return AlertDialog(
              title: const Text('Edit Text Overlay'),
              content: TextField(
                onChanged: (value) {
                  editedText = value;
                },
                controller: TextEditingController(text: overlay.text),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      overlay.text = editedText;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        overlay.text,
        style: TextStyle(fontSize: 24.0, color: overlay.color),
      ),
    );
  }

  void _showShapePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.crop_square),
                title: const Text('Rectangle'),
                onTap: () {
                  _addShape(ShapeType.rectangle);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle),
                title: const Text('Circle'),
                onTap: () {
                  _addShape(ShapeType.circle);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.change_history),
                title: const Text('Triangle'),
                onTap: () {
                  _addShape(ShapeType.triangle);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Choose Color : "),
              GridView.builder(
                shrinkWrap: true,
                itemCount: allMaterialColors.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = allMaterialColors[index];
                      });
                      Navigator.pop(context); // Close dialog after selection
                    },
                    child: Container(
                      height: 10,
                      width: 10,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(12),
                      color: allMaterialColors[index],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTextPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit Text Overlay : "),
              TextField(
                onChanged: (value) {
                  editedText = value;
                },
                //controller: TextEditingController(text: overlay.text),
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() {
                    final overlay = TextOverlay(
                      left: 0.0,
                      top: 0.0,
                      text: editedText,
                      color: _selectedColor,
                    );
                    _textOverlays.add(overlay);
                    undo.add(Models(
                        value: overlay,
                        type: "TextCanvas",
                        color: _selectedColor));

                    _textOverlayUndoList.add(List.from(_textOverlays));
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSlider() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                height: 200,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Choose Size : "),
                    Slider(
                      value: _selectedSize,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() {
                          _selectedSize = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _undo() {
    if (undo.isNotEmpty) {
      switch (undo.last.type) {
        case "TextCanvas":
          if (_textOverlays.isNotEmpty) {
            setState(() {
              redo.add(Models(type: "TextCanvas", value: _textOverlays.last));
              _textOverlays.removeLast();
              //  redo.add(undo.last);
              undo.removeLast();
            });
          }
          break;
        case "DrawingCanvas":
          if (_points.isNotEmpty) {
            setState(() {
              redo.add(Models(type: "DrawingCanvas", value: _points.last));
              _points.removeLast();
              undo.removeLast();
            });
          }
          break;
        case "ShapeCanvas":
          if (_shapes.isNotEmpty) {
            setState(() {
              redo.add(Models(type: "ShapeCanvas", value: _shapes.last));
              _shapes.removeLast();

              undo.removeLast();
            });
          }
          break;
      }
    }
  }

  void _redo() {
    if (redo.isNotEmpty) {
      switch (redo.last.type) {
        case "TextCanvas":
          setState(() {
            _textOverlays.add(redo.last.value);
            undo.add(redo.last);
            redo.removeLast();
          });

          break;
        case "DrawingCanvas":
          setState(() {
            _points.add(redo.last.value);
            // _points.add(
            //     DrawModel(offset: redo.last.value, color: redo.last.color));
            undo.add(redo.last);
            redo.removeLast();
          });

          break;
        case "ShapeCanvas":
          setState(() {
            _shapes.add(redo.last.value);
            undo.add(redo.last);
            redo.removeLast();
          });

          break;
      }
    }
  }

  Widget _buildRectangle(Shape shape) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shape.isDraggable = true;
          //shape.isDraggable = !shape.isDraggable;
        });
      },
      child: Stack(
        children: [
          Container(
            width: shape.width > 0 ? shape.width : 0,
            height: shape.height > 0 ? shape.height : 0,
            decoration: BoxDecoration(
              color: shape.color,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  shape.width = (shape.width + details.delta.dx)
                      .clamp(50.0, double.infinity);
                  shape.height = (shape.height + details.delta.dy)
                      .clamp(50.0, double.infinity);
                });
                // setState(() {
                //   shape.width += details.delta.dx;
                //   shape.height += details.delta.dy;
                // });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(Shape shape) {
    return GestureDetector(
      onTap: () {
        setState(() {
          //  shape.isDraggable = !shape.isDraggable;
          shape.isDraggable = true;
        });
      },
      child: Stack(
        children: [
          Container(
            width: shape.width > 0 ? shape.width : 0,
            height: shape.height > 0 ? shape.height : 0,
            decoration: BoxDecoration(
              color: shape.color,
              border: Border.all(color: Colors.black, width: 2.0),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                // setState(() {
                //   shape.width += details.delta.dx;
                //   shape.height += details.delta.dy;
                // });
                setState(() {
                  shape.width = (shape.width + details.delta.dx)
                      .clamp(50.0, double.infinity);
                  shape.height = (shape.height + details.delta.dy)
                      .clamp(50.0, double.infinity);
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriangle(Shape shape) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shape.isDraggable = true;
          //  shape.isDraggable = !shape.isDraggable;
        });
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: TrianglePainter(selectedColor: shape.color),
            child: SizedBox(
              width: shape.width > 0 ? shape.width : 0,
              height: shape.height > 0 ? shape.height : 0,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  shape.width = (shape.width + details.delta.dx)
                      .clamp(50.0, double.infinity);
                  shape.height = (shape.height + details.delta.dy)
                      .clamp(50.0, double.infinity);
                });
              },
              child: Visibility(
                visible: shape.isDraggable ? true : false,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addShape(ShapeType type) {
    setState(() {
      final shape = Shape(
        left: 0.0,
        top: 0.0,
        type: type,
        height: 100,
        width: 100,
        isDraggable: true,
        color: _selectedColor,
      );
      undo.add(
          Models(value: shape, type: "ShapeCanvas", color: _selectedColor));
      _shapes.add(shape);
    });
  }

  writeToFile(ByteData data) async {
    final buffer = data.buffer;
    var tempDir = await getApplicationDocumentsDirectory();
    String fullPath = "${tempDir.path}/Inspections/${DateTime.now()}.png";
    return File(fullPath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
