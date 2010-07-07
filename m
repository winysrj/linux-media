Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50317 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0GGLxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 07:53:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 4/6] v4l: subdev: Control ioctls support
Date: Wed,  7 Jul 2010 13:53:26 +0200
Message-Id: <1278503608-9126-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass the control-related ioctls to the subdev driver through the core
operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |   24 ++++++++++++++++++++++++
 drivers/media/video/v4l2-subdev.c            |   24 ++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index e831aac..f315858 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -314,6 +314,30 @@ controlled through GPIO pins. This distinction is only relevant when setting
 up the device, but once the subdev is registered it is completely transparent.
 
 
+V4L2 sub-device userspace API
+-----------------------------
+
+Beside exposing a kernel API through the v4l2_subdev_ops structure, V4L2
+sub-devices can also be controlled directly by userspace applications.
+
+When a sub-device is registered, a device node named subdevX is created in /dev.
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
+
 I2C sub-device drivers
 ----------------------
 
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index a3672f0..141098b 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -43,7 +43,31 @@ static int subdev_close(struct file *file)
 
 static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+
 	switch (cmd) {
+	case VIDIOC_QUERYCTRL:
+		return v4l2_subdev_call(sd, core, queryctrl, arg);
+
+	case VIDIOC_QUERYMENU:
+		return v4l2_subdev_call(sd, core, querymenu, arg);
+
+	case VIDIOC_G_CTRL:
+		return v4l2_subdev_call(sd, core, g_ctrl, arg);
+
+	case VIDIOC_S_CTRL:
+		return v4l2_subdev_call(sd, core, s_ctrl, arg);
+
+	case VIDIOC_G_EXT_CTRLS:
+		return v4l2_subdev_call(sd, core, g_ext_ctrls, arg);
+
+	case VIDIOC_S_EXT_CTRLS:
+		return v4l2_subdev_call(sd, core, s_ext_ctrls, arg);
+
+	case VIDIOC_TRY_EXT_CTRLS:
+		return v4l2_subdev_call(sd, core, try_ext_ctrls, arg);
+
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.7.1

