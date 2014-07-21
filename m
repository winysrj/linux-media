Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4713 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaGUNp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:45:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] v4l2-ctrls: add new RDS TX controls
Date: Mon, 21 Jul 2014 15:45:37 +0200
Message-Id: <1405950343-26892-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The si4713 supports several RDS features not yet implemented in the driver.

This patch adds the missing RDS functionality to the list of RDS controls.

The ALT_FREQS control is a compound control containing an array of up
to 25 (the maximum according to the RDS standard) frequencies. To support
that the V4L2_CTRL_TYPE_U32 was added.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 35 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  2 ++
 include/uapi/linux/v4l2-controls.h   |  9 +++++++++
 include/uapi/linux/videodev2.h       |  2 ++
 4 files changed, 48 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 1acc7aa..9a22f2c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -805,6 +805,15 @@ const char *v4l2_ctrl_get_name(u32 id)
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
+	case V4L2_CID_RDS_TX_ALT_FREQS_ENABLE:	return "RDS Enable Alt Frequencies";
+	case V4L2_CID_RDS_TX_ALT_FREQS:		return "RDS Alternate Frequencies";
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
 	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
 	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
@@ -946,6 +955,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_PLL_LOCK:
+	case V4L2_CID_RDS_TX_MONO_STEREO:
+	case V4L2_CID_RDS_TX_ARTIFICIAL_HEAD:
+	case V4L2_CID_RDS_TX_COMPRESSED:
+	case V4L2_CID_RDS_TX_DYNAMIC_PTY:
+	case V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT:
+	case V4L2_CID_RDS_TX_TRAFFIC_PROGRAM:
+	case V4L2_CID_RDS_TX_MUSIC_SPEECH:
+	case V4L2_CID_RDS_TX_ALT_FREQS_ENABLE:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -1089,6 +1106,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
 		*type = V4L2_CTRL_TYPE_U16;
 		break;
+	case V4L2_CID_RDS_TX_ALT_FREQS:
+		*type = V4L2_CTRL_TYPE_U32;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1209,6 +1229,8 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ptr1.p_u8[idx] == ptr2.p_u8[idx];
 	case V4L2_CTRL_TYPE_U16:
 		return ptr1.p_u16[idx] == ptr2.p_u16[idx];
+	case V4L2_CTRL_TYPE_U32:
+		return ptr1.p_u32[idx] == ptr2.p_u32[idx];
 	default:
 		if (ctrl->is_int)
 			return ptr1.p_s32[idx] == ptr2.p_s32[idx];
@@ -1242,6 +1264,9 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_U16:
 		ptr.p_u16[idx] = ctrl->default_value;
 		break;
+	case V4L2_CTRL_TYPE_U32:
+		ptr.p_u32[idx] = ctrl->default_value;
+		break;
 	default:
 		idx *= ctrl->elem_size;
 		memset(ptr.p + idx, 0, ctrl->elem_size);
@@ -1289,6 +1314,9 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	case V4L2_CTRL_TYPE_U16:
 		pr_cont("%u", (unsigned)*ptr.p_u16);
 		break;
+	case V4L2_CTRL_TYPE_U32:
+		pr_cont("%u", (unsigned)*ptr.p_u32);
+		break;
 	default:
 		pr_cont("unknown type %d", ctrl->type);
 		break;
@@ -1335,6 +1363,8 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
 	case V4L2_CTRL_TYPE_U16:
 		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
+	case V4L2_CTRL_TYPE_U32:
+		return ROUND_TO_RANGE(ptr.p_u32[idx], u32, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = !!ptr.p_s32[idx];
@@ -1567,6 +1597,7 @@ static int check_range(enum v4l2_ctrl_type type,
 		/* fall through */
 	case V4L2_CTRL_TYPE_U8:
 	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_U32:
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER64:
 		if (step == 0 || min > max || def < min || def > max)
@@ -1882,6 +1913,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U16:
 		elem_size = sizeof(u16);
 		break;
+	case V4L2_CTRL_TYPE_U32:
+		elem_size = sizeof(u32);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
@@ -3244,6 +3278,7 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_BITMASK:
 	case V4L2_CTRL_TYPE_U8:
 	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_U32:
 		if (ctrl->is_array)
 			return -EINVAL;
 		ret = check_range(ctrl->type, min, max, step, def);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 8c4edd6..a674bf7 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -41,6 +41,7 @@ struct poll_table_struct;
  * @p_s64:	Pointer to a 64-bit signed value.
  * @p_u8:	Pointer to a 8-bit unsigned value.
  * @p_u16:	Pointer to a 16-bit unsigned value.
+ * @p_u32:	Pointer to a 32-bit unsigned value.
  * @p_char:	Pointer to a string.
  * @p:		Pointer to a compound value.
  */
@@ -49,6 +50,7 @@ union v4l2_ctrl_ptr {
 	s64 *p_s64;
 	u8 *p_u8;
 	u16 *p_u16;
+	u32 *p_u32;
 	char *p_char;
 	void *p;
 };
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index db526d1..a13e6fe 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -757,6 +757,15 @@ enum v4l2_auto_focus_range {
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
+#define V4L2_CID_RDS_TX_ALT_FREQS_ENABLE	(V4L2_CID_FM_TX_CLASS_BASE + 14)
+#define V4L2_CID_RDS_TX_ALT_FREQS		(V4L2_CID_FM_TX_CLASS_BASE + 15)
 
 #define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 64)
 #define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 65)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b73e8cd..205ab62 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1281,6 +1281,7 @@ struct v4l2_ext_control {
 		char *string;
 		__u8 *p_u8;
 		__u16 *p_u16;
+		__u32 *p_u32;
 		void *ptr;
 	};
 } __attribute__ ((packed));
@@ -1313,6 +1314,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_COMPOUND_TYPES     = 0x0100,
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
+	V4L2_CTRL_TYPE_U32	     = 0x0102,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.0.1

