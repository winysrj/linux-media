Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36053 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1KSVq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 16:46:29 -0500
Received: by ghbz2 with SMTP id z2so1700046ghb.19
        for <linux-media@vger.kernel.org>; Sat, 19 Nov 2011 13:46:28 -0800 (PST)
Date: Sat, 19 Nov 2011 18:46:21 -0300
From: Ezequiel <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org
Cc: elezegarcia@yahoo.com.ar, moinejf@free.fr
Subject: [PATCH v2] [media] gspca: replaced static allocation by
 video_device_alloc/video_device_release
Message-ID: <20111119214621.GA2739@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pushed video_device initialization into a separate function.
Replace static allocation of struct video_device by 
video_device_alloc/video_device_release usage.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Previous version was sent stupidly incomplete by mistake.
---

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 881e04c..1f27f05 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1292,10 +1292,12 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 
 static void gspca_release(struct video_device *vfd)
 {
-	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
+	struct gspca_dev *gspca_dev = video_get_drvdata(vfd);
 
 	PDEBUG(D_PROBE, "%s released",
-		video_device_node_name(&gspca_dev->vdev));
+		video_device_node_name(gspca_dev->vdev));
+
+	video_device_release(vfd);
 
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
@@ -1304,9 +1306,11 @@ static void gspca_release(struct video_device *vfd)
 static int dev_open(struct file *file)
 {
 	struct gspca_dev *gspca_dev;
+	struct video_device *vdev;
 
 	PDEBUG(D_STREAM, "[%s] open", current->comm);
-	gspca_dev = (struct gspca_dev *) video_devdata(file);
+	vdev = video_devdata(file);
+	gspca_dev = video_get_drvdata(vdev);
 	if (!gspca_dev->present)
 		return -ENODEV;
 
@@ -1318,10 +1322,10 @@ static int dev_open(struct file *file)
 #ifdef GSPCA_DEBUG
 	/* activate the v4l2 debug */
 	if (gspca_debug & D_V4L2)
-		gspca_dev->vdev.debug |= V4L2_DEBUG_IOCTL
+		gspca_dev->vdev->debug |= V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG;
 	else
-		gspca_dev->vdev.debug &= ~(V4L2_DEBUG_IOCTL
+		gspca_dev->vdev->debug &= ~(V4L2_DEBUG_IOCTL
 					| V4L2_DEBUG_IOCTL_ARG);
 #endif
 	return 0;
@@ -2242,13 +2246,6 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_g_chip_ident	= vidioc_g_chip_ident,
 };
 
-static const struct video_device gspca_template = {
-	.name = "gspca main driver",
-	.fops = &dev_fops,
-	.ioctl_ops = &dev_ioctl_ops,
-	.release = gspca_release,
-};
-
 /* initialize the controls */
 static void ctrls_init(struct gspca_dev *gspca_dev)
 {
@@ -2265,6 +2262,26 @@ static void ctrls_init(struct gspca_dev *gspca_dev)
 	}
 }
 
+/* initialize a video_device struct */
+static int vdev_init(struct gspca_dev *dev, struct device *parent)
+{
+	struct video_device *vdev = video_device_alloc();
+	if (vdev == NULL)
+		return -ENOMEM;
+
+	/* fill struct video_device */
+	strlcpy(vdev->name, "gspca main driver", sizeof(vdev->name));
+	vdev->fops = &dev_fops,
+	vdev->ioctl_ops = &dev_ioctl_ops,
+	vdev->release = gspca_release,
+	vdev->parent = parent;
+
+	dev->vdev = vdev;
+	video_set_drvdata(vdev, dev);
+
+	return 0;
+}
+
 /*
  * probe and create a new gspca device
  *
@@ -2343,11 +2360,15 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	init_waitqueue_head(&gspca_dev->wq);
 
 	/* init video stuff */
-	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
-	gspca_dev->vdev.parent = &intf->dev;
+	ret = vdev_init(gspca_dev, &intf->dev);
+	if (ret < 0) {
+		pr_err("initialize video device err %d\n", ret);
+		goto out;
+	}
+
 	gspca_dev->module = module;
 	gspca_dev->present = 1;
-	ret = video_register_device(&gspca_dev->vdev,
+	ret = video_register_device(gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
 				  -1);
 	if (ret < 0) {
@@ -2356,7 +2377,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	}
 
 	usb_set_intfdata(intf, gspca_dev);
-	PDEBUG(D_PROBE, "%s created", video_device_node_name(&gspca_dev->vdev));
+	PDEBUG(D_PROBE, "%s created", video_device_node_name(gspca_dev->vdev));
 
 	gspca_input_create_urb(gspca_dev);
 
@@ -2411,7 +2432,7 @@ void gspca_disconnect(struct usb_interface *intf)
 #endif
 
 	PDEBUG(D_PROBE, "%s disconnect",
-		video_device_node_name(&gspca_dev->vdev));
+		video_device_node_name(gspca_dev->vdev));
 	mutex_lock(&gspca_dev->usb_lock);
 
 	gspca_dev->present = 0;
@@ -2436,7 +2457,7 @@ void gspca_disconnect(struct usb_interface *intf)
 
 	/* release the device */
 	/* (this will call gspca_release() immediately or on last close) */
-	video_unregister_device(&gspca_dev->vdev);
+	video_unregister_device(gspca_dev->vdev);
 
 /*	PDEBUG(D_PROBE, "disconnect complete"); */
 }
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index e444f16..f89b8fb 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -154,9 +154,9 @@ struct gspca_frame {
 };
 
 struct gspca_dev {
-	struct video_device vdev;	/* !! must be the first item */
 	struct module *module;		/* subdriver handling the device */
 	struct usb_device *dev;
+	struct video_device *vdev;	/* not necesarily the first item ;) */
 	struct file *capt_file;		/* file doing video capture */
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 	struct input_dev *input_dev;
