Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37373 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967334AbeF1QVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:53 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 03/22] [media] tvp5150: convert register access to regmap
Date: Thu, 28 Jun 2018 18:20:35 +0200
Message-Id: <20180628162054.25613-4-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Regmap provides built in debugging, caching and provides dedicated
accessors for bit manipulations in registers, which make the following
changes a lot simpler.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 199 ++++++++++++++++++++++++------------
 1 file changed, 136 insertions(+), 63 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 509ac243ea97..b3c7b65606fd 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -12,6 +12,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/module.h>
 #include <linux/of_graph.h>
+#include <linux/regmap.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -47,6 +48,7 @@ struct tvp5150 {
 #endif
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
+	struct regmap *regmap;
 
 	v4l2_std_id norm;	/* Current set standard */
 	u32 input;
@@ -71,32 +73,14 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 
 static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
 {
-	struct i2c_client *c = v4l2_get_subdevdata(sd);
-	int rc;
-
-	rc = i2c_smbus_read_byte_data(c, addr);
-	if (rc < 0) {
-		dev_err(sd->dev, "i2c i/o error: rc == %d\n", rc);
-		return rc;
-	}
-
-	dev_dbg_lvl(sd->dev, 2, debug, "tvp5150: read 0x%02x = %02x\n", addr, rc);
-
-	return rc;
-}
-
-static int tvp5150_write(struct v4l2_subdev *sd, unsigned char addr,
-				 unsigned char value)
-{
-	struct i2c_client *c = v4l2_get_subdevdata(sd);
-	int rc;
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	int ret, val;
 
-	dev_dbg_lvl(sd->dev, 2, debug, "tvp5150: writing %02x %02x\n", addr, value);
-	rc = i2c_smbus_write_byte_data(c, addr, value);
-	if (rc < 0)
-		dev_err(sd->dev, "i2c i/o error: rc == %d\n", rc);
+	ret = regmap_read(decoder->regmap, addr, &val);
+	if (ret < 0)
+		return ret;
 
-	return rc;
+	return val;
 }
 
 static void dump_reg_range(struct v4l2_subdev *sd, char *s, u8 init,
@@ -288,8 +272,8 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 			decoder->input, decoder->output,
 			input, opmode);
 
-	tvp5150_write(sd, TVP5150_OP_MODE_CTL, opmode);
-	tvp5150_write(sd, TVP5150_VD_IN_SRC_SEL_1, input);
+	regmap_write(decoder->regmap, TVP5150_OP_MODE_CTL, opmode);
+	regmap_write(decoder->regmap, TVP5150_VD_IN_SRC_SEL_1, input);
 
 	/*
 	 * Setup the FID/GLCO/VLK/HVLK and INTREQ/GPCL/VBLK output signals. For
@@ -308,7 +292,7 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 		val = (val & ~TVP5150_MISC_CTL_GPCL) | TVP5150_MISC_CTL_HVLK;
 	else
 		val = (val & ~TVP5150_MISC_CTL_HVLK) | TVP5150_MISC_CTL_GPCL;
-	tvp5150_write(sd, TVP5150_MISC_CTL, val);
+	regmap_write(decoder->regmap, TVP5150_MISC_CTL, val);
 };
 
 struct i2c_reg_value {
@@ -583,8 +567,10 @@ static struct i2c_vbi_ram_value vbi_ram_default[] = {
 static int tvp5150_write_inittab(struct v4l2_subdev *sd,
 				const struct i2c_reg_value *regs)
 {
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
 	while (regs->reg != 0xff) {
-		tvp5150_write(sd, regs->reg, regs->value);
+		regmap_write(decoder->regmap, regs->reg, regs->value);
 		regs++;
 	}
 	return 0;
@@ -592,15 +578,17 @@ static int tvp5150_write_inittab(struct v4l2_subdev *sd,
 
 static int tvp5150_vdp_init(struct v4l2_subdev *sd)
 {
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct regmap *map = decoder->regmap;
 	unsigned int i;
 	int j;
 
 	/* Disable Full Field */
