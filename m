Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46408 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbaB0Aam (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:30:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 06/16] e4000: convert to Regmap API
Date: Thu, 27 Feb 2014 02:30:15 +0200
Message-Id: <1393461025-11857-7-git-send-email-crope@iki.fi>
In-Reply-To: <1393461025-11857-1-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That comes possible after driver was converted to kernel I2C model
(I2C binding & proper I2C client with no gate control hack). All
nasty low level I2C routines are now covered by regmap.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig      |   1 +
 drivers/media/tuners/e4000.c      | 212 ++++++++++++--------------------------
 drivers/media/tuners/e4000_priv.h |   2 +
 3 files changed, 68 insertions(+), 147 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index ba2e365..a128488 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -204,6 +204,7 @@ config MEDIA_TUNER_TDA18212
 config MEDIA_TUNER_E4000
 	tristate "Elonics E4000 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Elonics E4000 silicon tuner driver.
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index fd38f51..3ac0254 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -21,97 +21,6 @@
 #include "e4000_priv.h"
 #include <linux/math64.h>
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
-/* write multiple registers */
-static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = priv->client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(priv->client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&priv->client->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = priv->client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = priv->client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
-			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
-		return -EINVAL;
-	}
-
-	ret = i2c_transfer(priv->client->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&priv->client->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int e4000_wr_reg(struct e4000_priv *priv, u8 reg, u8 val)
-{
-	return e4000_wr_regs(priv, reg, &val, 1);
-}
-
-/* read single register */
-static int e4000_rd_reg(struct e4000_priv *priv, u8 reg, u8 *val)
-{
-	return e4000_rd_regs(priv, reg, val, 1);
-}
-
 static int e4000_init(struct dvb_frontend *fe)
 {
 	struct e4000_priv *priv = fe->tuner_priv;
@@ -120,58 +29,58 @@ static int e4000_init(struct dvb_frontend *fe)
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	/* dummy I2C to ensure I2C wakes up */
-	ret = e4000_wr_reg(priv, 0x02, 0x40);
+	ret = regmap_write(priv->regmap, 0x02, 0x40);
 
 	/* reset */
-	ret = e4000_wr_reg(priv, 0x00, 0x01);
+	ret = regmap_write(priv->regmap, 0x00, 0x01);
 	if (ret < 0)
 		goto err;
 
 	/* disable output clock */
-	ret = e4000_wr_reg(priv, 0x06, 0x00);
+	ret = regmap_write(priv->regmap, 0x06, 0x00);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x7a, 0x96);
+	ret = regmap_write(priv->regmap, 0x7a, 0x96);
 	if (ret < 0)
 		goto err;
 
 	/* configure gains */
-	ret = e4000_wr_regs(priv, 0x7e, "\x01\xfe", 2);
+	ret = regmap_bulk_write(priv->regmap, 0x7e, "\x01\xfe", 2);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x82, 0x00);
+	ret = regmap_write(priv->regmap, 0x82, 0x00);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x24, 0x05);
+	ret = regmap_write(priv->regmap, 0x24, 0x05);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x87, "\x20\x01", 2);
+	ret = regmap_bulk_write(priv->regmap, 0x87, "\x20\x01", 2);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x9f, "\x7f\x07", 2);
+	ret = regmap_bulk_write(priv->regmap, 0x9f, "\x7f\x07", 2);
 	if (ret < 0)
 		goto err;
 
 	/* DC offset control */
-	ret = e4000_wr_reg(priv, 0x2d, 0x1f);
+	ret = regmap_write(priv->regmap, 0x2d, 0x1f);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x70, "\x01\x01", 2);
+	ret = regmap_bulk_write(priv->regmap, 0x70, "\x01\x01", 2);
 	if (ret < 0)
 		goto err;
 
 	/* gain control */
-	ret = e4000_wr_reg(priv, 0x1a, 0x17);
+	ret = regmap_write(priv->regmap, 0x1a, 0x17);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x1f, 0x1a);
+	ret = regmap_write(priv->regmap, 0x1f, 0x1a);
 	if (ret < 0)
 		goto err;
 
@@ -192,7 +101,7 @@ static int e4000_sleep(struct dvb_frontend *fe)
 
 	priv->active = false;
 
-	ret = e4000_wr_reg(priv, 0x00, 0x00);
+	ret = regmap_write(priv->regmap, 0x00, 0x00);
 	if (ret < 0)
 		goto err;
 err:
@@ -216,7 +125,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			c->bandwidth_hz);
 
 	/* gain control manual */
