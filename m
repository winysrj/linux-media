Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54781 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbaICKKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 06:10:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] m88ts2022: rename device state (priv => dev)
Date: Wed,  3 Sep 2014 13:10:33 +0300
Message-Id: <1409739036-5091-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

foo_dev seems to be most correct term for the structure holding data
of each device instance. It is most used term in Kernel and also
examples from book Linux Device Drivers, Third Edition, uses it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c      | 190 +++++++++++++++++-----------------
 drivers/media/tuners/m88ts2022_priv.h |   2 +-
 2 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index f51b107..94f0d3b 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -19,7 +19,7 @@
 #include "m88ts2022_priv.h"
 
 /* write multiple registers */
-static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
+static int m88ts2022_wr_regs(struct m88ts2022_dev *dev,
 		u8 reg, const u8 *val, int len)
 {
 #define MAX_WR_LEN 3
@@ -28,7 +28,7 @@ static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 	u8 buf[MAX_WR_XFER_LEN];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->client->addr,
+			.addr = dev->client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -41,11 +41,11 @@ static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->client->adapter, msg, 1);
+	ret = i2c_transfer(dev->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev,
+		dev_warn(&dev->client->dev,
 				"%s: i2c wr failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -55,7 +55,7 @@ static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 }
 
 /* read multiple registers */
-static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
+static int m88ts2022_rd_regs(struct m88ts2022_dev *dev, u8 reg,
 		u8 *val, int len)
 {
 #define MAX_RD_LEN 1
@@ -64,12 +64,12 @@ static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 	u8 buf[MAX_RD_XFER_LEN];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->client->addr,
+			.addr = dev->client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->client->addr,
+			.addr = dev->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -79,12 +79,12 @@ static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 	if (WARN_ON(len > MAX_RD_LEN))
 		return -EINVAL;
 
-	ret = i2c_transfer(priv->client->adapter, msg, 2);
+	ret = i2c_transfer(dev->client->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev,
+		dev_warn(&dev->client->dev,
 				"%s: i2c rd failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -94,19 +94,19 @@ static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 }
 
 /* write single register */
-static int m88ts2022_wr_reg(struct m88ts2022_priv *priv, u8 reg, u8 val)
+static int m88ts2022_wr_reg(struct m88ts2022_dev *dev, u8 reg, u8 val)
 {
-	return m88ts2022_wr_regs(priv, reg, &val, 1);
+	return m88ts2022_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register */
-static int m88ts2022_rd_reg(struct m88ts2022_priv *priv, u8 reg, u8 *val)
+static int m88ts2022_rd_reg(struct m88ts2022_dev *dev, u8 reg, u8 *val)
 {
-	return m88ts2022_rd_regs(priv, reg, val, 1);
+	return m88ts2022_rd_regs(dev, reg, val, 1);
 }
 
 /* write single register with mask */
-static int m88ts2022_wr_reg_mask(struct m88ts2022_priv *priv,
+static int m88ts2022_wr_reg_mask(struct m88ts2022_dev *dev,
 		u8 reg, u8 val, u8 mask)
 {
 	int ret;
@@ -114,7 +114,7 @@ static int m88ts2022_wr_reg_mask(struct m88ts2022_priv *priv,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = m88ts2022_rd_regs(priv, reg, &u8tmp, 1);
+		ret = m88ts2022_rd_regs(dev, reg, &u8tmp, 1);
 		if (ret)
 			return ret;
 
@@ -123,13 +123,13 @@ static int m88ts2022_wr_reg_mask(struct m88ts2022_priv *priv,
 		val |= u8tmp;
 	}
 
-	return m88ts2022_wr_regs(priv, reg, &val, 1);
+	return m88ts2022_wr_regs(dev, reg, &val, 1);
 }
 
 static int m88ts2022_cmd(struct dvb_frontend *fe,
 		int op, int sleep, u8 reg, u8 mask, u8 val, u8 *reg_val)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret, i;
 	u8 u8tmp;
 	struct m88ts2022_reg_val reg_vals[] = {
@@ -140,12 +140,12 @@ static int m88ts2022_cmd(struct dvb_frontend *fe,
 	};
 
 	for (i = 0; i < 2; i++) {
-		dev_dbg(&priv->client->dev,
+		dev_dbg(&dev->client->dev,
 				"%s: i=%d op=%02x reg=%02x mask=%02x val=%02x\n",
 				__func__, i, op, reg, mask, val);
 
 		for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
-			ret = m88ts2022_wr_reg(priv, reg_vals[i].reg,
+			ret = m88ts2022_wr_reg(dev, reg_vals[i].reg,
 					reg_vals[i].val);
 			if (ret)
 				goto err;
@@ -153,7 +153,7 @@ static int m88ts2022_cmd(struct dvb_frontend *fe,
 
 		usleep_range(sleep * 1000, sleep * 10000);
 
-		ret = m88ts2022_rd_reg(priv, reg, &u8tmp);
+		ret = m88ts2022_rd_reg(dev, reg, &u8tmp);
 		if (ret)
 			goto err;
 
@@ -169,7 +169,7 @@ err:
 
 static int m88ts2022_set_params(struct dvb_frontend *fe)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	unsigned int frequency_khz, frequency_offset_khz, f_3db_hz;
@@ -177,14 +177,14 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	u8 buf[3], u8tmp, cap_code, lpf_gm, lpf_mxdiv, div_max, div_min;
 	u16 u16tmp;
 
-	dev_dbg(&priv->client->dev,
+	dev_dbg(&dev->client->dev,
 			"%s: frequency=%d symbol_rate=%d rolloff=%d\n",
 			__func__, c->frequency, c->symbol_rate, c->rolloff);
 	/*
 	 * Integer-N PLL synthesizer
 	 * kHz is used for all calculations to keep calculations within 32-bit
 	 */
-	f_ref_khz = DIV_ROUND_CLOSEST(priv->cfg.clock, 1000);
+	f_ref_khz = DIV_ROUND_CLOSEST(dev->cfg.clock, 1000);
 	div_ref = DIV_ROUND_CLOSEST(f_ref_khz, 2000);
 
 	if (c->symbol_rate < 5000000)
@@ -204,14 +204,14 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 
 	buf[0] = u8tmp;
 	buf[1] = 0x40;
-	ret = m88ts2022_wr_regs(priv, 0x10, buf, 2);
+	ret = m88ts2022_wr_regs(dev, 0x10, buf, 2);
 	if (ret)
 		goto err;
 
 	f_vco_khz = frequency_khz * div_out;
 	pll_n = f_vco_khz * div_ref / f_ref_khz;
 	pll_n += pll_n % 2;
-	priv->frequency_khz = pll_n * f_ref_khz / div_ref / div_out;
+	dev->frequency_khz = pll_n * f_ref_khz / div_ref / div_out;
 
 	if (pll_n < 4095)
 		u16tmp = pll_n - 1024;
@@ -223,31 +223,31 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	buf[0] = (u16tmp >> 8) & 0x3f;
 	buf[1] = (u16tmp >> 0) & 0xff;
 	buf[2] = div_ref - 8;
-	ret = m88ts2022_wr_regs(priv, 0x01, buf, 3);
+	ret = m88ts2022_wr_regs(dev, 0x01, buf, 3);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->client->dev,
+	dev_dbg(&dev->client->dev,
 			"%s: frequency=%u offset=%d f_vco_khz=%u pll_n=%u div_ref=%u div_out=%u\n",
-			__func__, priv->frequency_khz,
-			priv->frequency_khz - c->frequency, f_vco_khz, pll_n,
+			__func__, dev->frequency_khz,
+			dev->frequency_khz - c->frequency, f_vco_khz, pll_n,
 			div_ref, div_out);
 
 	ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_rd_reg(priv, 0x14, &u8tmp);
+	ret = m88ts2022_rd_reg(dev, 0x14, &u8tmp);
 	if (ret)
 		goto err;
 
 	u8tmp &= 0x7f;
 	if (u8tmp < 64) {
-		ret = m88ts2022_wr_reg_mask(priv, 0x10, 0x80, 0x80);
+		ret = m88ts2022_wr_reg_mask(dev, 0x10, 0x80, 0x80);
 		if (ret)
 			goto err;
 
-		ret = m88ts2022_wr_reg(priv, 0x11, 0x6f);
+		ret = m88ts2022_wr_reg(dev, 0x11, 0x6f);
 		if (ret)
 			goto err;
 
@@ -256,13 +256,13 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	ret = m88ts2022_rd_reg(priv, 0x14, &u8tmp);
+	ret = m88ts2022_rd_reg(dev, 0x14, &u8tmp);
 	if (ret)
 		goto err;
 
 	u8tmp &= 0x1f;
 	if (u8tmp > 19) {
-		ret = m88ts2022_wr_reg_mask(priv, 0x10, 0x00, 0x02);
+		ret = m88ts2022_wr_reg_mask(dev, 0x10, 0x00, 0x02);
 		if (ret)
 			goto err;
 	}
@@ -271,26 +271,26 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x25, 0x00);
+	ret = m88ts2022_wr_reg(dev, 0x25, 0x00);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x27, 0x70);
+	ret = m88ts2022_wr_reg(dev, 0x27, 0x70);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x41, 0x09);
+	ret = m88ts2022_wr_reg(dev, 0x41, 0x09);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x08, 0x0b);
+	ret = m88ts2022_wr_reg(dev, 0x08, 0x0b);
 	if (ret)
 		goto err;
 
 	/* filters */
 	gdiv28 = DIV_ROUND_CLOSEST(f_ref_khz * 1694U, 1000000U);
 
-	ret = m88ts2022_wr_reg(priv, 0x04, gdiv28);
+	ret = m88ts2022_wr_reg(dev, 0x04, gdiv28);
 	if (ret)
 		goto err;
 
@@ -300,7 +300,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 
 	cap_code = u8tmp & 0x3f;
 
-	ret = m88ts2022_wr_reg(priv, 0x41, 0x0d);
+	ret = m88ts2022_wr_reg(dev, 0x41, 0x0d);
 	if (ret)
 		goto err;
 
@@ -328,11 +328,11 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		lpf_mxdiv = DIV_ROUND_CLOSEST(++lpf_gm * LPF_COEFF * f_ref_khz, f_3db_hz);
 	lpf_mxdiv = clamp_val(lpf_mxdiv, 0U, div_max);
 
-	ret = m88ts2022_wr_reg(priv, 0x04, lpf_mxdiv);
+	ret = m88ts2022_wr_reg(dev, 0x04, lpf_mxdiv);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x06, lpf_gm);
+	ret = m88ts2022_wr_reg(dev, 0x06, lpf_gm);
 	if (ret)
 		goto err;
 
@@ -342,7 +342,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 
 	cap_code = u8tmp & 0x3f;
 
-	ret = m88ts2022_wr_reg(priv, 0x41, 0x09);
+	ret = m88ts2022_wr_reg(dev, 0x41, 0x09);
 	if (ret)
 		goto err;
 
@@ -354,15 +354,15 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	cap_code = (cap_code + u8tmp) / 2;
 
 	u8tmp = cap_code | 0x80;
-	ret = m88ts2022_wr_reg(priv, 0x25, u8tmp);
+	ret = m88ts2022_wr_reg(dev, 0x25, u8tmp);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x27, 0x30);
+	ret = m88ts2022_wr_reg(dev, 0x27, 0x30);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x08, 0x09);
+	ret = m88ts2022_wr_reg(dev, 0x08, 0x09);
 	if (ret)
 		goto err;
 
@@ -371,14 +371,14 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int m88ts2022_init(struct dvb_frontend *fe)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret, i;
 	u8 u8tmp;
 	static const struct m88ts2022_reg_val reg_vals[] = {
@@ -395,23 +395,23 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		{0x12, 0xa0},
 	};
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "%s:\n", __func__);
 
-	ret = m88ts2022_wr_reg(priv, 0x00, 0x01);
+	ret = m88ts2022_wr_reg(dev, 0x00, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_wr_reg(priv, 0x00, 0x03);
+	ret = m88ts2022_wr_reg(dev, 0x00, 0x03);
 	if (ret)
 		goto err;
 
-	switch (priv->cfg.clock_out) {
+	switch (dev->cfg.clock_out) {
 	case M88TS2022_CLOCK_OUT_DISABLED:
 		u8tmp = 0x60;
 		break;
 	case M88TS2022_CLOCK_OUT_ENABLED:
 		u8tmp = 0x70;
-		ret = m88ts2022_wr_reg(priv, 0x05, priv->cfg.clock_out_div);
+		ret = m88ts2022_wr_reg(dev, 0x05, dev->cfg.clock_out_div);
 		if (ret)
 			goto err;
 		break;
@@ -422,61 +422,61 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = m88ts2022_wr_reg(priv, 0x42, u8tmp);
+	ret = m88ts2022_wr_reg(dev, 0x42, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->cfg.loop_through)
+	if (dev->cfg.loop_through)
 		u8tmp = 0xec;
 	else
 		u8tmp = 0x6c;
 
-	ret = m88ts2022_wr_reg(priv, 0x62, u8tmp);
+	ret = m88ts2022_wr_reg(dev, 0x62, u8tmp);
 	if (ret)
 		goto err;
 
 	for (i = 0; i < ARRAY_SIZE(reg_vals); i++) {
-		ret = m88ts2022_wr_reg(priv, reg_vals[i].reg, reg_vals[i].val);
+		ret = m88ts2022_wr_reg(dev, reg_vals[i].reg, reg_vals[i].val);
 		if (ret)
 			goto err;
 	}
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int m88ts2022_sleep(struct dvb_frontend *fe)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "%s:\n", __func__);
 
-	ret = m88ts2022_wr_reg(priv, 0x00, 0x00);
+	ret = m88ts2022_wr_reg(dev, 0x00, 0x00);
 	if (ret)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int m88ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "%s:\n", __func__);
 
-	*frequency = priv->frequency_khz;
+	*frequency = dev->frequency_khz;
 	return 0;
 }
 
 static int m88ts2022_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 
-	dev_dbg(&priv->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "%s:\n", __func__);
 
 	*frequency = 0; /* Zero-IF */
 	return 0;
@@ -484,27 +484,27 @@ static int m88ts2022_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static int m88ts2022_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct m88ts2022_priv *priv = fe->tuner_priv;
+	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret;
 	u8 u8tmp;
 	u16 gain, u16tmp;
 	unsigned int gain1, gain2, gain3;
 
-	ret = m88ts2022_rd_reg(priv, 0x3d, &u8tmp);
+	ret = m88ts2022_rd_reg(dev, 0x3d, &u8tmp);
 	if (ret)
 		goto err;
 
 	gain1 = (u8tmp >> 0) & 0x1f;
 	gain1 = clamp(gain1, 0U, 15U);
 
-	ret = m88ts2022_rd_reg(priv, 0x21, &u8tmp);
+	ret = m88ts2022_rd_reg(dev, 0x21, &u8tmp);
 	if (ret)
 		goto err;
 
 	gain2 = (u8tmp >> 0) & 0x1f;
 	gain2 = clamp(gain2, 2U, 16U);
 
-	ret = m88ts2022_rd_reg(priv, 0x66, &u8tmp);
+	ret = m88ts2022_rd_reg(dev, 0x66, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -520,7 +520,7 @@ static int m88ts2022_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	*strength = (u16tmp - 59000) * 0xffff / (61500 - 59000);
 err:
 	if (ret)
-		dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -545,44 +545,44 @@ static int m88ts2022_probe(struct i2c_client *client,
 {
 	struct m88ts2022_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct m88ts2022_priv *priv;
+	struct m88ts2022_dev *dev;
 	int ret;
 	u8 chip_id, u8tmp;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	memcpy(&priv->cfg, cfg, sizeof(struct m88ts2022_config));
-	priv->client = client;
+	memcpy(&dev->cfg, cfg, sizeof(struct m88ts2022_config));
+	dev->client = client;
 
 	/* check if the tuner is there */
-	ret = m88ts2022_rd_reg(priv, 0x00, &u8tmp);
+	ret = m88ts2022_rd_reg(dev, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
 	if ((u8tmp & 0x03) == 0x00) {
-		ret = m88ts2022_wr_reg(priv, 0x00, 0x01);
+		ret = m88ts2022_wr_reg(dev, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 
 		usleep_range(2000, 50000);
 	}
 
-	ret = m88ts2022_wr_reg(priv, 0x00, 0x03);
+	ret = m88ts2022_wr_reg(dev, 0x00, 0x03);
 	if (ret)
 		goto err;
 
 	usleep_range(2000, 50000);
 
-	ret = m88ts2022_rd_reg(priv, 0x00, &chip_id);
+	ret = m88ts2022_rd_reg(dev, 0x00, &chip_id);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->client->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+	dev_dbg(&dev->client->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
 	switch (chip_id) {
 	case 0xc3:
@@ -592,13 +592,13 @@ static int m88ts2022_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	switch (priv->cfg.clock_out) {
+	switch (dev->cfg.clock_out) {
 	case M88TS2022_CLOCK_OUT_DISABLED:
 		u8tmp = 0x60;
 		break;
 	case M88TS2022_CLOCK_OUT_ENABLED:
 		u8tmp = 0x70;
-		ret = m88ts2022_wr_reg(priv, 0x05, priv->cfg.clock_out_div);
+		ret = m88ts2022_wr_reg(dev, 0x05, dev->cfg.clock_out_div);
 		if (ret)
 			goto err;
 		break;
@@ -609,50 +609,50 @@ static int m88ts2022_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	ret = m88ts2022_wr_reg(priv, 0x42, u8tmp);
+	ret = m88ts2022_wr_reg(dev, 0x42, u8tmp);
 	if (ret)
 		goto err;
 
-	if (priv->cfg.loop_through)
+	if (dev->cfg.loop_through)
 		u8tmp = 0xec;
 	else
 		u8tmp = 0x6c;
 
-	ret = m88ts2022_wr_reg(priv, 0x62, u8tmp);
+	ret = m88ts2022_wr_reg(dev, 0x62, u8tmp);
 	if (ret)
 		goto err;
 
 	/* sleep */
-	ret = m88ts2022_wr_reg(priv, 0x00, 0x00);
+	ret = m88ts2022_wr_reg(dev, 0x00, 0x00);
 	if (ret)
 		goto err;
 
-	dev_info(&priv->client->dev,
+	dev_info(&dev->client->dev,
 			"%s: Montage M88TS2022 successfully identified\n",
 			KBUILD_MODNAME);
 
-	fe->tuner_priv = priv;
+	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &m88ts2022_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
 
-	i2c_set_clientdata(client, priv);
+	i2c_set_clientdata(client, dev);
 	return 0;
 err:
 	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
+	kfree(dev);
 	return ret;
 }
 
 static int m88ts2022_remove(struct i2c_client *client)
 {
-	struct m88ts2022_priv *priv = i2c_get_clientdata(client);
-	struct dvb_frontend *fe = priv->cfg.fe;
+	struct m88ts2022_dev *dev = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = dev->cfg.fe;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-	kfree(priv);
+	kfree(dev);
 
 	return 0;
 }
diff --git a/drivers/media/tuners/m88ts2022_priv.h b/drivers/media/tuners/m88ts2022_priv.h
index 0363dd8..e7f6c91 100644
--- a/drivers/media/tuners/m88ts2022_priv.h
+++ b/drivers/media/tuners/m88ts2022_priv.h
@@ -19,7 +19,7 @@
 
 #include "m88ts2022.h"
 
-struct m88ts2022_priv {
+struct m88ts2022_dev {
 	struct m88ts2022_config cfg;
 	struct i2c_client *client;
 	struct dvb_frontend *fe;
-- 
http://palosaari.fi/

