Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5CDZ916023694
	for <video4linux-list@redhat.com>; Thu, 12 Jun 2008 09:35:09 -0400
Received: from scing.com (scing.com [217.160.110.58])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5CDYvkt003110
	for <video4linux-list@redhat.com>; Thu, 12 Jun 2008 09:34:57 -0400
From: Janne Grunau <janne-dvb@grunau.be>
To: video4linux-list@redhat.com
Date: Thu, 12 Jun 2008 15:35:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121535.30530.janne-dvb@grunau.be>
Subject: [RFC] Extend V4L MPEG Encoding API, add AVC and AAC
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

the Hauppauge HD PVR uses not yet in the mpeg encoding api defined 
codecs. This patch adds only AVC and AVC since that's the only things 
the device supports now. It's planned to add Dolby Digital later but I 
rather write until the device supports it before adding codecs to the 
enums.

I haven't added audio bitrate controls since I don't know if the device 
supports audio bitrate setting.

Janne

----

Adds Advanced Audio Coding (AAC) and MPEG-4 Advanced Video Coding 
(AVC/H.264)
as audio/video codecs to the extended controls API


Signed-off-by: Janne Grunau <j@jannau.net>

diff -r af3fbab47be9 -r 8154d666f6f1 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Thu Jun 12 03:58:36 2008 +0200
+++ b/linux/include/linux/videodev2.h	Thu Jun 12 15:18:50 2008 +0200
@@ -923,6 +923,7 @@ enum v4l2_mpeg_audio_encoding {
 	V4L2_MPEG_AUDIO_ENCODING_LAYER_1 = 0,
 	V4L2_MPEG_AUDIO_ENCODING_LAYER_2 = 1,
 	V4L2_MPEG_AUDIO_ENCODING_LAYER_3 = 2,
+	V4L2_MPEG_AUDIO_ENCODING_AAC     = 3,
 };
 #define V4L2_CID_MPEG_AUDIO_L1_BITRATE 		(V4L2_CID_MPEG_BASE+102)
 enum v4l2_mpeg_audio_l1_bitrate {
@@ -1005,8 +1006,9 @@ enum v4l2_mpeg_audio_crc {
 /*  MPEG video */
 #define V4L2_CID_MPEG_VIDEO_ENCODING 		(V4L2_CID_MPEG_BASE+200)
 enum v4l2_mpeg_video_encoding {
-	V4L2_MPEG_VIDEO_ENCODING_MPEG_1 = 0,
-	V4L2_MPEG_VIDEO_ENCODING_MPEG_2 = 1,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_2     = 1,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC = 2,
 };
 #define V4L2_CID_MPEG_VIDEO_ASPECT 		(V4L2_CID_MPEG_BASE+201)
 enum v4l2_mpeg_video_aspect {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
