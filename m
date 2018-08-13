Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51315 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbeHMMHP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 08:07:15 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v2 7/7] [media] tvp5150: add s_power callback
Date: Mon, 13 Aug 2018 11:25:08 +0200
Message-Id: <20180813092508.1334-8-m.felsch@pengutronix.de>
In-Reply-To: <20180813092508.1334-1-m.felsch@pengutronix.de>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't en-/disable the interrupts during s_stream because someone can
disable the stream but wants to get informed if the stream is locked
again. So keep the interrupts enabled the whole time the pipeline is
opened.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index e736f609fecd..e296f5bfae21 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1389,11 +1389,26 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
 /****************************************************************************
 			I2C Command
  ****************************************************************************/
+static int tvp5150_s_power(struct  v4l2_subdev *sd, int on)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	unsigned int val = 0;
+
+	if (on)
+		val = TVP5150_INT_A_LOCK;
+
+	if (decoder->irq)
+		/* Enable / Disable lock interrupt */
+		regmap_update_bits(decoder->regmap, TVP5150_INT_ENABLE_REG_A,
+				   TVP5150_INT_A_LOCK, val);
+
+	return 0;
+}
 
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	unsigned int mask, val = 0, int_val = 0;
+	unsigned int mask, val = 0;
 
 	mask = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
 	       TVP5150_MISC_CTL_CLOCK_OE;
@@ -1406,15 +1421,10 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 			val = decoder->lock ? decoder->oe : 0;
 		else
 			val = decoder->oe;
-		int_val = TVP5150_INT_A_LOCK;
 		v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
 	}
 
 	regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, mask, val);
-	if (decoder->irq)
-		/* Enable / Disable lock interrupt */
-		regmap_update_bits(decoder->regmap, TVP5150_INT_ENABLE_REG_A,
-				   TVP5150_INT_A_LOCK, int_val);
 
 	return 0;
 }
@@ -1616,6 +1626,7 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.g_register = tvp5150_g_register,
 	.s_register = tvp5150_s_register,
 #endif
+	.s_power = tvp5150_s_power,
 };
 
 static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
-- 
2.18.0
