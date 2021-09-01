class ImageModel {
  final String id;
  final String imgUrl;

  ImageModel({
    required this.id,
    required this.imgUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    String url = json['xt_image'] as String;
    final newUrl = url.replaceAll('dev1', "dev3");

    // print(newUrl);
    return ImageModel(
      id: json['id'] as String,
      imgUrl: newUrl,
    );
  }
}
