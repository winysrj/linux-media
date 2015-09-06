Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbIFRbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:39 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Olli Salonen <olli.salonen@iki.fi>,
	Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 10/18] [media] cx231xx: enforce check for graph creation
Date: Sun,  6 Sep 2015 14:30:53 -0300
Message-Id: <ca2647ddd7cc6058cdc87cc0e5869d2753cf6c19.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the graph creation fails, don't register the device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 1070d87efc65..c05aaef85491 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1185,8 +1185,6 @@ static void cx231xx_unregister_media_device(struct cx231xx *dev)
 */
 void cx231xx_release_resources(struct cx231xx *dev)
 {
-	cx231xx_unregister_media_device(dev);
-
 	cx231xx_release_analog_resources(dev);
 
 	cx231xx_remove_from_devlist(dev);
@@ -1199,6 +1197,8 @@ void cx231xx_release_resources(struct cx231xx *dev)
 	/* delete v4l2 device */
 	v4l2_device_unregister(&dev->v4l2_dev);
 
+	cx231xx_unregister_media_device(dev);
+
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
@@ -1237,15 +1237,16 @@ static void cx231xx_media_device_register(struct cx231xx *dev,
 #endif
 }
 
-static void cx231xx_create_media_graph(struct cx231xx *dev)
+static int cx231xx_create_media_graph(struct cx231xx *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
+	int ret;
 
 	if (!mdev)
-		return;
+		return 0;
 
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->type) {
@@ -1261,16 +1262,24 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
 	/* Analog setup, using tuner as a link */
 
 	if (!decoder)
-		return;
+		return 0;
 
-	if (tuner)
-		media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, decoder, 0,
-					 MEDIA_LNK_FL_ENABLED);
-	media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
-	media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
+	if (tuner) {
+		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, decoder, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret < 0)
+			return ret;
+	}
+	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
+				    MEDIA_LNK_FL_ENABLED);
+	if (ret < 0)
+		return ret;
+	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
+				    MEDIA_LNK_FL_ENABLED);
+	if (ret < 0)
+		return ret;
 #endif
+	return 0;
 }
 
 /*
@@ -1732,9 +1741,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* load other modules required */
 	request_modules(dev);
 
-	cx231xx_create_media_graph(dev);
+	retval = cx231xx_create_media_graph(dev);
+	if (retval < 0) {
+		cx231xx_release_resources(dev);
+	}
 
-	return 0;
+	return retval;
 err_video_alt:
 	/* cx231xx_uninit_dev: */
 	cx231xx_close_extension(dev);
-- 
2.4.3


