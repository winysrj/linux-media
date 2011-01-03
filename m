Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3242 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab1ACNyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 08:54:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [RFC PATCH 3/4] dsbr100: convert to unlocked_ioctl
Date: Mon,  3 Jan 2011 14:54:31 +0100
Message-Id: <a89c9c2125d22e552c1b6881419d8cf2b6243495.1294062751.git.hverkuil@xs4all.nl>
In-Reply-To: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
References: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
References: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Use core-assisted locking so .ioctl can be replaced by .unlocked_ioctl.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/dsbr100.c |   79 ++++++++++++++++-------------------------
 1 files changed, 31 insertions(+), 48 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index ed9cd7a..bf2dd6f 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -148,7 +148,7 @@ struct dsbr100_device {
 	struct v4l2_device v4l2_dev;
 
 	u8 *transfer_buffer;
-	struct mutex lock;	/* buffer locking */
+	struct mutex v4l2_lock;
 	int curfreq;
 	int stereo;
 	int removed;
@@ -182,8 +182,6 @@ static int dsbr100_start(struct dsbr100_device *radio)
 	int retval;
 	int request;
 
-	mutex_lock(&radio->lock);
-
 	retval = usb_control_msg(radio->usbdev,
 		usb_rcvctrlpipe(radio->usbdev, 0),
 		USB_REQ_GET_STATUS,
@@ -207,11 +205,9 @@ static int dsbr100_start(struct dsbr100_device *radio)
 	}
 
 	radio->status = STARTED;
-	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 
 usb_control_msg_failed:
-	mutex_unlock(&radio->lock);
 	dev_err(&radio->usbdev->dev,
 		"%s - usb_control_msg returned %i, request %i\n",
 			__func__, retval, request);
@@ -225,8 +221,6 @@ static int dsbr100_stop(struct dsbr100_device *radio)
 	int retval;
 	int request;
 
-	mutex_lock(&radio->lock);
-
 	retval = usb_control_msg(radio->usbdev,
 		usb_rcvctrlpipe(radio->usbdev, 0),
 		USB_REQ_GET_STATUS,
@@ -250,11 +244,9 @@ static int dsbr100_stop(struct dsbr100_device *radio)
 	}
 
 	radio->status = STOPPED;
-	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 
 usb_control_msg_failed:
-	mutex_unlock(&radio->lock);
 	dev_err(&radio->usbdev->dev,
 		"%s - usb_control_msg returned %i, request %i\n",
 			__func__, retval, request);
@@ -269,8 +261,6 @@ static int dsbr100_setfreq(struct dsbr100_device *radio)
 	int request;
 	int freq = (radio->curfreq / 16 * 80) / 1000 + 856;
 
-	mutex_lock(&radio->lock);
-
 	retval = usb_control_msg(radio->usbdev,
 		usb_rcvctrlpipe(radio->usbdev, 0),
 		DSB100_TUNE,
@@ -306,12 +296,10 @@ static int dsbr100_setfreq(struct dsbr100_device *radio)
 	}
 
 	radio->stereo = !((radio->transfer_buffer)[0] & 0x01);
-	mutex_unlock(&radio->lock);
 	return (radio->transfer_buffer)[0];
 
 usb_control_msg_failed:
 	radio->stereo = -1;
-	mutex_unlock(&radio->lock);
 	dev_err(&radio->usbdev->dev,
 		"%s - usb_control_msg returned %i, request %i\n",
 			__func__, retval, request);
@@ -324,8 +312,6 @@ static void dsbr100_getstat(struct dsbr100_device *radio)
 {
 	int retval;
 
-	mutex_lock(&radio->lock);
-
 	retval = usb_control_msg(radio->usbdev,
 		usb_rcvctrlpipe(radio->usbdev, 0),
 		USB_REQ_GET_STATUS,
@@ -340,33 +326,8 @@ static void dsbr100_getstat(struct dsbr100_device *radio)
 	} else {
 		radio->stereo = !(radio->transfer_buffer[0] & 0x01);
 	}
-
-	mutex_unlock(&radio->lock);
-}
-
-/* USB subsystem interface begins here */
-
-/*
- * Handle unplugging of the device.
- * We call video_unregister_device in any case.
- * The last function called in this procedure is
- * usb_dsbr100_video_device_release
- */
-static void usb_dsbr100_disconnect(struct usb_interface *intf)
-{
-	struct dsbr100_device *radio = usb_get_intfdata(intf);
-
-	usb_set_intfdata (intf, NULL);
-
-	mutex_lock(&radio->lock);
-	radio->removed = 1;
-	mutex_unlock(&radio->lock);
-
-	video_unregister_device(&radio->videodev);
-	v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
-
 static int vidioc_querycap(struct file *file, void *priv,
 					struct v4l2_capability *v)
 {
@@ -432,9 +393,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (radio->removed)
 		return -EIO;
 
-	mutex_lock(&radio->lock);
 	radio->curfreq = f->frequency;
-	mutex_unlock(&radio->lock);
 
 	retval = dsbr100_setfreq(radio);
 	if (retval < 0)
@@ -548,12 +507,36 @@ static int vidioc_s_audio(struct file *file, void *priv,
 	return 0;
 }
 
+/* USB subsystem interface begins here */
+
+/*
+ * Handle unplugging of the device.
+ * We call video_unregister_device in any case.
+ * The last function called in this procedure is
+ * usb_dsbr100_video_device_release
+ */
+static void usb_dsbr100_disconnect(struct usb_interface *intf)
+{
+	struct dsbr100_device *radio = usb_get_intfdata(intf);
+
+	usb_set_intfdata(intf, NULL);
+
+	mutex_lock(&radio->v4l2_lock);
+	radio->removed = 1;
+	mutex_unlock(&radio->v4l2_lock);
+
+	video_unregister_device(&radio->videodev);
+	v4l2_device_disconnect(&radio->v4l2_dev);
+}
+
+
 /* Suspend device - stop device. */
 static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
 	int retval;
 
+	mutex_lock(&radio->v4l2_lock);
 	if (radio->status == STARTED) {
 		retval = dsbr100_stop(radio);
 		if (retval < 0)
@@ -564,11 +547,9 @@ static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 		 * we set status equal to STARTED.
 		 * On resume we will check status and run radio if needed.
 		 */
-
-		mutex_lock(&radio->lock);
 		radio->status = STARTED;
-		mutex_unlock(&radio->lock);
 	}
+	mutex_unlock(&radio->v4l2_lock);
 
 	dev_info(&intf->dev, "going into suspend..\n");
 
@@ -581,11 +562,13 @@ static int usb_dsbr100_resume(struct usb_interface *intf)
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
 	int retval;
 
+	mutex_lock(&radio->v4l2_lock);
 	if (radio->status == STARTED) {
 		retval = dsbr100_start(radio);
 		if (retval < 0)
 			dev_warn(&intf->dev, "dsbr100_start failed\n");
 	}
+	mutex_unlock(&radio->v4l2_lock);
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
 
@@ -605,7 +588,7 @@ static void usb_dsbr100_video_device_release(struct video_device *videodev)
 /* File system interface */
 static const struct v4l2_file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
@@ -653,13 +636,13 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 		return retval;
 	}
 
+	mutex_init(&radio->v4l2_lock);
 	strlcpy(radio->videodev.name, v4l2_dev->name, sizeof(radio->videodev.name));
 	radio->videodev.v4l2_dev = v4l2_dev;
 	radio->videodev.fops = &usb_dsbr100_fops;
 	radio->videodev.ioctl_ops = &usb_dsbr100_ioctl_ops;
 	radio->videodev.release = usb_dsbr100_video_device_release;
-
-	mutex_init(&radio->lock);
+	radio->videodev.lock = &radio->v4l2_lock;
 
 	radio->removed = 0;
 	radio->usbdev = interface_to_usbdev(intf);
-- 
1.7.0.4

