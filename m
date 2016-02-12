Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 08/11] [media] cx231xx: use v4l2 core function to create the MC graph
Date: Fri, 12 Feb 2016 07:45:03 -0200
Message-Id: <b4a6cd80d5561da2c87677815dd1e0001ca8a8a4.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having its own routine, use the one defined at the
core, as it is generic enough to handle the cx231xx usecases.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 47 +------------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index a8d0655f7250..0b8b5011f80e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1221,51 +1221,6 @@ static int cx231xx_media_device_init(struct cx231xx *dev,
 	return 0;
 }
 
-static int cx231xx_create_media_graph(struct cx231xx *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL;
-	int ret;
-
-	if (!mdev)
-		return 0;
-
-	media_device_for_each_entity(entity, mdev) {
-		switch (entity->function) {
-		case MEDIA_ENT_F_TUNER:
-			tuner = entity;
-			break;
-		case MEDIA_ENT_F_ATV_DECODER:
-			decoder = entity;
-			break;
-		}
-	}
-
-	/* Analog setup, using tuner as a link */
-
-	if (!decoder)
-		return 0;
-
-	if (tuner) {
-		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT, decoder, 0,
-					    MEDIA_LNK_FL_ENABLED);
-		if (ret < 0)
-			return ret;
-	}
-	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret < 0)
-		return ret;
-	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret < 0)
-		return ret;
-#endif
-	return 0;
-}
-
 /*
  * cx231xx_init_dev()
  * allocates and inits the device structs, registers i2c bus and v4l device
@@ -1729,7 +1684,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* load other modules required */
 	request_modules(dev);
 
-	retval = cx231xx_create_media_graph(dev);
+	retval = v4l2_mc_create_media_graph(dev->media_dev);
 	if (retval < 0)
 		goto done;
 
-- 
2.5.0


