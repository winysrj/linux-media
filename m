Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 05/13] [media] v4l2-mc.h: Split audio from baseband output
Date: Fri, 29 Jan 2016 10:10:55 -0200
Message-Id: <d668af863faeb8d6a4a95358d6b2a673110a00e7.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Analog TV tuners have a separate output pad for the audio
IF or audio sampled data. This pad is connected to a different
chipset.

Add an extra pad for it and improve the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/tuner-core.c |  1 +
 include/media/v4l2-mc.h              | 28 +++++++++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index a1f858b34187..d6bd9ce1101d 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -698,6 +698,7 @@ register_client:
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
 	t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+	t->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	t->sd.entity.function = MEDIA_ENT_F_TUNER;
 	t->sd.entity.name = t->name;
 
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index f6fcd70f3548..c174e5b4f188 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -19,20 +19,26 @@
  *
  * @TUNER_PAD_RF_INPUT:	Radiofrequency (RF) sink pad, usually linked to a
  *			RF connector entity.
- * @TUNER_PAD_OUTPUT:	Tuner output pad. This is actually more complex than
- *			a single pad output, as, in addition to luminance and
- *			chrominance IF a tuner may have internally an
- *			audio decoder (like xc3028) or it may produce an audio
- *			IF that will be used by an audio decoder like msp34xx.
- *			It may also have an IF-PLL demodulator on it, like
- *			tuners with tda9887. Yet, currently, we don't need to
- *			represent all the dirty details, as this is transparent
- *			for the V4L2 API usage. So, let's represent all kinds
- *			of different outputs as a single source pad.
+ * @TUNER_PAD_OUTPUT:	Tuner video output source pad. Contains the video
+ *			chrominance and luminance or the hole bandwidth
+ *			of the signal converted to an Intermediate Frequency
+ *			(IF) or to baseband (on zero-IF tuners).
+ * @TUNER_PAD_AUD_OUT:	Tuner audio output source pad. Tuners used to decode
+ *			analog TV signals have an extra pad for audio output.
+ *			Old tuners use an analog stage with a saw filter for
+ *			the audio IF frequency. The output of the pad is, in
+ *			this case, the audio IF, with should be decoded either
+ *			by the bridge chipset (that's the case of cx2388x
+ *			chipsets) or may require an external IF sound
+ *			processor, like msp34xx. On modern silicon tuners,
+ *			the audio IF decoder is usually incorporated at the
+ *			tuner. On such case, the output of this pad is an
+ *			audio sampled data.
  * @TUNER_NUM_PADS:	Number of pads of the tuner.
  */
 enum tuner_pad_index {
 	TUNER_PAD_RF_INPUT,
 	TUNER_PAD_OUTPUT,
+	TUNER_PAD_AUD_OUT,
 	TUNER_NUM_PADS
-};
\ No newline at end of file
+};
-- 
2.5.0


