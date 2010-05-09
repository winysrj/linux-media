Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2000 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0EIT1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:48 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JRk4d034686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <efc9985d3c9d015f783adf87338244a3b17c6dd4.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
References: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:22 +0200
Subject: [PATCH 5/7] [RFC] v4l2-ioctl: add priority handling support.
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers that use either v4l2_fh or don't use filehandles at all can now
use the core framework support of g/s_priority.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ioctl.c |   64 ++++++++++++++++++++++++++++++++++---
 1 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 0395b1c..f928f80 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 
 #define dbgarg(cmd, fmt, arg...) \
@@ -611,6 +612,7 @@ static long __video_do_ioctl(struct file *file,
 {
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
+	enum v4l2_priority prio = V4L2_PRIORITY_UNSET;
 	void *fh = file->private_data;
 	long ret = -EINVAL;
 
@@ -640,6 +642,40 @@ static long __video_do_ioctl(struct file *file,
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
+			ret = v4l2_prio_check(&vfd->v4l2_dev->prio, prio);
+			if (ret)
+				goto exit_prio;
+			break;
+		}
+	}
+
 	switch (cmd) {
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -689,9 +725,14 @@ static long __video_do_ioctl(struct file *file,
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
@@ -700,10 +741,20 @@ static long __video_do_ioctl(struct file *file,
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
 
@@ -2010,6 +2061,7 @@ static long __video_do_ioctl(struct file *file,
 	}
 	} /* switch */
 
+exit_prio:
 	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
 		if (ret < 0) {
 			v4l_print_ioctl(vfd->name, cmd);
-- 
1.6.4.2

