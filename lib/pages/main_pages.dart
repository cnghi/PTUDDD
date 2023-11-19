import 'package:chau_nghi/Database/SQLHelper.dart';
import 'package:chau_nghi/pages/add_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>>? dataList = [];
  bool isEmpty = true;
//Format DateTime to DD//MM/YYYY
  formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    int a = dateTime.day;
    int b = dateTime.month;
    int c = dateTime.year;
    String d = sprintf('%02d-%02d-%04d', [a, b, c]);
    return d;
  }

  // Delete a Note by ID
  Future<void> _deleteNote(id) async {
    await SQLHelper.deleteNote(id);
    _refresh();
  }

  //Delete dialog
  void showDeleteWarning(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa danh mục'),
          content: Text(
            'Bạn muốn xóa danh mục đang chọn?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                _deleteNote(id);
                _refresh();

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _refresh() async {
    final data = await SQLHelper.getAll();
    // if (data.isNotEmpty) {
    //   data!.sort((a, b) {
    //     DateTime dateA = DateTime.parse(a['dateadded']);
    //     DateTime dateB = DateTime.parse(b['dateadded']);
    //     return dateB.compareTo(dateA);
    //   });
    // }
    // ;

    setState(() {
      dataList = data;
      if (dataList!.isNotEmpty) {
        isEmpty = false;
      }
      // Sort dataList based on dateadded in descending order
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    if (dataList != null || dataList!.isNotEmpty || dataList!.length > 0) {
      isEmpty = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes App"),
          actions: [
            FloatingActionButton(
              child: Icon(Icons.plus_one_sharp),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const AddNote(
                              isUpdate: false,
                              note: null,
                            )));
              },
            )
          ],
        ),
        body: isEmpty
            ? EmptyUI()
            : SafeArea(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataList!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddNote(
                                      isUpdate: true,
                                    ),
                                settings: RouteSettings(
                                    arguments: dataList![index]['id'])));
                      },
                      onLongPress: () {
                        final deleteId = dataList![index]['id'];
                        showDeleteWarning(context, deleteId);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataList![index]['title'],
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                dataList![index]['content'],
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child:
                                  //  Text(a[index].dateadded.toString()),
                                  Text(formatDate(dataList![index]['dateadded']
                                          .toString())
                                      .toString()),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }

  Widget EmptyUI() {
    return const Center(
      child: Text("List is empty!"),
    );
  }
}
