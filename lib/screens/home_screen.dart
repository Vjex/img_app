import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_app/Utils/constants.dart';
import 'package:image_app/models/image_model.dart';
import 'package:image_app/widgets/single_Image_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingMore = false;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //dIO VARIABLE FOR http request with a base url(options) to be implemented in the initstate.
  Dio? _dio;

  BaseOptions _options = new BaseOptions(
    baseUrl: Constants.baseUrlLocal,
    connectTimeout: 32000,
    receiveTimeout: 32000,
  );

  //Empty List if Images
  List<ImageModel> _imagesList = [];

  //Var for Curr Index
  int _currIndex = 1;

  @override
  void initState() {
    //Initialising Dio
    _dio = new Dio(_options);

    //Get Initial Images.
    _getDataFomServer(_currIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _screenAppBar(),
      body: Container(
          child: _imagesList.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _imagesList.length,
                  itemBuilder: (context, i) {
                    // return SingleImageItem(imageModel: _imagesList[i]);
                    if (i == (_imagesList.length - 1)) {
                      return Column(children: [
                        SingleImageItem(imageModel: _imagesList[i]),
                        SizedBox(
                          height: 10,
                        ),
                        _isLoadingMore
                            ? _circularIndicator()
                            : _getLoadMoreWidget(),
                      ]);
                    } else {
                      return SingleImageItem(imageModel: _imagesList[i]);
                    }
                  },
                )
              : _circularIndicator()),
    );
  }

  //Widget Indicator
  Widget _circularIndicator() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  //Load More Widget
  Widget _getLoadMoreWidget() {
    return Container(
      child: Center(
        child: IconButton(
          icon: Icon(Icons.more),
          onPressed: () {
            _isLoadingMore = true;
            setState(() {});
            _getDataFomServer(_currIndex);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _screenAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        'Images',
      ),
    );
  }

  void _getDataFomServer(int index) async {
 
    var formData = FormData.fromMap({
      'user_id': "108",
      'offset': index,
      'type': "popular",
    });
    //print(formData);
    try {
      Response response = await _dio!.post("/getdata.php", data: formData);

      if (response.statusCode == 200) {
        // print(response.toString());
        String responseStatus =
            jsonDecode(response.toString())['status'] as String;

        // String responseMsg = jsonDecode(response.toString())['msg'] as String;
        // print(responseStatus.toString());
        if (responseStatus == "success") {
          // print(response.toString());
          List<ImageModel>? _imagesListNew;
          _imagesListNew = (jsonDecode(response.toString())['images'] as List)
              .map((dataObj) => ImageModel.fromJson(dataObj))
              .toList();

          //Next Index
          _currIndex++;

          //Add Images To Current Global List Images
          _imagesList.addAll(_imagesListNew);

          //Set Back to false
          _isLoadingMore = false;
          setState(() {});
        } else {
          _showSnackBar('No data Found');
        }
      } else {
        print('A network error occurred');

        throw Exception('Server Error , Please try later.');
      }
    } catch (e) {
      _showSnackBar('OOPS,Server can not be reached. Please try again.');

      print(e);
    }
  }

  //Methpd To Show SnackBar()
  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    );

    // Find the Scaffold in the widget tree and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
