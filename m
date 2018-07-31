Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36668 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbeGaSnc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 14:43:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Brian Warner <brian.warner@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH RFC 1/4] media: v4l2: remove VBI output pad
Date: Tue, 31 Jul 2018 14:02:10 -0300
Message-Id: <50ef58927b86995c3e48dbccac88fb33ff2b0b4b.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The signal there is the same as the video output (well,
except for sliced VBI, but let's simplify the model and ignore
it, at least for now - as it is routed together with raw
VBI).

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
index 343dc92ef54e..30cd2bd7aec2 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -722,7 +722,6 @@ static int au8522_probe(struct i2c_client *client,
 
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	state->pads[DEMOD_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index b07114b5efb2..4c72db58dfd2 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1836,7 +1836,6 @@ static int saa711x_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 1734ed4ede33..1414c2c14639 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1496,7 +1496,6 @@ static int tvp5150_probe(struct i2c_client *c,
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
