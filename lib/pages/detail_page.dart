import 'dart:io';

import 'package:my_database/model/post_model.dart';
import 'package:my_database/services/prefs_service.dart';
import 'package:my_database/services/rtdb_service.dart';
import 'package:my_database/services/stor_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  static const String id = "detail_page";

  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading = false;
  late File _image;
  final picker = ImagePicker();

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async {
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    if(title.isEmpty || content.isEmpty)return;
    _apiAddPost(title, content);
  }



  _apiAddPost(String title, String content) async {
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id!, title, content,)).then((response) => {
          _respAddPost(),
        });
  }

  _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "Content",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _addPost,
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          isLoading? const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
