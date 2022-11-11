import 'package:flutter/material.dart';
import 'package:video_and_audio_call/video_call.dart';

import 'audio_call.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video & Audio call'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              'https://media-exp1.licdn.com/dms/image/C4D03AQHegw7qn3UMLg/profile-displayphoto-shrink_800_800/0/1657090576273?e=1673481600&v=beta&t=_P567yhI3ZybmqYvU2tkd95XjO53HmX-evbRGHjnPr4'),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Mohamed Hany',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            '+20 1118050299',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const VideoCallScreen()));
                  },
                  icon: const Icon(Icons.video_call),
                  color: Colors.red),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AudioCallScreen()));

                  },
                  icon: const Icon(Icons.video_call),
                  color: Colors.red),
            ],
          )
        ],
      ),
    );
  }
}
