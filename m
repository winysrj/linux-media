Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1161 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0EPNTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 09:19:33 -0400
Message-Id: <152cc3bfe55af1b902aec7fe4529f0f0468d8d05.1274015085.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1274015084.git.hverkuil@xs4all.nl>
References: <cover.1274015084.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 16 May 2010 15:21:03 +0200
Subject: [PATCH 04/15] [RFCv2] v4l2: hook up the new control framework into the core framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the calls needed to automatically merge subdev controls into a bridge
control handler.

Hook up the control framework in __video_ioctl2 and video_register_device.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c    |    8 +++++-
 drivers/media/video/v4l2-device.c |    7 +++++
 drivers/media/video/v4l2-ioctl.c  |   46 ++++++++++++++++++++++++++----------
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7ec9..773ffe1 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -447,8 +447,12 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 
 	vdev->vfl_type = type;
 	vdev->cdev = NULL;
-	if (vdev->v4l2_dev && vdev->v4l2_dev->dev)
-		vdev->parent = vdev->v4l2_dev->dev;
+	if (vdev->v4l2_dev) {
+		if (vdev->v4l2_dev->dev)
+			vdev->parent = vdev->v4l2_dev->dev;
+		if (vdev->ctrl_handler == NULL)
+			vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
+	}
 
 	/* Part 2: find a free minor, device node number and device index. */
 #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 5a7dc4a..0b08f96 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -26,6 +26,7 @@
 #endif
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 {
@@ -115,6 +116,8 @@ EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 						struct v4l2_subdev *sd)
 {
+	int err;
+
 	/* Check for valid input */
 	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
 		return -EINVAL;
@@ -122,6 +125,10 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	WARN_ON(sd->v4l2_dev != NULL);
 	if (!try_module_get(sd->owner))
 		return -ENODEV;
+	/* This just returns 0 if either of the two args is NULL */
+	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
+	if (err)
+		return err;
 	sd->v4l2_dev = v4l2_dev;
 	spin_lock(&v4l2_dev->lock);
 	list_add_tail(&sd->list, &v4l2_dev->subdevs);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 0395b1c..94776c3 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -25,6 +25,7 @@
 #endif
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
@@ -1258,9 +1259,12 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_queryctrl *p = arg;
 
-		if (!ops->vidioc_queryctrl)
+		if (vfd->ctrl_handler)
+			ret = v4l2_queryctrl(vfd->ctrl_handler, p);
+		else if (ops->vidioc_queryctrl)
+			ret = ops->vidioc_queryctrl(file, fh, p);
+		else
 			break;
-		ret = ops->vidioc_queryctrl(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "id=0x%x, type=%d, name=%s, min/max=%d/%d, "
 					"step=%d, default=%d, flags=0x%08x\n",
@@ -1275,7 +1279,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_control *p = arg;
 
-		if (ops->vidioc_g_ctrl)
+		if (vfd->ctrl_handler)
+			ret = v4l2_g_ctrl(vfd->ctrl_handler, p);
+		else if (ops->vidioc_g_ctrl)
 			ret = ops->vidioc_g_ctrl(file, fh, p);
 		else if (ops->vidioc_g_ext_ctrls) {
 			struct v4l2_ext_controls ctrls;
@@ -1305,11 +1311,16 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls ctrls;
 		struct v4l2_ext_control ctrl;
 
-		if (!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
+		if (!vfd->ctrl_handler &&
+			!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
 			break;
 
 		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 
+		if (vfd->ctrl_handler) {
+			ret = v4l2_s_ctrl(vfd->ctrl_handler, p);
+			break;
+		}
 		if (ops->vidioc_s_ctrl) {
 			ret = ops->vidioc_s_ctrl(file, fh, p);
 			break;
@@ -1331,10 +1342,12 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!ops->vidioc_g_ext_ctrls)
-			break;
-		if (check_ext_ctrls(p, 0))
+		if (vfd->ctrl_handler)
+			ret = v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
+		else if (ops->vidioc_g_ext_ctrls && check_ext_ctrls(p, 0))
 			ret = ops->vidioc_g_ext_ctrls(file, fh, p);
+		else
+			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, !ret);
 		break;
 	}
@@ -1343,10 +1356,12 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!ops->vidioc_s_ext_ctrls)
+		if (!vfd->ctrl_handler && !ops->vidioc_s_ext_ctrls)
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (check_ext_ctrls(p, 0))
+		if (vfd->ctrl_handler)
+			ret = v4l2_s_ext_ctrls(vfd->ctrl_handler, p);
+		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
 		break;
 	}
@@ -1355,10 +1370,12 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!ops->vidioc_try_ext_ctrls)
+		if (!vfd->ctrl_handler && !ops->vidioc_try_ext_ctrls)
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (check_ext_ctrls(p, 0))
+		if (vfd->ctrl_handler)
+			ret = v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
+		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_try_ext_ctrls(file, fh, p);
 		break;
 	}
@@ -1366,9 +1383,12 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_querymenu *p = arg;
 
-		if (!ops->vidioc_querymenu)
+		if (vfd->ctrl_handler)
+			ret = v4l2_querymenu(vfd->ctrl_handler, p);
+		else if (ops->vidioc_querymenu)
+			ret = ops->vidioc_querymenu(file, fh, p);
+		else
 			break;
-		ret = ops->vidioc_querymenu(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "id=0x%x, index=%d, name=%s\n",
 				p->id, p->index, p->name);
-- 
1.6.4.2

