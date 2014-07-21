Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4310 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaGUNp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:45:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] v4l2-ctrls: add RX RDS controls.
Date: Mon, 21 Jul 2014 15:45:40 +0200
Message-Id: <1405950343-26892-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The radio-miropcm20 driver has firmware that decodes the RDS signals. So in that
case the RDS data becomes available in the form of controls.

Add support for these controls to the control framework, allowing the miro driver
to use them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 19 +++++++++++++++++--
 include/uapi/linux/v4l2-controls.h   |  6 ++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9a22f2c..a7b4d4c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -881,7 +881,6 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
-
 	case V4L2_CID_RF_TUNER_CLASS:		return "RF Tuner Controls";
 	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:	return "LNA Gain, Auto";
 	case V4L2_CID_RF_TUNER_LNA_GAIN:	return "LNA Gain";
@@ -892,6 +891,12 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:	return "Bandwidth, Auto";
 	case V4L2_CID_RF_TUNER_BANDWIDTH:	return "Bandwidth";
 	case V4L2_CID_RF_TUNER_PLL_LOCK:	return "PLL Lock";
+	case V4L2_CID_RDS_RX_PTY:		return "RDS Program Type";
+	case V4L2_CID_RDS_RX_PS_NAME:		return "RDS PS Name";
+	case V4L2_CID_RDS_RX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT: return "RDS Traffic Announcement";
+	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:	return "RDS Traffic Program";
+	case V4L2_CID_RDS_RX_MUSIC_SPEECH:	return "RDS Music";
 
 	/* Detection controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -900,7 +905,6 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD: return "MD Global Threshold";
 	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:	return "MD Threshold Grid";
 	case V4L2_CID_DETECT_MD_REGION_GRID:	return "MD Region Grid";
-
 	default:
 		return NULL;
 	}
@@ -963,6 +967,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_TRAFFIC_PROGRAM:
 	case V4L2_CID_RDS_TX_MUSIC_SPEECH:
 	case V4L2_CID_RDS_TX_ALT_FREQS_ENABLE:
+	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT:
+	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:
+	case V4L2_CID_RDS_RX_MUSIC_SPEECH:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -1035,6 +1042,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
+	case V4L2_CID_RDS_RX_PS_NAME:
+	case V4L2_CID_RDS_RX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
 		break;
 	case V4L2_CID_ISO_SENSITIVITY:
@@ -1166,6 +1175,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
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
 	case V4L2_CID_RF_TUNER_PLL_LOCK:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index a13e6fe..e946e43 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -910,6 +910,12 @@ enum v4l2_deemphasis {
 };
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
+#define V4L2_CID_RDS_RX_PTY			(V4L2_CID_FM_RX_CLASS_BASE + 3)
+#define V4L2_CID_RDS_RX_PS_NAME			(V4L2_CID_FM_RX_CLASS_BASE + 4)
+#define V4L2_CID_RDS_RX_RADIO_TEXT		(V4L2_CID_FM_RX_CLASS_BASE + 5)
+#define V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT	(V4L2_CID_FM_RX_CLASS_BASE + 6)
+#define V4L2_CID_RDS_RX_TRAFFIC_PROGRAM		(V4L2_CID_FM_RX_CLASS_BASE + 7)
+#define V4L2_CID_RDS_RX_MUSIC_SPEECH		(V4L2_CID_FM_RX_CLASS_BASE + 8)
 
 #define V4L2_CID_RF_TUNER_CLASS_BASE		(V4L2_CTRL_CLASS_RF_TUNER | 0x900)
 #define V4L2_CID_RF_TUNER_CLASS			(V4L2_CTRL_CLASS_RF_TUNER | 1)
-- 
2.0.1

