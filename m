Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58649 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967329AbeF1QVq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:46 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 22/22] [media] tvp5150: Change default input source selection behaviour
Date: Thu, 28 Jun 2018 18:20:54 +0200
Message-Id: <20180628162054.25613-23-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default input is still TVP5150_COMPOSITE1, but if the platform
supports DT the default will be changed to the first valid connector.
First in this context means the connector at the lowest port number.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 3645d1166118..8b40cf721853 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1835,7 +1835,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	struct v4l2_subdev *sd;
 	struct device_node *np = c->dev.of_node;
 	struct regmap *map;
-	int res;
+	int res, i;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -1881,7 +1881,16 @@ static int tvp5150_probe(struct i2c_client *c,
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->detected_norm = V4L2_STD_UNKNOWN;
+	/*
+	 * Default is TVP5150_COMPOSITE1.
+	 * In case of OF support, default is first valid port
+	 */
 	core->input = TVP5150_COMPOSITE1;
+	for (i = 0; i < TVP5150_PORT_NUM - 1; i++)
+		if (core->endpoints[i]) {
+			core->input = i;
+			break;
+		}
 	core->enable = true;
 
 	v4l2_ctrl_handler_init(&core->hdl, 5);
-- 
2.17.1
