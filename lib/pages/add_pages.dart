import 'package:flutter/material.dart';

import '../Database/SQLHelper.dart';
import '../Model/Note.dart';

class AddNote extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNote({Key? key, required this.isUpdate, this.note})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AddState createState() => _AddState();
}

class _AddState extends State<AddNote> {
  Map<String, dynamic>? dataList2;

  final _fromKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  TextEditingController titleUpdateController = TextEditingController();
  TextEditingController contentUpdateController = TextEditingController();

  List<Map<String, dynamic>> dataList1 = [];

  String Title = "Thêm mới ghi chú";

  void _refresh() async {
    final data = await SQLHelper.getAll();
    setState(() {
      dataList1 = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    if (widget.isUpdate) {
      titleUpdateController.text = dataList2?['title'].toString() ?? "";
      contentUpdateController.text = dataList2?['content'].toString() ?? "";
      Title = "Cập nhật ghi chú";
    }
  }

  //Add a new Note
  Future<void> _addItem() async {
    await SQLHelper.createNote(titleController.text, contentController.text);
    _refresh();

    print("Add completed");
  }

  //Update an Note
  Future<void> _updateNote(id) async {
    DateTime date = DateTime.now();
    await SQLHelper.updateNote(
        id, titleUpdateController.text, contentUpdateController.text);
    _refresh();
    print("Update completed");
  }

  //Get Note by ID from Home
  Future<void> _getNote(id) async {
    final data = await SQLHelper.getNote(id);
    if (dataList2 != data) {
      setState(() {
        dataList2 = data;
        titleUpdateController.text = dataList2?['title'].toString() ?? "";
        contentUpdateController.text = dataList2?['content'].toString() ?? "";
      });
    }
  }

// Check is CapNhat mode?
  bool _CapNhat = false;

  @override
  Widget build(BuildContext context) {
    bool isUpdating = widget.isUpdate;

    int a = 0;
    // Get ID from DanhMuc_Activity
    final danhmuc = ModalRoute.of(context)!.settings.arguments;
    if (danhmuc != null) {
      isUpdating = true;
      _CapNhat = true;
      a = int.parse(danhmuc.toString());
      if (dataList2 == null) _getNote(a);
    }
    ;

    

    //Body for Them Moi
    Widget _addnewBody = ListView(
      children: [
      Form(
          key: _fromKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 13.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ !";
                    }
                    return null;
                  },
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập tiêu đề",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập tiêu đề",
                  ),
                ),
              ),
             Container(
              margin: EdgeInsets.fromLTRB(13.0, 13.0, 13.0,
                    5.0), 
              child:  TextFormField(
                maxLines: 20,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng điền đầy đủ ";
                  }
                  return null;
                },
                controller: contentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  labelText: "Nhập nội dung",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),)
            ],
          ))
    ]);

    //Body for Cap Nhat Danh Muc
    Widget _updateBody = ListView(children: [
      Form(
          key: _fromKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 13.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ!";
                    }
                    return null;
                  },
                  controller: titleUpdateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập tiêu đề",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập tiêu đề",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  maxLines: 20,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ thông tin!";
                    }
                    return null;
                  },
                  controller: contentUpdateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập nội dung",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ))
    ]);

    return Scaffold(
        appBar: AppBar(
          title: Text(Title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (widget.isUpdate) {
                  _updateNote(a);
                  _refresh();
                  Navigator.pop(context);
                } else {
                  _addItem();
                  _refresh();
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: _CapNhat ? _updateBody : _addnewBody);
  }
}
