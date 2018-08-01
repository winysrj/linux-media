Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56466 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389854AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 09/13] media: tvp5150: declare its own pads
Date: Wed,  1 Aug 2018 12:55:11 -0300
Message-Id: <e3a1c6054573773db373d0fc88b7d710a8f9bfcf.1533138685.git.mchehab+samsung@kernel.org>
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
 drivers/media/i2c/tvp5150.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 5037a03b5442..a9f7c70ca25c 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -38,10 +38,16 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 #define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
 
+enum tvp5150_pads {
+       TVP5150_PAD_IF_INPUT,
+       TVP5150_PAD_VID_OUT,
+       TVP5150_NUM_PADS
+};
+
 struct tvp5150 {
 	struct v4l2_subdev sd;
 #ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_pad pads[DEMOD_NUM_PADS];
+	struct media_pad pads[TVP5150_NUM_PADS];
 	struct media_entity input_ent[TVP5150_INPUT_NUM];
 	struct media_pad input_pad[TVP5150_INPUT_NUM];
 #endif
@@ -866,7 +872,7 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *f;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	if (!format || (format->pad != DEMOD_PAD_VID_OUT))
+	if (!format || (format->pad != TVP5150_PAD_VID_OUT))
 		return -EINVAL;
 
 	f = &format->format;
@@ -1217,7 +1223,7 @@ static int tvp5150_registered(struct v4l2_subdev *sd)
 			return ret;
 
 		ret = media_create_pad_link(input, 0, &sd->entity,
-					    DEMOD_PAD_IF_INPUT, 0);
+					    TVP5150_PAD_IF_INPUT, 0);
 		if (ret < 0) {
 			media_device_unregister_entity(input);
 			return ret;
@@ -1499,14 +1505,14 @@ static int tvp5150_probe(struct i2c_client *c,
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	core->pads[DEMOD_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	core->pads[DEMOD_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
+	core->pads[TVP5150_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[TVP5150_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	core->pads[TVP5150_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	core->pads[TVP5150_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
-	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
+	res = media_entity_pads_init(&sd->entity, TVP5150_NUM_PADS, core->pads);
 	if (res < 0)
 		return res;
 
-- 
2.17.1
