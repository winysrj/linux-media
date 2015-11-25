Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbKYRie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 12:38:34 -0500
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH v2 3/9] [media] tvp5150: determine BT.656 or YUV 4:2:2 mode from device tree
Date: Wed, 25 Nov 2015 18:38:30 +0100
Message-Id: <1448473116-24735-3-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1448473116-24735-1-git-send-email-l.stach@pengutronix.de>
References: <1448473116-24735-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

By looking at the endpoint flags, it can be determined whether the link
should be of V4L2_MBUS_PARALLEL or V4L2_MBUS_BT656 type. Disable the
dedicated HSYNC/VSYNC outputs in BT.656 mode.

For devices that are not instantiated through DT the current behavior
is preserved.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 3eab4d918c54..f504fc005222 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -11,10 +11,12 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
+#include <linux/of_graph.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 
 #include "tvp5150_reg.h"
 
@@ -38,6 +40,7 @@ struct tvp5150 {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
+	enum v4l2_mbus_type bus_type;
 	struct v4l2_mbus_framefmt format;
 	struct v4l2_rect rect;
 	struct regmap *regmap;
@@ -424,8 +427,6 @@ static const struct i2c_reg_value tvp5150_init_enable[] = {
 		TVP5150_MISC_CTL, 0x6f
 	},{	/* Activates video std autodetection for all standards */
 		TVP5150_AUTOSW_MSK, 0x0
-	},{	/* Default format: 0x47. For 4:2:2: 0x40 */
-		TVP5150_DATA_RATE_SEL, 0x47
 	},{
 		TVP5150_CHROMA_PROC_CTL_1, 0x0c
 	},{
@@ -760,6 +761,25 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	/* Initializes TVP5150 to stream enabled values */
 	tvp5150_write_inittab(sd, tvp5150_init_enable);
 
+	switch (decoder->bus_type) {
+	case V4L2_MBUS_BT656:
+		/* 8-bit ITU BT.656 */
+		regmap_update_bits(decoder->regmap, TVP5150_DATA_RATE_SEL,
+				   0x7, 0x7);
+		/* disable HSYNC, VSYNC/PALI, AVID, and FID/GLCO */
+		regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, 0x4, 0x0);
+		break;
+	case V4L2_MBUS_PARALLEL:
+		/* 8-bit YUV 4:2:2 */
+		regmap_update_bits(decoder->regmap, TVP5150_DATA_RATE_SEL,
+				   0x7, 0x0);
+		/* enable HSYNC, VSYNC/PALI, AVID, and FID/GLCO */
+		regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, 0x4, 0x4);
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* Initialize image preferences */
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
@@ -1332,6 +1352,8 @@ static struct regmap_config tvp5150_config = {
 static int tvp5150_probe(struct i2c_client *c,
 			 const struct i2c_device_id *id)
 {
+	struct v4l2_of_endpoint bus_cfg;
+	struct device_node *endpoint;
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
 	struct regmap *map;
@@ -1398,6 +1420,14 @@ static int tvp5150_probe(struct i2c_client *c,
 		}
 	}
 
+	endpoint = of_graph_get_next_endpoint(c->dev.of_node, NULL);
+	if (endpoint) {
+		v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+		core->bus_type = bus_cfg.bus_type;
+	} else {
+		core->bus_type = V4L2_MBUS_BT656;
+	}
+
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = 1;
-- 
2.6.2

