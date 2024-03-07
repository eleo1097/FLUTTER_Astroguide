import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/post_field.dart';
import 'widgets/post_data.dart';
import 'package:astroguide_flutter/controllers/post_controller.dart';
import 'package:astroguide_flutter/pages/menu.dart';
import 'package:astroguide_flutter/controllers/authentication.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController _postController = Get.put(PostController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AstroGuide'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await _postController.getAllPosts();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostFIeld(
                  hintText: '¿Que estas pensando?',
                  controller: _textController,
                ),
                // const SizedBox(
                //   height: ,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () async {
                    await _postController.createPost(
                      content: _textController.text.trim(),
                    );
                    _textController.clear();
                    _postController.getAllPosts();
                  },
                  child: Obx(() {
                    return _postController.isLoading.value
                        ? const CircularProgressIndicator()
                        : Text('Publicar');
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text('Publicaciones'),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  print(_postController.posts);
                  return _postController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _postController.posts.value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: PostData(
                                post: _postController.posts.value[index],
                              ),
                            );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
