Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:28691 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2HJLVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:21:33 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Subject: [RFCv3 PATCH 3/8] v4l2-subdev: add support for the new edid ioctls.
Date: Fri, 10 Aug 2012 13:21:19 +0200
Message-Id: <1c192a606143bbe1fb56fe02ffd5715e6592b3b6.1344592468.git.hans.verkuil@cisco.com>
In-Reply-To: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
References: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
References: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |   57 +++++++++++++++++++++++++++++
 drivers/media/video/v4l2-ioctl.c          |   13 +++++++
 drivers/media/video/v4l2-subdev.c         |    6 +++
 include/media/v4l2-subdev.h               |    2 +
 4 files changed, 78 insertions(+)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 9ebd5c5..e843705 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -16,6 +16,7 @@
 #include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/videodev2.h>
+#include <linux/v4l2-subdev.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 
@@ -729,6 +730,44 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 	return 0;
 }
 
+struct v4l2_subdev_edid32 {
+	__u32 pad;
+	__u32 start_block;
+	__u32 blocks;
+	__u32 reserved[5];
+	compat_caddr_t edid;
+};
+
+static int get_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subdev_edid32 __user *up)
+{
+	u32 tmp;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_subdev_edid32)) ||
+		get_user(kp->pad, &up->pad) ||
+		get_user(kp->start_block, &up->start_block) ||
+		get_user(kp->blocks, &up->blocks) ||
+		get_user(tmp, &up->edid) ||
+		copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+			return -EFAULT;
+	kp->edid = compat_ptr(tmp);
+	return 0;
+}
+
+static int put_v4l2_subdev_edid32(struct v4l2_subdev_edid *kp, struct v4l2_subdev_edid32 __user *up)
+{
+	u32 tmp = (u32)((unsigned long)kp->edid);
+
+	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_subdev_edid32)) ||
+		put_user(kp->pad, &up->pad) ||
+		put_user(kp->start_block, &up->start_block) ||
+		put_user(kp->blocks, &up->blocks) ||
+		put_user(tmp, &up->edid) ||
+		copy_to_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+			return -EFAULT;
+	return 0;
+}
+
+
 #define VIDIOC_G_FMT32		_IOWR('V',  4, struct v4l2_format32)
 #define VIDIOC_S_FMT32		_IOWR('V',  5, struct v4l2_format32)
 #define VIDIOC_QUERYBUF32	_IOWR('V',  9, struct v4l2_buffer32)
@@ -738,6 +777,8 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 #define VIDIOC_DQBUF32		_IOWR('V', 17, struct v4l2_buffer32)
 #define VIDIOC_ENUMSTD32	_IOWR('V', 25, struct v4l2_standard32)
 #define VIDIOC_ENUMINPUT32	_IOWR('V', 26, struct v4l2_input32)
+#define VIDIOC_SUBDEV_G_EDID32	_IOWR('V', 63, struct v4l2_subdev_edid32)
+#define VIDIOC_SUBDEV_S_EDID32	_IOWR('V', 64, struct v4l2_subdev_edid32)
 #define VIDIOC_TRY_FMT32      	_IOWR('V', 64, struct v4l2_format32)
 #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
 #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
@@ -765,6 +806,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		struct v4l2_ext_controls v2ecs;
 		struct v4l2_event v2ev;
 		struct v4l2_create_buffers v2crt;
+		struct v4l2_subdev_edid v2edid;
 		unsigned long vx;
 		int vi;
 	} karg;
@@ -797,6 +839,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
 	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
 	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
+	case VIDIOC_SUBDEV_G_EDID32: cmd = VIDIOC_SUBDEV_G_EDID; break;
+	case VIDIOC_SUBDEV_S_EDID32: cmd = VIDIOC_SUBDEV_S_EDID; break;
 	}
 
 	switch (cmd) {
@@ -814,6 +858,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
+	case VIDIOC_SUBDEV_G_EDID:
+	case VIDIOC_SUBDEV_S_EDID:
+		err = get_v4l2_subdev_edid32(&karg.v2edid, up);
+		compatible_arg = 0;
+		break;
+
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
@@ -906,6 +956,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		err = put_v4l2_event32(&karg.v2ev, up);
 		break;
 
+	case VIDIOC_SUBDEV_G_EDID:
+	case VIDIOC_SUBDEV_S_EDID:
+		err = put_v4l2_subdev_edid32(&karg.v2edid, up);
+		break;
+
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
@@ -1026,6 +1081,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_QUERY_DV_TIMINGS:
 	case VIDIOC_DV_TIMINGS_CAP:
 	case VIDIOC_ENUM_FREQ_BANDS:
+	case VIDIOC_SUBDEV_G_EDID32:
+	case VIDIOC_SUBDEV_S_EDID32:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index c3b7b5f..1400f98 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2185,6 +2185,19 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		break;
 	}
 
+	case VIDIOC_SUBDEV_G_EDID:
+	case VIDIOC_SUBDEV_S_EDID: {
+		struct v4l2_subdev_edid *edid = parg;
+
+		if (edid->blocks) {
+			*user_ptr = (void __user *)edid->edid;
+			*kernel_ptr = (void *)&edid->edid;
+			*array_size = edid->blocks * 128;
+			ret = 1;
+		}
+		break;
+	}
+
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS: {
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 9182f81..dced41c 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -348,6 +348,12 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh, sel);
 	}
+
+	case VIDIOC_SUBDEV_G_EDID:
+		return v4l2_subdev_call(sd, pad, get_edid, arg);
+
+	case VIDIOC_SUBDEV_S_EDID:
+		return v4l2_subdev_call(sd, pad, set_edid, arg);
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c35a354..74c578f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -476,6 +476,8 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
+	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
+	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
 			     struct v4l2_subdev_format *source_fmt,
-- 
1.7.10.4

