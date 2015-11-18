Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222AbbKRQza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 11:55:30 -0500
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH 7/9] [media] tvp5150: remove pin configuration from initialization tables
Date: Wed, 18 Nov 2015 17:55:26 +0100
Message-Id: <1447865728-5726-7-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1447865728-5726-1-git-send-email-l.stach@pengutronix.de>
References: <1447865728-5726-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

To allow optional interrupt support, we want to configure the pin settings
dynamically. Move those register accesses out of the static initialization
tables.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c     | 19 +++++++------------
 drivers/media/i2c/tvp5150_reg.h |  1 +
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 791572737ee3..abea26eb6fe0 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -323,9 +323,6 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 	{ /* 0x0e */
 		TVP5150_LUMA_PROC_CTL_3,0x00
 	},
-	{ /* 0x0f */
-		TVP5150_CONF_SHARED_PIN,0x08
-	},
 	{ /* 0x11 */
 		TVP5150_ACT_VD_CROP_ST_MSB,0x00
 	},
@@ -362,9 +359,6 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 	{ /* 0x1d */
 		TVP5150_INT_ENABLE_REG_B,0x00
 	},
-	{ /* 0x1e */
-		TVP5150_INTT_CONFIG_REG_B,0x00
-	},
 	{ /* 0x28 */
 		TVP5150_VIDEO_STD,0x00
 	},
@@ -383,9 +377,6 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 	{ /* 0xc1 */
 		TVP5150_INT_ENABLE_REG_A,0x00
 	},
-	{ /* 0xc2 */
-		TVP5150_INT_CONF,0x04
-	},
 	{ /* 0xc8 */
 		TVP5150_FIFO_INT_THRESHOLD,0x80
 	},
@@ -420,9 +411,7 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
 
 /* Default values as sugested at TVP5150AM1 datasheet */
 static const struct i2c_reg_value tvp5150_init_enable[] = {
-	{
-		TVP5150_CONF_SHARED_PIN, 2
-	},{	/* Automatic offset and AGC enabled */
+	{	/* Automatic offset and AGC enabled */
 		TVP5150_ANAL_CHL_CTL, 0x15
 	},{	/* Activate YCrCb output 0x9 or 0xd ? */
 		TVP5150_MISC_CTL, 0x6f
@@ -772,6 +761,12 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
 
+	/* Configure pins: FID, VSYNC, GPCL/VBLK, SCLK */
+	regmap_write(map, TVP5150_CONF_SHARED_PIN, 0x2);
+	/* Keep interrupt polarity active low */
+	regmap_write(map, TVP5150_INT_CONF, TVP5150_VDPOE);
+	regmap_write(map, TVP5150_INTT_CONFIG_REG_B, 0x0);
+
 	/* Initializes VDP registers */
 	tvp5150_vdp_init(sd, vbi_ram_default);
 
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index 25a994944918..fc3bcb26413a 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -117,6 +117,7 @@
 #define TVP5150_INT_STATUS_REG_A    0xc0 /* Interrupt status register A */
 #define TVP5150_INT_ENABLE_REG_A    0xc1 /* Interrupt enable register A */
 #define TVP5150_INT_CONF            0xc2 /* Interrupt configuration */
+#define   TVP5150_VDPOE             BIT(2)
 #define TVP5150_VDP_CONF_RAM_DATA   0xc3 /* VDP configuration RAM data */
 #define TVP5150_CONF_RAM_ADDR_LOW   0xc4 /* Configuration RAM address low byte */
 #define TVP5150_CONF_RAM_ADDR_HIGH  0xc5 /* Configuration RAM address high byte */
-- 
2.6.2

