Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbcBEJwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 04:52:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] em2xx: use v4l2_mc_create_media_graph()
Date: Fri,  5 Feb 2016 07:51:15 -0200
Message-Id: <59857dfeea3d7b2590c05f58cf273745d99d1415.1454665849.git.mchehab@osg.samsung.com>
In-Reply-To: <6e3da35783650a6e555d20524421f4549d919821.1454665849.git.mchehab@osg.samsung.com>
References: <6e3da35783650a6e555d20524421f4549d919821.1454665849.git.mchehab@osg.samsung.com>
In-Reply-To: <6e3da35783650a6e555d20524421f4549d919821.1454665849.git.mchehab@osg.samsung.com>
References: <6e3da35783650a6e555d20524421f4549d919821.1454665849.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the core has a function to create the media graph,
we can get rid of the specialized code at em28xx.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 131 +-------------------------------
 1 file changed, 1 insertion(+), 130 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 16a2d4039330..e7fd0bac4a08 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -883,135 +883,6 @@ static void em28xx_v4l2_media_release(struct em28xx *dev)
  * Media Controller helper functions
  */
 
-static int em28xx_v4l2_create_media_graph(struct em28xx *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct em28xx_v4l2 *v4l2 = dev->v4l2;
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *entity;
-	struct media_entity *if_vid = NULL, *if_aud = NULL;
-	struct media_entity *tuner = NULL, *decoder = NULL;
-	int i, ret;
-
-	if (!mdev)
-		return 0;
-
-	/* Webcams are really simple */
-	if (dev->board.is_webcam) {
-		media_device_for_each_entity(entity, mdev) {
-			if (entity->function != MEDIA_ENT_F_CAM_SENSOR)
-				continue;
-			ret = media_create_pad_link(entity, 0,
-						    &v4l2->vdev.entity, 0,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-		}
-		return 0;
-	}
-
-	/* Non-webcams have analog TV decoder and other complexities */
-
-	media_device_for_each_entity(entity, mdev) {
-		switch (entity->function) {
-		case MEDIA_ENT_F_IF_VID_DECODER:
-			if_vid = entity;
-			break;
-		case MEDIA_ENT_F_IF_AUD_DECODER:
-			if_aud = entity;
-			break;
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
-	/* Something bad happened! */
-	if (!decoder)
-		return -EINVAL;
-
-	if (tuner) {
-		if (if_vid) {
-			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-						    if_vid,
-						    IF_VID_DEC_PAD_IF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-			ret = media_create_pad_link(if_vid, IF_VID_DEC_PAD_OUT,
-						decoder, DEMOD_PAD_IF_INPUT,
-						MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-		} else {
-			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-						decoder, DEMOD_PAD_IF_INPUT,
-						MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-		}
-
-		if (if_aud) {
-			ret = media_create_pad_link(tuner, TUNER_PAD_AUD_OUT,
-						    if_aud,
-						    IF_AUD_DEC_PAD_IF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-		} else {
-			if_aud = tuner;
-		}
-
-	}
-	ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
-				    &v4l2->vdev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
-
-	if (em28xx_vbi_supported(dev)) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT,
-					    &v4l2->vbi_dev.entity, 0,
-					    MEDIA_LNK_FL_ENABLED);
-		if (ret)
-			return ret;
-	}
-
-	for (i = 0; i < MAX_EM28XX_INPUT; i++) {
-		struct media_entity *ent = &dev->input_ent[i];
-
-		if (!INPUT(i)->type)
-			break;
-
-		switch (INPUT(i)->type) {
-		case EM28XX_VMUX_COMPOSITE:
-		case EM28XX_VMUX_SVIDEO:
-			ret = media_create_pad_link(ent, 0, decoder,
-						    DEMOD_PAD_IF_INPUT, 0);
-			if (ret)
-				return ret;
-			break;
-		default: /* EM28XX_VMUX_TELEVISION or EM28XX_RADIO */
-			if (!tuner)
-				break;
-
-			ret = media_create_pad_link(ent, 0, tuner,
-						    TUNER_PAD_RF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-			break;
-		}
-	}
-#endif
-	return 0;
-}
-
 static int em28xx_enable_analog_tuner(struct em28xx *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -2842,7 +2713,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Init entities at the Media Controller */
 	em28xx_v4l2_create_entities(dev);
 
-	ret = em28xx_v4l2_create_media_graph(dev);
+	ret = v4l2_mc_create_media_graph(dev->media_dev);
 	if (ret) {
 		em28xx_errdev("failed to create media graph\n");
 		em28xx_v4l2_media_release(dev);
-- 
2.5.0

