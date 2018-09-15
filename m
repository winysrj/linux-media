Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43360 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbeIPBer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 14/14] media: v4l2-mc: get rid of global pad indexes
Date: Sat, 15 Sep 2018 17:14:29 -0300
Message-Id: <8a0329ffa68d0c3d7a05485aa25e53013f992fd6.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all drivers are using pad signal types, we can get
rid of the global static definition, as routes are stablished
using the pad signal type.

The tuner and IF-PLL pads are now used only by the tuner core,
so move the definitions to be there.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/tuner-core.c | 49 +++++++++++++++++-
 include/media/v4l2-mc.h              | 76 ----------------------------
 2 files changed, 48 insertions(+), 77 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 2f3b7fb092b9..92b20bae6c06 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -94,9 +94,56 @@ static const struct v4l2_subdev_ops tuner_ops;
 } while (0)
 
 /*
- * Internal struct used inside the driver
+ * Internal enums/struct used inside the driver
  */
 
+/**
+ * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
+ *
+ * @TUNER_PAD_RF_INPUT:
+ *	Radiofrequency (RF) sink pad, usually linked to a RF connector entity.
+ * @TUNER_PAD_OUTPUT:
+ *	tuner video output source pad. Contains the video chrominance
+ *	and luminance or the hole bandwidth of the signal converted to
+ *	an Intermediate Frequency (IF) or to baseband (on zero-IF tuners).
+ * @TUNER_PAD_AUD_OUT:
+ *	Tuner audio output source pad. Tuners used to decode analog TV
+ *	signals have an extra pad for audio output. Old tuners use an
+ *	analog stage with a saw filter for the audio IF frequency. The
+ *	output of the pad is, in this case, the audio IF, with should be
+ *	decoded either by the bridge chipset (that's the case of cx2388x
+ *	chipsets) or may require an external IF sound processor, like
+ *	msp34xx. On modern silicon tuners, the audio IF decoder is usually
+ *	incorporated at the tuner. On such case, the output of this pad
+ *	is an audio sampled data.
+ * @TUNER_NUM_PADS:
+ *	Number of pads of the tuner.
+ */
+enum tuner_pad_index {
+	TUNER_PAD_RF_INPUT,
+	TUNER_PAD_OUTPUT,
+	TUNER_PAD_AUD_OUT,
+	TUNER_NUM_PADS
+};
+
+/**
+ * enum if_vid_dec_pad_index - video IF-PLL pad index
+ *	for MEDIA_ENT_F_IF_VID_DECODER
+ *
+ * @IF_VID_DEC_PAD_IF_INPUT:
+ *	video Intermediate Frequency (IF) sink pad
+ * @IF_VID_DEC_PAD_OUT:
+ * 	IF-PLL video output source pad. Contains the video chrominance
+ *	and luminance IF signals.
+ * @IF_VID_DEC_PAD_NUM_PADS:
+ *	Number of pads of the video IF-PLL.
+ */
+enum if_vid_dec_pad_index {
+	IF_VID_DEC_PAD_IF_INPUT,
+	IF_VID_DEC_PAD_OUT,
+	IF_VID_DEC_PAD_NUM_PADS
+};
+
 struct tuner {
 	/* device */
 	struct dvb_frontend fe;
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 7c9c781b16a9..bf5043c1ab6b 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -23,82 +23,6 @@
 #include <media/v4l2-dev.h>
 #include <linux/types.h>
 
-/**
- * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
- *
- * @TUNER_PAD_RF_INPUT:	Radiofrequency (RF) sink pad, usually linked to a
- *			RF connector entity.
- * @TUNER_PAD_OUTPUT:	Tuner video output source pad. Contains the video
- *			chrominance and luminance or the hole bandwidth
- *			of the signal converted to an Intermediate Frequency
- *			(IF) or to baseband (on zero-IF tuners).
- * @TUNER_PAD_AUD_OUT:	Tuner audio output source pad. Tuners used to decode
- *			analog TV signals have an extra pad for audio output.
- *			Old tuners use an analog stage with a saw filter for
- *			the audio IF frequency. The output of the pad is, in
- *			this case, the audio IF, with should be decoded either
- *			by the bridge chipset (that's the case of cx2388x
- *			chipsets) or may require an external IF sound
- *			processor, like msp34xx. On modern silicon tuners,
- *			the audio IF decoder is usually incorporated at the
- *			tuner. On such case, the output of this pad is an
- *			audio sampled data.
- * @TUNER_NUM_PADS:	Number of pads of the tuner.
- */
-enum tuner_pad_index {
-	TUNER_PAD_RF_INPUT,
-	TUNER_PAD_OUTPUT,
-	TUNER_PAD_AUD_OUT,
-	TUNER_NUM_PADS
-};
-
-/**
- * enum if_vid_dec_pad_index - video IF-PLL pad index for
- *			   MEDIA_ENT_F_IF_VID_DECODER
- *
- * @IF_VID_DEC_PAD_IF_INPUT:	video Intermediate Frequency (IF) sink pad
- * @IF_VID_DEC_PAD_OUT:		IF-PLL video output source pad. Contains the
- *				video chrominance and luminance IF signals.
- * @IF_VID_DEC_PAD_NUM_PADS:	Number of pads of the video IF-PLL.
- */
-enum if_vid_dec_pad_index {
-	IF_VID_DEC_PAD_IF_INPUT,
-	IF_VID_DEC_PAD_OUT,
-	IF_VID_DEC_PAD_NUM_PADS
-};
-
-/**
- * enum if_aud_dec_pad_index - audio/sound IF-PLL pad index for
- *			   MEDIA_ENT_F_IF_AUD_DECODER
- *
- * @IF_AUD_DEC_PAD_IF_INPUT:	audio Intermediate Frequency (IF) sink pad
- * @IF_AUD_DEC_PAD_OUT:		IF-PLL audio output source pad. Contains the
- *				audio sampled stream data, usually connected
- *				to the bridge bus via an Inter-IC Sound (I2S)
- *				bus.
- * @IF_AUD_DEC_PAD_NUM_PADS:	Number of pads of the audio IF-PLL.
- */
-enum if_aud_dec_pad_index {
-	IF_AUD_DEC_PAD_IF_INPUT,
-	IF_AUD_DEC_PAD_OUT,
-	IF_AUD_DEC_PAD_NUM_PADS
-};
-
-/**
- * enum demod_pad_index - analog TV pad index for MEDIA_ENT_F_ATV_DECODER
- *
- * @DEMOD_PAD_IF_INPUT:	IF input sink pad.
- * @DEMOD_PAD_VID_OUT:	Video output source pad.
- * @DEMOD_PAD_AUDIO_OUT: Audio output source pad.
- * @DEMOD_NUM_PADS:	Maximum number of output pads.
- */
-enum demod_pad_index {
-	DEMOD_PAD_IF_INPUT,
-	DEMOD_PAD_VID_OUT,
-	DEMOD_PAD_AUDIO_OUT,
-	DEMOD_NUM_PADS
-};
-
 /* We don't need to include pci.h or usb.h here */
 struct pci_dev;
 struct usb_device;
-- 
2.17.1
