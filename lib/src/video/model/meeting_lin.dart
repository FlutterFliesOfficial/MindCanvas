import 'package:august_plus/src/constant/constant.dart';
import 'package:august_plus/src/video/service/sdk_intializer.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

import 'data_store.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool isLocalAudioOn = true;
  bool isLocalVideoOn = true;
  final bool _isLoading = false;
  Offset position = const Offset(10, 10);

  Future<bool> leaveRoom() async {
    SDKIntializer.hmssdk.leave();
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isVideoOff = context.select<UserDataStore, bool>(
        (user) => user.remoteVideoTrack?.isMute ?? true);
    final peer =
        context.select<UserDataStore, HMSPeer?>((user) => user.remotePeer);
    final remoteTrack = context
        .select<UserDataStore, HMSTrack?>((user) => user.remoteVideoTrack);
    final localTrack = context
        .select<UserDataStore, HMSVideoTrack?>((user) => user.localTrack);

    return WillPopScope(
      onWillPop: () async {
        return leaveRoom();
      },
      child: SafeArea(
        child: Scaffold(
          body: (_isLoading)
              ? const CircularProgressIndicator()
              : (peer == null)
                  ? Container(
                      color: kPrimaryColor,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, bottom: 20),
                                child: Text(
                                  "You're the only one here",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Please wait while doctor join",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Draggable<bool>(
                                  data: true,
                                  childWhenDragging: Container(),
                                  onDragEnd: (details) => {
                                        setState(
                                            () => position = details.offset)
                                      },
                                  feedback: Container(
                                    height: 200,
                                    width: 150,
                                    color: Colors.black,
                                    child: const Icon(
                                      Icons.videocam_off_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: localPeerTile(localTrack)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                            color: kPrimaryColor,
                            child: isVideoOff
                                ? Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.blue.withAlpha(60),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0,
                                              ),
                                            ]),
                                        child:
                                            const CircularProgressIndicator()),
                                  )
                                : (remoteTrack != null)
                                    ? HMSVideoView(
                                        track: remoteTrack as HMSVideoTrack,
                                        matchParent: false)
                                    : const Center(
                                        child: Text("No Video"),
                                      ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      leaveRoom();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withAlpha(60),
                                              blurRadius: 3.0,
                                              spreadRadius: 5.0,
                                            ),
                                          ]),
                                      child: const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.call_end,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () => {
                                  //     SDKIntializer.hmssdk
                                  //         .switchVideo(isOn: isLocalVideoOn),
                                  //     if (!isLocalVideoOn)
                                  //       SDKIntializer.hmssdk.startCapturing()
                                  //     else
                                  //       SDKIntializer.hmssdk.stopCapturing(),
                                  //     setState(() {
                                  //       isLocalVideoOn = !isLocalVideoOn;
                                  //     })
                                  //   },
                                  //   child: CircleAvatar(
                                  //     radius: 25,
                                  //     backgroundColor:
                                  //         Colors.transparent.withOpacity(0.2),
                                  //     child: Icon(
                                  //       isLocalVideoOn
                                  //           ? Icons.videocam
                                  //           : Icons.videocam_off_rounded,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  GestureDetector(
                                    onTap: () => {
                                      SDKIntializer.hmssdk
                                          .switchAudio(isOn: isLocalAudioOn),
                                      setState(() {
                                        isLocalAudioOn = !isLocalAudioOn;
                                      })
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Colors.transparent.withOpacity(0.2),
                                      child: Icon(
                                        isLocalAudioOn
                                            ? Icons.mic
                                            : Icons.mic_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          isVideoOff
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.videocam_off,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : Container(),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: GestureDetector(
                              onTap: () {
                                leaveRoom();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                if (isLocalVideoOn) {
                                  SDKIntializer.hmssdk.switchCamera();
                                }
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.2),
                                child: const Icon(
                                  Icons.switch_camera_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 100),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Draggable<bool>(
                                  data: true,
                                  childWhenDragging: Container(),
                                  onDragEnd: (details) => {
                                        setState(
                                            () => position = details.offset)
                                      },
                                  feedback: Container(
                                    height: 200,
                                    width: 150,
                                    color: Colors.black,
                                    child: const Icon(
                                      Icons.videocam_off_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: localPeerTile(localTrack)),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget localPeerTile(HMSVideoTrack? localTrack) {
    return Container(
      height: 200,
      width: 150,
      color: kSecondaryColor,
      child: (isLocalVideoOn && localTrack != null)
          ? HMSVideoView(
              track: localTrack,
            )
          : const Icon(
              Icons.videocam_off_rounded,
              color: Colors.white,
            ),
    );
  }
}
