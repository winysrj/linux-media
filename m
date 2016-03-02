Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbcCBQj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 11:39:58 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 2/2] [media] au0828: use v4l2_mc_create_media_graph()
Date: Wed,  2 Mar 2016 13:39:49 -0300
Message-Id: <1ebf20bc2e7a00bac83784683103bdac6833a48c.1456936755.git.mchehab@osg.samsung.com>
In-Reply-To: <e1ccb8434a42af97f45d65ffbe8035e809bf57e9.1456936755.git.mchehab@osg.samsung.com>
References: <cover.1456928097.git.mchehab@osg.samsung.com>
 <e1ccb8434a42af97f45d65ffbe8035e809bf57e9.1456936755.git.mchehab@osg.samsung.com>
In-Reply-To: <e1ccb8434a42af97f45d65ffbe8035e809bf57e9.1456936755.git.mchehab@osg.samsung.com>
References: <e1ccb8434a42af97f45d65ffbe8035e809bf57e9.1456936755.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason to implement its own function to create the
media graph. So, use the core one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 103 ++------------------------------
 drivers/media/v4l2-core/v4l2-mc.c       |  21 ++++++-
 2 files changed, 25 insertions(+), 99 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index b82deda02643..c0839d62ff13 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-mc.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include <media/tuner.h>
@@ -652,102 +653,6 @@ void au0828_usb_v4l2_media_release(struct au0828_dev *dev)
 #endif
 }
 
-static int au0828_create_media_graph(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL, *demod = NULL;
-	int i, ret;
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
-		case MEDIA_ENT_F_DTV_DEMOD:
-			demod = entity;
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
-		dev->tuner = tuner;
-		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-					    decoder, DEMOD_PAD_IF_INPUT, 0);
-		if (ret)
-			return ret;
-	}
-	ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
-				    &dev->vdev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
-	ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT,
-				    &dev->vbi_dev.entity, 0,
-				    MEDIA_LNK_FL_ENABLED);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < AU0828_MAX_INPUT; i++) {
-		struct media_entity *ent = &dev->input_ent[i];
-
-		switch (AUVI_INPUT(i).type) {
-		case AU0828_VMUX_UNDEFINED:
-			break;
-		case AU0828_VMUX_CABLE:
-		case AU0828_VMUX_TELEVISION:
-		case AU0828_VMUX_DVB:
-			if (!tuner)
-				break;
-
-			ret = media_create_pad_link(ent, 0, tuner,
-						    TUNER_PAD_RF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-			break;
-		case AU0828_VMUX_COMPOSITE:
-		case AU0828_VMUX_SVIDEO:
-			/* FIXME: fix the decoder PAD */
-			ret = media_create_pad_link(ent, 0, decoder,
-						    DEMOD_PAD_IF_INPUT, 0);
-			if (ret)
-				return ret;
-			break;
-		}
-	}
-
-	/*
-	 * Disable tuner to demod link to avoid disable step
-	 * when tuner is requested by video or audio
-	*/
-	if (tuner && demod) {
-		struct media_link *link;
-
-		list_for_each_entry(link, &demod->links, list) {
-			if (link->sink->entity == demod &&
-			    link->source->entity == tuner) {
-				media_entity_setup_link(link, 0);
-			}
-		}
-	}
-#endif
-	return 0;
-}
-
 static void au0828_usb_v4l2_release(struct v4l2_device *v4l2_dev)
 {
 	struct au0828_dev *dev =
@@ -2120,14 +2025,16 @@ int au0828_analog_register(struct au0828_dev *dev,
 		ret = -ENODEV;
 		goto err_reg_vbi_dev;
 	}
-	retval = au0828_create_media_graph(dev);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	retval = v4l2_mc_create_media_graph(dev->media_dev);
 	if (retval) {
 		pr_err("%s() au0282_dev_register failed to create graph\n",
 			__func__);
 		ret = -ENODEV;
 		goto err_reg_vbi_dev;
 	}
-
+#endif
 
 	dprintk(1, "%s completed!\n", __func__);
 
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 643686d40551..e6c8a34590b9 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -27,7 +27,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *if_vid = NULL, *if_aud = NULL;
-	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL, *dtv_demod = NULL;
 	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
 	bool is_webcam = false;
 	u32 flags;
@@ -50,6 +50,9 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		case MEDIA_ENT_F_ATV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_F_DTV_DEMOD:
+			dtv_demod = entity;
+			break;
 		case MEDIA_ENT_F_IO_V4L:
 			io_v4l = entity;
 			break;
@@ -183,6 +186,22 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 		flags = 0;
 	}
+
+       /*
+        * Disable tuner to demod link to avoid disable step
+        * when tuner is requested by video or audio
+        */
+	if (tuner && dtv_demod) {
+		struct media_link *link;
+
+		list_for_each_entry(link, &dtv_demod->links, list) {
+			if (link->sink->entity == dtv_demod &&
+			    link->source->entity == tuner) {
+				media_entity_setup_link(link, 0);
+			}
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_mc_create_media_graph);
-- 
2.5.0

