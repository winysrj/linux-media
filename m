Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40685 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab0GIPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 11:32:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 5/7] v4l: subdev: Control ioctls support
Date: Fri,  9 Jul 2010 17:31:50 +0200
Message-Id: <1278689512-30849-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass the control-related ioctls to the subdev driver through the core
operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |   16 ++++++++++++++++
 drivers/media/video/v4l2-subdev.c            |   24 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 164bb0f..9c3f33c 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -331,6 +331,22 @@ argument to 0. Setting the argument to 1 will only enable device node
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
index 37142ae..0ebd760 100644
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

