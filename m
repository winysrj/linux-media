Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbbAFVJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:08 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 11/20] cx231xx: initialize video/vbi pads
Date: Tue,  6 Jan 2015 19:08:42 -0200
Message-Id: <a5936ea965f4d7db9f1b37b390dd838882c61990.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
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

