class MusicModel {
  final String? title;
  final String? url;
  final String? image;

  MusicModel({
    this.title,
    this.url,
    this.image,
  });

  // Factory method to create an instance from JSON
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      title: json['title'],
      url: json['url'],
      image: json['image'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'image': image,
    };
  }
}
