import 'package:music_test/models/music_model.dart';

class MusicService {
  final List<Map<String, dynamic>> playlist = [
    {
      'title': 'Christmas Dreams - Jingle Bells',
      'url': 'assets/musics/christmas-dreams-jingle-bells-268299.mp3',
      'image': 'assets/images/christmas1.png',
    },
    {
      'title': 'Christmas Spirit',
      'url': 'assets/musics/christmas-spirit-265741.mp3',
      'image': 'assets/images/christmas2.png',
    },
    {
      'title': 'Magic Christmas Night',
      'url': 'assets/musics/magic-christmas-night-264068.mp3',
      'image': 'assets/images/christmas3.png',
    },
    {
      'title': 'Christmas Holidays',
      'url': 'assets/musics/christmas-holidays-270797.mp3',
      'image': 'assets/images/christmas4.png',
    },
    {
      'title': 'Christmas Holiday Harmony',
      'url': 'assets/musics/christmas-holiday-harmony-272169.mp3',
      'image': 'assets/images/christmas5.png',
    },
    {
      'title': 'Winter Day - Christmas Holidays',
      'url': 'assets/musics/winter-day-christmas-holidays-270802.mp3',
      'image': 'assets/images/christmas6.png',
    },
    {
      'title': 'We Wish You a Merry Christmas (Happy Remix)',
      'url': 'assets/musics/we-wish-you-a-merry-christmas-happy-remix-background-intro-theme-265842.mp3',
      'image': 'assets/images/christmas7.png',
    },
    {
      'title': 'Merry Christmas',
      'url': 'assets/musics/christmas-music-merry-christmas-264517.mp3',
      'image': 'assets/images/christmas8.png',
    },
    {
      'title': 'Christmas Lofi Music',
      'url': 'assets/musics/christmas-lofi-music-269177.mp3',
      'image': 'assets/images/christmas9.png',
    },
    {
      'title': 'Calm Christmas Piano',
      'url': 'assets/musics/calm-christmas-piano-262888.mp3',
      'image': 'assets/images/christmas10.png',
    },
  ];

  Future<List<MusicModel>> fetchMusics() async {
    return playlist.map((data) => MusicModel(title: data['title'], url: data['url'], image: data['image'])).toList();
  }
}
