import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ramble_mobile/controllers/user_controller.dart';
import '../../models/post_model.dart';
import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';
import '../../utilities/utilities.dart';
import '../../views/reusable/button.dart';
import '../../views/reusable/ramble_icon_button.dart';
import '../pages/view_post_widget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required PostModel post,
    required UserController controller,
  })  :
        _post = post,
        _controller = controller;

  final PostModel _post;
  final UserController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: LightModeTheme().secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 46.0,
                  height: 46.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeOutDuration: const Duration(milliseconds: 500),
                    imageUrl: _post.userProfilePicture ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                    errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _post.userCommonName,
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                  '@${_post.username}',
                                style: TypographyTheme().bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ],
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: Text(
                              "42 hours ago",
                              style: TypographyTheme().bodyMedium.override(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ].divide(const SizedBox(width: 10.0)),
                      ),
                    ),
                  ),
                ),
              ].divide(const SizedBox(width: 10.0)),
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewPostWidget(post: _post, controller: _controller,)));
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 15.0, 0.0, 0.0),
                      child: Text(
                        _post.postContent,
                        maxLines: 3,
                        style: TypographyTheme().bodyMedium.override(
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 5.0, 7.0, 5.0),
                      child: Text(
                        'Read more...',
                        style: TypographyTheme().bodyMedium.override(
                              fontFamily: 'Roboto',
                              color: LightModeTheme().orangePeel,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                  if (_post.postMedia != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Image.asset("assets/profile_placeholder.jpg"),
                        errorWidget: (context, url, error) => Image.asset("assets/profile_placeholder.jpg"),
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        imageUrl: _post.postMedia!,
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      if (_post.hasLiked > 0) {
                        return ButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: formatNumber(
                            _post.likeCount,
                            formatType: FormatType.compact,
                          ),
                          icon: const Icon(
                            Icons.favorite_sharp,
                            size: 22.0,
                          ),
                          options: ButtonOptions(
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: LightModeTheme().secondaryBackground,
                            textStyle: TypographyTheme().titleSmall.override(
                                  fontFamily: 'Roboto',
                                  color: _post.hasLiked > 0
                                      ? LightModeTheme().orangePeel
                                      : LightModeTheme().primaryText,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        );
                      } else {
                        return ButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: formatNumber(
                            _post.likeCount,
                            formatType: FormatType.compact,
                          ),
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 22.0,
                          ),
                          options: ButtonOptions(
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: LightModeTheme().secondaryBackground,
                            textStyle: TypographyTheme().titleSmall.override(
                                  fontFamily: 'Roboto',
                                  color: LightModeTheme().primaryText,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        );
                      }
                    },
                  ),
                  ButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: formatNumber(
                      _post.replyCount,
                      formatType: FormatType.compact,
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.comment,
                      size: 22.0,
                    ),
                    options: ButtonOptions(
                      height: 40.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: const Color(0x00F1F4F8),
                      textStyle: TypographyTheme().titleSmall.override(
                            fontFamily: 'Roboto',
                            color: LightModeTheme().primaryText,
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  RambleIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.keyboard_control,
                      color: LightModeTheme().primaryText,
                      size: 20.0,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ].divide(const SizedBox(width: 5.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
