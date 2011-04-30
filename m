Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59809 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab1D3Ndm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:33:42 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 669B0359BB
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:33:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] uvcvideo: Register a v4l2_device
Date: Sat, 30 Apr 2011 15:34:02 +0200
Message-Id: <1304170445-11978-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As a first step to the media controller integration register a
v4l2_device for each UVC control interface and make the video_device a
child of the v4l2_device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |   25 +++++++++++++++++++++++--
 drivers/media/video/uvc/uvcvideo.h   |    4 ++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 496a9de..1d0696c 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1580,6 +1580,11 @@ static void uvc_delete(struct uvc_device *dev)
 	uvc_status_cleanup(dev);
 	uvc_ctrl_cleanup_device(dev);
 
+	if (dev->vdev.dev)
+		v4l2_device_unregister(&dev->vdev);
+	if (media_devnode_is_registered(&dev->mdev.devnode))
+		media_device_unregister(&dev->mdev);
+
 	list_for_each_safe(p, n, &dev->chains) {
 		struct uvc_video_chain *chain;
 		chain = list_entry(p, struct uvc_video_chain, list);
@@ -1677,7 +1682,7 @@ static int uvc_register_video(struct uvc_device *dev,
 	 * unregistered before the reference is released, so we don't need to
 	 * get another one.
 	 */
-	vdev->parent = &dev->intf->dev;
+	vdev->v4l2_dev = &dev->vdev;
 	vdev->fops = &uvc_fops;
 	vdev->release = uvc_release;
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
@@ -1809,6 +1814,22 @@ static int uvc_probe(struct usb_interface *intf,
 			"linux-uvc-devel mailing list.\n");
 	}
 
+	/* Register the media and V4L2 devices. */
+	dev->mdev.dev = &intf->dev;
+	strlcpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
+	if (udev->serial)
+		strlcpy(dev->mdev.serial, udev->serial,
+			sizeof(dev->mdev.serial));
+	strcpy(dev->mdev.bus_info, udev->devpath);
+	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	dev->mdev.driver_version = DRIVER_VERSION_NUMBER;
+	if (media_device_register(&dev->mdev) < 0)
+		goto error;
+
+	dev->vdev.mdev = &dev->mdev;
+	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
+		goto error;
+
 	/* Initialize controls. */
 	if (uvc_ctrl_init_device(dev) < 0)
 		goto error;
@@ -1817,7 +1838,7 @@ static int uvc_probe(struct usb_interface *intf,
 	if (uvc_scan_device(dev) < 0)
 		goto error;
 
-	/* Register video devices. */
+	/* Register video device nodes. */
 	if (uvc_register_chains(dev) < 0)
 		goto error;
 
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 38dd4e1..87ce89e 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -100,6 +100,8 @@ struct uvc_xu_control {
 #include <linux/poll.h>
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
+#include <media/media-device.h>
+#include <media/v4l2-device.h>
 
 /* --------------------------------------------------------------------------
  * UVC constants
@@ -501,6 +503,8 @@ struct uvc_device {
 	atomic_t nmappings;
 
 	/* Video control interface */
+	struct media_device mdev;
+	struct v4l2_device vdev;
 	__u16 uvc_version;
 	__u32 clock_frequency;
 
-- 
1.7.3.4