-	ret = e4000_wr_reg(priv, 0x1a, 0x00);
+	ret = regmap_write(priv->regmap, 0x1a, 0x00);
 	if (ret < 0)
 		goto err;
 
@@ -243,7 +152,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			"%s: f_vco=%llu pll div=%d sigma_delta=%04x\n",
 			__func__, f_vco, buf[0], sigma_delta);
 
-	ret = e4000_wr_regs(priv, 0x09, buf, 5);
+	ret = regmap_bulk_write(priv->regmap, 0x09, buf, 5);
 	if (ret < 0)
 		goto err;
 
@@ -258,7 +167,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = e4000_wr_reg(priv, 0x10, e400_lna_filter_lut[i].val);
+	ret = regmap_write(priv->regmap, 0x10, e400_lna_filter_lut[i].val);
 	if (ret < 0)
 		goto err;
 
@@ -276,7 +185,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	buf[0] = e4000_if_filter_lut[i].reg11_val;
 	buf[1] = e4000_if_filter_lut[i].reg12_val;
 
-	ret = e4000_wr_regs(priv, 0x11, buf, 2);
+	ret = regmap_bulk_write(priv->regmap, 0x11, buf, 2);
 	if (ret < 0)
 		goto err;
 
@@ -291,33 +200,33 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = e4000_wr_reg(priv, 0x07, e4000_band_lut[i].reg07_val);
+	ret = regmap_write(priv->regmap, 0x07, e4000_band_lut[i].reg07_val);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_reg(priv, 0x78, e4000_band_lut[i].reg78_val);
+	ret = regmap_write(priv->regmap, 0x78, e4000_band_lut[i].reg78_val);
 	if (ret < 0)
 		goto err;
 
 	/* DC offset */
 	for (i = 0; i < 4; i++) {
 		if (i == 0)
-			ret = e4000_wr_regs(priv, 0x15, "\x00\x7e\x24", 3);
+			ret = regmap_bulk_write(priv->regmap, 0x15, "\x00\x7e\x24", 3);
 		else if (i == 1)
-			ret = e4000_wr_regs(priv, 0x15, "\x00\x7f", 2);
+			ret = regmap_bulk_write(priv->regmap, 0x15, "\x00\x7f", 2);
 		else if (i == 2)
-			ret = e4000_wr_regs(priv, 0x15, "\x01", 1);
+			ret = regmap_bulk_write(priv->regmap, 0x15, "\x01", 1);
 		else
-			ret = e4000_wr_regs(priv, 0x16, "\x7e", 1);
+			ret = regmap_bulk_write(priv->regmap, 0x16, "\x7e", 1);
 
 		if (ret < 0)
 			goto err;
 
-		ret = e4000_wr_reg(priv, 0x29, 0x01);
+		ret = regmap_write(priv->regmap, 0x29, 0x01);
 		if (ret < 0)
 			goto err;
 
-		ret = e4000_rd_regs(priv, 0x2a, buf, 3);
+		ret = regmap_bulk_read(priv->regmap, 0x2a, buf, 3);
 		if (ret < 0)
 			goto err;
 
@@ -328,16 +237,16 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	swap(q_data[2], q_data[3]);
 	swap(i_data[2], i_data[3]);
 
-	ret = e4000_wr_regs(priv, 0x50, q_data, 4);
+	ret = regmap_bulk_write(priv->regmap, 0x50, q_data, 4);
 	if (ret < 0)
 		goto err;
 
-	ret = e4000_wr_regs(priv, 0x60, i_data, 4);
+	ret = regmap_bulk_write(priv->regmap, 0x60, i_data, 4);
 	if (ret < 0)
 		goto err;
 
 	/* gain control auto */
-	ret = e4000_wr_reg(priv, 0x1a, 0x17);
+	ret = regmap_write(priv->regmap, 0x1a, 0x17);
 	if (ret < 0)
 		goto err;
 err:
@@ -378,12 +287,12 @@ static int e4000_set_lna_gain(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x10;
 
-	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	ret = regmap_write(priv->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
 	if (priv->lna_gain_auto->val == false) {
-		ret = e4000_wr_reg(priv, 0x14, priv->lna_gain->val);
+		ret = regmap_write(priv->regmap, 0x14, priv->lna_gain->val);
 		if (ret)
 			goto err;
 	}
@@ -410,12 +319,12 @@ static int e4000_set_mixer_gain(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x14;
 
-	ret = e4000_wr_reg(priv, 0x20, u8tmp);
+	ret = regmap_write(priv->regmap, 0x20, u8tmp);
 	if (ret)
 		goto err;
 
 	if (priv->mixer_gain_auto->val == false) {
-		ret = e4000_wr_reg(priv, 0x15, priv->mixer_gain->val);
+		ret = regmap_write(priv->regmap, 0x15, priv->mixer_gain->val);
 		if (ret)
 			goto err;
 	}
@@ -447,14 +356,14 @@ static int e4000_set_if_gain(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x10;
 
-	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	ret = regmap_write(priv->regmap, 0x1a, u8tmp);
 	if (ret)
 		goto err;
 
 	if (priv->if_gain_auto->val == false) {
 		buf[0] = e4000_if_gain_lut[priv->if_gain->val].reg16_val;
 		buf[1] = e4000_if_gain_lut[priv->if_gain->val].reg17_val;
-		ret = e4000_wr_regs(priv, 0x16, buf, 2);
+		ret = regmap_bulk_write(priv->regmap, 0x16, buf, 2);
 		if (ret)
 			goto err;
 	}
@@ -469,16 +378,13 @@ static int e4000_pll_lock(struct dvb_frontend *fe)
 {
 	struct e4000_priv *priv = fe->tuner_priv;
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
 
-	if (priv->active == false)
-		return 0;
-
-	ret = e4000_rd_reg(priv, 0x07, &u8tmp);
-	if (ret)
+	ret = regmap_read(priv->regmap, 0x07, &utmp);
+	if (ret < 0)
 		goto err;
 
-	priv->pll_lock->val = (u8tmp & 0x01);
+	priv->pll_lock->val = (utmp & 0x01);
 err:
 	if (ret)
 		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
@@ -488,15 +394,19 @@ err:
 
 static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000_priv *priv =
-			container_of(ctrl->handler, struct e4000_priv, hdl);
+	struct e4000_priv *priv = container_of(ctrl->handler, struct e4000_priv, hdl);
 	int ret;
 
+	if (priv->active == false)
+		return 0;
+
 	switch (ctrl->id) {
 	case  V4L2_CID_RF_TUNER_PLL_LOCK:
 		ret = e4000_pll_lock(priv->fe);
 		break;
 	default:
+		dev_dbg(&priv->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
+				__func__, ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -505,16 +415,13 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct e4000_priv *priv =
-			container_of(ctrl->handler, struct e4000_priv, hdl);
+	struct e4000_priv *priv = container_of(ctrl->handler, struct e4000_priv, hdl);
 	struct dvb_frontend *fe = priv->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->client->dev,
-			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
-			__func__, ctrl->id, ctrl->name, ctrl->val,
-			ctrl->minimum, ctrl->maximum, ctrl->step);
+	if (priv->active == false)
+		return 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
@@ -535,6 +442,8 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = e4000_set_if_gain(priv->fe);
 		break;
 	default:
+		dev_dbg(&priv->client->dev, "%s: unknown ctrl: id=%d name=%s\n",
+				__func__, ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -574,7 +483,12 @@ static int e4000_probe(struct i2c_client *client,
 	struct dvb_frontend *fe = cfg->fe;
 	struct e4000_priv *priv;
 	int ret;
-	u8 chip_id;
+	unsigned int utmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0xff,
+	};
 
 	priv = kzalloc(sizeof(struct e4000_priv), GFP_KERNEL);
 	if (!priv) {
@@ -586,22 +500,26 @@ static int e4000_probe(struct i2c_client *client,
 	priv->clock = cfg->clock;
 	priv->client = client;
 	priv->fe = cfg->fe;
+	priv->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(priv->regmap)) {
+		ret = PTR_ERR(priv->regmap);
+		goto err;
+	}
 
 	/* check if the tuner is there */
-	ret = e4000_rd_reg(priv, 0x02, &chip_id);
+	ret = regmap_read(priv->regmap, 0x02, &utmp);
 	if (ret < 0)
 		goto err;
 
-	dev_dbg(&priv->client->dev,
-			"%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&priv->client->dev, "%s: chip id=%02x\n", __func__, utmp);
 
-	if (chip_id != 0x40) {
+	if (utmp != 0x40) {
 		ret = -ENODEV;
 		goto err;
 	}
 
 	/* put sleep as chip seems to be in normal mode by default */
-	ret = e4000_wr_reg(priv, 0x00, 0x00);
+	ret = regmap_write(priv->regmap, 0x00, 0x00);
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index d41dbcc..40ba176 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -23,9 +23,11 @@
 
 #include "e4000.h"
 #include <media/v4l2-ctrls.h>
+#include <linux/regmap.h>
 
 struct e4000_priv {
 	struct i2c_client *client;
+	struct regmap *regmap;
 	u32 clock;
 	struct dvb_frontend *fe;
 	bool active;
-- 
1.8.5.3

