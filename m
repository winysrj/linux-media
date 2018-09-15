Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbeIPBes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:48 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Brian Warner <brian.warner@samsung.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH v2 02/14] media: v4l2: taint pads with the signal types for consumer devices
Date: Sat, 15 Sep 2018 17:14:17 -0300
Message-Id: <c0e02d89fe321ed5b30f75c9a6f58d76e85cb9a8.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/au8522_decoder.c |  3 ++
 drivers/media/i2c/msp3400-driver.c           |  2 ++
 drivers/media/i2c/saa7115.c                  |  2 ++
 drivers/media/i2c/tvp5150.c                  |  2 ++
 drivers/media/pci/saa7134/saa7134-core.c     |  2 ++
 drivers/media/tuners/si2157.c                |  4 ++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c      |  2 ++
 drivers/media/v4l2-core/tuner-core.c         |  5 ++++
 include/media/media-entity.h                 | 29 ++++++++++++++++++++
 9 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 198dd2b6f326..583fdaa7339f 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -719,8 +719,11 @@ static int au8522_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 	state->pads[DEMOD_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_AUDIO_OUT].sig_type = PAD_SIGNAL_AUDIO;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 98d20479b651..226854ccbd19 100644
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
index 471d1b7af164..7b2dbe7c59b2 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1835,7 +1835,9 @@ static int saa711x_probe(struct i2c_client *client,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 93c373c20efd..94841cf81a7d 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1500,7 +1500,9 @@ static int tvp5150_probe(struct i2c_client *c,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	core->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 267d143c3a48..c4e2df197bf9 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -846,7 +846,9 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 	if (!decoder) {
 		dev->demod.name = "saa713x";
 		dev->demod_pad[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->demod_pad[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->demod_pad[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 		dev->demod.function = MEDIA_ENT_F_ATV_DECODER;
 
 		ret = media_entity_pads_init(&dev->demod, DEMOD_NUM_PADS,
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index a08d8fe2bb1b..0e39810922fc 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -467,10 +467,12 @@ static int si2157_probe(struct i2c_client *client,
 
 		dev->ent.name = KBUILD_MODNAME;
 		dev->ent.function = MEDIA_ENT_F_TUNER;
-
 		dev->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 		dev->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
 		dev->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 
 		ret = media_entity_pads_init(&dev->ent, TUNER_NUM_PADS,
 					     &dev->pad[0]);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 4713ba65e1c2..ecd758388745 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -893,7 +893,9 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 	state->tuner.function = MEDIA_ENT_F_TUNER;
 	state->tuner.name = "mxl111sf tuner";
 	state->tuner_pads[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->tuner_pads[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 	state->tuner_pads[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->tuner_pads[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
 
 	ret = media_entity_pads_init(&state->tuner,
 				     TUNER_NUM_PADS, state->tuner_pads);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 7f858c39753c..2f3b7fb092b9 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -685,15 +685,20 @@ static int tuner_probe(struct i2c_client *client,
 	 */
 	if (t->type == TUNER_TDA9887) {
 		t->pad[IF_VID_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		t->pad[IF_VID_DEC_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 		t->pad[IF_VID_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[IF_VID_DEC_PAD_OUT].sig_type = PAD_SIGNAL_ANALOG;
 		ret = media_entity_pads_init(&t->sd.entity,
 					     IF_VID_DEC_PAD_NUM_PADS,
 					     &t->pad[0]);
 		t->sd.entity.function = MEDIA_ENT_F_IF_VID_DECODER;
 	} else {
 		t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		t->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 		t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
 		t->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 		ret = media_entity_pads_init(&t->sd.entity, TUNER_NUM_PADS,
 					     &t->pad[0]);
 		t->sd.entity.function = MEDIA_ENT_F_TUNER;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3aa3d58d1d58..b132687bd36f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -155,6 +155,34 @@ struct media_link {
 	bool is_backlink;
 };
 
+/**
+ * struct media_pad_signal_type - type of the signal inside a media pad
+ *
+ * @PAD_SIGNAL_DEFAULT
+ *	Default signal. Use this when all inputs or all outputs are
+ *	uniquely identified by the pad number.
+ * @PAD_SIGNAL_ANALOG
+ *	The pad contains an analog signal. It can be Radio Frequency,
+ *	Intermediate Frequency, a baseband signal or sub-cariers.
+ *	Tuner inputs, IF-PLL demodulators, composite and s-video signals
+ *	should use it.
+ * @PAD_SIGNAL_DV
+ *	Contains a digital video signal, with can be a bitstream of samples
+ *	taken from an analog TV video source. On such case, it usually
+ *	contains the VBI data on it.
+ * @PAD_SIGNAL_AUDIO
+ *	Contains an Intermediate Frequency analog signal from an audio
+ *	sub-carrier or an audio bitstream. IF signals are provided by tuners
+ *	and consumed by	audio AM/FM decoders. Bitstream audio is provided by
+ *	an audio decoder.
+ */
+enum media_pad_signal_type {
+	PAD_SIGNAL_DEFAULT = 0,
+	PAD_SIGNAL_ANALOG,
+	PAD_SIGNAL_DV,
+	PAD_SIGNAL_AUDIO,
+};
+
 /**
  * struct media_pad - A media pad graph object.
  *
@@ -169,6 +197,7 @@ struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	struct media_entity *entity;
 	u16 index;
+	enum media_pad_signal_type sig_type;
 	unsigned long flags;
 };
 
-- 
2.17.1