-	tvp5150_write(sd, TVP5150_FULL_FIELD_ENA, 0);
+	regmap_write(map, TVP5150_FULL_FIELD_ENA, 0);
 
 	/* Before programming, Line mode should be at 0xff */
 	for (i = TVP5150_LINE_MODE_INI; i <= TVP5150_LINE_MODE_END; i++)
-		tvp5150_write(sd, i, 0xff);
+		regmap_write(map, i, 0xff);
 
 	/* Load Ram Table */
 	for (j = 0; j < ARRAY_SIZE(vbi_ram_default); j++) {
@@ -609,11 +597,12 @@ static int tvp5150_vdp_init(struct v4l2_subdev *sd)
 		if (!regs->type.vbi_type)
 			continue;
 
-		tvp5150_write(sd, TVP5150_CONF_RAM_ADDR_HIGH, regs->reg >> 8);
-		tvp5150_write(sd, TVP5150_CONF_RAM_ADDR_LOW, regs->reg);
+		regmap_write(map, TVP5150_CONF_RAM_ADDR_HIGH, regs->reg >> 8);
+		regmap_write(map, TVP5150_CONF_RAM_ADDR_LOW, regs->reg);
 
 		for (i = 0; i < 16; i++)
-			tvp5150_write(sd, TVP5150_VDP_CONF_RAM_DATA, regs->values[i]);
+			regmap_write(map, TVP5150_VDP_CONF_RAM_DATA,
+				     regs->values[i]);
 	}
 	return 0;
 }
@@ -693,10 +682,10 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
 	reg = ((line - 6) << 1) + TVP5150_LINE_MODE_INI;
 
 	if (fields & 1)
-		tvp5150_write(sd, reg, type);
+		regmap_write(decoder->regmap, reg, type);
 
 	if (fields & 2)
-		tvp5150_write(sd, reg + 1, type);
+		regmap_write(decoder->regmap, reg + 1, type);
 
 	return type;
 }
@@ -763,7 +752,7 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	}
 
 	dev_dbg_lvl(sd->dev, 1, debug, "Set video std register to %d.\n", fmt);
-	tvp5150_write(sd, TVP5150_VIDEO_STD, fmt);
+	regmap_write(decoder->regmap, TVP5150_VIDEO_STD, fmt);
 	return 0;
 }
 
@@ -806,7 +795,7 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	tvp5150_set_std(sd, decoder->norm);
 
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
-		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
+		regmap_write(decoder->regmap, TVP5150_DATA_RATE_SEL, 0x40);
 
 	return 0;
 };
@@ -818,16 +807,17 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		tvp5150_write(sd, TVP5150_BRIGHT_CTL, ctrl->val);
+		regmap_write(decoder->regmap, TVP5150_BRIGHT_CTL, ctrl->val);
 		return 0;
 	case V4L2_CID_CONTRAST:
-		tvp5150_write(sd, TVP5150_CONTRAST_CTL, ctrl->val);
+		regmap_write(decoder->regmap, TVP5150_CONTRAST_CTL, ctrl->val);
 		return 0;
 	case V4L2_CID_SATURATION:
-		tvp5150_write(sd, TVP5150_SATURATION_CTL, ctrl->val);
+		regmap_write(decoder->regmap, TVP5150_SATURATION_CTL,
+			     ctrl->val);
 		return 0;
 	case V4L2_CID_HUE:
-		tvp5150_write(sd, TVP5150_HUE_CTL, ctrl->val);
+		regmap_write(decoder->regmap, TVP5150_HUE_CTL, ctrl->val);
 		return 0;
 	case V4L2_CID_TEST_PATTERN:
 		decoder->enable = ctrl->val ? false : true;
@@ -925,17 +915,17 @@ static int tvp5150_set_selection(struct v4l2_subdev *sd,
 			      hmax - TVP5150_MAX_CROP_TOP - rect.top,
 			      hmax - rect.top, 0, 0);
 
-	tvp5150_write(sd, TVP5150_VERT_BLANKING_START, rect.top);
-	tvp5150_write(sd, TVP5150_VERT_BLANKING_STOP,
+	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
+	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
 		      rect.top + rect.height - hmax);
-	tvp5150_write(sd, TVP5150_ACT_VD_CROP_ST_MSB,
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
 		      rect.left >> TVP5150_CROP_SHIFT);
