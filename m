Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbeIPBev (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:51 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Brian Warner <brian.warner@samsung.com>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 01/14] media: v4l2: remove VBI output pad
Date: Sat, 15 Sep 2018 17:14:16 -0300
Message-Id: <b088a4161e8980d24c7ccf3c752cec84b43f98e9.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The signal there is the same as the video output (well,
except for sliced VBI, but let's simplify the model and ignore
it, at least for now - as it is routed together with raw
VBI).

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 1 -
 drivers/media/i2c/saa7115.c                  | 1 -
 drivers/media/i2c/tvp5150.c                  | 1 -
 drivers/media/pci/saa7134/saa7134-core.c     | 1 -
 drivers/media/v4l2-core/v4l2-mc.c            | 2 +-
 include/media/v4l2-mc.h                      | 2 --
 6 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index f285096a48f0..198dd2b6f326 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -720,7 +720,6 @@ static int au8522_probe(struct i2c_client *client,
 
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	state->pads[DEMOD_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 7bc3b721831e..471d1b7af164 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1836,7 +1836,6 @@ static int saa711x_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 57b2102586bc..93c373c20efd 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1501,7 +1501,6 @@ static int tvp5150_probe(struct i2c_client *c,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
 	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 9e76de2411ae..267d143c3a48 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -847,7 +847,6 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 		dev->demod.name = "saa713x";
 		dev->demod_pad[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
 		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->demod_pad[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 		dev->demod.function = MEDIA_ENT_F_ATV_DECODER;
 
 		ret = media_entity_pads_init(&dev->demod, DEMOD_NUM_PADS,
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 0fc185a2ce90..982bab3530f6 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -147,7 +147,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	if (io_vbi) {
-		ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT,
+		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
 					    io_vbi, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 2634d9dc9916..7c9c781b16a9 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -89,14 +89,12 @@ enum if_aud_dec_pad_index {
  *
  * @DEMOD_PAD_IF_INPUT:	IF input sink pad.
  * @DEMOD_PAD_VID_OUT:	Video output source pad.
- * @DEMOD_PAD_VBI_OUT:	Vertical Blank Interface (VBI) output source pad.
  * @DEMOD_PAD_AUDIO_OUT: Audio output source pad.
  * @DEMOD_NUM_PADS:	Maximum number of output pads.
  */
 enum demod_pad_index {
 	DEMOD_PAD_IF_INPUT,
 	DEMOD_PAD_VID_OUT,
-	DEMOD_PAD_VBI_OUT,
 	DEMOD_PAD_AUDIO_OUT,
 	DEMOD_NUM_PADS
 };
-- 
2.17.1
