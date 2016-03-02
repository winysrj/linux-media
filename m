Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbcCBOQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 09:16:18 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] [media] au0828: use standard demod pads struct
Date: Wed,  2 Mar 2016 11:16:08 -0300
Message-Id: <b8604bfcb3878cd1b1f1d0f0ad6ddc6374703946.1456928097.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1456928097.git.mchehab@osg.samsung.com>
References: <cover.1456928097.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1456928097.git.mchehab@osg.samsung.com>
References: <cover.1456928097.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we want au0828 to use the core function to create the MC
graphs, use enum demod_pad_index instead of
enum au8522_media_pads.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/au8522.h         | 9 ---------
 drivers/media/dvb-frontends/au8522_decoder.c | 8 ++++----
 drivers/media/dvb-frontends/au8522_priv.h    | 3 ++-
 drivers/media/usb/au0828/au0828-core.c       | 2 +-
 drivers/media/usb/au0828/au0828-video.c      | 8 ++++----
 include/media/v4l2-mc.h                      | 1 +
 6 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index d7a997fada7f..78bf3f73e58d 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -89,13 +89,4 @@ enum au8522_audio_input {
 	AU8522_AUDIO_NONE,
 	AU8522_AUDIO_SIF,
 };
-
-enum au8522_media_pads {
-	AU8522_PAD_INPUT,
-	AU8522_PAD_VID_OUT,
-	AU8522_PAD_VBI_OUT,
-	AU8522_PAD_AUDIO_OUT,
-
-	AU8522_NUM_PADS
-};
 #endif /* __AU8522_H__ */
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 0ab9f1eb8a29..add246382806 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -763,10 +763,10 @@ static int au8522_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(sd, client, &au8522_ops);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 
-	state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index 505215a21ddd..f5a9438f6ce5 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -30,6 +30,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-mc.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 #include "au8522.h"
@@ -70,7 +71,7 @@ struct au8522_state {
 	struct v4l2_ctrl_handler hdl;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_pad pads[AU8522_NUM_PADS];
+	struct media_pad pads[DEMOD_NUM_PADS];
 #endif
 };
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index ca1e5ebf3b6b..6da4e5749f3a 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -218,7 +218,7 @@ static void au0828_media_graph_notify(struct media_entity *new,
 	switch (new->function) {
 	case MEDIA_ENT_F_AUDIO_MIXER:
 		ret = media_create_pad_link(dev->decoder,
-					    AU8522_PAD_AUDIO_OUT,
+					    DEMOD_PAD_AUDIO_OUT,
 					    new, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 1958de192608..b82deda02643 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -686,16 +686,16 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	if (tuner) {
 		dev->tuner = tuner;
 		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
-					    decoder, AU8522_PAD_INPUT, 0);
+					    decoder, DEMOD_PAD_IF_INPUT, 0);
 		if (ret)
 			return ret;
 	}
-	ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
+	ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
 				    &dev->vdev.entity, 0,
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		return ret;
-	ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
+	ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT,
 				    &dev->vbi_dev.entity, 0,
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
@@ -723,7 +723,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		case AU0828_VMUX_SVIDEO:
 			/* FIXME: fix the decoder PAD */
 			ret = media_create_pad_link(ent, 0, decoder,
-						    AU8522_PAD_INPUT, 0);
+						    DEMOD_PAD_IF_INPUT, 0);
 			if (ret)
 				return ret;
 			break;
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 5cbc20923faf..2d880e035490 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -93,6 +93,7 @@ enum demod_pad_index {
 	DEMOD_PAD_IF_INPUT,
 	DEMOD_PAD_VID_OUT,
 	DEMOD_PAD_VBI_OUT,
+	DEMOD_PAD_AUDIO_OUT,
 	DEMOD_NUM_PADS
 };
 
-- 
2.5.0


