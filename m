Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54252 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbaICKKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 06:10:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] m88ts2022: convert to RegMap I2C API
Date: Wed,  3 Sep 2014 13:10:35 +0300
Message-Id: <1409739036-5091-3-git-send-email-crope@iki.fi>
In-Reply-To: <1409739036-5091-1-git-send-email-crope@iki.fi>
References: <1409739036-5091-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use RegMap to cover I2C register routines.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig          |   1 +
 drivers/media/tuners/m88ts2022.c      | 231 ++++++++++------------------------
 drivers/media/tuners/m88ts2022_priv.h |   2 +
 3 files changed, 69 insertions(+), 165 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index d79fd1c..8319996 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -226,6 +226,7 @@ config MEDIA_TUNER_FC2580
 config MEDIA_TUNER_M88TS2022
 	tristate "Montage M88TS2022 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Montage M88TS2022 silicon tuner driver.
diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 4d7f7e1..9f7ebcf 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -18,120 +18,12 @@
 
 #include "m88ts2022_priv.h"
 
-/* write multiple registers */
-static int m88ts2022_wr_regs(struct m88ts2022_dev *dev,
-		u8 reg, const u8 *val, int len)
-{
-#define MAX_WR_LEN 3
-#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
-	int ret;
-	u8 buf[MAX_WR_XFER_LEN];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = dev->client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_WR_LEN))
-		return -EINVAL;
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(dev->client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&dev->client->dev,
-				"i2c wr failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* read multiple registers */
-static int m88ts2022_rd_regs(struct m88ts2022_dev *dev, u8 reg,
-		u8 *val, int len)
-{
-#define MAX_RD_LEN 1
-#define MAX_RD_XFER_LEN (MAX_RD_LEN)
-	int ret;
-	u8 buf[MAX_RD_XFER_LEN];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = dev->client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = dev->client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_RD_LEN))
-		return -EINVAL;
-
-	ret = i2c_transfer(dev->client->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&dev->client->dev,
-				"i2c rd failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int m88ts2022_wr_reg(struct m88ts2022_dev *dev, u8 reg, u8 val)
-{
-	return m88ts2022_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int m88ts2022_rd_reg(struct m88ts2022_dev *dev, u8 reg, u8 *val)
-{
-	return m88ts2022_rd_regs(dev, reg, val, 1);
-}
-
-/* write single register with mask */
-static int m88ts2022_wr_reg_mask(struct m88ts2022_dev *dev,
-		u8 reg, u8 val, u8 mask)
-{
-	int ret;
-	u8 u8tmp;
-
-	/* no need for read if whole reg is written */
-	if (mask != 0xff) {
-		ret = m88ts2022_rd_regs(dev, reg, &u8tmp, 1);
-		if (ret)
-			return ret;
-
-		val &= mask;
-		u8tmp &= ~mask;
-		val |= u8tmp;
-	}
-
-	return m88ts2022_wr_regs(dev, reg, &val, 1);
-}
-
 static int m88ts2022_cmd(struct dvb_frontend *fe,
 		int op, int sleep, u8 reg, u8 mask, u8 val, u8 *reg_val)
 {
 	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret, i;
-	u8 u8tmp;
+	unsigned int utmp;
 	struct m88ts2022_reg_val reg_vals[] = {
 		{0x51, 0x1f - op},
 		{0x51, 0x1f},
@@ -145,7 +37,7 @@ static int m88ts2022_cmd(struct dvb_frontend *fe,
 				i, op, reg, mask, val);
 
 		for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
-			ret = m88ts2022_wr_reg(dev, reg_vals[i].reg,
+			ret = regmap_write(dev->regmap, reg_vals[i].reg,
 					reg_vals[i].val);
 			if (ret)
 				goto err;
@@ -153,16 +45,16 @@ static int m88ts2022_cmd(struct dvb_frontend *fe,
 
 		usleep_range(sleep * 1000, sleep * 10000);
 
-		ret = m88ts2022_rd_reg(dev, reg, &u8tmp);
+		ret = regmap_read(dev->regmap, reg, &utmp);
 		if (ret)
 			goto err;
 
-		if ((u8tmp & mask) != val)
+		if ((utmp & mask) != val)
 			break;
 	}
 
 	if (reg_val)
-		*reg_val = u8tmp;
+		*reg_val = utmp;
 err:
 	return ret;
 }
@@ -172,7 +64,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	struct m88ts2022_dev *dev = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	unsigned int frequency_khz, frequency_offset_khz, f_3db_hz;
+	unsigned int utmp, frequency_khz, frequency_offset_khz, f_3db_hz;
 	unsigned int f_ref_khz, f_vco_khz, div_ref, div_out, pll_n, gdiv28;
 	u8 buf[3], u8tmp, cap_code, lpf_gm, lpf_mxdiv, div_max, div_min;
 	u16 u16tmp;
@@ -204,7 +96,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 
 	buf[0] = u8tmp;
 	buf[1] = 0x40;
-	ret = m88ts2022_wr_regs(dev, 0x10, buf, 2);
+	ret = regmap_bulk_write(dev->regmap, 0x10, buf, 2);
 	if (ret)
 		goto err;
 
@@ -223,7 +115,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	buf[0] = (u16tmp >> 8) & 0x3f;
 	buf[1] = (u16tmp >> 0) & 0xff;
 	buf[2] = div_ref - 8;
-	ret = m88ts2022_wr_regs(dev, 0x01, buf, 3);
+	ret = regmap_bulk_write(dev->regmap, 0x01, buf, 3);
 	if (ret)
 		goto err;
 
@@ -236,17 +128,17 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_rd_reg(dev, 0x14, &u8tmp);
+	ret = regmap_read(dev->regmap, 0x14, &utmp);
 	if (ret)
 		goto err;
 
-	u8tmp &= 0x7f;
-	if (u8tmp < 64) {
-		ret = m88ts2022_wr_reg_mask(dev, 0x10, 0x80, 0x80);
+	utmp &= 0x7f;
+	if (utmp < 64) {
+		ret = regmap_update_bits(dev->regmap, 0x10, 0x80, 0x80);
 		if (ret)
 			goto err;
 
-		ret = m88ts2022_wr_reg(dev, 0x11, 0x6f);
+		ret = regmap_write(dev->regmap, 0x11, 0x6f);
 		if (ret)
 			goto err;
 
@@ -255,13 +147,13 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	ret = m88ts2022_rd_reg(dev, 0x14, &u8tmp);
+	ret = regmap_read(dev->regmap, 0x14, &utmp);
 	if (ret)
 		goto err;
 
-	u8tmp &= 0x1f;
-	if (u8tmp > 19) {
-		ret = m88ts2022_wr_reg_mask(dev, 0x10, 0x00, 0x02);
+	utmp &= 0x1f;
+	if (utmp > 19) {
+		ret = regmap_update_bits(dev->regmap, 0x10, 0x02, 0x00);
 		if (ret)
 			goto err;
 	}
@@ -270,26 +162,26 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x25, 0x00);
+	ret = regmap_write(dev->regmap, 0x25, 0x00);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x27, 0x70);
+	ret = regmap_write(dev->regmap, 0x27, 0x70);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x41, 0x09);
+	ret = regmap_write(dev->regmap, 0x41, 0x09);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x08, 0x0b);
+	ret = regmap_write(dev->regmap, 0x08, 0x0b);
 	if (ret)
 		goto err;
 
 	/* filters */
 	gdiv28 = DIV_ROUND_CLOSEST(f_ref_khz * 1694U, 1000000U);
 
-	ret = m88ts2022_wr_reg(dev, 0x04, gdiv28);
+	ret = regmap_write(dev->regmap, 0x04, gdiv28);
 	if (ret)
 		goto err;
 
@@ -299,7 +191,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 
 	cap_code = u8tmp & 0x3f;
 
-	ret = m88ts2022_wr_reg(dev, 0x41, 0x0d);
+	ret = regmap_write(dev->regmap, 0x41, 0x0d);
 	if (ret)
 		goto err;
 
@@ -327,11 +219,11 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		lpf_mxdiv = DIV_ROUND_CLOSEST(++lpf_gm * LPF_COEFF * f_ref_khz, f_3db_hz);
 	lpf_mxdiv = clamp_val(lpf_mxdiv, 0U, div_max);
 
-	ret = m88ts2022_wr_reg(dev, 0x04, lpf_mxdiv);
+	ret = regmap_write(dev->regmap, 0x04, lpf_mxdiv);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x06, lpf_gm);
+	ret = regmap_write(dev->regmap, 0x06, lpf_gm);
 	if (ret)
 		goto err;
 
@@ -341,7 +233,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 
 	cap_code = u8tmp & 0x3f;
 
-	ret = m88ts2022_wr_reg(dev, 0x41, 0x09);
+	ret = regmap_write(dev->regmap, 0x41, 0x09);
 	if (ret)
 		goto err;
 
@@ -353,15 +245,15 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	cap_code = (cap_code + u8tmp) / 2;
 
 	u8tmp = cap_code | 0x80;
-	ret = m88ts2022_wr_reg(dev, 0x25, u8tmp);
+	ret = regmap_write(dev->regmap, 0x25, u8tmp);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x27, 0x30);
+	ret = regmap_write(dev->regmap, 0x27, 0x30);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x08, 0x09);
+	ret = regmap_write(dev->regmap, 0x08, 0x09);
 	if (ret)
 		goto err;
 
