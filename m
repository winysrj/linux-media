Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3614 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3HVKOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:14:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 03/10] v4l2-compat-ioctl32: add g/s_matrix support.
Date: Thu, 22 Aug 2013 12:14:17 +0200
Message-Id: <8b4d154fc2351c7c1f2999bfec665011dd0afdb9.1377166147.git.hans.verkuil@cisco.com>
In-Reply-To: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
References: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
References: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 49 +++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..3e5a30f 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -777,6 +777,38 @@ static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subde
 	return 0;
 }
 
+struct v4l2_matrix32 {
+	__u32 type;
+	union {
+		__u32 raw[4];
+	} ref;
+	struct v4l2_rect rect;
+	compat_caddr_t matrix;
+	__u32 reserved[12];
+} __attribute__ ((packed));
+
+static int get_v4l2_matrix32(struct v4l2_matrix *kp, struct v4l2_matrix32 __user *up)
+{
+	u32 tmp;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_matrix32)) ||
+	    get_user(kp->type, &up->type) ||
+	    copy_from_user(&kp->rect, &up->rect, sizeof(up->rect)) ||
+	    get_user(tmp, &up->matrix) ||
+	    copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+		return -EFAULT;
+	kp->matrix = compat_ptr(tmp);
+	return 0;
+}
+
+static int put_v4l2_matrix32(struct v4l2_matrix *kp, struct v4l2_matrix32 __user *up)
+{
+	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_matrix32)) ||
+	    copy_to_user(&kp->rect, &up->rect, sizeof(kp->rect)) ||
+	    copy_to_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+		return -EFAULT;
+	return 0;
+}
 
 #define VIDIOC_G_FMT32		_IOWR('V',  4, struct v4l2_format32)
 #define VIDIOC_S_FMT32		_IOWR('V',  5, struct v4l2_format32)
@@ -796,6 +828,8 @@ static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subde
 #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
 #define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
 #define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
+#define VIDIOC_G_MATRIX32	_IOWR('V', 104, struct v4l2_matrix32)
+#define VIDIOC_S_MATRIX32	_IOWR('V', 105, struct v4l2_matrix32)
 
 #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
 #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
@@ -817,6 +851,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		struct v4l2_event v2ev;
 		struct v4l2_create_buffers v2crt;
 		struct v4l2_subdev_edid v2edid;
+		struct v4l2_matrix v2matrix;
 		unsigned long vx;
 		int vi;
 	} karg;
@@ -851,6 +886,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
 	case VIDIOC_SUBDEV_G_EDID32: cmd = VIDIOC_SUBDEV_G_EDID; break;
 	case VIDIOC_SUBDEV_S_EDID32: cmd = VIDIOC_SUBDEV_S_EDID; break;
+	case VIDIOC_G_MATRIX32: cmd = VIDIOC_G_MATRIX; break;
+	case VIDIOC_S_MATRIX32: cmd = VIDIOC_S_MATRIX; break;
 	}
 
 	switch (cmd) {
@@ -922,6 +959,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_DQEVENT:
 		compatible_arg = 0;
 		break;
+
+	case VIDIOC_G_MATRIX:
+	case VIDIOC_S_MATRIX:
+		err = get_v4l2_matrix32(&karg.v2matrix, up);
+		compatible_arg = 0;
+		break;
 	}
 	if (err)
 		return err;
@@ -994,6 +1037,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_ENUMINPUT:
 		err = put_v4l2_input32(&karg.v2i, up);
 		break;
+
+	case VIDIOC_G_MATRIX:
+	case VIDIOC_S_MATRIX:
+		err = put_v4l2_matrix32(&karg.v2matrix, up);
+		break;
 	}
 	return err;
 }
@@ -1089,6 +1137,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_ENUM_FREQ_BANDS:
 	case VIDIOC_SUBDEV_G_EDID32:
 	case VIDIOC_SUBDEV_S_EDID32:
+	case VIDIOC_QUERY_MATRIX:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
-- 
1.8.3.2

