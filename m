Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3179 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161374Ab3BOMzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/10] au0828: convert to the control framework.
Date: Fri, 15 Feb 2013 13:55:09 +0100
Message-Id: <ee2066add82356ded9c2a017e4faf22d76bbeb4e.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-core.c  |   15 ++++++++++--
 drivers/media/usb/au0828/au0828-video.c |   39 ++-----------------------------
 drivers/media/usb/au0828/au0828.h       |    2 ++
 3 files changed, 17 insertions(+), 39 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1e6f40e..ffd3bcb 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -143,6 +143,7 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_i2c_unregister(dev);
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
+	v4l2_ctrl_handler_free(&dev->v4l2_ctrl_hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
 #endif
 
@@ -205,12 +206,22 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	/* Create the v4l2_device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
-		printk(KERN_ERR "%s() v4l2_device_register failed\n",
+		pr_err("%s() v4l2_device_register failed\n",
 		       __func__);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
-		return -EIO;
+		return retval;
 	}
+	/* This control handler will inherit the controls from au8522 */
+	retval = v4l2_ctrl_handler_init(&dev->v4l2_ctrl_hdl, 4);
+	if (retval) {
+		pr_err("%s() v4l2_ctrl_handler_init failed\n",
+		       __func__);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return retval;
+	}
+	dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;
 #endif
 
 	/* Power Up the bridge */
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index e4a24fa..7d762c0 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1226,18 +1226,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 }
 
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, queryctrl, qc);
-	if (qc->type)
-		return 0;
-	else
-		return -EINVAL;
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
@@ -1495,26 +1483,6 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 	return 0;
 }
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_ctrl, ctrl);
-	return 0;
-
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
-	return 0;
-}
-
 static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct au0828_fh *fh = priv;
@@ -1904,9 +1872,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input          = vidioc_enum_input,
 	.vidioc_g_input             = vidioc_g_input,
 	.vidioc_s_input             = vidioc_s_input,
-	.vidioc_queryctrl           = vidioc_queryctrl,
-	.vidioc_g_ctrl              = vidioc_g_ctrl,
-	.vidioc_s_ctrl              = vidioc_s_ctrl,
 	.vidioc_streamon            = vidioc_streamon,
 	.vidioc_streamoff           = vidioc_streamoff,
 	.vidioc_g_tuner             = vidioc_g_tuner,
@@ -2012,13 +1977,13 @@ int au0828_analog_register(struct au0828_dev *dev,
 
 	/* Fill the video capture device struct */
 	*dev->vdev = au0828_video_template;
-	dev->vdev->parent = &dev->usbdev->dev;
+	dev->vdev->v4l2_dev = &dev->v4l2_dev;
 	dev->vdev->lock = &dev->lock;
 	strcpy(dev->vdev->name, "au0828a video");
 
 	/* Setup the VBI device */
 	*dev->vbi_dev = au0828_video_template;
-	dev->vbi_dev->parent = &dev->usbdev->dev;
+	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
 	dev->vbi_dev->lock = &dev->lock;
 	strcpy(dev->vbi_dev->name, "au0828a vbi");
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index e579ff6..803af10 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -28,6 +28,7 @@
 #include <linux/videodev2.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 /* DVB */
 #include "demux.h"
@@ -202,6 +203,7 @@ struct au0828_dev {
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	/* Analog */
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler v4l2_ctrl_hdl;
 #endif
 	int users;
 	unsigned int resources;	/* resources in use */
-- 
1.7.10.4

