Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60058 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbAVOsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 09:48:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH 1/7] v4l2-ctrls: Add new S8, S16 and S32 compound control types
Date: Thu, 22 Jan 2015 16:48:40 +0200
Message-Id: <1421938126-17747-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only unsigned compound types are implemented so far, add the
corresponding signes types.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 21 +++++++++++++++
 .../DocBook/media/v4l/vidioc-queryctrl.xml         | 30 ++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 30 ++++++++++++++++++++++
 include/media/v4l2-ctrls.h                         |  4 +++
 include/uapi/linux/videodev2.h                     |  6 +++++
 5 files changed, 91 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index c5bdbfc..845087e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -186,6 +186,27 @@ type <constant>V4L2_CTRL_TYPE_STRING</constant>.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>__s8 *</entry>
+	    <entry><structfield>p_s8</structfield></entry>
+	    <entry>A pointer to a matrix control of signed 8-bit values.
+Valid if this control is of type <constant>V4L2_CTRL_TYPE_S8</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__s16 *</entry>
+	    <entry><structfield>p_s16</structfield></entry>
+	    <entry>A pointer to a matrix control of signed 16-bit values.
+Valid if this control is of type <constant>V4L2_CTRL_TYPE_S16</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__s32 *</entry>
+	    <entry><structfield>p_s32</structfield></entry>
+	    <entry>A pointer to a matrix control of signed 32-bit values.
+Valid if this control is of type <constant>V4L2_CTRL_TYPE_S32</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8 *</entry>
 	    <entry><structfield>p_u8</structfield></entry>
 	    <entry>A pointer to a matrix control of unsigned 8-bit values.
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 2bd98fd..293e225 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -512,6 +512,36 @@ Older drivers which do not support this feature return an
 &EINVAL;.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_S8</constant></entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>A signed 8-bit valued control ranging from minimum to
+maximum inclusive. The step value indicates the increment between
+values which are actually different on the hardware.
+</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_S16</constant></entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>A signed 16-bit valued control ranging from minimum to
+maximum inclusive. The step value indicates the increment between
+values which are actually different on the hardware.
+</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_S32</constant></entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>A signed 32-bit valued control ranging from minimum to
+maximum inclusive. The step value indicates the increment between
+values which are actually different on the hardware.
+</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_U8</constant></entry>
 	    <entry>any</entry>
 	    <entry>any</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..301abb7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1247,10 +1247,13 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return ptr1.p_s64[idx] == ptr2.p_s64[idx];
 	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_S8:
 		return ptr1.p_u8[idx] == ptr2.p_u8[idx];
 	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_S16:
 		return ptr1.p_u16[idx] == ptr2.p_u16[idx];
 	case V4L2_CTRL_TYPE_U32:
+	case V4L2_CTRL_TYPE_S32:
 		return ptr1.p_u32[idx] == ptr2.p_u32[idx];
 	default:
 		if (ctrl->is_int)
@@ -1280,12 +1283,15 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 		ptr.p_s32[idx] = ctrl->default_value;
 		break;
 	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_S8:
 		ptr.p_u8[idx] = ctrl->default_value;
 		break;
 	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_S16:
 		ptr.p_u16[idx] = ctrl->default_value;
 		break;
 	case V4L2_CTRL_TYPE_U32:
+	case V4L2_CTRL_TYPE_S32:
 		ptr.p_u32[idx] = ctrl->default_value;
 		break;
 	default:
@@ -1338,6 +1344,15 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	case V4L2_CTRL_TYPE_U32:
 		pr_cont("%u", (unsigned)*ptr.p_u32);
 		break;
+	case V4L2_CTRL_TYPE_S8:
+		pr_cont("%d", (int)*ptr.p_s8);
+		break;
+	case V4L2_CTRL_TYPE_S16:
+		pr_cont("%d", (int)*ptr.p_s16);
+		break;
+	case V4L2_CTRL_TYPE_S32:
+		pr_cont("%d", (int)*ptr.p_s32);
+		break;
 	default:
 		pr_cont("unknown type %d", ctrl->type);
 		break;
@@ -1397,6 +1412,12 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
 	case V4L2_CTRL_TYPE_U32:
 		return ROUND_TO_RANGE(ptr.p_u32[idx], u32, ctrl);
+	case V4L2_CTRL_TYPE_S8:
+		return ROUND_TO_RANGE(ptr.p_s8[idx], s8, ctrl);
+	case V4L2_CTRL_TYPE_S16:
+		return ROUND_TO_RANGE(ptr.p_s16[idx], s16, ctrl);
+	case V4L2_CTRL_TYPE_S32:
+		return ROUND_TO_RANGE(ptr.p_s32[idx], s32, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = !!ptr.p_s32[idx];
@@ -1630,6 +1651,9 @@ static int check_range(enum v4l2_ctrl_type type,
 	case V4L2_CTRL_TYPE_U8:
 	case V4L2_CTRL_TYPE_U16:
 	case V4L2_CTRL_TYPE_U32:
+	case V4L2_CTRL_TYPE_S8:
+	case V4L2_CTRL_TYPE_S16:
+	case V4L2_CTRL_TYPE_S32:
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER64:
 		if (step == 0 || min > max || def < min || def > max)
@@ -1933,12 +1957,15 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		elem_size = max + 1;
 		break;
 	case V4L2_CTRL_TYPE_U8:
+	case V4L2_CTRL_TYPE_S8:
 		elem_size = sizeof(u8);
 		break;
 	case V4L2_CTRL_TYPE_U16:
+	case V4L2_CTRL_TYPE_S16:
 		elem_size = sizeof(u16);
 		break;
 	case V4L2_CTRL_TYPE_U32:
+	case V4L2_CTRL_TYPE_S32:
 		elem_size = sizeof(u32);
 		break;
 	default:
@@ -3312,6 +3339,9 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_U8:
 	case V4L2_CTRL_TYPE_U16:
 	case V4L2_CTRL_TYPE_U32:
+	case V4L2_CTRL_TYPE_S8:
+	case V4L2_CTRL_TYPE_S16:
+	case V4L2_CTRL_TYPE_S32:
 		if (ctrl->is_array)
 			return -EINVAL;
 		ret = check_range(ctrl->type, min, max, step, def);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 911f3e5..e1cfb8f 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -37,6 +37,8 @@ struct v4l2_fh;
 struct poll_table_struct;
 
 /** union v4l2_ctrl_ptr - A pointer to a control value.
+ * @p_s8:	Pointer to a 8-bit signed value.
+ * @p_s16:	Pointer to a 16-bit signed value.
  * @p_s32:	Pointer to a 32-bit signed value.
  * @p_s64:	Pointer to a 64-bit signed value.
  * @p_u8:	Pointer to a 8-bit unsigned value.
@@ -46,6 +48,8 @@ struct poll_table_struct;
  * @p:		Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
+	s8 *p_s8;
+	s16 *p_s16;
 	s32 *p_s32;
 	s64 *p_s64;
 	u8 *p_u8;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..9f51535 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1370,6 +1370,9 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		__s8 __user *p_s8;
+		__s16 __user *p_s16;
+		__s32 __user *p_s32;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1403,6 +1406,9 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_S8	     = 0x0103,
+	V4L2_CTRL_TYPE_S16	     = 0x0104,
+	V4L2_CTRL_TYPE_S32	     = 0x0105,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.0.5

