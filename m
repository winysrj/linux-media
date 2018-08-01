Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56476 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389864AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/13] media: si2157: declare its own pads
Date: Wed,  1 Aug 2018 12:55:12 -0300
Message-Id: <f7b1765b0883479f8013365dcec63b782760c2e5.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we don't need anymore to share pad numbers with similar
drivers, use its own pad definition instead of a global
model.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/tuners/si2157.c      | 14 +++++++-------
 drivers/media/tuners/si2157_priv.h |  9 ++++++++-
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d222912662d7..dc21a86c0175 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -468,14 +468,14 @@ static int si2157_probe(struct i2c_client *client,
 		dev->ent.name = KBUILD_MODNAME;
 		dev->ent.function = MEDIA_ENT_F_TUNER;
 
-		dev->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		dev->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-		dev->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_TV_CARRIERS;
-		dev->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
+		dev->pad[SI2157_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->pad[SI2157_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->pad[SI2157_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[SI2157_PAD_VID_OUT].sig_type = PAD_SIGNAL_TV_CARRIERS;
+		dev->pad[SI2157_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[SI2157_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 
-		ret = media_entity_pads_init(&dev->ent, TUNER_NUM_PADS,
+		ret = media_entity_pads_init(&dev->ent, SI2157_NUM_PADS,
 					     &dev->pad[0]);
 
 		if (ret)
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index e6436f74abaa..129a35e4e11b 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -21,6 +21,13 @@
 #include <media/v4l2-mc.h>
 #include "si2157.h"
 
+enum si2157_pads {
+       SI2157_PAD_RF_INPUT,
+       SI2157_PAD_VID_OUT,
+       SI2157_PAD_AUD_OUT,
+       SI2157_NUM_PADS
+};
+
 /* state struct */
 struct si2157_dev {
 	struct mutex i2c_mutex;
@@ -35,7 +42,7 @@ struct si2157_dev {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device	*mdev;
 	struct media_entity	ent;
-	struct media_pad	pad[TUNER_NUM_PADS];
+	struct media_pad	pad[SI2157_NUM_PADS];
 #endif
 
 };
-- 
2.17.1
