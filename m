Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732144AbeGaPCv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 11:02:51 -0400
Date: Tue, 31 Jul 2018 10:22:22 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: Marco Felsch <m.felsch@pengutronix.de>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
Message-ID: <20180731102222.698c7206@coco.lan>
In-Reply-To: <20180731070659.43afe417@coco.lan>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-19-m.felsch@pengutronix.de>
        <20180730151842.0fd99d01@coco.lan>
        <3a9f8715-a3a6-b250-82ad-6f2df6500767@redhat.com>
        <20180731070659.43afe417@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 31 Jul 2018 07:06:59 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Tue, 31 Jul 2018 10:52:56 +0200
> Javier Martinez Canillas <javierm@redhat.com> escreveu:
> 

> The graph is not built correct, as it is linking tvp5150's input pads as
> if they were output ones.
> 
> The problem is that now you need to teach drivers/media/v4l2-core/v4l2-mc.c
> to do the proper wiring for tvp5150.
> 
> I suspect that fixing v4l2-mc for doing that is not hard, but it may
> require changes at the other demods. Thankfully there aren't many
> demod drivers, but such patch should be applied before patch 19/22.
> 
> In the specific case of demods that don't support sliced VBI (or
> where sliced VBI is not coded), there should be just one source pad.
> 
> On demods with sliced VBI, there are actually two source pads,
> although, for simplicity, maybe we could map them as just one.
> 
> If we map as just one source pad, it is probably easy to change the
> code at v4l2-mc to do the right thing.
> 
> I'll do some tests here and try to code it.

Ok, did some coding. The way to make it more robust and allow having
a different number of PADs for different demods/tuners is with an
approach like the one below.

This is just a RFC sort of patch, as it is incomplete, not covering the
dvbdev.c pipeline setup logic.

Anyway, it should be useful for further discussions, but some work
is needed.

Regards,
Mauro


[RFC] media: v4l2: taint pads with the signal types for consumer devices

Consumer devices are provided with a wide diferent range of types
supported by the same driver, allowing different configutations.

In order to make easier to setup media controller links, "taint"
pads with the signal type it carries.

While here, get rid of DEMOD_PAD_VBI_OUT, as the signal it carries
is actually the same as the normal video output.

The difference happens at the video/VBI interface:
        - for VBI, only the hidden lines are streamed;
        - for video, the stream is usually cropped to hide the
          vbi lines.

Compile-tested only and incomplete: the dvbdev.c should have a similar
change like the one done at v4l2-mc.c.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 343dc92ef54e..f4df9ab3d8b0 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -721,9 +721,11 @@ static int au8522_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 	state->pads[DEMOD_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_AUDIO_OUT].sig_type = PAD_SIGNAL_AUDIO;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 3db966db83eb..3b9c729fbd52 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -704,7 +704,9 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[IF_AUD_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[IF_AUD_DEC_PAD_IF_INPUT].sig_type = PAD_SIGNAL_AUDIO;
 	state->pads[IF_AUD_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[IF_AUD_DEC_PAD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 
 	sd->entity.function = MEDIA_ENT_F_IF_AUD_DECODER;
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index b07114b5efb2..0b298aa34a7c 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1835,8 +1835,9 @@ static int saa711x_probe(struct i2c_client *client,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 1734ed4ede33..dab83a774e73 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1495,8 +1495,9 @@ static int tvp5150_probe(struct i2c_client *c,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	core->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 9e76de2411ae..322e2ac00066 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -846,8 +846,9 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 	if (!decoder) {
 		dev->demod.name = "saa713x";
 		dev->demod_pad[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->demod_pad[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->demod_pad[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->demod_pad[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 		dev->demod.function = MEDIA_ENT_F_ATV_DECODER;
 
 		ret = media_entity_pads_init(&dev->demod, DEMOD_NUM_PADS,
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 9e34d31d724d..85e9ea9059a3 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -469,8 +469,11 @@ static int si2157_probe(struct i2c_client *client,
 		dev->ent.function = MEDIA_ENT_F_TUNER;
 
 		dev->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_RF;
 		dev->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_CARRIERS;
 		dev->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 
 		ret = media_entity_pads_init(&dev->ent, TUNER_NUM_PADS,
 					     &dev->pad[0]);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 67953360fda5..9161064b7718 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -893,7 +893,9 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 	state->tuner.function = MEDIA_ENT_F_TUNER;
 	state->tuner.name = "mxl111sf tuner";
 	state->tuner_pads[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->tuner_pads[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_RF;
 	state->tuner_pads[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->tuner_pads[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_CARRIERS;
 
 	ret = media_entity_pads_init(&state->tuner,
 				     TUNER_NUM_PADS, state->tuner_pads);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 7f858c39753c..4c09c30e6ea1 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -685,15 +685,20 @@ static int tuner_probe(struct i2c_client *client,
 	 */
 	if (t->type == TUNER_TDA9887) {
 		t->pad[IF_VID_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		t->pad[IF_VID_DEC_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 		t->pad[IF_VID_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[IF_VID_DEC_PAD_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 		ret = media_entity_pads_init(&t->sd.entity,
 					     IF_VID_DEC_PAD_NUM_PADS,
 					     &t->pad[0]);
 		t->sd.entity.function = MEDIA_ENT_F_IF_VID_DECODER;
 	} else {
 		t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		t->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_RF;
 		t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_CARRIERS;
 		t->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 		ret = media_entity_pads_init(&t->sd.entity, TUNER_NUM_PADS,
 					     &t->pad[0]);
 		t->sd.entity.function = MEDIA_ENT_F_TUNER;
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
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a732af1dbba0..bf0604d315ef 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -155,6 +155,38 @@ struct media_link {
 	bool is_backlink;
 };
 
+/**
+ * struct media_pad_signal_type - type of the signal inside a media pad
+ *
+ * @PAD_SIGNAL_DEFAULT
+ *	Default signal. Use this when all inputs or all outputs are
+ *	uniquely identified by just its number and all carries the same
+ *	signal type
+ * @PAD_SIGNAL_RF
+ *	The pad contains a Radio Frequency, Intermediate Frequency or
+ *	baseband signal.
+ *	All Tuner sinks should use it.
+ *	On tuner sources, this is used for digital TV demodulators and for
+ *	IF-PLL demodulator like tda9887.
+ * @PAD_SIGNAL_CARRIERS
+ *	The pad contains analog signals carrying either a digital or an analog
+ *	modulated (or baseband) signal. This is provided by tuner source
+ *	pads and used by analog TV standard decoders and by digital tv demods.
+ * @PAD_SIGNAL_ATV_VIDEO
+ *	Contains a bitstream of samples from an analog TV video source, with
+ *	usually contains the VBI data on it.
+ * @PAD_SIGNAL_AUDIO
+ *	Contains an Intermediate Frequency analog signal from an audio
+ *	sub-carrier or an audio bitstream. Provided by tuners and consumed by audio AM/FM decoders.
+ */
+enum media_pad_signal_type {
+	PAD_SIGNAL_DEFAULT = 0,
+	PAD_SIGNAL_RF,
+	PAD_SIGNAL_CARRIERS,
+	PAD_SIGNAL_ATV_VIDEO,
+	PAD_SIGNAL_AUDIO,
+};
+
 /**
  * struct media_pad - A media pad graph object.
  *
@@ -169,6 +201,7 @@ struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	struct media_entity *entity;
 	u16 index;
+	enum media_pad_signal_type sig_type;
 	unsigned long flags;
 };
 
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





Thanks,
Mauro
