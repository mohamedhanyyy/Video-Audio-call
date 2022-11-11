import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_and_audio_call/app_brain.dart';
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? remoteUid = 0;
  RtcEngine? engine;
  bool localUserJoined = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _renderRemoteVideo(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: _renderLocalVideo(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    icon: const Icon(Icons.call_end),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    engine = createAgoraRtcEngine();
    await engine!.initialize(RtcEngineContext(
      appId: AgoraManager.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    engine!.enableVideo();
    engine!.unregisterEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (kDebugMode) {
            print('local user joined successfully ${connection.localUid}');
          }
          setState(() {
            localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteId, int elapsed) {
          if (kDebugMode) {
            print('Other user joined successfully $remoteId');
          }

          setState(() {
            remoteUid = remoteId;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          if (kDebugMode) {
            print('remote user left call');
          }
          setState(() {
            remoteUid = 0;
          });
          Navigator.of(context).pop(true);
        },
      ),
    );
    await engine!.joinChannel(
      token: AgoraManager.token,
      channelId: AgoraManager.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Widget _renderLocalVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _renderRemoteVideo() {
    if (remoteUid != 0) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: AgoraManager.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
