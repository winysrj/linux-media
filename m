Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34749 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967321AbeF1QVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:44 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 04/22] [media] tvp5150: make use of regmap_update_bits
Date: Thu, 28 Jun 2018 18:20:36 +0200
Message-Id: <20180628162054.25613-5-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit a27e33e3dd27 ("[media] tvp5150: convert register access to
regmap") the driver supports regmap. Now we can drop the handmade bit
update sequence and move to the regmap provided helpers.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index b3c7b65606fd..d150487cc2d1 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -246,8 +246,8 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 {
 	int opmode = 0;
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	unsigned int mask, val;
 	int input = 0;
-	int val;
 
 	/* Only tvp5150am1 and tvp5151 have signal generator support */
 	if ((decoder->dev_id == 0x5150 && decoder->rom_ver == 0x0400) ||
@@ -282,17 +282,12 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 	 * field indicator (FID) signal on FID/GLCO/VLK/HVLK and set
 	 * INTREQ/GPCL/VBLK to logic 1.
 	 */
-	val = tvp5150_read(sd, TVP5150_MISC_CTL);
-	if (val < 0) {
-		dev_err(sd->dev, "%s: failed with error = %d\n", __func__, val);
-		return;
-	}
-
+	mask = TVP5150_MISC_CTL_GPCL | TVP5150_MISC_CTL_HVLK;
 	if (decoder->input == TVP5150_SVIDEO)
-		val = (val & ~TVP5150_MISC_CTL_GPCL) | TVP5150_MISC_CTL_HVLK;
+		val = TVP5150_MISC_CTL_HVLK;
 	else
-		val = (val & ~TVP5150_MISC_CTL_HVLK) | TVP5150_MISC_CTL_GPCL;
-	regmap_write(decoder->regmap, TVP5150_MISC_CTL, val);
+		val = TVP5150_MISC_CTL_GPCL;
+	regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, mask, val);
 };
 
 struct i2c_reg_value {
@@ -795,7 +790,9 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	tvp5150_set_std(sd, decoder->norm);
 
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
-		regmap_write(decoder->regmap, TVP5150_DATA_RATE_SEL, 0x40);
+		/* 8-bit 4:2:2 YUV with discrete sync output */
+		regmap_update_bits(decoder->regmap, TVP5150_DATA_RATE_SEL,
+				   0x7, 0x0);
 
 	return 0;
 };
@@ -1053,27 +1050,22 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	int val;
-
-	/* Enable or disable the video output signals. */
-	val = tvp5150_read(sd, TVP5150_MISC_CTL);
-	if (val < 0)
-		return val;
+	unsigned int mask, val = 0;
 
-	val &= ~(TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
-		 TVP5150_MISC_CTL_CLOCK_OE);
+	mask = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
+	       TVP5150_MISC_CTL_CLOCK_OE;
 
 	if (enable) {
 		/*
 		 * Enable the YCbCr and clock outputs. In discrete sync mode
 		 * (non-BT.656) additionally enable the the sync outputs.
 		 */
-		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
+		val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
 		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 			val |= TVP5150_MISC_CTL_SYNC_OE;
 	}
 
-	regmap_write(decoder->regmap, TVP5150_MISC_CTL, val);
+	regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, mask, val);
 
 	return 0;
 }
-- 
2.17.1
