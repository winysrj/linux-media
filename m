Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:40658 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbcCDAIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 19:08:38 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: add prefixes to interface types
Date: Thu,  3 Mar 2016 17:08:32 -0700
Message-Id: <1457050112-6831-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing prefixes for DVB, V4L, and ALSA interface types.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index bcd7464..561c939 100644
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
+		return "dvb-DVR";
 	case MEDIA_INTF_T_DVB_CA:
-		return  "CA";
+		return  "dvb-conditional-access";
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
 		return "v4l2-subdev";
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

