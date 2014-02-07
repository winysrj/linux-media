Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3434 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbaBGMUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 07:20:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/7] v4l2-ctrls: add RX RDS controls.
Date: Fri,  7 Feb 2014 13:19:37 +0100
Message-Id: <1391775580-29907-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
References: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The radio-miropcm20 driver has firmware that decodes the RDS signals. So in that
case the RDS data becomes available in the form of controls.

Add support for these controls to the control framework, allowing the miro driver
to use them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 17 +++++++++++++++++
 include/uapi/linux/v4l2-controls.h   |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 66a2d0b..7c138b5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -866,6 +866,12 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
+	case V4L2_CID_RDS_RX_PTY:		return "RDS Program Type";
+	case V4L2_CID_RDS_RX_PS_NAME:		return "RDS PS Name";
+	case V4L2_CID_RDS_RX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT: return "RDS Traffic Announcement";
+	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:	return "RDS Traffic Program";
+	case V4L2_CID_RDS_RX_MUSIC_SPEECH:	return "RDS Music";
 	default:
 		return NULL;
 	}
@@ -923,6 +929,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_TRAFFIC_PROGRAM:
 	case V4L2_CID_RDS_TX_MUSIC_SPEECH:
 	case V4L2_CID_RDS_TX_ALT_FREQ_ENABLE:
+	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT:
+	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:
+	case V4L2_CID_RDS_RX_MUSIC_SPEECH:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -990,6 +999,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
+	case V4L2_CID_RDS_RX_PS_NAME:
+	case V4L2_CID_RDS_RX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
 		break;
 	case V4L2_CID_ISO_SENSITIVITY:
@@ -1096,6 +1107,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_TX_RXSENSE:
 	case V4L2_CID_DV_TX_EDID_PRESENT:
 	case V4L2_CID_DV_RX_POWER_PRESENT:
+	case V4L2_CID_RDS_RX_PTY:
+	case V4L2_CID_RDS_RX_PS_NAME:
+	case V4L2_CID_RDS_RX_RADIO_TEXT:
+	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT:
+	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:
+	case V4L2_CID_RDS_RX_MUSIC_SPEECH:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	}
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 21abf77..52c9679 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -903,5 +903,11 @@ enum v4l2_deemphasis {
 };
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
+#define V4L2_CID_RDS_RX_PTY			(V4L2_CID_FM_RX_CLASS_BASE + 3)
+#define V4L2_CID_RDS_RX_PS_NAME			(V4L2_CID_FM_RX_CLASS_BASE + 4)
+#define V4L2_CID_RDS_RX_RADIO_TEXT		(V4L2_CID_FM_RX_CLASS_BASE + 5)
+#define V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT	(V4L2_CID_FM_RX_CLASS_BASE + 6)
+#define V4L2_CID_RDS_RX_TRAFFIC_PROGRAM		(V4L2_CID_FM_RX_CLASS_BASE + 7)
+#define V4L2_CID_RDS_RX_MUSIC_SPEECH		(V4L2_CID_FM_RX_CLASS_BASE + 8)
 
 #endif
-- 
1.8.5.2

