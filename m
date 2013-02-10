Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4621 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab3BJRxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/12] stk-webcam: add support for control events and prio handling.
Date: Sun, 10 Feb 2013 18:52:47 +0100
Message-Id: <3fecfbda3c462bf6c427ea30fe4e832aaf9d6f47.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Also correct the first_init static: this should be part of the stk_camera struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   27 +++++++++++++++++----------
 drivers/media/usb/stkwebcam/stk-webcam.h |    1 +
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 05fb48a..272e1a2 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -35,6 +35,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 
 #include "stk-webcam.h"
 
@@ -565,20 +566,21 @@ static void stk_free_buffers(struct stk_camera *dev)
 
 static int v4l_stk_open(struct file *fp)
 {
-	static int first_init = 1; /* webcam LED management */
 	struct stk_camera *dev = video_drvdata(fp);
+	int err;
 
 	if (dev == NULL || !is_present(dev))
 		return -ENXIO;
 
-	if (!first_init)
+	if (!dev->first_init)
 		stk_camera_write_reg(dev, 0x0, 0x24);
 	else
-		first_init = 0;
-
-	usb_autopm_get_interface(dev->interface);
+		dev->first_init = 0;
 
-	return 0;
+	err = v4l2_fh_open(fp);
+	if (!err)
+		usb_autopm_get_interface(dev->interface);
+	return err;
 }
 
 static int v4l_stk_release(struct file *fp)
@@ -595,8 +597,7 @@ static int v4l_stk_release(struct file *fp)
 
 	if (is_present(dev))
 		usb_autopm_put_interface(dev->interface);
-
-	return 0;
+	return v4l2_fh_release(fp);
 }
 
 static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
@@ -663,6 +664,7 @@ static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
 static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 {
 	struct stk_camera *dev = video_drvdata(fp);
+	unsigned res = v4l2_ctrl_poll(fp, wait);
 
 	poll_wait(fp, &dev->wait_frame, wait);
 
@@ -670,9 +672,9 @@ static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 		return POLLERR;
 
 	if (!list_empty(&dev->sio_full))
-		return POLLIN | POLLRDNORM;
+		return res | POLLIN | POLLRDNORM;
 
-	return 0;
+	return res;
 }
 
 
@@ -1152,6 +1154,9 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
 	.vidioc_streamoff = stk_vidioc_streamoff,
 	.vidioc_g_parm = stk_vidioc_g_parm,
 	.vidioc_enum_framesizes = stk_vidioc_enum_framesizes,
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static void stk_v4l_dev_release(struct video_device *vd)
@@ -1179,6 +1184,7 @@ static int stk_register_video_device(struct stk_camera *dev)
 	dev->vdev = stk_v4l_data;
 	dev->vdev.debug = debug;
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
 	video_set_drvdata(&dev->vdev, dev);
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
@@ -1232,6 +1238,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 
 	spin_lock_init(&dev->spinlock);
 	init_waitqueue_head(&dev->wait_frame);
+	dev->first_init = 1; /* webcam LED management */
 
 	dev->udev = udev;
 	dev->interface = interface;
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 901f0df..2156320 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -99,6 +99,7 @@ struct stk_camera {
 	struct usb_interface *interface;
 	int webcam_model;
 	struct file *owner;
+	int first_init;
 
 	u8 isoc_ep;
 
-- 
1.7.10.4

