Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1IQJ1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 05:27:21 -0400
From: Martin Hostettler <martin@neutronstar.dyndns.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH] v4l subdev: add dispatching for VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER.
Date: Sat, 17 Sep 2011 11:26:36 +0200
Message-Id: <1316251596-32073-1-git-send-email-martin@neutronstar.dyndns.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ioctls on the subdevs node currently don't dispatch the register access debug driver callbacks. Add
the dispatching with the same security checks are for non subdev video nodes
(i.e. only capable(CAP_SYS_ADMIN may call the register access ioctls).
---
 drivers/media/video/v4l2-subdev.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index b7967c9..8bf8397 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -173,6 +174,25 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	case VIDIOC_DBG_G_REGISTER:
+	{
+		struct v4l2_dbg_register *p = arg;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return v4l2_subdev_call(sd, core, g_register, p);
+	}
+	case VIDIOC_DBG_S_REGISTER:
+	{
+		struct v4l2_dbg_register *p = arg;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return v4l2_subdev_call(sd, core, s_register, p);
+	}
+#endif
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	case VIDIOC_SUBDEV_G_FMT: {
 		struct v4l2_subdev_format *format = arg;
-- 
1.7.2.5

