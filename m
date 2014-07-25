Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34274 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGYLmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 07:42:33 -0400
Received: by mail-la0-f54.google.com with SMTP id el20so2882431lab.41
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 04:42:31 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kamil Debski <k.debski@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] media/v4l2-ctrl: Support for pixel type
Date: Fri, 25 Jul 2014 13:42:27 +0200
Message-Id: <1406288547-4896-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have compound controls and support for array of controls it
might be a good idea to create a new type to describe individual pixels
(points).

This types of control can be used to provide the user a list of dead
pixels.

Please consider this PATCH as an RFC to find out if this kind of
control whould be useful for anybody else. If there is a need for this
kind of control I will resend this patch with changes in the
Documentation and the required changes on v4l-utils.

Thanks!

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 8 ++++++++
 include/media/v4l2-ctrls.h           | 2 ++
 include/uapi/linux/videodev2.h       | 7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 004e7e8..441a2c8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1209,6 +1209,9 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ptr1.p_u8[idx] == ptr2.p_u8[idx];
 	case V4L2_CTRL_TYPE_U16:
 		return ptr1.p_u16[idx] == ptr2.p_u16[idx];
+	case V4L2_CTRL_TYPE_POINT:
+		return memcmp(&ptr1.p_point[idx], &ptr2.p_point[idx],
+			      sizeof(ptr1.p_point[idx]));
 	default:
 		if (ctrl->is_int)
 			return ptr1.p_s32[idx] == ptr2.p_s32[idx];
@@ -1289,6 +1292,9 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	case V4L2_CTRL_TYPE_U16:
 		pr_cont("%u", (unsigned)*ptr.p_u16);
 		break;
+	case V4L2_CTRL_TYPE_POINT:
+		pr_cont("(%u,%u)", ptr.p_point->x, ptr.p_point->y);
+		break;
 	default:
 		pr_cont("unknown type %d", ctrl->type);
 		break;
@@ -1346,6 +1352,8 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
 	case V4L2_CTRL_TYPE_U16:
 		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
+	case V4L2_CTRL_TYPE_POINT:
+		return 0;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = !!ptr.p_s32[idx];
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 8c4edd6..41ea629 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -42,6 +42,7 @@ struct poll_table_struct;
  * @p_u8:	Pointer to a 8-bit unsigned value.
  * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_char:	Pointer to a string.
+ * @p_pint:Pointer to a v4l2_point structure.
  * @p:		Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -50,6 +51,7 @@ union v4l2_ctrl_ptr {
 	u8 *p_u8;
 	u16 *p_u16;
 	char *p_char;
+	struct v4l2_point *p_point;
 	void *p;
 };
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5fd4202..6d5a2e1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -218,6 +218,11 @@ struct v4l2_rect {
 	__u32   height;
 };
 
+struct v4l2_point {
+	__u32   x;
+	__u32   y;
+};
+
 struct v4l2_fract {
 	__u32   numerator;
 	__u32   denominator;
@@ -1288,6 +1293,7 @@ struct v4l2_ext_control {
 		char *string;
 		__u8 *p_u8;
 		__u16 *p_u16;
+		struct v4l2_point *p_point;
 		void *ptr;
 	};
 } __attribute__ ((packed));
@@ -1320,6 +1326,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_COMPOUND_TYPES     = 0x0100,
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
+	V4L2_CTRL_TYPE_POINT	     = 0x0102,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.0.1

