import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Helper.dart';
import 'User.dart';
import 'Utils.dart';
import 'Utility.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xffe31f00),
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  title: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )))),
      home: MyHomePage(title: 'Watched Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool flag = false;
  bool insertItem = false;
  final teNameController = TextEditingController();
  final tePhotoController = TextEditingController();
  final teDirectorController = TextEditingController();
  List<User> items = new List();
  List<User> values;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  ScrollController _scrollController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcdcdcd),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getAllUser(),
      floatingActionButton: _buildFab(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    print("INIT");
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  Widget _buildFab() {
    bool visibilityFlag = true;
    double max;
    double currentScroll;

    if (_scrollController.hasClients) {
      //visibilityFlag = true;

      max = _scrollController.position.maxScrollExtent;
      double min = _scrollController.position.minScrollExtent;
      currentScroll = _scrollController.position.pixels;

      if ((min == currentScroll) &&
          (_scrollController.position.userScrollDirection ==
              ScrollDirection.idle)) {
        visibilityFlag = true;
      } else if (max == currentScroll) {
        visibilityFlag = false;
      }
    }

    return new Visibility(
      visible: visibilityFlag,
      child: new FloatingActionButton(
        onPressed: () => openAlertBox(null),
        tooltip: 'Increment',
        backgroundColor: Color(0xffe31f00),
        child: Icon(Icons.add),
      ),
    );
  }

  ///edit User
  editUser(int id) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var user = User();
      user.id = id;
      user.movie = teNameController.text;
      user.photo = tePhotoController.text;
      user.director = teDirectorController.text;
      var dbHelper = Helper();
      dbHelper.update(user).then((update) {
        teNameController.text = "";
        tePhotoController.text = "";
        teDirectorController.text = "";
        Navigator.of(context).pop();
        showtoast("Data Saved successfully");
        setState(() {
          flag = false;
        });
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  ///add User Method
  addUser() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var user = User();
      user.movie = teNameController.text;
      user.photo = tePhotoController.text;
      user.director = teDirectorController.text;
      var dbHelper = Helper();
      dbHelper.insert(user).then((value) {
        teNameController.text = "";
        tePhotoController.text = "";
        teDirectorController.text = "";
        Navigator.of(context).pop();
        showtoast("Successfully Added Data");
        setState(() {
          insertItem = true;
        });
      });
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /// openAlertBox to add/edit user
  openAlertBox(User user) {
    if (user != null) {
      teNameController.text = user.movie;
      tePhotoController.text = user.photo;
      teDirectorController.text = user.director;
      flag = true;
    } else {
      flag = false;
      teNameController.text = "";
      tePhotoController.text = "";
      teDirectorController.text = "";
    }




    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        flag ? "Edit Details" : "Add Movie",
                        style: TextStyle(fontSize: 28.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                        children: <Widget>[
                          Text("Poster: ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_photo_alternate),
                            color: Colors.lightBlueAccent,
                            onPressed: () {
                              ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile){
                                  String imgString = Utility.base64String(imgFile.readAsBytesSync());
                                  tePhotoController.text = imgString;
                              });
                            },
                          ),
                          TextFormField(
                            controller: teNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Movie Name",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            onSaved: (String val) {
                              teNameController.text = val;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: teDirectorController,
                            decoration: InputDecoration(
                              hintText: "Director's Name",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                            onSaved: (String val) {
                              teDirectorController.text = val;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => flag ? editUser(user.id) : addUser(),
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color(0xffe31f00),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)),
                      ),
                      child: Text(
                        flag ? "Save" : "Add",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  /// Get all users data
  getAllUser() {
    return FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return createListView(context, snapshot);
        });
  }

  ///Fetch data from database
  Future<List<User>> _getData() async {
    var dbHelper = Helper();
    await dbHelper.getAllUsers().then((value) {
      items = value;
      if (insertItem) {
        _listKey.currentState.insertItem(values.length);
        insertItem = false;
      }
    });

    return items;
  }

  ///create List View with Animation
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    values = snapshot.data;
    if (values != null) {
      showProgress();
      return new AnimatedList(
          key: _listKey,
          controller: _scrollController,
          shrinkWrap: true,
          initialItemCount: values.length,
          itemBuilder: (BuildContext context, int index, animation) {
            return _buildItem(values[index], animation, index);
          });
    } else
      return Container();
  }

  ///Construct cell for List View
  Widget _buildItem(User values, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        color: Color(0xffeeeeee),
        child: ListTile(
          onTap: () => onItemClick(values),
          title: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
              Column(
                children: <Widget>[
                  Container(
                    height: 110,
                    width: 90,
                    child: Utility.imageFromBase64String(values.photo)
                    ),
                ],
              ),
              Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0)),
                  new Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      new InkWell(
                        child: Container(
                          constraints: new BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 200),
                          child: Text(
                            values.movie,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0)),
                  new Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      new InkWell(
                          child: new Text(
                            "Director: ",
                            style:
                            TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      new InkWell(
                        child: Container(
                          constraints: new BoxConstraints(
                              maxWidth:
                              MediaQuery.of(context).size.width - 200),
                          child: new Text(
                            values.director.toString(),
                            style:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0)),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: <Widget>[
              Flexible(
                flex: 5,
                fit: FlexFit.loose,
                child: IconButton(
                    color: Colors.black,
                    icon: new Icon(Icons.edit),
                    iconSize: 28,
                    onPressed: () => onEdit(values, index)),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: IconButton(
                    color: Colors.black,
                    icon: new Icon(Icons.delete),
                    iconSize: 28,
                    onPressed: () => onDelete(values, index)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///On Item Click
  onItemClick(User values) {
    print("Clicked position is ${values.movie}");
  }

  /// Delete Click and delete item
  onDelete(User values, int index) {
    var id = values.id;
    var dbHelper = Helper();
    dbHelper.delete(id).then((value) {
      User removedItem = items.removeAt(index);

      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return _buildItem(removedItem, animation, index);
      };
      _listKey.currentState.removeItem(index, builder);
    });
  }

  /// Edit Click
  onEdit(User user, int index) {
    openAlertBox(user);
  }
}
