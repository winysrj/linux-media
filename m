Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4635 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaBGMUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 07:20:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/7] v4l2-ctrls: add new RDS TX controls
Date: Fri,  7 Feb 2014 13:19:34 +0100
Message-Id: <1391775580-29907-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
References: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The si4713 supports several RDS features not yet implemented in the driver.

This patch adds the missing RDS functionality to the list of RDS controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 17 +++++++++++++++++
 include/uapi/linux/v4l2-controls.h   |  9 +++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6ff002b..66a2d0b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -794,6 +794,15 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
 	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
 	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_RDS_TX_MONO_STEREO:	return "RDS Stereo";
+	case V4L2_CID_RDS_TX_ARTIFICIAL_HEAD:	return "RDS Artificial Head";
+	case V4L2_CID_RDS_TX_COMPRESSED:	return "RDS Compressed";
+	case V4L2_CID_RDS_TX_DYNAMIC_PTY:	return "RDS Dynamic PTY";
+	case V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT: return "RDS Traffic Announcement";
+	case V4L2_CID_RDS_TX_TRAFFIC_PROGRAM:	return "RDS Traffic Program";
+	case V4L2_CID_RDS_TX_MUSIC_SPEECH:	return "RDS Music";
+	case V4L2_CID_RDS_TX_ALT_FREQ_ENABLE:	return "RDS Enable Alternate Frequency";
+	case V4L2_CID_RDS_TX_ALT_FREQ:		return "RDS Alternate Frequency";
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
 	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
 	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
@@ -906,6 +915,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
 	case V4L2_CID_RDS_RECEPTION:
+	case V4L2_CID_RDS_TX_MONO_STEREO:
+	case V4L2_CID_RDS_TX_ARTIFICIAL_HEAD:
+	case V4L2_CID_RDS_TX_COMPRESSED:
+	case V4L2_CID_RDS_TX_DYNAMIC_PTY:
+	case V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT:
+	case V4L2_CID_RDS_TX_TRAFFIC_PROGRAM:
+	case V4L2_CID_RDS_TX_MUSIC_SPEECH:
+	case V4L2_CID_RDS_TX_ALT_FREQ_ENABLE:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2cbe605..21abf77 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -753,6 +753,15 @@ enum v4l2_auto_focus_range {
 #define V4L2_CID_RDS_TX_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
 #define V4L2_CID_RDS_TX_PS_NAME			(V4L2_CID_FM_TX_CLASS_BASE + 5)
 #define V4L2_CID_RDS_TX_RADIO_TEXT		(V4L2_CID_FM_TX_CLASS_BASE + 6)
+#define V4L2_CID_RDS_TX_MONO_STEREO		(V4L2_CID_FM_TX_CLASS_BASE + 7)
+#define V4L2_CID_RDS_TX_ARTIFICIAL_HEAD		(V4L2_CID_FM_TX_CLASS_BASE + 8)
+#define V4L2_CID_RDS_TX_COMPRESSED		(V4L2_CID_FM_TX_CLASS_BASE + 9)
+#define V4L2_CID_RDS_TX_DYNAMIC_PTY		(V4L2_CID_FM_TX_CLASS_BASE + 10)
+#define V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT	(V4L2_CID_FM_TX_CLASS_BASE + 11)
+#define V4L2_CID_RDS_TX_TRAFFIC_PROGRAM		(V4L2_CID_FM_TX_CLASS_BASE + 12)
+#define V4L2_CID_RDS_TX_MUSIC_SPEECH		(V4L2_CID_FM_TX_CLASS_BASE + 13)
+#define V4L2_CID_RDS_TX_ALT_FREQ_ENABLE		(V4L2_CID_FM_TX_CLASS_BASE + 14)
+#define V4L2_CID_RDS_TX_ALT_FREQ		(V4L2_CID_FM_TX_CLASS_BASE + 15)
 
 #define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 64)
 #define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 65)
-- 
1.8.5.2

