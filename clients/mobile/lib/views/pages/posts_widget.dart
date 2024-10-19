import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ramble_mobile/models/post_model.dart';
import '../../controllers/user_controller.dart';
import '../reusable/post_widget.dart';
import '../reusable/post_creator_widget.dart';

class PostsWidget extends StatefulWidget {
  final UserController userController;
  const PostsWidget({super.key, required this.userController });

  @override
  State<StatefulWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  late UserController _userController;
  final PagingController<int, PostModel> _pageController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _userController = widget.userController;
    _pageController.addPageRequestListener((pageKey) {
      _loadPosts(pageKey);
    });
    super.initState();
  }

  Future<void> _loadPosts(int pageKey) async {
    var newPosts = await _userController.getPosts(page: pageKey, category: "trending");
    if (newPosts.isNotEmpty) {
      _pageController.appendPage(newPosts, pageKey+1);
    } else {
      _pageController.appendLastPage([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
          child: PostCreatorWidget(prompt: "What's new?", controller: _userController,
            onPost: () async {
              _pageController.refresh();
            }
          )
        ),
        Expanded(
          child: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pageController.refresh(),
          ),
            child: PagedListView(
                pagingController: _pageController,
                builderDelegate: PagedChildBuilderDelegate<PostModel>(
                    itemBuilder: (context, item, index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: PostWidget(post: item, userController: _userController, allowViewPost: true,
                            onDelete: () {
                            _pageController.refresh();
                          },)
                      );
                    }
                )
            ),
          )
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
