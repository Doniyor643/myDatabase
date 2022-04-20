import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_database/model/post_model.dart';

class RTDBService {
  static final _database = FirebaseDatabase.instance.ref("posts");

  static Future<Stream<DatabaseEvent>> addPost(Post post) async {
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async {
    List<Post> items = [];

    Query _query = _database.ref.child("posts").orderByChild("userId").equalTo(id);
    var snapshot = await _query.once();
    var result = snapshot.snapshot.value as Iterable;

    for (var item in result) {
      items.add(Post.fromJson(Map<String, dynamic>.from(item)));
    }
    return items;
  }

}

