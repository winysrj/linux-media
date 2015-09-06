Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbIFRbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:40 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Tommi Rantala <tt.rantala@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 01/18] [media] tuner-core: add an input pad
Date: Sun,  6 Sep 2015 14:30:44 -0300
Message-Id: <7e90c4ecdcdc15ebb3b32ac075168a93a6b63f4f.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuners actually have at least one connector on its
input.

Add a PAD to connect it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index f00f1a5f279c..a8e7e2398f7a 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -34,6 +34,9 @@
 #include <linux/mutex.h>
 #include "dvbdev.h"
 
+/* Due to enum tuner_pad_index */
+#include <media/tuner.h>
+
 static DEFINE_MUTEX(dvbdev_mutex);
 static int dvbdev_debug;
 
@@ -552,7 +555,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	}
 
 	if (tuner && demod)
-		media_create_pad_link(tuner, 0, demod, 0, 0);
+		media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, demod, 0, 0);
 
 	if (demod && demux)
 		media_create_pad_link(demod, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index e28cabe65934..f54c7d10f350 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -27,6 +27,9 @@
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
 
+/* Due to enum tuner_pad_index */
+#include <media/tuner.h>
+
 /*
  * 1 = General debug messages
  * 2 = USB handling
@@ -260,7 +263,7 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 		return;
 
 	if (tuner)
-		media_create_pad_link(tuner, 0, decoder, 0,
+		media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, decoder, 0,
 				      MEDIA_LNK_FL_ENABLED);
 	media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
 			      MEDIA_LNK_FL_ENABLED);
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 3b5c9ae39ad3..1070d87efc65 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1264,7 +1264,7 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
 		return;
 
 	if (tuner)
-		media_create_pad_link(tuner, 0, decoder, 0,
+		media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
 	media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 100b8f069640..b90f2a52db96 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -134,8 +134,9 @@ struct tuner {
 	unsigned int        type; /* chip type id */
 	void                *config;
 	const char          *name;
+
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	struct media_pad	pad;
+	struct media_pad	pad[TUNER_NUM_PADS];
 #endif
 };
 
@@ -695,11 +696,12 @@ static int tuner_probe(struct i2c_client *client,
 	/* Should be just before return */
 register_client:
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	t->pad.flags = MEDIA_PAD_FL_SOURCE;
+	t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	t->pad[TUNER_PAD_IF_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
 	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
 	t->sd.entity.name = t->name;
 
-	ret = media_entity_init(&t->sd.entity, 1, &t->pad);
+	ret = media_entity_init(&t->sd.entity, TUNER_NUM_PADS, &t->pad[0]);
 	if (ret < 0) {
 		tuner_err("failed to initialize media entity!\n");
 		kfree(t);
diff --git a/include/media/tuner.h b/include/media/tuner.h
index b46ebb48fe74..95835c8069dd 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -25,6 +25,14 @@
 
 #include <linux/videodev2.h>
 
+/* Tuner PADs */
+/* FIXME: is this the right place for it? */
+enum tuner_pad_index {
+	TUNER_PAD_RF_INPUT,
+	TUNER_PAD_IF_OUTPUT,
+	TUNER_NUM_PADS
+};
+
 #define ADDR_UNSET (255)
 
 #define TUNER_TEMIC_PAL			0        /* 4002 FH5 (3X 7756, 9483) */
-- 
2.4.3


