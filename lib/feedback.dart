import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedbackPageState();
  }
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextStyle _selectStyle = TextStyle(color: Colors.black, fontSize: 19);
  final TextStyle _unSelectStyle = TextStyle(color: Colors.grey, fontSize: 19);
  FocusNode _textFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  PageController _controller = new PageController(initialPage: 1);
  int _selectIndex = -1;
  int _currentPage = 1;
  final _troubleNames = <String>[
    "无法播放",
    "播放卡顿",
    "标签错误",
    "有bug",
    "搜索不准",
    "无法下载",
    "账号问题",
    "我想看的没有",
    "其他"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _items = _listItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        title: Text(
          "意见反馈",
          style: _selectStyle,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          _textFocusNode.unfocus();
          _emailFocusNode.unfocus();
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildSelectItems(),
              Expanded(
                  child: PageView(
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                  _controller.jumpToPage(page);
                },
                controller: _controller,
                children: <Widget>[
                  Container(
                    child: Center(child: Text("暂无内容", style: _unSelectStyle)),
                  ),
                  ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return _items[index];
                      }),
                  Container(
                    child: Center(child: Text("暂无内容", style: _unSelectStyle)),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _listItems() {
    return <Widget>[
      _questionTabs(),
      _questionDescription(),
      _uploadPicture(),
      _email(),
      _submitButton()
    ];
  }

  Widget _buildSelectItems() {
    var child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 0;
              });
              _controller.jumpToPage(0);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("常见问题",
                    style: _currentPage == 0 ? _selectStyle : _unSelectStyle),
                _currentPage == 0
                    ? Container(
                        margin: EdgeInsets.only(top: 1),
                        width: 15,
                        height: 3,
                        color: Colors.blue)
                    : Container()
              ],
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 1;
              });
              _controller.jumpToPage(1);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("立即反馈",
                    style: _currentPage == 1 ? _selectStyle : _unSelectStyle),
                _currentPage == 1
                    ? Container(
                        margin: EdgeInsets.only(top: 1),
                        width: 15,
                        height: 3,
                        color: Colors.blue)
                    : Container()
              ],
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _currentPage = 2;
              });
              _controller.jumpToPage(2);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("我的反馈",
                    style: _currentPage == 2 ? _selectStyle : _unSelectStyle),
                _currentPage == 2
                    ? Container(
                        margin: EdgeInsets.only(top: 1),
                        width: 15,
                        height: 3,
                        color: Colors.blue)
                    : Container()
              ],
            ))
      ],
    );
    return Container(
      decoration: UnderlineTabIndicator(
          borderSide: BorderSide(width: 1.0, color: Colors.grey)),
      height: 50,
      child: child,
    );
  }

  Widget _questionTabs() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleWidget("我遇到的问题（必选）"),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buttons(),
          )
        ],
      ),
    );
  }

  Widget _titleWidget(String title) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Text(title, style: _selectStyle),
    );
  }

  Widget _questionDescription() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleWidget("问题描述（必填）"),
          TextField(
            focusNode: _textFocusNode,
            decoration: InputDecoration(
                hintText: "请详细描述遇到的问题，方便我们及时为您解决。（至少填10个字符）",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide())),
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
            maxLines: 5,
            maxLength: 200,
          ),
        ],
      ),
    );
  }

  Widget _uploadPicture() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleWidget("上传照片（最多3张）"),
          GestureDetector(
            child: Container(
              child: Icon(
                Icons.photo_size_select_actual,
                size: 100,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _email() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleWidget("您的邮箱（选填）"),
          CupertinoTextField(
            placeholder: "请输入邮箱",
            focusNode: _emailFocusNode,
          ),
          Text(
            "有效改进建议，有丰厚礼物赠送哦~",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
      height: 40,
      color: Colors.blue,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Text("提交", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  List<Widget> _buttons() {
    var widgets = new List<Widget>();
    _troubleNames.forEach((name) {
      widgets.add(_selectButton(name));
    });
    return widgets;
  }

  Widget _selectButton(String name) {
    var index = _troubleNames.indexOf(name);
    return GestureDetector(
      onTap: () {
        _textFocusNode.unfocus();
        if (_troubleNames.indexOf(name) >= 0) {
          setState(() {
            _selectIndex = index;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
            color: index == _selectIndex ? Colors.deepOrange : Colors.white),
        width: (MediaQuery.of(context).size.width - 64) / 3,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
              color: index == _selectIndex ? Colors.white : Colors.black,
              fontSize: 15),
        ),
      ),
    );
  }
}