-	tvp5150_write(sd, TVP5150_ACT_VD_CROP_ST_LSB,
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
 		      rect.left | (1 << TVP5150_CROP_SHIFT));
-	tvp5150_write(sd, TVP5150_ACT_VD_CROP_STP_MSB,
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
 		      (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
 		      TVP5150_CROP_SHIFT);
-	tvp5150_write(sd, TVP5150_ACT_VD_CROP_STP_LSB,
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
 		      rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
 
 	decoder->rect = rect;
@@ -1083,7 +1073,7 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 			val |= TVP5150_MISC_CTL_SYNC_OE;
 	}
 
-	tvp5150_write(sd, TVP5150_MISC_CTL, val);
+	regmap_write(decoder->regmap, TVP5150_MISC_CTL, val);
 
 	return 0;
 }
@@ -1107,6 +1097,8 @@ static int tvp5150_s_routing(struct v4l2_subdev *sd,
 
 static int tvp5150_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt)
 {
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
 	/*
 	 * this is for capturing 36 raw vbi lines
 	 * if there's a way to cut off the beginning 2 vbi lines
@@ -1116,16 +1108,18 @@ static int tvp5150_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt
 	 */
 
 	if (fmt->sample_format == V4L2_PIX_FMT_GREY)
-		tvp5150_write(sd, TVP5150_LUMA_PROC_CTL_1, 0x70);
+		regmap_write(decoder->regmap, TVP5150_LUMA_PROC_CTL_1, 0x70);
 	if (fmt->count[0] == 18 && fmt->count[1] == 18) {
-		tvp5150_write(sd, TVP5150_VERT_BLANKING_START, 0x00);
-		tvp5150_write(sd, TVP5150_VERT_BLANKING_STOP, 0x01);
+		regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START,
+			     0x00);
+		regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP, 0x01);
 	}
 	return 0;
 }
 
 static int tvp5150_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *svbi)
 {
+	struct tvp5150 *decoder = to_tvp5150(sd);
 	int i;
 
 	if (svbi->service_set != 0) {
@@ -1136,17 +1130,17 @@ static int tvp5150_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_f
 						0xf0, i, 3);
 		}
 		/* Enables FIFO */
-		tvp5150_write(sd, TVP5150_FIFO_OUT_CTRL, 1);
+		regmap_write(decoder->regmap, TVP5150_FIFO_OUT_CTRL, 1);
 	} else {
 		/* Disables FIFO*/
-		tvp5150_write(sd, TVP5150_FIFO_OUT_CTRL, 0);
+		regmap_write(decoder->regmap, TVP5150_FIFO_OUT_CTRL, 0);
 
 		/* Disable Full Field */
-		tvp5150_write(sd, TVP5150_FULL_FIELD_ENA, 0);
+		regmap_write(decoder->regmap, TVP5150_FULL_FIELD_ENA, 0);
 
 		/* Disable Line modes */
 		for (i = TVP5150_LINE_MODE_INI; i <= TVP5150_LINE_MODE_END; i++)
-			tvp5150_write(sd, i, 0xff);
+			regmap_write(decoder->regmap, i, 0xff);
 	}
 	return 0;
 }
@@ -1184,7 +1178,9 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int tvp5150_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	return tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	return regmap_write(decoder->regmap, reg->reg & 0xff, reg->val & 0xff);
 }
 #endif
 
@@ -1291,11 +1287,83 @@ static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
 			I2C Client & Driver
  ****************************************************************************/
 