@@ -396,11 +288,11 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 
 	dev_dbg(&dev->client->dev, "\n");
 
-	ret = m88ts2022_wr_reg(dev, 0x00, 0x01);
+	ret = regmap_write(dev->regmap, 0x00, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(dev, 0x00, 0x03);
+	ret = regmap_write(dev->regmap, 0x00, 0x03);
 	if (ret)
 		goto err;
 
@@ -410,7 +302,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		break;
 	case M88TS2022_CLOCK_OUT_ENABLED:
 		u8tmp = 0x70;
-		ret = m88ts2022_wr_reg(dev, 0x05, dev->cfg.clock_out_div);
+		ret = regmap_write(dev->regmap, 0x05, dev->cfg.clock_out_div);
 		if (ret)
 			goto err;
 		break;
@@ -421,7 +313,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = m88ts2022_wr_reg(dev, 0x42, u8tmp);
+	ret = regmap_write(dev->regmap, 0x42, u8tmp);
 	if (ret)
 		goto err;
 
@@ -430,12 +322,12 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x6c;
 
-	ret = m88ts2022_wr_reg(dev, 0x62, u8tmp);
+	ret = regmap_write(dev->regmap, 0x62, u8tmp);
 	if (ret)
 		goto err;
 
 	for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
-		ret = m88ts2022_wr_reg(dev, reg_vals[i].reg, reg_vals[i].val);
+		ret = regmap_write(dev->regmap, reg_vals[i].reg, reg_vals[i].val);
 		if (ret)
 			goto err;
 	}
