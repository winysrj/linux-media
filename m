Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:41001 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3HWMPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 08:15:35 -0400
Message-ID: <52175262.3040702@cisco.com>
Date: Fri, 23 Aug 2013 14:15:30 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com
Subject: [RFCv4 PATCH] v4l2-compat-ioctl32: add g/s_matrix support.
References: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl> <8b4d154fc2351c7c1f2999bfec665011dd0afdb9.1377166147.git.hans.verkuil@cisco.com>
In-Reply-To: <8b4d154fc2351c7c1f2999bfec665011dd0afdb9.1377166147.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update of RFCv3 PATCH 03/10 from the "Matrix and Motion Detection support"
patch series. This time I've actually tested it, and as a bonus found a
bug in the G/S_SUBDEV_EDID32 handling as well.

Regards,

	Hans

[PATCH] v4l2-compat-ioctl32: add g/s_matrix support.

Also fix a copy_to_user bug in put_v4l2_subdev_edid32(): the user and kernel
pointers were used the wrong way around.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   50 ++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..8fb3e86 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -772,11 +772,40 @@ static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subde
 		put_user(kp->start_block, &up->start_block) ||
 		put_user(kp->blocks, &up->blocks) ||
 		put_user(tmp, &up->edid) ||
-		copy_to_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+		copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
 			return -EFAULT;
 	return 0;
 }
 
+struct v4l2_matrix32 {
+	__u32 type;
+	struct v4l2_rect rect;
+	compat_caddr_t matrix;
+	__u32 reserved[16];
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
+	    copy_to_user(&up->rect, &kp->rect, sizeof(up->rect)) ||
+	    copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+		return -EFAULT;
+	return 0;
+}
 
 #define VIDIOC_G_FMT32		_IOWR('V',  4, struct v4l2_format32)
 #define VIDIOC_S_FMT32		_IOWR('V',  5, struct v4l2_format32)
@@ -796,6 +825,8 @@ static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subde
 #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
 #define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
 #define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
+#define VIDIOC_G_MATRIX32	_IOWR('V', 104, struct v4l2_matrix32)
+#define VIDIOC_S_MATRIX32	_IOWR('V', 105, struct v4l2_matrix32)
 
 #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
 #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
@@ -817,6 +848,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		struct v4l2_event v2ev;
 		struct v4l2_create_buffers v2crt;
 		struct v4l2_subdev_edid v2edid;
+		struct v4l2_matrix v2matrix;
 		unsigned long vx;
 		int vi;
 	} karg;
@@ -851,6 +883,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
 	case VIDIOC_SUBDEV_G_EDID32: cmd = VIDIOC_SUBDEV_G_EDID; break;
 	case VIDIOC_SUBDEV_S_EDID32: cmd = VIDIOC_SUBDEV_S_EDID; break;
+	case VIDIOC_G_MATRIX32: cmd = VIDIOC_G_MATRIX; break;
+	case VIDIOC_S_MATRIX32: cmd = VIDIOC_S_MATRIX; break;
 	}
 
 	switch (cmd) {
@@ -922,6 +956,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
@@ -994,6 +1034,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
@@ -1089,6 +1134,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_ENUM_FREQ_BANDS:
 	case VIDIOC_SUBDEV_G_EDID32:
 	case VIDIOC_SUBDEV_S_EDID32:
+	case VIDIOC_QUERY_MATRIX:
+	case VIDIOC_G_MATRIX32:
+	case VIDIOC_S_MATRIX32:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
-- 
1.7.10.4

