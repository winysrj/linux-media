Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50005 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbcCZEiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 00:38:51 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH 4/4] drivers: change au0828, uvcvideo, snd-usb-audio to use Media Device Allocator
Date: Fri, 25 Mar 2016 22:38:45 -0600
Message-Id: <6c6f7815b82c5681cda3213652e666769b895b4e.1458966594.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828, uvcvideo, snd-usb-audio to use Media Device Allocator and
new Media Controller API media_device_unregister_put().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c |  7 +++++--
 drivers/media/usb/au0828/au0828.h      |  1 +
 drivers/media/usb/uvc/uvc_driver.c     | 32 ++++++++++++++++++--------------
 drivers/media/usb/uvc/uvcvideo.h       |  3 ++-
 sound/usb/media.c                      | 10 +++++++---
 sound/usb/media.h                      |  1 +
 6 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 85c13ca..b410166 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -157,7 +157,8 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
 
-	media_device_unregister_devres(dev->media_dev);
+	media_device_unregister_put(dev->media_dev);
+	media_device_put(dev->media_dev->dev);
 	dev->media_dev = NULL;
 #endif
 }
@@ -210,7 +211,7 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = media_device_get_devres(&udev->dev);
+	mdev = media_device_get(&udev->dev);
 	if (!mdev)
 		return -ENOMEM;
 
@@ -485,11 +486,13 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
 		if (ret) {
+			media_device_put(dev->media_dev->dev);
 			dev_err(&udev->dev,
 				"Media Device Register Error: %d\n", ret);
 			return ret;
 		}
 	} else {
+		media_device_register_ref(dev->media_dev);
 		/*
 		 * Call au0828_media_graph_notify() to connect
 		 * audio graph to our graph. In this case, audio
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 87f3284..3edd50f 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -35,6 +35,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/media-device.h>
+#include <media/media-dev-allocator.h>
 
 /* DVB */
 #include "demux.h"
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 451e84e9..81d95b8 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1674,9 +1674,8 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
-		media_device_unregister(&dev->mdev);
-	media_device_cleanup(&dev->mdev);
+	if (media_devnode_is_registered(&dev->mdev->devnode))
+		media_device_unregister_put(dev->mdev);
 #endif
 
 	list_for_each_safe(p, n, &dev->chains) {
@@ -1929,17 +1928,20 @@ static int uvc_probe(struct usb_interface *intf,
 
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
@@ -1958,7 +1960,7 @@ static int uvc_probe(struct usb_interface *intf,
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	/* Register the media device node */
-	if (media_device_register(&dev->mdev) < 0)
+	if (media_device_register(dev->mdev) < 0)
 		goto error;
 #endif
 	/* Save our data pointer in the interface data. */
@@ -1976,6 +1978,8 @@ static int uvc_probe(struct usb_interface *intf,
 	return 0;
 
 error:
+	media_device_put(&intf->dev);
+media_device_get_error:
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
diff --git a/sound/usb/media.c b/sound/usb/media.c
index e35af88..bd7016d 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -262,7 +262,7 @@ int media_snd_device_create(struct snd_usb_audio *chip,
 	struct usb_device *usbdev = interface_to_usbdev(iface);
 	int ret;
 
-	mdev = media_device_get_devres(&usbdev->dev);
+	mdev = media_device_get(&usbdev->dev);
 	if (!mdev)
 		return -ENOMEM;
 
@@ -270,15 +270,18 @@ int media_snd_device_create(struct snd_usb_audio *chip,
 	if (!mdev->dev)
 		media_device_usb_init(mdev, usbdev, NULL);
 
+	/* register if needed, otherwise get register reference */
 	if (!media_devnode_is_registered(&mdev->devnode)) {
 		ret = media_device_register(mdev);
 		if (ret) {
+			media_device_put(mdev->dev);
 			dev_err(&usbdev->dev,
 				"Couldn't register media device. Error: %d\n",
 				ret);
 			return ret;
 		}
-	}
+	} else
+		media_device_register_ref(mdev);
 
 	/* save media device - avoid lookups */
 	chip->media_dev = mdev;
@@ -312,7 +315,8 @@ void media_snd_device_delete(struct snd_usb_audio *chip)
 	media_snd_mixer_delete(chip);
 
 	if (mdev) {
-		media_device_unregister_devres(mdev);
+		media_device_unregister_put(mdev);
+		media_device_put(mdev->dev);
 		chip->media_dev = NULL;
 	}
 }
diff --git a/sound/usb/media.h b/sound/usb/media.h
index 1dcdcdc..42ce8eb 100644
--- a/sound/usb/media.h
+++ b/sound/usb/media.h
@@ -21,6 +21,7 @@
 
 #include <media/media-device.h>
 #include <media/media-entity.h>
+#include <media/media-dev-allocator.h>
 #include <sound/asound.h>
 
 struct media_ctl {
-- 
2.5.0

