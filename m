Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbeIPBer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Brian Warner <brian.warner@samsung.com>
Subject: [PATCH v2 09/14] media: saa7115: declare its own pads
Date: Sat, 15 Sep 2018 17:14:24 -0300
Message-Id: <75d23f5b6cf851ffe2a1a64dbc9052e5b2552d50.1537042262.git.mchehab+samsung@kernel.org>
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
 drivers/media/i2c/saa7115.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 7b2dbe7c59b2..1b30f568119a 100644
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
