Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbbACUJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 15:09:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/7] cx231xx: create media links for analog mode
Date: Sat,  3 Jan 2015 18:09:36 -0200
Message-Id: <4143f052ec91ea72fe08faf16ef4c043bf447369.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have entities and pads, let's create media links
between them, for analog setup.

We may not have all the links for digital yet, as the dvb extention
may not be loaded yet.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 7e1c73a5172d..5fc7d97df166 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1159,6 +1159,44 @@ static void cx231xx_media_device_register(struct cx231xx *dev,
 #endif
 }
 
+static void cx231xx_create_media_graph(struct cx231xx *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity *entity;
+	struct media_entity *tuner = NULL, *decoder = NULL;
+
+	if (!mdev)
+		return;
+
+	media_device_for_each_entity(entity, mdev) {
+		printk("entity %s, type %d\n", entity->name, entity->type);
+
+		switch (entity->type) {
+		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+			tuner = entity;
+			break;
+		case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
+			decoder = entity;
+			break;
+		}
+	}
+
+	/* Analog setup, using tuner as a link */
+
+	if (!decoder)
+		return;
+
+	if (tuner)
+		media_entity_create_link(tuner, 0, decoder, 0,
+					 MEDIA_LNK_FL_ENABLED);
+	media_entity_create_link(decoder, 1, &dev->vdev->entity, 0,
+				 MEDIA_LNK_FL_ENABLED);
+	media_entity_create_link(decoder, 2, &dev->vbi_dev->entity, 0,
+				 MEDIA_LNK_FL_ENABLED);
+#endif
+}
+
 /*
  * cx231xx_init_dev()
  * allocates and inits the device structs, registers i2c bus and v4l device
@@ -1615,6 +1653,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* load other modules required */
 	request_modules(dev);
 
+	cx231xx_create_media_graph(dev);
+
 	return 0;
 err_video_alt:
 	/* cx231xx_uninit_dev: */
-- 
2.1.0

