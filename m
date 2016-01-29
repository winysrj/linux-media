Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbcA2MMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:13 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Olli Salonen <olli.salonen@iki.fi>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 03/13] [media] tuner.h: rename TUNER_PAD_IF_OUTPUT to TUNER_PAD_OUTPUT
Date: Fri, 29 Jan 2016 10:10:53 -0200
Message-Id: <1ffe1264ce5399fba30a953602be896b0bcd7f5a.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output of a tuner is not only IF frequencies. They may also
output audio on some of its pins. So, rename the PAD name to
make it clearer and add a proper documentation about that at
tuner.h.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvbdev.c           |  2 +-
 drivers/media/usb/au0828/au0828-core.c    |  2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c   |  2 +-
 drivers/media/v4l2-core/tuner-core.c      |  2 +-
 include/media/tuner.h                     | 21 ++++++++++++++++++---
 6 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 560450a0b32a..a7de62ebc415 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -661,7 +661,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	if (ntuner && ndemod) {
 		ret = media_create_pad_links(mdev,
 					     MEDIA_ENT_F_TUNER,
-					     tuner, TUNER_PAD_IF_OUTPUT,
+					     tuner, TUNER_PAD_OUTPUT,
 					     MEDIA_ENT_F_DTV_DEMOD,
 					     demod, 0, MEDIA_LNK_FL_ENABLED,
 					     false);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 9e29e70a78d7..df2bc3f732b6 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -276,7 +276,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		return -EINVAL;
 
 	if (tuner) {
-		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
+		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
 					    decoder, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 620b83d03f75..54e43fe13e6d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1259,7 +1259,7 @@ static int cx231xx_create_media_graph(struct cx231xx *dev)
 		return 0;
 
 	if (tuner) {
-		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, decoder, 0,
+		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT, decoder, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index b669deccc34c..e7978e4e40ea 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -888,7 +888,7 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 	state->tuner.function = MEDIA_ENT_F_TUNER;
 	state->tuner.name = "mxl111sf tuner";
 	state->tuner_pads[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->tuner_pads[TUNER_PAD_IF_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->tuner_pads[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
 
 	ret = media_entity_pads_init(&state->tuner,
 				     TUNER_NUM_PADS, state->tuner_pads);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 76496fd282aa..a1f858b34187 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -697,7 +697,7 @@ static int tuner_probe(struct i2c_client *client,
 register_client:
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	t->pad[TUNER_PAD_IF_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+	t->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
 	t->sd.entity.function = MEDIA_ENT_F_TUNER;
 	t->sd.entity.name = t->name;
 
diff --git a/include/media/tuner.h b/include/media/tuner.h
index e5321fda5489..c5994fe865a0 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -21,11 +21,26 @@
 
 #include <linux/videodev2.h>
 
-/* Tuner PADs */
-/* FIXME: is this the right place for it? */
+/**
+ * enum tuner_pad_index - tuner pad index
+ *
+ * @TUNER_PAD_RF_INPUT:	Radiofrequency (RF) sink pad, usually linked to a
+ *			RF connector entity.
+ * @TUNER_PAD_OUTPUT:	Tuner output pad. This is actually more complex than
+ *			a single pad output, as, in addition to luminance and
+ *			chrominance IF a tuner may have internally an
+ *			audio decoder (like xc3028) or it may produce an audio
+ *			IF that will be used by an audio decoder like msp34xx.
+ *			It may also have an IF-PLL demodulator on it, like
+ *			tuners with tda9887. Yet, currently, we don't need to
+ *			represent all the dirty details, as this is transparent
+ *			for the V4L2 API usage. So, let's represent all kinds
+ *			of different outputs as a single source pad.
+ * @TUNER_NUM_PADS:	Number of pads of the tuner.
+ */
 enum tuner_pad_index {
 	TUNER_PAD_RF_INPUT,
-	TUNER_PAD_IF_OUTPUT,
+	TUNER_PAD_OUTPUT,
 	TUNER_NUM_PADS
 };
 
-- 
2.5.0


