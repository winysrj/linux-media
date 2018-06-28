Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53499 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934499AbeF1QV3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:29 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 11/22] [media] tvp5150: remove pin configuration from initialization tables
Date: Thu, 28 Jun 2018 18:20:43 +0200
Message-Id: <20180628162054.25613-12-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

To allow optional interrupt support, we want to configure the pin settings
dynamically. Move those register accesses out of the static initialization
tables.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[m.felsch@pengutronix.de: drop init_default register remove]
[m.felsch@pengutronix.de: fix regmap access during reset()]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 284694c21556..c66a962d873a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -438,9 +438,7 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 
 /* Default values as sugested at TVP5150AM1 datasheet */
 static const struct i2c_reg_value tvp5150_init_enable[] = {
-	{
-		TVP5150_CONF_SHARED_PIN, 2
-	}, {	/* Automatic offset and AGC enabled */
+	{	/* Automatic offset and AGC enabled */
 		TVP5150_ANAL_CHL_CTL, 0x15
 	}, {	/* Activate YCrCb output 0x9 or 0xd ? */
 		TVP5150_MISC_CTL, TVP5150_MISC_CTL_GPCL |
@@ -796,9 +794,15 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 {
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct regmap *map = decoder->regmap;
+
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
 
+	/* Configure pins: FID, VSYNC, GPCL/VBLK, SCLK */
+	regmap_write(map, TVP5150_CONF_SHARED_PIN, 0x2);
+
 	/* Initializes VDP registers */
 	tvp5150_vdp_init(sd);
 
-- 
2.17.1
