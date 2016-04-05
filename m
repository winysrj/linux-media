Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50248 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbcDEDgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 23:36:11 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com, ricard.wanderlof@axis.com,
	julian@jusst.de, pierre-louis.bossart@linux.intel.com,
	clemens@ladisch.de, dominic.sacre@gmx.de, takamichiho@gmail.com,
	johan@oljud.se, geliangtang@163.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH v2 3/5] media: uvcvideo change to use Media Device Allocator API
Date: Mon,  4 Apr 2016 21:35:58 -0600
Message-Id: <7788c0ae7eea624d5d855358d781cd99a3e3f95f.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change uvcvideo to use Media Device Allocator API and new Media Controller
media_device_unregister_put() interface.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 36 ++++++++++++++++++++++--------------
 drivers/media/usb/uvc/uvcvideo.h   |  3 ++-
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 451e84e9..95e30c4 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1674,9 +1674,10 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
-		media_device_unregister(&dev->mdev);
-	media_device_cleanup(&dev->mdev);
+	if (media_devnode_is_registered(&dev->mdev->devnode)) {
+		media_device_unregister_put(dev->mdev);
+		media_device_put(dev->mdev->dev);
+	}
 #endif
 
 	list_for_each_safe(p, n, &dev->chains) {
@@ -1929,17 +1930,20 @@ static int uvc_probe(struct usb_interface *intf,
 
 	/* Initialize the media device and register the V4L2 device. */
 #ifdef CONFIG_MEDIA_CONTROLLER
-	dev->mdev.dev = &intf->dev;
-	strlcpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
+	dev->mdev = media_device_get(&intf->dev);
+	if (!dev->mdev)
+		goto media_device_get_error;
+	dev->mdev->dev = &intf->dev;
+	strlcpy(dev->mdev->model, dev->name, sizeof(dev->mdev->model));
 	if (udev->serial)
-		strlcpy(dev->mdev.serial, udev->serial,
-			sizeof(dev->mdev.serial));
-	strcpy(dev->mdev.bus_info, udev->devpath);
-	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	dev->mdev.driver_version = LINUX_VERSION_CODE;
-	media_device_init(&dev->mdev);
-
-	dev->vdev.mdev = &dev->mdev;
+		strlcpy(dev->mdev->serial, udev->serial,
+			sizeof(dev->mdev->serial));
+	strcpy(dev->mdev->bus_info, udev->devpath);
+	dev->mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	dev->mdev->driver_version = LINUX_VERSION_CODE;
+	media_device_init(dev->mdev);
+
+	dev->vdev.mdev = dev->mdev;
 #endif
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
 		goto error;
@@ -1958,7 +1962,7 @@ static int uvc_probe(struct usb_interface *intf,
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	/* Register the media device node */
-	if (media_device_register(&dev->mdev) < 0)
+	if (media_device_register(dev->mdev) < 0)
 		goto error;
 #endif
 	/* Save our data pointer in the interface data. */
@@ -1976,6 +1980,10 @@ static int uvc_probe(struct usb_interface *intf,
 	return 0;
 
 error:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_put(&intf->dev);
+media_device_get_error:
+#endif
 	uvc_unregister_video(dev);
 	return -ENODEV;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 7e4d3ee..a5ef719 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -12,6 +12,7 @@
 #include <linux/uvcvideo.h>
 #include <linux/videodev2.h>
 #include <media/media-device.h>
+#include <media/media-dev-allocator.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-fh.h>
@@ -543,7 +544,7 @@ struct uvc_device {
 
 	/* Video control interface */
 #ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device mdev;
+	struct media_device *mdev;
 #endif
 	struct v4l2_device vdev;
 	__u16 uvc_version;
-- 
2.5.0

