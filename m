Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbbCIQg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/19] hdpvr: embed video_device
Date: Mon,  9 Mar 2015 17:34:09 +0100
Message-Id: <1425918853-12371-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c  | 10 +++-------
 drivers/media/usb/hdpvr/hdpvr-video.c | 19 ++++++-------------
 drivers/media/usb/hdpvr/hdpvr.h       |  2 +-
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 42b4cdf..3fc6419 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -69,10 +69,6 @@ MODULE_DEVICE_TABLE(usb, hdpvr_table);
 void hdpvr_delete(struct hdpvr_device *dev)
 {
 	hdpvr_free_buffers(dev);
-
-	if (dev->video_dev)
-		video_device_release(dev->video_dev);
-
 	usb_put_dev(dev->udev);
 }
 
@@ -397,7 +393,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	/* let the user know what node this device is now attached to */
 	v4l2_info(&dev->v4l2_dev, "device now attached to %s\n",
-		  video_device_node_name(dev->video_dev));
+		  video_device_node_name(&dev->video_dev));
 	return 0;
 
 reg_fail:
@@ -420,7 +416,7 @@ static void hdpvr_disconnect(struct usb_interface *interface)
 	struct hdpvr_device *dev = to_hdpvr_dev(usb_get_intfdata(interface));
 
 	v4l2_info(&dev->v4l2_dev, "device %s disconnected\n",
-		  video_device_node_name(dev->video_dev));
+		  video_device_node_name(&dev->video_dev));
 	/* prevent more I/O from starting and stop any ongoing */
 	mutex_lock(&dev->io_mutex);
 	dev->status = STATUS_DISCONNECTED;
@@ -436,7 +432,7 @@ static void hdpvr_disconnect(struct usb_interface *interface)
 #if IS_ENABLED(CONFIG_I2C)
 	i2c_del_adapter(&dev->i2c_adapter);
 #endif
-	video_unregister_device(dev->video_dev);
+	video_unregister_device(&dev->video_dev);
 	atomic_dec(&dev_nr);
 }
 
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 59d15fd..d8d8c0f 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -797,7 +797,7 @@ static int vidioc_s_input(struct file *file, void *_fh,
 		 * Comment this out for now, but if the legacy mode can be
 		 * removed in the future, then this code should be enabled
 		 * again.
-		dev->video_dev->tvnorms =
+		dev->video_dev.tvnorms =
 			(index != HDPVR_COMPONENT) ? V4L2_STD_ALL : 0;
 		 */
 	}
@@ -1228,19 +1228,12 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	}
 
 	/* setup and register video device */
-	dev->video_dev = video_device_alloc();
-	if (!dev->video_dev) {
-		v4l2_err(&dev->v4l2_dev, "video_device_alloc() failed\n");
-		res = -ENOMEM;
-		goto error;
-	}
-
-	*dev->video_dev = hdpvr_video_template;
-	strcpy(dev->video_dev->name, "Hauppauge HD PVR");
-	dev->video_dev->v4l2_dev = &dev->v4l2_dev;
-	video_set_drvdata(dev->video_dev, dev);
+	dev->video_dev = hdpvr_video_template;
+	strcpy(dev->video_dev.name, "Hauppauge HD PVR");
+	dev->video_dev.v4l2_dev = &dev->v4l2_dev;
+	video_set_drvdata(&dev->video_dev, dev);
 
-	res = video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum);
+	res = video_register_device(&dev->video_dev, VFL_TYPE_GRABBER, devnum);
 	if (res < 0) {
 		v4l2_err(&dev->v4l2_dev, "video_device registration failed\n");
 		goto error;
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index dc685d4..a319430 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -66,7 +66,7 @@ struct hdpvr_options {
 /* Structure to hold all of our device specific stuff */
 struct hdpvr_device {
 	/* the v4l device for this device */
-	struct video_device	*video_dev;
+	struct video_device	video_dev;
 	/* the control handler for this device */
 	struct v4l2_ctrl_handler hdl;
 	/* the usb device for this device */
-- 
2.1.4

