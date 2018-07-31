Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732212AbeGaSnc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 14:43:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Brian Warner <brian.warner@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH RFC 2/4] media: v4l2: taint pads with the signal types for consumer devices
Date: Tue, 31 Jul 2018 14:02:11 -0300
Message-Id: <7924b017ca7ec869e94cd54dbf74f1c537c16e3d.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
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

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/au8522_decoder.c |  3 ++
 drivers/media/i2c/msp3400-driver.c           |  2 ++
 drivers/media/i2c/saa7115.c                  |  2 ++
 drivers/media/i2c/tvp5150.c                  |  2 ++
 drivers/media/pci/saa7134/saa7134-core.c     |  2 ++
 drivers/media/tuners/si2157.c                |  3 ++
 drivers/media/usb/dvb-usb-v2/mxl111sf.c      |  2 ++
 drivers/media/v4l2-core/tuner-core.c         |  5 +++
 include/media/media-entity.h                 | 33 ++++++++++++++++++++
 9 files changed, 54 insertions(+)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 30cd2bd7aec2..f4df9ab3d8b0 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -721,8 +721,11 @@ static int au8522_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
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
index 4c72db58dfd2..0b298aa34a7c 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1835,7 +1835,9 @@ static int saa711x_probe(struct i2c_client *client,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 1414c2c14639..dab83a774e73 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1495,7 +1495,9 @@ static int tvp5150_probe(struct i2c_client *c,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	core->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_ATV_VIDEO;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 267d143c3a48..322e2ac00066 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -846,7 +846,9 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 	if (!decoder) {
 		dev->demod.name = "saa713x";
 		dev->demod_pad[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->demod_pad[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_RF;
 		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
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
 
-- 
2.17.1
