Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1790 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273AbaFLLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 23/34] v4l2-ctrls/videodev2.h: add u8 and u16 types.
Date: Thu, 12 Jun 2014 13:52:55 +0200
Message-Id: <fa4484719563d70f7cb5e1bc017069ea73d1d086.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are needed by the upcoming patches for the motion detection
matrices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 45 ++++++++++++++++++++++++++++++++----
 include/media/v4l2-ctrls.h           |  4 ++++
 include/uapi/linux/videodev2.h       |  4 ++++
 3 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 1086ae3..adf5485 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1174,6 +1174,10 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
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
@@ -1201,6 +1205,12 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
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
@@ -1242,6 +1252,12 @@ static void std_log(const struct v4l2_ctrl *ctrl)
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
@@ -1272,6 +1288,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return ROUND_TO_RANGE(ptr.p_s64[idx], u64, ctrl);
+	case V4L2_CTRL_TYPE_U8:
+		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
+	case V4L2_CTRL_TYPE_U16:
+		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = !!ptr.p_s32[idx];
@@ -1502,6 +1522,8 @@ static int check_range(enum v4l2_ctrl_type type,
 		if (step != 1 || max > 1 || min < 0)
 			return -ERANGE;
 		/* fall through */
+	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_U16:
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER64:
 		if (step == 0 || min > max || def < min || def > max)
@@ -1803,12 +1825,25 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	}
 	is_array = nr_of_dims > 0;
 
-	if (type == V4L2_CTRL_TYPE_INTEGER64)
+	/* Prefill elem_size for all types handled by std_type_ops */
+	switch (type) {
+	case V4L2_CTRL_TYPE_INTEGER64:
 		elem_size = sizeof(s64);
-	else if (type == V4L2_CTRL_TYPE_STRING)
+		break;
+	case V4L2_CTRL_TYPE_STRING:
 		elem_size = max + 1;
-	else if (type < V4L2_CTRL_COMPOUND_TYPES)
-		elem_size = sizeof(s32);
+		break;
+	case V4L2_CTRL_TYPE_U8:
+		elem_size = sizeof(u8);
+		break;
+	case V4L2_CTRL_TYPE_U16:
+		elem_size = sizeof(u16);
+		break;
+	default:
+		if (type < V4L2_CTRL_COMPOUND_TYPES)
+			elem_size = sizeof(s32);
+		break;
+	}
 	tot_ctrl_size = elem_size * elems;
 
 	/* Sanity checks */
@@ -3148,6 +3183,8 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
+	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_U16:
 		if (ctrl->is_array)
 			return -EINVAL;
 		ret = check_range(ctrl->type, min, max, step, def);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 7915b1125..c630345 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -39,12 +39,16 @@ struct poll_table_struct;
 /** union v4l2_ctrl_ptr - A pointer to a control value.
  * @p_s32:	Pointer to a 32-bit signed value.
  * @p_s64:	Pointer to a 64-bit signed value.
+ * @p_u8:	Pointer to a 8-bit unsigned value.
+ * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_char:	Pointer to a string.
  * @p:		Pointer to a compound value.
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
index 7d94adc..93ae827 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1254,6 +1254,8 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		__u8 *p_u8;
+		__u16 *p_u16;
 		void *ptr;
 	};
 } __attribute__ ((packed));
@@ -1284,6 +1286,8 @@ enum v4l2_ctrl_type {
 
 	/* Compound types are >= 0x0100 */
 	V4L2_CTRL_COMPOUND_TYPES     = 0x0100,
+	V4L2_CTRL_TYPE_U8	     = 0x0100,
+	V4L2_CTRL_TYPE_U16	     = 0x0101,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.0.0.rc0

