Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46633 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760793AbZDCVp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 17:45:28 -0400
Received: by mail-fx0-f158.google.com with SMTP id 2so1154392fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 14:45:26 -0700 (PDT)
Subject: [patch 2/2] radio-mr800: convert to to v4l2_device
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org, klimov.linux@gmail.com
Content-Type: text/plain
Date: Sat, 04 Apr 2009 01:45:27 +0400
Message-Id: <1238795127.3102.14.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

radio-mr800: convert to to v4l2_device.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
--
diff -r 4cd17f5a20cc linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Thu Apr 02 20:50:21 2009 -0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Sat Apr 04 01:32:08 2009 +0400
@@ -43,6 +43,7 @@
  * 			Douglas Schilling Landgraf <dougsland@gmail.com> and
  * 			David Ellingsworth <david@identd.dyndns.org>
  * 			for discussion, help and support.
+ * Version 0.11:	Converted to v4l2_device.
  *
  * Many things to do:
  * 	- Correct power managment of device (suspend & resume)
@@ -59,7 +60,7 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO */
@@ -68,8 +69,8 @@
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
 #define DRIVER_DESC "AverMedia MR 800 USB FM radio driver"
-#define DRIVER_VERSION "0.10"
-#define RADIO_VERSION KERNEL_VERSION(0, 1, 0)
+#define DRIVER_VERSION "0.11"
+#define RADIO_VERSION KERNEL_VERSION(0, 1, 1)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
@@ -114,38 +115,6 @@
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr, "Radio Nr");
 
-static struct v4l2_queryctrl radio_qctrl[] = {
-	{
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.step	       = 1,
-		.default_value = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},
-/* HINT: the disabled controls are only here to satify kradio and such apps */
-	{	.id		= V4L2_CID_AUDIO_VOLUME,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
-		.id		= V4L2_CID_AUDIO_BALANCE,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
-		.id		= V4L2_CID_AUDIO_BASS,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
-		.id		= V4L2_CID_AUDIO_TREBLE,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-	{
-		.id		= V4L2_CID_AUDIO_LOUDNESS,
-		.flags		= V4L2_CTRL_FLAG_DISABLED,
-	},
-};
-
 static int usb_amradio_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
 static void usb_amradio_disconnect(struct usb_interface *intf);
@@ -160,6 +129,7 @@
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
 	struct video_device *videodev;
+	struct v4l2_device v4l2_dev;
 
 	unsigned char *buffer;
 	struct mutex lock;	/* buffer locking */
@@ -332,6 +302,7 @@
 
 	usb_set_intfdata(intf, NULL);
 	video_unregister_device(radio->videodev);
+	v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
 /* vidioc_querycap - query device capabilities */
@@ -466,14 +437,11 @@
 static int vidioc_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qc)
 {
-	int i;
+	switch (qc->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
+	}
 
-	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
-		if (qc->id && qc->id == radio_qctrl[i].id) {
-			memcpy(qc, &(radio_qctrl[i]), sizeof(*qc));
-			return 0;
-		}
-	}
 	return -EINVAL;
 }
 
@@ -674,34 +642,29 @@
 	.vidioc_s_input     = vidioc_s_input,
 };
 
-static void usb_amradio_device_release(struct video_device *videodev)
+static void usb_amradio_video_device_release(struct video_device *videodev)
 {
 	struct amradio_device *radio = video_get_drvdata(videodev);
 
 	/* we call v4l to free radio->videodev */
 	video_device_release(videodev);
 
+	v4l2_device_unregister(&radio->v4l2_dev);
+
 	/* free rest memory */
 	kfree(radio->buffer);
 	kfree(radio);
 }
-
-/* V4L2 interface */
-static struct video_device amradio_videodev_template = {
-	.name		= "AverMedia MR 800 USB FM Radio",
-	.fops		= &usb_amradio_fops,
-	.ioctl_ops 	= &usb_amradio_ioctl_ops,
-	.release	= usb_amradio_device_release,
-};
 
 /* check if the device is present and register with v4l and usb if it is */
 static int usb_amradio_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct amradio_device *radio;
+	struct v4l2_device *v4l2_dev;
 	int retval;
 
-	radio = kmalloc(sizeof(struct amradio_device), GFP_KERNEL);
+	radio = kzalloc(sizeof(struct amradio_device), GFP_KERNEL);
 
 	if (!radio) {
 		dev_err(&intf->dev, "kmalloc for amradio_device failed\n");
@@ -716,6 +679,15 @@
 		return -ENOMEM;
 	}
 
+	v4l2_dev = &radio->v4l2_dev;
+	retval = v4l2_device_register(&intf->dev, v4l2_dev);
+	if (retval < 0) {
+		dev_err(&intf->dev, "couldn't register v4l2_device\n");
+		kfree(radio->buffer);
+		kfree(radio);
+		return retval;
+	}
+
 	radio->videodev = video_device_alloc();
 
 	if (!radio->videodev) {
@@ -725,8 +697,11 @@
 		return -ENOMEM;
 	}
 
-	memcpy(radio->videodev, &amradio_videodev_template,
-		sizeof(amradio_videodev_template));
+	strlcpy(radio->videodev->name, v4l2_dev->name, sizeof(radio->videodev->name));
+	radio->videodev->v4l2_dev = v4l2_dev;
+	radio->videodev->fops = &usb_amradio_fops;
+	radio->videodev->ioctl_ops = &usb_amradio_ioctl_ops;
+	radio->videodev->release = usb_amradio_video_device_release;
 
 	radio->removed = 0;
 	radio->users = 0;
@@ -737,10 +712,12 @@
 	mutex_init(&radio->lock);
 
 	video_set_drvdata(radio->videodev, radio);
+
 	retval = video_register_device(radio->videodev,	VFL_TYPE_RADIO,	radio_nr);
 	if (retval < 0) {
 		dev_err(&intf->dev, "could not register video device\n");
 		video_device_release(radio->videodev);
+		v4l2_device_unregister(v4l2_dev);
 		kfree(radio->buffer);
 		kfree(radio);
 		return -EIO;


-- 
Best regards, Klimov Alexey

