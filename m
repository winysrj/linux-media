Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49460 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbbBMW6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:21 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv4 17/25] [media] cx231xx: initialize video/vbi pads
Date: Fri, 13 Feb 2015 20:58:00 -0200
Message-Id: <adca72951078de7069b61ded4212d47ae5b4fe71.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both video and vbi are sink pads. Initialize them as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index ecea76fe07f6..f3d1a488dfa7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2121,7 +2121,12 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		dev_err(dev->dev, "cannot allocate video_device.\n");
 		return -ENODEV;
 	}
-
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&dev->vdev->entity, 1, &dev->video_pad, 0);
+	if (ret < 0)
+		dev_err(dev->dev, "failed to initialize video media entity!\n");
+#endif
 	dev->vdev->ctrl_handler = &dev->ctrl_handler;
 	/* register v4l2 video video_device */
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
@@ -2147,6 +2152,12 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		dev_err(dev->dev, "cannot allocate video_device.\n");
 		return -ENODEV;
 	}
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&dev->vbi_dev->entity, 1, &dev->vbi_pad, 0);
+	if (ret < 0)
+		dev_err(dev->dev, "failed to initialize vbi media entity!\n");
+#endif
 	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
 	/* register v4l2 vbi video_device */
 	ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index af9d6c4041dc..e0d3106f6b44 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -660,6 +660,7 @@ struct cx231xx {
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *media_dev;
+	struct media_pad video_pad, vbi_pad;
 #endif
 
 	unsigned char eedata[256];
-- 
2.1.0

