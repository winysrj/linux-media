Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43732 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeGPQQX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 12:16:23 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Mark Brown <broonie@kernel.org>, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH -next v4 3/3] media: ov9650: use SCCB regmap
Date: Tue, 17 Jul 2018 00:47:50 +0900
Message-Id: <1531756070-8560-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert ov965x register access to use SCCB regmap.

Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Rosin <peda@axentia.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig  |   1 +
 drivers/media/i2c/ov9650.c | 157 ++++++++++++++++++++++-----------------------
 2 files changed, 76 insertions(+), 82 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b923a51..7028824 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -755,6 +755,7 @@ config VIDEO_OV7740
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select REGMAP_SCCB
 	---help---
 	  This is a V4L2 sensor-level driver for the Omnivision
 	  OV9650 and OV9652 camera sensors.
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 5bea31c..16f625f 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -20,6 +20,7 @@
 #include <linux/media.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/videodev2.h>
@@ -259,7 +260,7 @@ struct ov965x {
 	/* Protects the struct fields below */
 	struct mutex lock;
 
-	struct i2c_client *client;
+	struct regmap *regmap;
 
 	/* Exposure row interval in us */
 	unsigned int exp_row_interval;
@@ -424,51 +425,40 @@ static inline struct ov965x *to_ov965x(struct v4l2_subdev *sd)
 	return container_of(sd, struct ov965x, sd);
 }
 
