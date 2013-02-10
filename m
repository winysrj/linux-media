Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3336 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3BJRxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 03/12] stk-webcam: add support for struct v4l2_device.
Date: Sun, 10 Feb 2013 18:52:44 +0100
Message-Id: <49da1b338bd8e3b18ca20ac9c06cbc29102d7efd.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   10 +++++++++-
 drivers/media/usb/stkwebcam/stk-webcam.h |    2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 3b874e4..f21ba43 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1256,7 +1256,7 @@ static int stk_register_video_device(struct stk_camera *dev)
 
 	dev->vdev = stk_v4l_data;
 	dev->vdev.debug = debug;
-	dev->vdev.parent = &dev->interface->dev;
+	dev->vdev.v4l2_dev = &dev->v4l2_dev;
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		STK_ERROR("v4l registration failed\n");
@@ -1285,6 +1285,12 @@ static int stk_camera_probe(struct usb_interface *interface,
 		STK_ERROR("Out of memory !\n");
 		return -ENOMEM;
 	}
+	err = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
+	if (err < 0) {
+		dev_err(&udev->dev, "couldn't register v4l2_device\n");
+		kfree(dev);
+		return err;
+	}
 
 	spin_lock_init(&dev->spinlock);
 	init_waitqueue_head(&dev->wait_frame);
@@ -1345,6 +1351,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	return 0;
 
 error:
+	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
 	return err;
 }
@@ -1362,6 +1369,7 @@ static void stk_camera_disconnect(struct usb_interface *interface)
 		 video_device_node_name(&dev->vdev));
 
 	video_unregister_device(&dev->vdev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 9f67366..49ebe85 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -23,6 +23,7 @@
 #define STKWEBCAM_H
 
 #include <linux/usb.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 
 #define DRIVER_VERSION		"v0.0.1"
@@ -91,6 +92,7 @@ struct regval {
 };
 
 struct stk_camera {
+	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	struct usb_device *udev;
 	struct usb_interface *interface;
-- 
1.7.10.4

