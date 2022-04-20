import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "post_images";

  static Future<String?> uploadImage(File _image) async {
    String imgName = "image_" + DateTime.now().toString();
    Reference firebaseStorageRef = _storage.child(folder).child(imgName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    var taskSnapshot = await uploadTask.whenComplete(() => null);
    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }
    return null;
  }
}