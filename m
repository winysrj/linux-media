Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50416 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbcCDVOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 16:14:10 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: add prefixes to interface types
Date: Fri,  4 Mar 2016 14:14:05 -0700
Message-Id: <1457126045-8108-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing prefixes for DVB, V4L, and ALSA interface types.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v1:
Addresses Hans's comments on v1

 drivers/media/media-entity.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index bcd7464..e95070b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -46,41 +46,41 @@ static inline const char *intf_type(struct media_interface *intf)
 {
 	switch (intf->type) {
 	case MEDIA_INTF_T_DVB_FE:
-		return "frontend";
+		return "dvb-frontend";
 	case MEDIA_INTF_T_DVB_DEMUX:
-		return "demux";
+		return "dvb-demux";
 	case MEDIA_INTF_T_DVB_DVR:
-		return "DVR";
+		return "dvb-dvr";
 	case MEDIA_INTF_T_DVB_CA:
-		return  "CA";
+		return  "dvb-ca";
 	case MEDIA_INTF_T_DVB_NET:
-		return "dvbnet";
+		return "dvb-net";
 	case MEDIA_INTF_T_V4L_VIDEO:
-		return "video";
+		return "v4l-video";
 	case MEDIA_INTF_T_V4L_VBI:
-		return "vbi";
+		return "v4l-vbi";
 	case MEDIA_INTF_T_V4L_RADIO:
-		return "radio";
+		return "v4l-radio";
 	case MEDIA_INTF_T_V4L_SUBDEV:
-		return "v4l2-subdev";
+		return "v4l-subdev";
 	case MEDIA_INTF_T_V4L_SWRADIO:
-		return "swradio";
+		return "v4l-swradio";
 	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
-		return "pcm-capture";
+		return "alsa-pcm-capture";
 	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
-		return "pcm-playback";
+		return "alsa-pcm-playback";
 	case MEDIA_INTF_T_ALSA_CONTROL:
 		return "alsa-control";
 	case MEDIA_INTF_T_ALSA_COMPRESS:
-		return "compress";
+		return "alsa-compress";
 	case MEDIA_INTF_T_ALSA_RAWMIDI:
-		return "rawmidi";
+		return "alsa-rawmidi";
 	case MEDIA_INTF_T_ALSA_HWDEP:
-		return "hwdep";
+		return "alsa-hwdep";
 	case MEDIA_INTF_T_ALSA_SEQUENCER:
-		return "sequencer";
+		return "alsa-sequencer";
 	case MEDIA_INTF_T_ALSA_TIMER:
-		return "timer";
+		return "alsa-timer";
 	default:
 		return "unknown-intf";
 	}
-- 
2.5.0

