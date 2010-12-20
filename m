Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34479 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0LTLgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:36:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 6/7] v4l: subdev: Control ioctls support
Date: Mon, 20 Dec 2010 12:35:55 +0100
Message-Id: <1292844956-7853-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292844956-7853-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292844956-7853-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Pass the control-related ioctls to the subdev driver through the control
framework.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |   16 ++++++++++++++++
 drivers/media/video/v4l2-subdev.c            |   25 +++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 4c9185a..f683f63 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -336,6 +336,22 @@ argument to 0. Setting the argument to 1 will only enable device node
 registration if the sub-device driver has set the V4L2_SUBDEV_FL_HAS_DEVNODE
 flag.
 
+The device node handles a subset of the V4L2 API.
+
+VIDIOC_QUERYCTRL
+VIDIOC_QUERYMENU
+VIDIOC_G_CTRL
+VIDIOC_S_CTRL
+VIDIOC_G_EXT_CTRLS
+VIDIOC_S_EXT_CTRLS
+VIDIOC_TRY_EXT_CTRLS
+
+	The controls ioctls are identical to the ones defined in V4L2. They
+	behave identically, with the only exception that they deal only with
+	controls implemented in the sub-device. Depending on the driver, those
+	controls can be also be accessed through one (or several) V4L2 device
+	nodes.
+
 
 I2C sub-device drivers
 ----------------------
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 0deff78..fc57ce7 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -24,6 +24,7 @@
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
@@ -45,7 +46,31 @@ static int subdev_close(struct file *file)
 
 static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+
 	switch (cmd) {
+	case VIDIOC_QUERYCTRL:
+		return v4l2_subdev_queryctrl(sd, arg);
+
+	case VIDIOC_QUERYMENU:
+		return v4l2_subdev_querymenu(sd, arg);
+
+	case VIDIOC_G_CTRL:
+		return v4l2_subdev_g_ctrl(sd, arg);
+
+	case VIDIOC_S_CTRL:
+		return v4l2_subdev_s_ctrl(sd, arg);
+
+	case VIDIOC_G_EXT_CTRLS:
+		return v4l2_subdev_g_ext_ctrls(sd, arg);
+
+	case VIDIOC_S_EXT_CTRLS:
+		return v4l2_subdev_s_ext_ctrls(sd, arg);
+
+	case VIDIOC_TRY_EXT_CTRLS:
+		return v4l2_subdev_try_ext_ctrls(sd, arg);
+
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.7.2.2

