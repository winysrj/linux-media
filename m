Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56510 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389863AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Brian Warner <brian.warner@samsung.com>
Subject: [PATCH 08/13] media: saa7115: declare its own pads
Date: Wed,  1 Aug 2018 12:55:10 -0300
Message-Id: <b4ef071343e4bd4584d2121e299d095613870f78.1533138685.git.mchehab+samsung@kernel.org>
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
 drivers/media/i2c/saa7115.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 8798a06c212f..09bedbc71567 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -59,10 +59,17 @@ enum saa711x_model {
 	SAA7118,
 };
 
+
+enum saa711x_pads {
+       SAA711X_PAD_IF_INPUT,
+       SAA711X_PAD_VID_OUT,
+       SAA711X_NUM_PADS
+};
+
 struct saa711x_state {
 	struct v4l2_subdev sd;
 #ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_pad pads[DEMOD_NUM_PADS];
+	struct media_pad pads[SAA711X_NUM_PADS];
 #endif
 	struct v4l2_ctrl_handler hdl;
 
@@ -1834,14 +1841,14 @@ static int saa711x_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(sd, client, &saa711x_ops);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	state->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-	state->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+	state->pads[SAA711X_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[SAA711X_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->pads[SAA711X_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[SAA711X_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
-	ret = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, state->pads);
+	ret = media_entity_pads_init(&sd->entity, SAA711X_NUM_PADS, state->pads);
 	if (ret < 0)
 		return ret;
 #endif
-- 
2.17.1
