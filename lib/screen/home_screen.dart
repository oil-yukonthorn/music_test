import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_test/controller/music_controller.dart';
import 'package:music_test/models/music_model.dart';

class MusicApp extends StatelessWidget {
  final MusicController controller = Get.put(MusicController());

  MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Music App',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: _buildPlaylistSection(),
            ),
            _buildNowPlayingBar()
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistSection() {
    return Obx(() {
      if (controller.playlist.isEmpty) {
        // Show a message if the playlist is empty
        return Center(
          child: Text(
            'No tracks available',
            style: TextStyle(color: Colors.grey[300], fontSize: 16),
          ),
        );
      }
      return ListView.builder(
        itemCount: controller.playlist.length,
        itemBuilder: (context, index) {
          final track = controller.playlist[index];
          final isSelected = index == controller.currentTrackIndex.value;
          return _buildPlaylistItem(track, isSelected, index);
        },
      );
    });
  }

  Widget _buildPlaylistItem(MusicModel track, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => controller.selectTrack(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey[700] : Colors.grey[850],
          border: Border.all(
            color: isSelected ? Colors.pinkAccent : Colors.grey[700]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            _buildTrackImage(track.image),
            const SizedBox(width: 16.0),
            _buildTrackDetails(track.title, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackImage(String? imageUrl) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
        image: imageUrl != null && imageUrl.isNotEmpty
            ? DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null || imageUrl.isEmpty
          ? Icon(
              Icons.music_note,
              color: Colors.grey[500],
            )
          : null,
    );
  }

  Widget _buildTrackDetails(String? title, bool isSelected) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: isSelected ? Colors.pinkAccent : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingBar() {
    if (controller.playlist.isEmpty) {
      return Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No track playing',
            style: TextStyle(color: Colors.grey[300], fontSize: 16),
          ),
        ),
      );
    }

    final currentTrack = controller.playlist[controller.currentTrackIndex.value];
    final currentPosition = controller.currentPosition.value;
    final totalDuration = controller.totalDuration.value;
    final progress = totalDuration.inMilliseconds > 0 ? currentPosition.inMilliseconds / totalDuration.inMilliseconds : 0.0;

    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTrackImage(currentTrack.image),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  'Now Playing: ${currentTrack.title ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildControlButtons(),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildProgressBar(progress),
          const SizedBox(height: 4.0),
          _buildTimeDisplay(currentPosition, totalDuration),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            size: 32,
            color: Colors.pinkAccent,
          ),
          onPressed: () => controller.backTrack(),
        ),
        IconButton(
          icon: Icon(
            controller.isPlaying.value ? Icons.pause_circle_filled : Icons.play_circle_filled,
            size: 32,
            color: Colors.pinkAccent,
          ),
          onPressed: () {
            if (controller.isPlaying.value) {
              controller.pause();
            } else {
              controller.play();
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next,
            size: 32,
            color: Colors.pinkAccent,
          ),
          onPressed: () => controller.nextTrack(),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return LinearProgressIndicator(
      value: progress,
      minHeight: 6.0,
      backgroundColor: Colors.grey[700],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
    );
  }

  Widget _buildTimeDisplay(Duration currentPosition, Duration totalDuration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDuration(currentPosition),
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        Text(
          _formatDuration(totalDuration),
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
