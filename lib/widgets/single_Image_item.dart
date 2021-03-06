import 'package:flutter/material.dart';
import 'package:image_app/Utils/routes.dart';

import 'package:image_app/models/image_model.dart';

class SingleImageItem extends StatelessWidget {
  final ImageModel imageModel;
  final int calledBy;
  SingleImageItem({Key? key, required this.imageModel, this.calledBy = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///  print(imageModel.imgUrl);
    return InkWell(
      onTap: () {
        if (calledBy == 1) _onTapImage(context);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Image(image: NetworkImage(imageModel.imgUrl)),
      ),
    );
  }

  //On Tab Image
  void _onTapImage(BuildContext context) {
    //Navigate to detail Screen,
    Navigator.of(context)
        .pushNamed(MyRoutes.DETAIL_ROUTE, arguments: {"data": imageModel});
  }
}
