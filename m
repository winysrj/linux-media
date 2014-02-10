Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3772 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaBJIsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:48:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 24/34] v4l2-ctrls/videodev2.h: add u8 and u16 types.
Date: Mon, 10 Feb 2014 09:46:49 +0100
Message-Id: <1392022019-5519-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are needed by the upcoming patches for the motion detection
matrices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 24 ++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  4 ++++
 include/uapi/linux/videodev2.h       |  4 ++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c81ebcf..0b200dd 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1145,6 +1145,10 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		return !strcmp(ptr1.p_char + idx, ptr2.p_char + idx);
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return ptr1.p_s64[idx] == ptr2.p_s64[idx];
+	case V4L2_CTRL_TYPE_U8:
+		return ptr1.p_u8[idx] == ptr2.p_u8[idx];
+	case V4L2_CTRL_TYPE_U16:
+		return ptr1.p_u16[idx] == ptr2.p_u16[idx];
 	default:
 		if (ctrl->is_int)
 			return ptr1.p_s32[idx] == ptr2.p_s32[idx];
@@ -1172,6 +1176,12 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = ctrl->default_value;
 		break;
+	case V4L2_CTRL_TYPE_U8:
+		ptr.p_u8[idx] = ctrl->default_value;
+		break;
+	case V4L2_CTRL_TYPE_U16:
+		ptr.p_u16[idx] = ctrl->default_value;
+		break;
 	default:
 		idx *= ctrl->elem_size;
 		memset(ptr.p + idx, 0, ctrl->elem_size);
@@ -1208,6 +1218,12 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	case V4L2_CTRL_TYPE_STRING:
 		pr_cont("%s", ptr.p_char);
 		break;
+	case V4L2_CTRL_TYPE_U8:
+		pr_cont("%u", (unsigned)*ptr.p_u8);
+		break;
+	case V4L2_CTRL_TYPE_U16:
+		pr_cont("%u", (unsigned)*ptr.p_u16);
+		break;
 	default:
 		pr_cont("unknown type %d", ctrl->type);
 		break;
@@ -1238,6 +1254,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return ROUND_TO_RANGE(ptr.p_s64[idx], u64, ctrl);
+	case V4L2_CTRL_TYPE_U8:
+		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
+	case V4L2_CTRL_TYPE_U16:
+		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = !!ptr.p_s32[idx];
@@ -1469,6 +1489,8 @@ static int check_range(enum v4l2_ctrl_type type,
 		if (step != 1 || max > 1 || min < 0)
 			return -ERANGE;
 		/* fall through */
+	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_U16:
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER64:
 		if (step == 0 || min > max || def < min || def > max)
@@ -3119,6 +3141,8 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
+	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_U16:
 		if (ctrl->is_matrix)
 			return -EINVAL;
 		ret = check_range(ctrl->type, min, max, step, def);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 7d72328..2ccad5f 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -39,12 +39,16 @@ struct poll_table_struct;
 /** union v4l2_ctrl_ptr - A pointer to a control value.
  * @p_s32:	Pointer to a 32-bit signed value.
  * @p_s64:	Pointer to a 64-bit signed value.
+ * @p_u8:	Pointer to a 8-bit unsigned value.
+ * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_char:	Pointer to a string.
  * @p:		Pointer to a complex value.
  */
 union v4l2_ctrl_ptr {
 	s32 *p_s32;
 	s64 *p_s64;
+	u8 *p_u8;
+	u16 *p_u16;
 	char *p_char;
 	void *p;
 };
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 858a6f3..8b70f51 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1228,6 +1228,8 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		__u8 *p_u8;
+		__u16 *p_u16;
 		void *p;
 	};
 } __attribute__ ((packed));
@@ -1257,6 +1259,8 @@ enum v4l2_ctrl_type {
 
 	/* Complex types are >= 0x0100 */
 	V4L2_CTRL_COMPLEX_TYPES	     = 0x0100,
+	V4L2_CTRL_TYPE_U8	     = 0x0100,
+	V4L2_CTRL_TYPE_U16	     = 0x0101,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.8.5.2

