import 'package:my_database/model/post_model.dart';
import 'package:my_database/pages/detail_page.dart';
import 'package:my_database/services/auth_service.dart';
import 'package:my_database/services/prefs_service.dart';
import 'package:my_database/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

 Future _openDetail() async{
    //Navigator.pushNamed(context, DetailPage.id);
    Map results = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context){
          return const DetailPage();
        }
    ));
    if(results.containsKey("data")){
      print(results['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async{
    setState(() {
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
      _respPosts(posts),
    });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      isLoading = false;
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Posts"),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: const Icon(Icons.exit_to_app,color: Colors.white,),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i){
              return itemOfList(items[i]);
            },
          ),
          // isLoading?
          // const Center(
          //   child: CircularProgressIndicator(),
          // ): const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget itemOfList(Post post){
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const SizedBox(width: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title,style: const TextStyle(color: Colors.black,fontSize: 20),),
              const SizedBox(height: 10,),
              Text(post.content,style: const TextStyle(color: Colors.black,fontSize: 16),),
            ],
          ),
        ],
      ),
    );
  }
}