+static const struct regmap_range tvp5150_readable_ranges[] = {
+	{
+		.range_min = TVP5150_VD_IN_SRC_SEL_1,
+		.range_max = TVP5150_AUTOSW_MSK,
+	}, {
+		.range_min = TVP5150_COLOR_KIL_THSH_CTL,
+		.range_max = TVP5150_CONF_SHARED_PIN,
+	}, {
+		.range_min = TVP5150_ACT_VD_CROP_ST_MSB,
+		.range_max = TVP5150_HORIZ_SYNC_START,
+	}, {
+		.range_min = TVP5150_VERT_BLANKING_START,
+		.range_max = TVP5150_INTT_CONFIG_REG_B,
+	}, {
+		.range_min = TVP5150_VIDEO_STD,
+		.range_max = TVP5150_VIDEO_STD,
+	}, {
+		.range_min = TVP5150_CB_GAIN_FACT,
+		.range_max = TVP5150_REV_SELECT,
+	}, {
+		.range_min = TVP5150_MSB_DEV_ID,
+		.range_max = TVP5150_STATUS_REG_5,
+	}, {
+		.range_min = TVP5150_CC_DATA_INI,
+		.range_max = TVP5150_TELETEXT_FIL_ENA,
+	}, {
+		.range_min = TVP5150_INT_STATUS_REG_A,
+		.range_max = TVP5150_FIFO_OUT_CTRL,
+	}, {
+		.range_min = TVP5150_FULL_FIELD_ENA,
+		.range_max = TVP5150_FULL_FIELD_MODE_REG,
+	},
+};
+
+bool tvp5150_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case TVP5150_VERT_LN_COUNT_MSB:
+	case TVP5150_VERT_LN_COUNT_LSB:
+	case TVP5150_INT_STATUS_REG_A:
+	case TVP5150_INT_STATUS_REG_B:
+	case TVP5150_INT_ACTIVE_REG_B:
+	case TVP5150_STATUS_REG_1:
+	case TVP5150_STATUS_REG_2:
+	case TVP5150_STATUS_REG_3:
+	case TVP5150_STATUS_REG_4:
+	case TVP5150_STATUS_REG_5:
+	/* CC, WSS, VPS, VITC data? */
+	case TVP5150_VBI_FIFO_READ_DATA:
+	case TVP5150_VDP_STATUS_REG:
+	case TVP5150_FIFO_WORD_COUNT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const struct regmap_access_table tvp5150_readable_table = {
+	.yes_ranges = tvp5150_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(tvp5150_readable_ranges),
+};
+
+static struct regmap_config tvp5150_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0xff,
+
+	.cache_type = REGCACHE_RBTREE,
+
+	.rd_table = &tvp5150_readable_table,
+	.volatile_reg = tvp5150_volatile_reg,
+};
+
 static int tvp5150_detect_version(struct tvp5150 *core)
 {
 	struct v4l2_subdev *sd = &core->sd;
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
-	unsigned int i;
 	u8 regs[4];
 	int res;
 
@@ -1303,11 +1371,10 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 	 * Read consequent registers - TVP5150_MSB_DEV_ID, TVP5150_LSB_DEV_ID,
 	 * TVP5150_ROM_MAJOR_VER, TVP5150_ROM_MINOR_VER
 	 */
-	for (i = 0; i < 4; i++) {
-		res = tvp5150_read(sd, TVP5150_MSB_DEV_ID + i);
-		if (res < 0)
-			return res;
-		regs[i] = res;
+	res = regmap_bulk_read(core->regmap, TVP5150_MSB_DEV_ID, regs, 4);
+	if (res < 0) {
+		dev_err(&c->dev, "reading ID registers failed: %d\n", res);
+		return res;
 	}
 
 	core->dev_id = (regs[0] << 8) | regs[1];
@@ -1323,7 +1390,7 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 		dev_info(sd->dev, "tvp5150am1 detected.\n");
 
 		/* ITU-T BT.656.4 timing */
-		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
+		regmap_write(core->regmap, TVP5150_REV_SELECT, 0);
 	} else if (core->dev_id == 0x5151 && core->rom_ver == 0x0100) {
 		dev_info(sd->dev, "tvp5151 detected.\n");
 	} else {
@@ -1470,6 +1537,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
 	struct device_node *np = c->dev.of_node;
+	struct regmap *map;
 	int res;
 
 	/* Check if the adapter supports the needed features */
@@ -1485,6 +1553,11 @@ static int tvp5150_probe(struct i2c_client *c,
 	if (!core)
 		return -ENOMEM;
 
+	map = devm_regmap_init_i2c(c, &tvp5150_config);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	core->regmap = map;
 	sd = &core->sd;
 
 	if (IS_ENABLED(CONFIG_OF) && np) {
-- 
2.17.1
