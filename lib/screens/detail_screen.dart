import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_app/Utils/constants.dart';
import 'package:image_app/Utils/string_extension.dart';
import 'package:image_app/models/image_model.dart';
import 'package:image_app/widgets/single_Image_item.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Dio? _dio;

  BaseOptions _options = new BaseOptions(
    baseUrl: Constants.baseUrlLocal,
    connectTimeout: 32000,
    receiveTimeout: 32000,
  );

  //Empty List if Images
  List<ImageModel> _imagesModelList = [];

  //Image File To Upload
  late File _fileToUpload;

  ////Controllers
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    //Initialising Dio
    _dio = new Dio(_options);

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    //Getting Data List, Passed From the Previous Page .
    final dataGot =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

    //Get Selected Day from the argument passed by Navigatr argument Property.
    ImageModel _imagesModel = dataGot['data'] as ImageModel;
    if (_imagesModelList.length == 0) {
      _imagesModelList.add(_imagesModel);

      _fileToUpload = await _urlToFile(_imagesModel.imgUrl);
      print(_fileToUpload);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _screenAppBar(),
      body: _imagesModelList.length > 0
          ? SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      SingleImageItem(imageModel: _imagesModelList[0]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: TextFormField(
                          //  initialValue: vendor.name,
                          controller: _firstNameController,
                          // onSaved: (value) {
                          //   vendor.name = value;
                          // },
                          decoration:
                              textFieldInputDecoration("First Name", 'Vishal'),
                          validator: (val) {
                            return val == null || val.isEmpty || val.length < 3
                                ? "In Valid Name"
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: TextFormField(
                          //  initialValue: vendor.name,
                          controller: _lastNameController,
                          // onSaved: (value) {
                          //   vendor.name = value;
                          // },
                          decoration:
                              textFieldInputDecoration("Last Name", 'Verma'),
                          validator: (val) {
                            return val == null || val.isEmpty || val.length < 3
                                ? "InValid Last Name"
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: TextFormField(
                          //  initialValue: vendor.name,
                          controller: _emailNameController,
                          // onSaved: (value) {
                          //   vendor.name = value;
                          // },
                          decoration: textFieldInputDecoration(
                              "Email", 'abc@email.com'),
                          validator: (val) {
                            return val == null ||
                                    val.isEmpty ||
                                    val.length < 3 ||
                                    !val.isValidEmail()
                                ? "InValid Email"
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: TextFormField(
                          //  initialValue: vendor.name,
                          controller: _phoneController,
                          // onSaved: (value) {
                          //   vendor.name = value;
                          // },
                          decoration:
                              textFieldInputDecoration("Phone", '8285283829'),
                          validator: (val) {
                            return val == null ||
                                    val.isEmpty ||
                                    val.length != 10 ||
                                    !val.isNumeric()
                                ? "InValid Phone No."
                                : null;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _formValidateAndSubmit,
                        child: Text('Submit'),
                      )
                    ],
                  ),
                ),
              ),
            )
          : _circularIndicator(),
    );
  }

// input decoration for text input fields
  textFieldInputDecoration(
    String label,
    String hint,
  ) {
    return InputDecoration(
      //hoverColor: greenC,
      //prefixStyle: TextStyle(color:Colors.black,fontSize:14),
      counterText: "",
      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: Colors.blue,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: label,
      //labelStyle: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400,color:greenC ),
      //errorText: errorText,
    );
  }

  //Form Submit
  void _formValidateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String firstname = _firstNameController.text;
      String lastname = _firstNameController.text;
      String email = _firstNameController.text;
      String phone = _firstNameController.text;
      // if(_fileToUpload != null)
      _submitDataAtServer(firstname, lastname, email, phone, _fileToUpload);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: new Text(
            'Some Error',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 50,
        ),
      );
    }
  }

  //Widget Indicator
  Widget _circularIndicator() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // //Load More Widget
  // Widget _getLoadMoreWidget() {
  //   return Container(
  //     child: Center(
  //       child: IconButton(
  //         icon: Icon(Icons.more),
  //         onPressed: () {
  //           _isLoadingMore = true;
  //           setState(() {});
  //           _getDataFomServer(_currIndex);
  //         },
  //       ),
  //     ),
  //   );
  // }

  PreferredSizeWidget _screenAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        'Detail Screen',
      ),
      leading: InkWell(
        onTap: () {
          _goBack(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<File> _urlToFile(String imageUrl) async {
    print(imageUrl);
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.jpg');
// call http.get method and pass imageUrl into it to get response.
    Response response = await Dio().get(imageUrl);
// write bodyBytes received in response to file.
    print(response.data);
    await file.writeAsString(response.data);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

//Method to Go Back To Previous Screen.
  void _goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _submitDataAtServer(String firstN, String lastN, String email,
      String phone, File imgFile) async {
    //SHOW lOADING dIALOG
    _loadingDialog();
    var formData = FormData.fromMap({
      'first_name': firstN,
      'last_name': lastN,
      'email': email,
      'phone': "popular",
      "user_image": await MultipartFile.fromFile(imgFile.path),
    });
    print(formData);
    try {
      Response response = await _dio!.post("/savedata.php", data: formData);

      if (response.statusCode == 200) {
        Navigator.pop(context); //pop dialog
        print(response.toString());
        String responseStatus =
            jsonDecode(response.toString())['status'] as String;

        // String responseMsg = jsonDecode(response.toString())['msg'] as String;
        // print(responseStatus.toString());
        if (responseStatus == "success") {
          String msg = jsonDecode(response.toString())['message'] as String;
          _showSnackBar(msg);
          // setState(() {});
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

  //Show Dialog Method
  void _loadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text("Please wait.."),
                ),
              ],
            ),
          ),
        );
      },
    );
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
