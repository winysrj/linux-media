Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42388 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 07/13] [media] v4l2-mc.h Add pads for audio and video IF-PLL decoders
Date: Fri, 29 Jan 2016 10:10:57 -0200
Message-Id: <a57edbf5f98266272cf8e45ec509a5845e9adcbb.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The audio and video IF-PLL decoders have one sink and one source
PAD. Add macro names for those pads and describe what kind of
signals are represented at such pads.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/tuner-core.c | 27 +++++++++++++++++++++------
 include/media/v4l2-mc.h              | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index d6bd9ce1101d..731487be5baa 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -696,17 +696,32 @@ static int tuner_probe(struct i2c_client *client,
 	/* Should be just before return */
 register_client:
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
-	t->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	t->sd.entity.function = MEDIA_ENT_F_TUNER;
 	t->sd.entity.name = t->name;
+	/*
+	 * Handle the special case where the tuner has actually
+	 * two stages: the PLL to tune into a frequency and the
+	 * IF-PLL demodulator (tda988x).
+	 */
+	if (t->type == TUNER_TDA9887) {
+		t->pad[IF_VID_DEC_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		t->pad[IF_VID_DEC_PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(&t->sd.entity,
+					     IF_VID_DEC_PAD_NUM_PADS,
+					     &t->pad[0]);
+		t->sd.entity.function = MEDIA_ENT_F_IF_VID_DECODER;
+	} else {
+		t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+		t->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(&t->sd.entity, TUNER_NUM_PADS,
+					     &t->pad[0]);
+		t->sd.entity.function = MEDIA_ENT_F_TUNER;
+	}
 
-	ret = media_entity_pads_init(&t->sd.entity, TUNER_NUM_PADS, &t->pad[0]);
 	if (ret < 0) {
 		tuner_err("failed to initialize media entity!\n");
 		kfree(t);
-		return -ENODEV;
+		return ret;
 	}
 #endif
 	/* Sets a default mode */
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index c174e5b4f188..6a6ef5bc767e 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -42,3 +42,35 @@ enum tuner_pad_index {
 	TUNER_PAD_AUD_OUT,
 	TUNER_NUM_PADS
 };
+
+/**
+ * enum if_vid_dec_index - video IF-PLL pad index for
+ *			   MEDIA_ENT_F_IF_VID_DECODER
+ *
+ * @IF_VID_DEC_PAD_IF_INPUT:	video Intermediate Frequency (IF) sink pad
+ * @IF_VID_DEC_PAD_OUT:		IF-PLL video output source pad. Contains the
+ *				video chrominance and luminance IF signals.
+ * @IF_VID_DEC_PAD_NUM_PADS:	Number of pads of the video IF-PLL.
+ */
+enum if_vid_dec_pad_index {
+	IF_VID_DEC_PAD_IF_INPUT,
+	IF_VID_DEC_PAD_OUT,
+	IF_VID_DEC_PAD_NUM_PADS
+};
+
+/**
+ * enum if_aud_dec_index - audio/sound IF-PLL pad index for
+ *			   MEDIA_ENT_F_IF_AUD_DECODER
+ *
+ * @IF_AUD_DEC_PAD_IF_INPUT:	audio Intermediate Frequency (IF) sink pad
+ * @IF_AUD_DEC_PAD_OUT:		IF-PLL audio output source pad. Contains the
+ *				audio sampled stream data, usually connected
+ *				to the bridge bus via an Inter-IC Sound (I2S)
+ *				bus.
+ * @IF_AUD_DEC_PAD_NUM_PADS:	Number of pads of the audio IF-PLL.
+ */
+enum if_aud_dec_pad_index {
+	IF_AUD_DEC_PAD_IF_INPUT,
+	IF_AUD_DEC_PAD_OUT,
+	IF_AUD_DEC_PAD_NUM_PADS
+};
-- 
2.5.0


