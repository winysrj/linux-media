Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbeIPBer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 11/14] media: si2157: declare its own pads
Date: Sat, 15 Sep 2018 17:14:26 -0300
Message-Id: <dbf8228f8e14b1c3009e788beac6dceaf9159b7e.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we don't need anymore to share pad numbers with similar
drivers, use its own pad definition instead of a global
model.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/tuners/si2157.c      | 15 ++++++++-------
 drivers/media/tuners/si2157_priv.h |  9 ++++++++-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 0e39810922fc..d389f1fc237a 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -467,14 +467,15 @@ static int si2157_probe(struct i2c_client *client,
 
 		dev->ent.name = KBUILD_MODNAME;
 		dev->ent.function = MEDIA_ENT_F_TUNER;
-		dev->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-		dev->pad[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-		dev->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->pad[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
-		dev->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-		dev->pad[TUNER_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
 
-		ret = media_entity_pads_init(&dev->ent, TUNER_NUM_PADS,
+		dev->pad[SI2157_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->pad[SI2157_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->pad[SI2157_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[SI2157_PAD_VID_OUT].sig_type = PAD_SIGNAL_ANALOG;
+		dev->pad[SI2157_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[SI2157_PAD_AUD_OUT].sig_type = PAD_SIGNAL_AUDIO;
+
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
