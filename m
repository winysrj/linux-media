Return-path: <mchehab@gaivota>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3473 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0L2VnW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:22 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhHPw002076
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:21 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <47c90822adbd700c3cfa616ccb425d37b46c5d4d.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:17 +0100
Subject: [PATCH 05/10] [RFC] v4l2-ioctl: add priority handling support.
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Drivers that use either v4l2_fh or don't use filehandles at all can now
use the core framework support of g/s_priority.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-si4713.c         |    3 +-
 drivers/media/video/cx18/cx18-ioctl.c      |    3 +-
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c      |    3 +-
 drivers/media/video/meye.c                 |    3 +-
 drivers/media/video/mxb.c                  |    3 +-
 drivers/media/video/v4l2-ioctl.c           |   73 +++++++++++++++++++++++++---
 include/media/v4l2-ioctl.h                 |    2 +-
 8 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 726d367..444b4cf 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -224,7 +224,8 @@ static int radio_si4713_s_frequency(struct file *file, void *p,
 							s_frequency, vf);
 }
 
-static long radio_si4713_default(struct file *file, void *p, int cmd, void *arg)
+static long radio_si4713_default(struct file *file, void *p,
+				bool valid_prio, int cmd, void *arg)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
 							ioctl, cmd, arg);
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 7150195..6b5bb3e 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -1056,7 +1056,8 @@ static int cx18_log_status(struct file *file, void *fh)
 	return 0;
 }
 
-static long cx18_default(struct file *file, void *fh, int cmd, void *arg)
+static long cx18_default(struct file *file, void *fh, bool valid_prio,
+							int cmd, void *arg)
 {
 	struct cx18 *cx = ((struct cx18_open_id *)fh)->cx;
 
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 353eada..71e961e 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1719,7 +1719,7 @@ unlock_out:
 
 
 static long vpfe_param_handler(struct file *file, void *priv,
-		int cmd, void *param)
+		bool valid_prio, int cmd, void *param)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	int ret = 0;
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index b686da5..d9386a7 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1795,7 +1795,8 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	return 0;
 }
 
-static long ivtv_default(struct file *file, void *fh, int cmd, void *arg)
+static long ivtv_default(struct file *file, void *fh, bool valid_prio,
+						int cmd, void *arg)
 {
 	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
 
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index 48d2c24..b09a3c8 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1547,7 +1547,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 	return 0;
 }
 
-static long vidioc_default(struct file *file, void *fh, int cmd, void *arg)
+static long vidioc_default(struct file *file, void *fh, bool valid_prio,
+						int cmd, void *arg)
 {
 	switch (cmd) {
 	case MEYEIOC_G_PARAMS:
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 4e8fd96..507bed2 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -643,7 +643,8 @@ static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_regist
 }
 #endif
 
-static long vidioc_default(struct file *file, void *fh, int cmd, void *arg)
+static long vidioc_default(struct file *file, void *fh, bool valid_prio,
+							int cmd, void *arg)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 7e47f15..d682a4c 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -25,6 +25,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 
 #define dbgarg(cmd, fmt, arg...) \
@@ -564,6 +565,7 @@ static long __video_do_ioctl(struct file *file,
 {
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
+	enum v4l2_priority prio = V4L2_PRIORITY_UNSET;
 	void *fh = file->private_data;
 	long ret = -EINVAL;
 
@@ -579,6 +581,43 @@ static long __video_do_ioctl(struct file *file,
 		printk(KERN_CONT "\n");
 	}
 
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
+		prio = ((struct v4l2_fh *)fh)->prio;
+	else if (test_bit(V4L2_FL_USES_V4L2_PRIO, &vfd->flags))
+		prio = (enum v4l2_priority)fh;
+	if (prio != V4L2_PRIORITY_UNSET) {
+		switch (cmd) {
+		case VIDIOC_S_CTRL:
+		case VIDIOC_S_STD:
+		case VIDIOC_S_INPUT:
+		case VIDIOC_S_OUTPUT:
+		case VIDIOC_S_TUNER:
+		case VIDIOC_S_FREQUENCY:
+		case VIDIOC_S_FMT:
+		case VIDIOC_S_CROP:
+		case VIDIOC_S_AUDIO:
+		case VIDIOC_S_AUDOUT:
+		case VIDIOC_S_EXT_CTRLS:
+		case VIDIOC_S_FBUF:
+		case VIDIOC_S_PRIORITY:
+		case VIDIOC_S_DV_PRESET:
+		case VIDIOC_S_DV_TIMINGS:
+		case VIDIOC_S_JPEGCOMP:
+		case VIDIOC_S_MODULATOR:
+		case VIDIOC_S_PARM:
+		case VIDIOC_S_HW_FREQ_SEEK:
+		case VIDIOC_ENCODER_CMD:
+		case VIDIOC_OVERLAY:
+		case VIDIOC_REQBUFS:
+		case VIDIOC_STREAMON:
+		case VIDIOC_STREAMOFF:
+			ret = v4l2_prio_check(vfd->prio, prio);
+			if (ret)
+				goto exit_prio;
+			break;
+		}
+	}
+
 	switch (cmd) {
 
 	/* --- capabilities ------------------------------------------ */
@@ -605,9 +644,14 @@ static long __video_do_ioctl(struct file *file,
 	{
 		enum v4l2_priority *p = arg;
 
-		if (!ops->vidioc_g_priority)
-			break;
-		ret = ops->vidioc_g_priority(file, fh, p);
+		if (!ops->vidioc_g_priority) {
+			if (prio == V4L2_PRIORITY_UNSET)
+				break;
+			*p = v4l2_prio_max(&vfd->v4l2_dev->prio);
+			ret = 0;
+		} else {
+			ret = ops->vidioc_g_priority(file, fh, p);
+		}
 		if (!ret)
 			dbgarg(cmd, "priority is %d\n", *p);
 		break;
@@ -616,10 +660,20 @@ static long __video_do_ioctl(struct file *file,
 	{
 		enum v4l2_priority *p = arg;
 
-		if (!ops->vidioc_s_priority)
-			break;
+		if (!ops->vidioc_s_priority && prio == V4L2_PRIORITY_UNSET)
+				break;
 		dbgarg(cmd, "setting priority to %d\n", *p);
-		ret = ops->vidioc_s_priority(file, fh, *p);
+		if (ops->vidioc_s_priority) {
+			ret = ops->vidioc_s_priority(file, fh, *p);
+		} else {
+			ret = v4l2_prio_change(&vfd->v4l2_dev->prio, &prio, *p);
+			if (!ret) {
+				if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
+					((struct v4l2_fh *)fh)->prio = prio;
+				else
+					file->private_data = (void *)prio;
+			}
+		}
 		break;
 	}
 
@@ -1938,13 +1992,18 @@ static long __video_do_ioctl(struct file *file,
 	}
 	default:
 	{
+		bool valid_prio = true;
+
 		if (!ops->vidioc_default)
 			break;
-		ret = ops->vidioc_default(file, fh, cmd, arg);
+		if (prio != V4L2_PRIORITY_UNSET)
+			valid_prio = v4l2_prio_check(vfd->prio, prio) >= 0;
+		ret = ops->vidioc_default(file, fh, valid_prio, cmd, arg);
 		break;
 	}
 	} /* switch */
 
+exit_prio:
 	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
 		if (ret < 0) {
 			v4l_print_ioctl(vfd->name, cmd);
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 67df375..4d6303b 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -254,7 +254,7 @@ struct v4l2_ioctl_ops {
 
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
-					int cmd, void *arg);
+					bool valid_prio, int cmd, void *arg);
 };
 
 
-- 
1.6.4.2

