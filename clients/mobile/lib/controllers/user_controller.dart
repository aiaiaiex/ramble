import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ramble_mobile/models/post_model.dart';
import '../environment.dart';
import '../models/user_model.dart';

class UserController {
  UserController();

  final Map<String, String> _headers = {
    'content-type': 'application/json',
    'response-type': 'application/json'
  };

  UserModel? _user;

  UserModel get user {
    return _user ?? UserModel.named(userCommonName: "Unknown", username: "unknown", userCreatedAt: DateTime.now());
  }

  bool get loggedIn {
    return _user != null;
  }

  Future<UserModel> _getActiveUser() async {
    var uri = Uri.http(Environment.serverURL, "/account/view");
    var response = await http.post(uri, headers: _headers);
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  Future<void> login({required String usernameOrEmail, required String password}) async {
    var uri = Uri.http(Environment.serverURL, "/account/login");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "usernameOrEmail": usernameOrEmail,
      "password": password
    }));

    String? cookie = response.headers["set-cookie"];
    if (cookie != null) {
      int index = cookie.indexOf(";");
      _headers['cookie'] = (index == -1) ? cookie : cookie.substring(0, index);
      _user = await _getActiveUser();
    }
  }

  Future<void> logout() async {
    var uri = Uri.http(Environment.serverURL, "/account/login");
    var response = await http.post(uri, headers: _headers);
    if (response.statusCode == 200) {
      _headers.remove("cookie");
      _user = null;
    }
  }

  Future<UserModel> view({ String? username }) async {
    var uri = Uri.http(Environment.serverURL, "/account/view");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username ?? _user?.username,
    }));
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  Future<void> signUp({ required String username, required String email, required String password }) async {
    var uri = Uri.http(Environment.serverURL, "/account/signup");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username,
      "email": email,
      "password": password
    }));

    if (response.statusCode == 200) {
      await login(usernameOrEmail: username, password: password);
      _user = await _getActiveUser();
    }
  }

  Future<void> updateAccount({ String? userCommonName, String? biography }) async {
    var uri = Uri.http(Environment.serverURL, "/account/update");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "userCommonName": userCommonName,
      "biography": biography
    }));
    if (response.statusCode == 200) {
      _user = await _getActiveUser();
    }
  }

  Future<void> deleteAccount() async {
    var uri = Uri.http(Environment.serverURL, "/account/delete");
    var response = await http.post(uri, headers: _headers);
    if (response.statusCode == 200) {
      _user = null;
    }
  }

  Future<List<String>> _listPosts({ int page=0, String? username, String? parentId, String? category }) async {
    var uri = Uri.http(Environment.serverURL, "/post/list");
    Map<String, dynamic> unencodedBody = { "page": page };

    if (username != null) {
      unencodedBody["username"] = username;
    }

    if (parentId != null) {
      unencodedBody["parentId"] = parentId;
    }

    if (category != null) {
      unencodedBody["category"] = category;
    }

    var response = await http.post(uri, headers: _headers, body: jsonEncode(unencodedBody));
    return List<String>.from(jsonDecode(response.body)["posts"]);
  }

  Future<PostModel> viewPost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/view");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({ "postId": postId }));
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return PostModel.fromJSONAPI(body);
  }

  Future<List<PostModel>> getPosts({ int page=0, String? username, String? parentId, String? category }) async {
    var postIds = await _listPosts(page: page, username: username, parentId: parentId, category: category);
    List<PostModel> posts = [];

    for (var postId in postIds) {
      posts.add(await viewPost(postId: postId));
    }

    return posts;
  }

  Future<bool> createPost({ required String content, String? parentId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/new");
    Map<String, dynamic> unencodedBody = { "content": content };
    if (parentId != null) {
      unencodedBody["parentId"] = parentId;
    }
    var response = await http.post(uri, headers: _headers, body: jsonEncode(unencodedBody));
    return response.statusCode == 200;
  }

  Future<bool> likePost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/like");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "postId": postId
    }));
    return response.statusCode == 200;
  }

  Future<bool> dislikePost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/dislike");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "postId": postId
    }));
    return response.statusCode == 200;
  }

  Future<bool> deletePost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/delete");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "postId": postId
    }));
    return response.statusCode == 200;
  }
}