import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:music_test/models/music_model.dart';
import 'package:music_test/services/music_service.dart';

// คอนโทรลเลอร์สำหรับจัดการการเล่นเพลงในแอปพลิเคชัน
class MusicController extends GetxController {
  // บริการสำหรับดึงข้อมูลเพลย์ลิสต์
  final musicService = MusicService();

  // เก็บดัชนีของเพลงที่กำลังเล่นอยู่
  final currentTrackIndex = 0.obs;

  // สถานะการเล่นเพลง (กำลังเล่น/หยุดชั่วคราว)
  final isPlaying = false.obs;

  // ตำแหน่งปัจจุบันของเพลงที่กำลังเล่น (เช่น 1:30)
  final currentPosition = Duration.zero.obs;

  // ความยาวทั้งหมดของเพลงที่กำลังเล่น
  final totalDuration = Duration.zero.obs;

  // เพลย์ลิสต์ของเพลง
  var playlist = <MusicModel>[].obs;

  // อินสแตนซ์ของ AudioPlayer สำหรับเล่นเพลง
  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _setupListeners(); // ตั้งค่าการฟังเหตุการณ์ต่าง ๆ จาก AudioPlayer
    _loadPlaylist(); // โหลดเพลย์ลิสต์เมื่อเริ่มต้นใช้งานคอนโทรลเลอร์
  }

  // ฟังก์ชันสำหรับโหลดเพลย์ลิสต์จาก MusicService
  Future<void> _loadPlaylist() async {
    playlist.value = await musicService.fetchMusics();
  }

  // ตั้งค่าการฟังเหตุการณ์ต่าง ๆ จาก AudioPlayer
  void _setupListeners() {
    // ฟังตำแหน่งการเล่นเพลงปัจจุบัน
    player.positionStream.listen((position) {
      currentPosition.value = position;
    });

    // ฟังระยะเวลาทั้งหมดของเพลง
    player.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });

    // ฟังสถานะการเล่นเพลง เช่น เมื่อเพลงเล่นจบ
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        nextTrack(); // เมื่อเพลงจบให้เล่นเพลงถัดไป
      }
      isPlaying.value = state.playing; // อัปเดตสถานะการเล่น
    });
  }

  // โหลดเพลงสำหรับเล่นจากเพลย์ลิสต์
  Future<void> loadTrack(int index) async {
    final track = playlist[index];
    if (track.url == null || track.url?.isEmpty == true) {
      return; // หากไม่มี URL ของเพลง ให้ยกเลิกการโหลด
    }
    await player.setAsset(track.url ?? ''); // โหลดเพลงจากไฟล์ใน Asset
    totalDuration.value = player.duration ?? Duration.zero; // อัปเดตความยาวเพลง
  }

  // เลือกเพลงจากเพลย์ลิสต์
  void selectTrack(int index) async {
    if (index != currentTrackIndex.value) {
      currentTrackIndex.value = index; // อัปเดตดัชนีเพลงที่เลือก
      await loadTrack(index); // โหลดเพลงใหม่
      play(); // เล่นเพลงที่เลือก
    } else {
      // หากเลือกเพลงเดิม สลับสถานะการเล่น/หยุดชั่วคราว
      if (isPlaying.value) {
        pause();
      } else {
        play();
      }
    }
  }

  // เล่นเพลง
  void play() {
    player.play();
  }

  // หยุดชั่วคราว
  void pause() {
    player.pause();
  }

  // เล่นเพลงถัดไป
  void nextTrack() {
    if (currentTrackIndex.value < playlist.length - 1) {
      selectTrack(currentTrackIndex.value + 1); // หากยังไม่ใช่เพลงสุดท้าย ให้เล่นเพลงถัดไป
    } else {
      selectTrack(0); // หากเป็นเพลงสุดท้าย ให้กลับไปเล่นเพลงแรก
    }
  }

  // เล่นเพลงก่อนหน้า
  void backTrack() {
    if (currentTrackIndex.value > 0) {
      selectTrack(currentTrackIndex.value - 1); // หากยังไม่ใช่เพลงแรก ให้เล่นเพลงก่อนหน้า
    } else {
      selectTrack(playlist.length - 1); // หากเป็นเพลงแรก ให้กลับไปเล่นเพลงสุดท้าย
    }
  }

  @override
  void onClose() {
    player.dispose(); // ล้างหน่วยความจำเมื่อปิดคอนโทรลเลอร์
    super.onClose();
  }
}
