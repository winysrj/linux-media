Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36427 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbCaQPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 12:15:44 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] [media] uvcvideo: Enable runtime PM of descendant devices
Date: Tue, 31 Mar 2015 18:14:45 +0200
Message-Id: <1427818501-10201-2-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1427818501-10201-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1427818501-10201-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So UVC devices can remain runtime-suspended when the system goes into a
sleep state, they and all of their descendant devices need to have
runtime PM enable.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 4 ++++
 drivers/media/usb/uvc/uvc_status.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index cf27006..e98830a1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1792,6 +1792,8 @@ static int uvc_register_video(struct uvc_device *dev,
 		return ret;
 	}
 
+	pm_runtime_enable(&vdev->dev);
+
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
 	else
@@ -1932,6 +1934,8 @@ static int uvc_probe(struct usb_interface *intf,
 	if (media_device_register(&dev->mdev) < 0)
 		goto error;
 
+	pm_runtime_enable(&dev->mdev.devnode.dev);
+
 	dev->vdev.mdev = &dev->mdev;
 #endif
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index f552ab9..b1d3d8c 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/input.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
@@ -46,6 +47,8 @@ static int uvc_input_init(struct uvc_device *dev)
 	if ((ret = input_register_device(input)) < 0)
 		goto error;
 
+	pm_runtime_enable(&input->dev);
+
 	dev->input = input;
 	return 0;
 
-- 
2.3.4