@@ -452,7 +344,7 @@ static int m88ts2022_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&dev->client->dev, "\n");
 
-	ret = m88ts2022_wr_reg(dev, 0x00, 0x00);
+	ret = regmap_write(dev->regmap, 0x00, 0x00);
 	if (ret)
 		goto err;
 err:
@@ -485,29 +377,28 @@ static int m88ts2022_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret;
-	u8 u8tmp;
 	u16 gain, u16tmp;
-	unsigned int gain1, gain2, gain3;
+	unsigned int utmp, gain1, gain2, gain3;
 
-	ret = m88ts2022_rd_reg(dev, 0x3d, &u8tmp);
+	ret = regmap_read(dev->regmap, 0x3d, &utmp);
 	if (ret)
 		goto err;
 
-	gain1 = (u8tmp >> 0) & 0x1f;
+	gain1 = (utmp >> 0) & 0x1f;
 	gain1 = clamp(gain1, 0U, 15U);
 
-	ret = m88ts2022_rd_reg(dev, 0x21, &u8tmp);
+	ret = regmap_read(dev->regmap, 0x21, &utmp);
 	if (ret)
 		goto err;
 
-	gain2 = (u8tmp >> 0) & 0x1f;
+	gain2 = (utmp >> 0) & 0x1f;
 	gain2 = clamp(gain2, 2U, 16U);
 
