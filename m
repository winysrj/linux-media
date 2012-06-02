Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1249 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2FBL6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/6] zr364xx: embed video_device and register it at the end of probe.
Date: Sat,  2 Jun 2012 13:58:15 +0200
Message-Id: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
In-Reply-To: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
References: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct instead of allocating it and register it as
the last thing in probe().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zr364xx.c |   46 ++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index e44cb33..daf2099 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -173,7 +173,7 @@ static const struct zr364xx_fmt formats[] = {
 struct zr364xx_camera {
 	struct usb_device *udev;	/* save off the usb device pointer */
 	struct usb_interface *interface;/* the interface for this device */
-	struct video_device *vdev;	/* v4l video device */
+	struct video_device vdev;	/* v4l video device */
 	int nb;
 	struct zr364xx_bufferi		buffer;
 	int skip;
@@ -1322,9 +1322,7 @@ static void zr364xx_destroy(struct zr364xx_camera *cam)
 		return;
 	}
 	mutex_lock(&cam->open_lock);
-	if (cam->vdev)
-		video_unregister_device(cam->vdev);
-	cam->vdev = NULL;
+	video_unregister_device(&cam->vdev);
 
 	/* stops the read pipe if it is running */
 	if (cam->b_acquire)
@@ -1346,7 +1344,6 @@ static void zr364xx_destroy(struct zr364xx_camera *cam)
 	cam->pipe->transfer_buffer = NULL;
 	mutex_unlock(&cam->open_lock);
 	kfree(cam);
-	cam = NULL;
 }
 
 /* release the camera */
@@ -1466,7 +1463,7 @@ static struct video_device zr364xx_template = {
 	.name = DRIVER_DESC,
 	.fops = &zr364xx_fops,
 	.ioctl_ops = &zr364xx_ioctl_ops,
-	.release = video_device_release,
+	.release = video_device_release_empty,
 };
 
 
@@ -1557,19 +1554,11 @@ static int zr364xx_probe(struct usb_interface *intf,
 	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
-
-	cam->vdev = video_device_alloc();
-	if (cam->vdev == NULL) {
-		dev_err(&udev->dev, "cam->vdev: out of memory !\n");
-		kfree(cam);
-		cam = NULL;
-		return -ENOMEM;
-	}
-	memcpy(cam->vdev, &zr364xx_template, sizeof(zr364xx_template));
-	cam->vdev->parent = &intf->dev;
-	video_set_drvdata(cam->vdev, cam);
+	cam->vdev = zr364xx_template;
+	cam->vdev.parent = &intf->dev;
+	video_set_drvdata(&cam->vdev, cam);
 	if (debug)
-		cam->vdev->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
+		cam->vdev.debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
 
 	cam->udev = udev;
 
@@ -1636,37 +1625,34 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	if (!cam->read_endpoint) {
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
-		video_device_release(cam->vdev);
 		kfree(cam);
-		cam = NULL;
 		return -ENOMEM;
 	}
 
 	/* v4l */
 	INIT_LIST_HEAD(&cam->vidq.active);
 	cam->vidq.cam = cam;
-	err = video_register_device(cam->vdev, VFL_TYPE_GRABBER, -1);
-	if (err) {
-		dev_err(&udev->dev, "video_register_device failed\n");
-		video_device_release(cam->vdev);
-		kfree(cam);
-		cam = NULL;
-		return err;
-	}
 
 	usb_set_intfdata(intf, cam);
 
 	/* load zr364xx board specific */
 	err = zr364xx_board_init(cam);
 	if (err) {
-		spin_lock_init(&cam->slock);
+		kfree(cam);
 		return err;
 	}
 
 	spin_lock_init(&cam->slock);
 
+	err = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
+	if (err) {
+		dev_err(&udev->dev, "video_register_device failed\n");
+		kfree(cam);
+		return err;
+	}
+
 	dev_info(&udev->dev, DRIVER_DESC " controlling device %s\n",
-		 video_device_node_name(cam->vdev));
+		 video_device_node_name(&cam->vdev));
 	return 0;
 }
 
-- 
1.7.10