-static int ov965x_read(struct i2c_client *client, u8 addr, u8 *val)
+static int ov965x_read(struct ov965x *ov965x, u8 addr, u8 *val)
 {
-	u8 buf = addr;
-	struct i2c_msg msg = {
-		.addr = client->addr,
-		.flags = 0,
-		.len = 1,
-		.buf = &buf
-	};
 	int ret;
+	unsigned int buf;
 
-	ret = i2c_transfer(client->adapter, &msg, 1);
-	if (ret == 1) {
-		msg.flags = I2C_M_RD;
-		ret = i2c_transfer(client->adapter, &msg, 1);
-
-		if (ret == 1)
-			*val = buf;
-	}
+	ret = regmap_read(ov965x->regmap, addr, &buf);
+	if (!ret)
+		*val = buf;
 
-	v4l2_dbg(2, debug, client, "%s: 0x%02x @ 0x%02x. (%d)\n",
+	v4l2_dbg(2, debug, &ov965x->sd, "%s: 0x%02x @ 0x%02x. (%d)\n",
 		 __func__, *val, addr, ret);
 
-	return ret == 1 ? 0 : ret;
+	return ret;
 }
 
-static int ov965x_write(struct i2c_client *client, u8 addr, u8 val)
+static int ov965x_write(struct ov965x *ov965x, u8 addr, u8 val)
 {
-	u8 buf[2] = { addr, val };
+	int ret;
 
-	int ret = i2c_master_send(client, buf, 2);
+	ret = regmap_write(ov965x->regmap, addr, val);
 
-	v4l2_dbg(2, debug, client, "%s: 0x%02x @ 0x%02X (%d)\n",
+	v4l2_dbg(2, debug, &ov965x->sd, "%s: 0x%02x @ 0x%02X (%d)\n",
 		 __func__, val, addr, ret);
 
-	return ret == 2 ? 0 : ret;
+	return ret;
 }
 
-static int ov965x_write_array(struct i2c_client *client,
+static int ov965x_write_array(struct ov965x *ov965x,
 			      const struct i2c_rv *regs)
 {
 	int i, ret = 0;
 
 	for (i = 0; ret == 0 && regs[i].addr != REG_NULL; i++)
-		ret = ov965x_write(client, regs[i].addr, regs[i].value);
+		ret = ov965x_write(ov965x, regs[i].addr, regs[i].value);
 
 	return ret;
 }
@@ -486,7 +476,7 @@ static int ov965x_set_default_gamma_curve(struct ov965x *ov965x)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(gamma_curve); i++) {
-		int ret = ov965x_write(ov965x->client, addr, gamma_curve[i]);
+		int ret = ov965x_write(ov965x, addr, gamma_curve[i]);
 
 		if (ret < 0)
 			return ret;
@@ -506,7 +496,7 @@ static int ov965x_set_color_matrix(struct ov965x *ov965x)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(mtx); i++) {
-		int ret = ov965x_write(ov965x->client, addr, mtx[i]);
+		int ret = ov965x_write(ov965x, addr, mtx[i]);
 
 		if (ret < 0)
 			return ret;
@@ -542,16 +532,15 @@ static int __ov965x_set_power(struct ov965x *ov965x, int on)
 static int ov965x_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct ov965x *ov965x = to_ov965x(sd);
-	struct i2c_client *client = ov965x->client;
 	int ret = 0;
 
-	v4l2_dbg(1, debug, client, "%s: on: %d\n", __func__, on);
+	v4l2_dbg(1, debug, sd, "%s: on: %d\n", __func__, on);
 
 	mutex_lock(&ov965x->lock);
 	if (ov965x->power == !on) {
 		ret = __ov965x_set_power(ov965x, on);
 		if (!ret && on) {
-			ret = ov965x_write_array(client,
+			ret = ov965x_write_array(ov965x,
 						 ov965x_init_regs);
 			ov965x->apply_frame_fmt = 1;
 			ov965x->ctrls.update = 1;
@@ -609,13 +598,13 @@ static int ov965x_set_banding_filter(struct ov965x *ov965x, int value)
 	int ret;
 	u8 reg;
 
-	ret = ov965x_read(ov965x->client, REG_COM8, &reg);
+	ret = ov965x_read(ov965x, REG_COM8, &reg);
 	if (!ret) {
 		if (value == V4L2_CID_POWER_LINE_FREQUENCY_DISABLED)
 			reg &= ~COM8_BFILT;
 		else
 			reg |= COM8_BFILT;
-		ret = ov965x_write(ov965x->client, REG_COM8, reg);
+		ret = ov965x_write(ov965x, REG_COM8, reg);
 	}
 	if (value == V4L2_CID_POWER_LINE_FREQUENCY_DISABLED)
 		return 0;
@@ -631,7 +620,7 @@ static int ov965x_set_banding_filter(struct ov965x *ov965x, int value)
 	       ov965x->fiv->interval.numerator;
 	mbd = ((mbd / (light_freq * 2)) + 500) / 1000UL;
 
-	return ov965x_write(ov965x->client, REG_MBD, mbd);
+	return ov965x_write(ov965x, REG_MBD, mbd);
 }
 
 static int ov965x_set_white_balance(struct ov965x *ov965x, int awb)
@@ -639,17 +628,17 @@ static int ov965x_set_white_balance(struct ov965x *ov965x, int awb)
 	int ret;
 	u8 reg;
 
-	ret = ov965x_read(ov965x->client, REG_COM8, &reg);
+	ret = ov965x_read(ov965x, REG_COM8, &reg);
 	if (!ret) {
 		reg = awb ? reg | REG_COM8 : reg & ~REG_COM8;
-		ret = ov965x_write(ov965x->client, REG_COM8, reg);
+		ret = ov965x_write(ov965x, REG_COM8, reg);
 	}
 	if (!ret && !awb) {
-		ret = ov965x_write(ov965x->client, REG_BLUE,
+		ret = ov965x_write(ov965x, REG_BLUE,
 				   ov965x->ctrls.blue_balance->val);
 		if (ret < 0)
 			return ret;
-		ret = ov965x_write(ov965x->client, REG_RED,
+		ret = ov965x_write(ov965x, REG_RED,
 				   ov965x->ctrls.red_balance->val);
 	}
 	return ret;
@@ -677,14 +666,13 @@ static int ov965x_set_brightness(struct ov965x *ov965x, int val)
 		return -EINVAL;
 
 	for (i = 0; i < NUM_BR_REGS && !ret; i++)
-		ret = ov965x_write(ov965x->client, regs[0][i],
+		ret = ov965x_write(ov965x, regs[0][i],
 				   regs[val][i]);
 	return ret;
 }
 
 static int ov965x_set_gain(struct ov965x *ov965x, int auto_gain)
 {
-	struct i2c_client *client = ov965x->client;
 	struct ov965x_ctrls *ctrls = &ov965x->ctrls;
 	int ret = 0;
 	u8 reg;
@@ -693,14 +681,14 @@ static int ov965x_set_gain(struct ov965x *ov965x, int auto_gain)
 	 * gain value in REG_VREF, REG_GAIN is not overwritten.
 	 */
 	if (ctrls->auto_gain->is_new) {
-		ret = ov965x_read(client, REG_COM8, &reg);
+		ret = ov965x_read(ov965x, REG_COM8, &reg);
 		if (ret < 0)
 			return ret;
 		if (ctrls->auto_gain->val)
 			reg |= COM8_AGC;
 		else
 			reg &= ~COM8_AGC;
-		ret = ov965x_write(client, REG_COM8, reg);
+		ret = ov965x_write(ov965x, REG_COM8, reg);
 		if (ret < 0)
 			return ret;
 	}
@@ -719,15 +707,15 @@ static int ov965x_set_gain(struct ov965x *ov965x, int auto_gain)
 		rgain = (gain - ((1 << m) * 16)) / (1 << m);
 		rgain |= (((1 << m) - 1) << 4);
 
-		ret = ov965x_write(client, REG_GAIN, rgain & 0xff);
+		ret = ov965x_write(ov965x, REG_GAIN, rgain & 0xff);
 		if (ret < 0)
 			return ret;
-		ret = ov965x_read(client, REG_VREF, &reg);
+		ret = ov965x_read(ov965x, REG_VREF, &reg);
 		if (ret < 0)
 			return ret;
 		reg &= ~VREF_GAIN_MASK;
 		reg |= (((rgain >> 8) & 0x3) << 6);
-		ret = ov965x_write(client, REG_VREF, reg);
+		ret = ov965x_write(ov965x, REG_VREF, reg);
 		if (ret < 0)
 			return ret;
 		/* Return updated control's value to userspace */
@@ -742,10 +730,10 @@ static int ov965x_set_sharpness(struct ov965x *ov965x, unsigned int value)
 	u8 com14, edge;
 	int ret;
 
-	ret = ov965x_read(ov965x->client, REG_COM14, &com14);
+	ret = ov965x_read(ov965x, REG_COM14, &com14);
 	if (ret < 0)
 		return ret;
-	ret = ov965x_read(ov965x->client, REG_EDGE, &edge);
+	ret = ov965x_read(ov965x, REG_EDGE, &edge);
 	if (ret < 0)
 		return ret;
 	com14 = value ? com14 | COM14_EDGE_EN : com14 & ~COM14_EDGE_EN;
@@ -756,33 +744,32 @@ static int ov965x_set_sharpness(struct ov965x *ov965x, unsigned int value)
 	} else {
 		com14 &= ~COM14_EEF_X2;
 	}
-	ret = ov965x_write(ov965x->client, REG_COM14, com14);
+	ret = ov965x_write(ov965x, REG_COM14, com14);
 	if (ret < 0)
 		return ret;
 
 	edge &= ~EDGE_FACTOR_MASK;
 	edge |= ((u8)value & 0x0f);
 
-	return ov965x_write(ov965x->client, REG_EDGE, edge);
+	return ov965x_write(ov965x, REG_EDGE, edge);
 }
 
 static int ov965x_set_exposure(struct ov965x *ov965x, int exp)
 {
-	struct i2c_client *client = ov965x->client;
 	struct ov965x_ctrls *ctrls = &ov965x->ctrls;
 	bool auto_exposure = (exp == V4L2_EXPOSURE_AUTO);
 	int ret;
 	u8 reg;
 
 	if (ctrls->auto_exp->is_new) {
-		ret = ov965x_read(client, REG_COM8, &reg);
+		ret = ov965x_read(ov965x, REG_COM8, &reg);
 		if (ret < 0)
 			return ret;
 		if (auto_exposure)
 			reg |= (COM8_AEC | COM8_AGC);
 		else
 			reg &= ~(COM8_AEC | COM8_AGC);
-		ret = ov965x_write(client, REG_COM8, reg);
+		ret = ov965x_write(ov965x, REG_COM8, reg);
 		if (ret < 0)
 			return ret;
 	}
@@ -794,12 +781,12 @@ static int ov965x_set_exposure(struct ov965x *ov965x, int exp)
 		 * Manual exposure value
 		 * [b15:b0] - AECHM (b15:b10), AECH (b9:b2), COM1 (b1:b0)
 		 */
-		ret = ov965x_write(client, REG_COM1, exposure & 0x3);
+		ret = ov965x_write(ov965x, REG_COM1, exposure & 0x3);
 		if (!ret)
-			ret = ov965x_write(client, REG_AECH,
+			ret = ov965x_write(ov965x, REG_AECH,
 					   (exposure >> 2) & 0xff);
 		if (!ret)
-			ret = ov965x_write(client, REG_AECHM,
+			ret = ov965x_write(ov965x, REG_AECHM,
 					   (exposure >> 10) & 0x3f);
 		/* Update the value to minimize rounding errors */
 		ctrls->exposure->val = ((exposure * ov965x->exp_row_interval)
@@ -822,7 +809,7 @@ static int ov965x_set_flip(struct ov965x *ov965x)
 	if (ov965x->ctrls.vflip->val)
 		mvfp |= MVFP_FLIP;
 
-	return ov965x_write(ov965x->client, REG_MVFP, mvfp);
+	return ov965x_write(ov965x, REG_MVFP, mvfp);
 }
 
 #define NUM_SAT_LEVELS	5
@@ -846,7 +833,7 @@ static int ov965x_set_saturation(struct ov965x *ov965x, int val)
 		return -EINVAL;
 
 	for (i = 0; i < NUM_SAT_REGS && !ret; i++)
-		ret = ov965x_write(ov965x->client, addr + i, regs[val][i]);
+		ret = ov965x_write(ov965x, addr + i, regs[val][i]);
 
 	return ret;
 }
@@ -856,16 +843,15 @@ static int ov965x_set_test_pattern(struct ov965x *ov965x, int value)
 	int ret;
 	u8 reg;
 
-	ret = ov965x_read(ov965x->client, REG_COM23, &reg);
+	ret = ov965x_read(ov965x, REG_COM23, &reg);
 	if (ret < 0)
 		return ret;
 	reg = value ? reg | COM23_TEST_MODE : reg & ~COM23_TEST_MODE;
-	return ov965x_write(ov965x->client, REG_COM23, reg);
+	return ov965x_write(ov965x, REG_COM23, reg);
 }
 
 static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
 {
-	struct i2c_client *client = ov965x->client;
 	unsigned int exposure, gain, m;
 	u8 reg0, reg1, reg2;
 	int ret;
@@ -877,10 +863,10 @@ static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
 	case V4L2_CID_AUTOGAIN:
 		if (!ctrl->val)
 			return 0;
-		ret = ov965x_read(client, REG_GAIN, &reg0);
+		ret = ov965x_read(ov965x, REG_GAIN, &reg0);
 		if (ret < 0)
 			return ret;
-		ret = ov965x_read(client, REG_VREF, &reg1);
+		ret = ov965x_read(ov965x, REG_VREF, &reg1);
 		if (ret < 0)
 			return ret;
 		gain = ((reg1 >> 6) << 8) | reg0;
@@ -891,13 +877,13 @@ static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
 			return 0;
-		ret = ov965x_read(client, REG_COM1, &reg0);
+		ret = ov965x_read(ov965x, REG_COM1, &reg0);
 		if (ret < 0)
 			return ret;
-		ret = ov965x_read(client, REG_AECH, &reg1);
+		ret = ov965x_read(ov965x, REG_AECH, &reg1);
 		if (ret < 0)
 			return ret;
-		ret = ov965x_read(client, REG_AECHM, &reg2);
+		ret = ov965x_read(ov965x, REG_AECHM, &reg2);
 		if (ret < 0)
 			return ret;
 		exposure = ((reg2 & 0x3f) << 10) | (reg1 << 2) |
@@ -1279,32 +1265,31 @@ static int ov965x_set_frame_size(struct ov965x *ov965x)
 	int i, ret = 0;
 
 	for (i = 0; ret == 0 && i < NUM_FMT_REGS; i++)
-		ret = ov965x_write(ov965x->client, frame_size_reg_addr[i],
+		ret = ov965x_write(ov965x, frame_size_reg_addr[i],
 				   ov965x->frame_size->regs[i]);
 	return ret;
 }
 
 static int __ov965x_set_params(struct ov965x *ov965x)
 {
-	struct i2c_client *client = ov965x->client;
 	struct ov965x_ctrls *ctrls = &ov965x->ctrls;
 	int ret = 0;
 	u8 reg;
 
 	if (ov965x->apply_frame_fmt) {
 		reg = DEF_CLKRC + ov965x->fiv->clkrc_div;
-		ret = ov965x_write(client, REG_CLKRC, reg);
+		ret = ov965x_write(ov965x, REG_CLKRC, reg);
 		if (ret < 0)
 			return ret;
 		ret = ov965x_set_frame_size(ov965x);
 		if (ret < 0)
 			return ret;
-		ret = ov965x_read(client, REG_TSLB, &reg);
+		ret = ov965x_read(ov965x, REG_TSLB, &reg);
 		if (ret < 0)
 			return ret;
 		reg &= ~TSLB_YUYV_MASK;
 		reg |= ov965x->tslb_reg;
-		ret = ov965x_write(client, REG_TSLB, reg);
+		ret = ov965x_write(ov965x, REG_TSLB, reg);
 		if (ret < 0)
 			return ret;
 	}
@@ -1318,10 +1303,10 @@ static int __ov965x_set_params(struct ov965x *ov965x)
 	 * Select manual banding filter, the filter will
 	 * be enabled further if required.
 	 */
-	ret = ov965x_read(client, REG_COM11, &reg);
+	ret = ov965x_read(ov965x, REG_COM11, &reg);
 	if (!ret)
 		reg |= COM11_BANDING;
-	ret = ov965x_write(client, REG_COM11, reg);
+	ret = ov965x_write(ov965x, REG_COM11, reg);
 	if (ret < 0)
 		return ret;
 	/*
@@ -1333,12 +1318,11 @@ static int __ov965x_set_params(struct ov965x *ov965x)
 
 static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov965x *ov965x = to_ov965x(sd);
 	struct ov965x_ctrls *ctrls = &ov965x->ctrls;
 	int ret = 0;
 
-	v4l2_dbg(1, debug, client, "%s: on: %d\n", __func__, on);
+	v4l2_dbg(1, debug, sd, "%s: on: %d\n", __func__, on);
 
 	mutex_lock(&ov965x->lock);
 	if (ov965x->streaming == !on) {
@@ -1358,7 +1342,7 @@ static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
 				ctrls->update = 0;
 		}
 		if (!ret)
-			ret = ov965x_write(client, REG_COM2,
+			ret = ov965x_write(ov965x, REG_COM2,
 					   on ? 0x01 : 0x11);
 	}
 	if (!ret)
@@ -1421,6 +1405,7 @@ static int ov965x_configure_gpios_pdata(struct ov965x *ov965x,
 {
 	int ret, i;
 	int gpios[NUM_GPIOS];
+	struct device *dev = regmap_get_device(ov965x->regmap);
 
 	gpios[GPIO_PWDN] = pdata->gpio_pwdn;
 	gpios[GPIO_RST]  = pdata->gpio_reset;
@@ -1430,7 +1415,7 @@ static int ov965x_configure_gpios_pdata(struct ov965x *ov965x,
 
 		if (!gpio_is_valid(gpio))
 			continue;
-		ret = devm_gpio_request_one(&ov965x->client->dev, gpio,
+		ret = devm_gpio_request_one(dev, gpio,
 					    GPIOF_OUT_INIT_HIGH, "OV965X");
 		if (ret < 0)
 			return ret;
@@ -1446,7 +1431,7 @@ static int ov965x_configure_gpios_pdata(struct ov965x *ov965x,
 
 static int ov965x_configure_gpios(struct ov965x *ov965x)
 {
-	struct device *dev = &ov965x->client->dev;
+	struct device *dev = regmap_get_device(ov965x->regmap);
 
 	ov965x->gpios[GPIO_PWDN] = devm_gpiod_get_optional(dev, "powerdown",
 							GPIOD_OUT_HIGH);
@@ -1467,7 +1452,6 @@ static int ov965x_configure_gpios(struct ov965x *ov965x)
 
 static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov965x *ov965x = to_ov965x(sd);
 	u8 pid, ver;
 	int ret;
@@ -1480,9 +1464,9 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 	msleep(25);
 
 	/* Check sensor revision */
-	ret = ov965x_read(client, REG_PID, &pid);
+	ret = ov965x_read(ov965x, REG_PID, &pid);
 	if (!ret)
-		ret = ov965x_read(client, REG_VER, &ver);
+		ret = ov965x_read(ov965x, REG_VER, &ver);
 
 	__ov965x_set_power(ov965x, 0);
 
@@ -1509,12 +1493,21 @@ static int ov965x_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	struct ov965x *ov965x;
 	int ret;
+	static const struct regmap_config ov965x_regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xab,
+	};
 
 	ov965x = devm_kzalloc(&client->dev, sizeof(*ov965x), GFP_KERNEL);
 	if (!ov965x)
 		return -ENOMEM;
 
-	ov965x->client = client;
+	ov965x->regmap = devm_regmap_init_sccb(client, &ov965x_regmap_config);
+	if (IS_ERR(ov965x->regmap)) {
+		dev_err(&client->dev, "Failed to allocate register map\n");
+		return PTR_ERR(ov965x->regmap);
+	}
 
 	if (pdata) {
 		if (pdata->mclk_frequency == 0) {
@@ -1527,7 +1520,7 @@ static int ov965x_probe(struct i2c_client *client,
 		if (ret < 0)
 			return ret;
 	} else if (dev_fwnode(&client->dev)) {
-		ov965x->clk = devm_clk_get(&ov965x->client->dev, NULL);
+		ov965x->clk = devm_clk_get(&client->dev, NULL);
 		if (IS_ERR(ov965x->clk))
 			return PTR_ERR(ov965x->clk);
 		ov965x->mclk_frequency = clk_get_rate(ov965x->clk);
-- 
2.7.4