-	ret = m88ts2022_rd_reg(dev, 0x66, &u8tmp);
+	ret = regmap_read(dev->regmap, 0x66, &utmp);
 	if (ret)
 		goto err;
 
-	gain3 = (u8tmp >> 3) & 0x07;
+	gain3 = (utmp >> 3) & 0x07;
 	gain3 = clamp(gain3, 0U, 6U);
 
 	gain = gain1 * 265 + gain2 * 338 + gain3 * 285;
@@ -546,7 +437,12 @@ static int m88ts2022_probe(struct i2c_client *client,
 	struct dvb_frontend *fe = cfg->fe;
 	struct m88ts2022_dev *dev;
 	int ret;
-	u8 chip_id, u8tmp;
+	u8 u8tmp;
+	unsigned int utmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
@@ -557,33 +453,38 @@ static int m88ts2022_probe(struct i2c_client *client,
 
 	memcpy(&dev->cfg, cfg, sizeof(struct m88ts2022_config));
 	dev->client = client;
+	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err;
+	}
 
 	/* check if the tuner is there */
-	ret = m88ts2022_rd_reg(dev, 0x00, &u8tmp);
+	ret = regmap_read(dev->regmap, 0x00, &utmp);
 	if (ret)
 		goto err;
 
-	if ((u8tmp & 0x03) == 0x00) {
-		ret = m88ts2022_wr_reg(dev, 0x00, 0x01);
-		if (ret < 0)
+	if ((utmp & 0x03) == 0x00) {
+		ret = regmap_write(dev->regmap, 0x00, 0x01);
+		if (ret)
 			goto err;
 
 		usleep_range(2000, 50000);
 	}
 
-	ret = m88ts2022_wr_reg(dev, 0x00, 0x03);
+	ret = regmap_write(dev->regmap, 0x00, 0x03);
 	if (ret)
 		goto err;
 
 	usleep_range(2000, 50000);
 
-	ret = m88ts2022_rd_reg(dev, 0x00, &chip_id);
+	ret = regmap_read(dev->regmap, 0x00, &utmp);
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "chip_id=%02x\n", chip_id);
+	dev_dbg(&dev->client->dev, "chip_id=%02x\n", utmp);
 
-	switch (chip_id) {
+	switch (utmp) {
 	case 0xc3:
 	case 0x83:
 		break;
@@ -597,7 +498,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 		break;
 	case M88TS2022_CLOCK_OUT_ENABLED:
 		u8tmp = 0x70;
-		ret = m88ts2022_wr_reg(dev, 0x05, dev->cfg.clock_out_div);
+		ret = regmap_write(dev->regmap, 0x05, dev->cfg.clock_out_div);
 		if (ret)
 			goto err;
 		break;
@@ -608,7 +509,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	ret = m88ts2022_wr_reg(dev, 0x42, u8tmp);
+	ret = regmap_write(dev->regmap, 0x42, u8tmp);
 	if (ret)
 		goto err;
 
@@ -617,12 +518,12 @@ static int m88ts2022_probe(struct i2c_client *client,
 	else
 		u8tmp = 0x6c;
 
-	ret = m88ts2022_wr_reg(dev, 0x62, u8tmp);
+	ret = regmap_write(dev->regmap, 0x62, u8tmp);
 	if (ret)
 		goto err;
 
 	/* sleep */
-	ret = m88ts2022_wr_reg(dev, 0x00, 0x00);
+	ret = regmap_write(dev->regmap, 0x00, 0x00);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/tuners/m88ts2022_priv.h b/drivers/media/tuners/m88ts2022_priv.h
index e7f6c91..56c1071 100644
--- a/drivers/media/tuners/m88ts2022_priv.h
+++ b/drivers/media/tuners/m88ts2022_priv.h
@@ -18,10 +18,12 @@
 #define M88TS2022_PRIV_H
 
 #include "m88ts2022.h"
+#include <linux/regmap.h>
 
 struct m88ts2022_dev {
 	struct m88ts2022_config cfg;
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct dvb_frontend *fe;
 	u32 frequency_khz;
 };
-- 
http://palosaari.fi/

