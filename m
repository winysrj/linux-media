Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58153 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1BNMVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v7 5/6] v4l: subdev: Control ioctls support
Date: Mon, 14 Feb 2011 13:20:58 +0100
Message-Id: <1297686059-9622-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Pass the control-related ioctls to the subdev driver through the control
framework.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |   16 ++++++++++++++++
 drivers/media/video/v4l2-subdev.c            |   25 +++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 8b35871..1feecfc 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -334,6 +334,22 @@ for all registered sub-devices marked with V4L2_SUBDEV_FL_HAS_DEVNODE by calling
 v4l2_device_register_subdev_nodes(). Those device nodes will be automatically
 removed when sub-devices are unregistered.
 
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
index 6cf7664..2fbc9cb 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -24,6 +24,7 @@
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
@@ -39,7 +40,31 @@ static int subdev_close(struct file *file)
 
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
1.7.3.4

