Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44636 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbbGTNA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/12] usbvision: convert to the control framework
Date: Mon, 20 Jul 2015 14:59:29 +0200
Message-Id: <1437397178-5013-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert this driver to the control framework and struct v4l2_fh
(needed for handling control events).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 69 ++++++++++-----------------
 drivers/media/usb/usbvision/usbvision.h       |  2 +
 2 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 1355b5d..ea67c8c 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -62,6 +62,7 @@
 #include <media/saa7115.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/tuner.h>
 
 #include <linux/workqueue.h>
@@ -351,6 +352,10 @@ static int usbvision_v4l2_open(struct file *file)
 	if (usbvision->user) {
 		err_code = -EBUSY;
 	} else {
+		err_code = v4l2_fh_open(file);
+		if (err_code)
+			goto unlock;
+
 		/* Allocate memory for the scratch ring buffer */
 		err_code = usbvision_scratch_alloc(usbvision);
 		if (isoc_mode == ISOC_MODE_COMPRESS) {
@@ -389,6 +394,7 @@ static int usbvision_v4l2_open(struct file *file)
 		}
 	}
 
+unlock:
 	mutex_unlock(&usbvision->v4l2_lock);
 
 	PDEBUG(DBG_IO, "success");
@@ -429,7 +435,7 @@ static int usbvision_v4l2_close(struct file *file)
 	mutex_unlock(&usbvision->v4l2_lock);
 
 	PDEBUG(DBG_IO, "success");
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 
@@ -675,37 +681,6 @@ static int vidioc_s_audio(struct file *file, void *fh,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *ctrl)
-{
-	struct usb_usbvision *usbvision = video_drvdata(file);
-
-	call_all(usbvision, core, queryctrl, ctrl);
-
-	if (!ctrl->type)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct usb_usbvision *usbvision = video_drvdata(file);
-
-	call_all(usbvision, core, g_ctrl, ctrl);
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct usb_usbvision *usbvision = video_drvdata(file);
-
-	call_all(usbvision, core, s_ctrl, ctrl);
-	return 0;
-}
-
 static int vidioc_reqbufs(struct file *file,
 			   void *priv, struct v4l2_requestbuffers *vr)
 {
@@ -1145,6 +1120,9 @@ static int usbvision_radio_open(struct file *file)
 
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
+	err_code = v4l2_fh_open(file);
+	if (err_code)
+		goto out;
 	if (usbvision->user) {
 		dev_err(&usbvision->rdev.dev,
 			"%s: Someone tried to open an already opened USBVision Radio!\n",
@@ -1174,14 +1152,13 @@ out:
 static int usbvision_radio_close(struct file *file)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
-	int err_code = 0;
 
 	PDEBUG(DBG_IO, "");
 
 	mutex_lock(&usbvision->v4l2_lock);
 	/* Set packet size to 0 */
 	usbvision->iface_alt = 0;
-	err_code = usb_set_interface(usbvision->dev, usbvision->iface,
+	usb_set_interface(usbvision->dev, usbvision->iface,
 				    usbvision->iface_alt);
 
 	usbvision_audio_off(usbvision);
@@ -1190,13 +1167,14 @@ static int usbvision_radio_close(struct file *file)
 
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
+		v4l2_fh_release(file);
 		usbvision_release(usbvision);
-		return err_code;
+		return 0;
 	}
 
 	mutex_unlock(&usbvision->v4l2_lock);
 	PDEBUG(DBG_IO, "success");
-	return err_code;
+	return v4l2_fh_release(file);
 }
 
 /* Video registration stuff */
@@ -1209,7 +1187,6 @@ static const struct v4l2_file_operations usbvision_fops = {
 	.read		= usbvision_v4l2_read,
 	.mmap		= usbvision_v4l2_mmap,
 	.unlocked_ioctl	= video_ioctl2,
-/*	.poll		= video_poll, */
 };
 
 static const struct v4l2_ioctl_ops usbvision_ioctl_ops = {
@@ -1227,17 +1204,17 @@ static const struct v4l2_ioctl_ops usbvision_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_g_audio       = vidioc_g_audio,
 	.vidioc_s_audio       = vidioc_s_audio,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_log_status    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1258,6 +1235,7 @@ static const struct v4l2_file_operations usbvision_radio_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_radio_open,
 	.release	= usbvision_radio_close,
+	.poll		= v4l2_ctrl_poll,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -1266,15 +1244,15 @@ static const struct v4l2_ioctl_ops usbvision_radio_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_g_audio       = vidioc_g_audio,
 	.vidioc_s_audio       = vidioc_s_audio,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_log_status    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device usbvision_radio_template = {
@@ -1377,6 +1355,9 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
 	if (v4l2_device_register(&intf->dev, &usbvision->v4l2_dev))
 		goto err_free;
 
+	if (v4l2_ctrl_handler_init(&usbvision->hdl, 4))
+		goto err_unreg;
+	usbvision->v4l2_dev.ctrl_handler = &usbvision->hdl;
 	mutex_init(&usbvision->v4l2_lock);
 
 	/* prepare control urb for control messages during interrupts */
@@ -1388,6 +1369,7 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
 	return usbvision;
 
 err_unreg:
+	v4l2_ctrl_handler_free(&usbvision->hdl);
 	v4l2_device_unregister(&usbvision->v4l2_dev);
 err_free:
 	kfree(usbvision);
@@ -1413,6 +1395,7 @@ static void usbvision_release(struct usb_usbvision *usbvision)
 
 	usb_free_urb(usbvision->ctrl_urb);
 
+	v4l2_ctrl_handler_free(&usbvision->hdl);
 	v4l2_device_unregister(&usbvision->v4l2_dev);
 	kfree(usbvision);
 
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index d39ab10..4dbb421 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -36,6 +36,7 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/tuner.h>
 #include <linux/videodev2.h>
 
@@ -357,6 +358,7 @@ extern struct usb_device_id usbvision_table[];
 
 struct usb_usbvision {
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
 	struct video_device vdev;					/* Video Device */
 	struct video_device rdev;					/* Radio Device */
 
-- 
2.1.4

