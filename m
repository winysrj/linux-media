Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37735 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967320AbeF1QVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:38 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 12/22] [media] tvp5150: Add sync lock interrupt handling
Date: Thu, 28 Jun 2018 18:20:44 +0200
Message-Id: <20180628162054.25613-13-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This patch adds an optional interrupt handler to handle the sync
lock interrupt and sync lock status.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
[m.felsch@pengutronix.de: move added .g_std callback to separate patch]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c     | 63 +++++++++++++++++++++++++++++++--
 drivers/media/i2c/tvp5150_reg.h |  3 ++
 2 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index c66a962d873a..d8bdbedd8826 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -10,6 +10,7 @@
 #include <linux/videodev2.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of_graph.h>
 #include <linux/regmap.h>
@@ -53,12 +54,14 @@ struct tvp5150 {
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
 	struct regmap *regmap;
+	int irq;
 
 	v4l2_std_id norm;	/* Current set standard */
 	v4l2_std_id detected_norm;
 	u32 input;
 	u32 output;
 	int enable;
+	bool lock;
 
 	u16 dev_id;
 	u16 rom_ver;
@@ -792,6 +795,33 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
+static irqreturn_t tvp5150_isr(int irq, void *dev_id)
+{
+	struct tvp5150 *decoder = dev_id;
+	struct regmap *map = decoder->regmap;
+	unsigned int active = 0, status = 0;
+
+	regmap_read(map, TVP5150_INT_STATUS_REG_A, &status);
+	if (status) {
+		regmap_write(map, TVP5150_INT_STATUS_REG_A, status);
+
+		if (status & TVP5150_INT_A_LOCK)
+			decoder->lock = !!(status & TVP5150_INT_A_LOCK_STATUS);
+
+		return IRQ_HANDLED;
+	}
+
+	regmap_read(map, TVP5150_INT_ACTIVE_REG_B, &active);
+	if (active) {
+		status = 0;
+		regmap_read(map, TVP5150_INT_STATUS_REG_B, &status);
+		if (status)
+			regmap_write(map, TVP5150_INT_RESET_REG_B, status);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
@@ -800,8 +830,19 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
 
-	/* Configure pins: FID, VSYNC, GPCL/VBLK, SCLK */
-	regmap_write(map, TVP5150_CONF_SHARED_PIN, 0x2);
+	if (decoder->irq) {
+		/* Configure pins: FID, VSYNC, INTREQ, SCLK */
+		regmap_write(map, TVP5150_CONF_SHARED_PIN, 0x0);
+		/* Set interrupt polarity to active high */
+		regmap_write(map, TVP5150_INT_CONF, TVP5150_VDPOE | 0x1);
+		regmap_write(map, TVP5150_INTT_CONFIG_REG_B, 0x1);
+	} else {
+		/* Configure pins: FID, VSYNC, GPCL/VBLK, SCLK */
+		regmap_write(map, TVP5150_CONF_SHARED_PIN, 0x2);
+		/* Keep interrupt polarity active low */
+		regmap_write(map, TVP5150_INT_CONF, TVP5150_VDPOE);
+		regmap_write(map, TVP5150_INTT_CONFIG_REG_B, 0x0);
+	}
 
 	/* Initializes VDP registers */
 	tvp5150_vdp_init(sd);
@@ -1141,7 +1182,7 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	unsigned int mask, val = 0;
+	unsigned int mask, val = 0, int_val = 0;
 
 	mask = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
 	       TVP5150_MISC_CTL_CLOCK_OE;
@@ -1156,9 +1197,15 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 		val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
 		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 			val |= TVP5150_MISC_CTL_SYNC_OE;
+
+		int_val = TVP5150_INT_A_LOCK;
 	}
 
 	regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, mask, val);
+	if (decoder->irq)
+		/* Enable / Disable lock interrupt */
+		regmap_update_bits(decoder->regmap, TVP5150_INT_ENABLE_REG_A,
+				   TVP5150_INT_A_LOCK, int_val);
 
 	return 0;
 }
@@ -1708,7 +1755,17 @@ static int tvp5150_probe(struct i2c_client *c,
 
 	tvp5150_set_default(tvp5150_read_std(sd), &core->rect);
 
+	core->irq = c->irq;
 	tvp5150_reset(sd, 0);	/* Calls v4l2_ctrl_handler_setup() */
+	if (c->irq) {
+		res = devm_request_threaded_irq(&c->dev, c->irq, NULL,
+						tvp5150_isr, IRQF_TRIGGER_HIGH |
+						IRQF_ONESHOT, "tvp5150", core);
+		if (res)
+			return res;
+	} else {
+		core->lock = true;
+	}
 
 	res = v4l2_async_register_subdev(sd);
 	if (res < 0)
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index d3a764cae1a0..9088186c24d1 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -125,8 +125,11 @@
 #define TVP5150_TELETEXT_FIL_ENA    0xbb /* Teletext filter enable */
 /* Reserved	BCh-BFh */
 #define TVP5150_INT_STATUS_REG_A    0xc0 /* Interrupt status register A */
+#define   TVP5150_INT_A_LOCK_STATUS BIT(7)
+#define   TVP5150_INT_A_LOCK        BIT(6)
 #define TVP5150_INT_ENABLE_REG_A    0xc1 /* Interrupt enable register A */
 #define TVP5150_INT_CONF            0xc2 /* Interrupt configuration */
+#define   TVP5150_VDPOE             BIT(2)
 #define TVP5150_VDP_CONF_RAM_DATA   0xc3 /* VDP configuration RAM data */
 #define TVP5150_CONF_RAM_ADDR_LOW   0xc4 /* Configuration RAM address low byte */
 #define TVP5150_CONF_RAM_ADDR_HIGH  0xc5 /* Configuration RAM address high byte */
-- 
2.17.1
