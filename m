Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42920 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/21] fc2580: improve set params logic
Date: Wed,  6 May 2015 00:58:26 +0300
Message-Id: <1430863122-9888-5-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate PLL dividers slightly differently, most likely it is now
correct. Move some register values to innitab. Use jiffies to poll
filter lock. Fix logging.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c      | 179 +++++++++++++++++--------------------
 drivers/media/tuners/fc2580_priv.h |   8 +-
 2 files changed, 88 insertions(+), 99 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 48e4dae..9324855 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -33,11 +33,6 @@
  *   fc2580_wr_regs()
  *   fc2580_rd_regs()
  * could not be used for accessing more than one register at once.
- *
- * TODO:
- * Currently it blind writes bunch of static registers from the
- * fc2580_freq_regs_lut[] when fc2580_set_params() is called. Add some
- * logic to reduce unneeded register writes.
  */
 
 /* write multiple registers */
@@ -137,107 +132,110 @@ static int fc2580_wr_reg_ff(struct fc2580_priv *priv, u8 reg, u8 val)
 		return fc2580_wr_regs(priv, reg, &val, 1);
 }
 
+
 static int fc2580_set_params(struct dvb_frontend *fe)
 {
 	struct fc2580_priv *priv = fe->tuner_priv;
+	struct i2c_client *client = priv->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret = 0, i;
-	unsigned int r_val, n_val, k_val, k_val_reg, f_ref;
-	u8 tmp_val, r18_val;
+	int ret, i;
+	unsigned int uitmp, div_ref, div_ref_val, div_n, k, k_cw, div_out;
 	u64 f_vco;
+	u8 u8tmp, synth_config;
+	unsigned long timeout;
 
-	/*
-	 * Fractional-N synthesizer/PLL.
-	 * Most likely all those PLL calculations are not correct. I am not
-	 * sure, but it looks like it is divider based Fractional-N synthesizer.
-	 * There is divider for reference clock too?
-	 * Anyhow, synthesizer calculation results seems to be quite correct.
-	 */
-
-	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
-			"bandwidth_hz=%d\n", __func__,
-			c->delivery_system, c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev,
+		"delivery_system=%u frequency=%u bandwidth_hz=%u\n",
+		c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	/* PLL */
+	/*
+	 * Fractional-N synthesizer
+	 *
+	 *                      +---------------------------------------+
+	 *                      v                                       |
+	 *  Fref   +----+     +----+     +-------+         +----+     +------+     +---+
+	 * ------> | /R | --> | PD | --> |  VCO  | ------> | /2 | --> | /N.F | <-- | K |
+	 *         +----+     +----+     +-------+         +----+     +------+     +---+
+	 *                                 |
+	 *                                 |
+	 *                                 v
+	 *                               +-------+  Fout
+	 *                               | /Rout | ------>
+	 *                               +-------+
+	 */
 	for (i = 0; i < ARRAY_SIZE(fc2580_pll_lut); i++) {
 		if (c->frequency <= fc2580_pll_lut[i].freq)
 			break;
 	}
-
-	if (i == ARRAY_SIZE(fc2580_pll_lut))
+	if (i == ARRAY_SIZE(fc2580_pll_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
-	f_vco = c->frequency;
-	f_vco *= fc2580_pll_lut[i].div;
-
-	if (f_vco >= 2600000000UL)
-		tmp_val = 0x0e | fc2580_pll_lut[i].band;
+	#define DIV_PRE_N 2
+	#define F_REF priv->clk
+	div_out = fc2580_pll_lut[i].div_out;
+	f_vco = (u64) c->frequency * div_out;
+	synth_config = fc2580_pll_lut[i].band;
+	if (f_vco < 2600000000ULL)
+		synth_config |= 0x06;
 	else
-		tmp_val = 0x06 | fc2580_pll_lut[i].band;
-
-	ret = fc2580_wr_reg(priv, 0x02, tmp_val);
-	if (ret < 0)
-		goto err;
-
-	if (f_vco >= 2UL * 76 * priv->clk) {
-		r_val = 1;
-		r18_val = 0x00;
-	} else if (f_vco >= 1UL * 76 * priv->clk) {
-		r_val = 2;
-		r18_val = 0x10;
+		synth_config |= 0x0e;
+
+	/* select reference divider R (keep PLL div N in valid range) */
+	#define DIV_N_MIN 76
+	if (f_vco >= div_u64((u64) DIV_PRE_N * DIV_N_MIN * F_REF, 1)) {
+		div_ref = 1;
+		div_ref_val = 0x00;
+	} else if (f_vco >= div_u64((u64) DIV_PRE_N * DIV_N_MIN * F_REF, 2)) {
+		div_ref = 2;
+		div_ref_val = 0x10;
 	} else {
-		r_val = 4;
-		r18_val = 0x20;
+		div_ref = 4;
+		div_ref_val = 0x20;
 	}
 
-	f_ref = 2UL * priv->clk / r_val;
-	n_val = div_u64_rem(f_vco, f_ref, &k_val);
-	k_val_reg = div_u64(1ULL * k_val * (1 << 20), f_ref);
+	/* calculate PLL integer and fractional control word */
+	uitmp = DIV_PRE_N * F_REF / div_ref;
+	div_n = div_u64_rem(f_vco, uitmp, &k);
+	k_cw = div_u64((u64) k * 0x100000, uitmp);
 
-	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
+	dev_dbg(&client->dev,
+		"frequency=%u f_vco=%llu F_REF=%u div_ref=%u div_n=%u k=%u div_out=%u k_cw=%0x\n",
+		c->frequency, f_vco, F_REF, div_ref, div_n, k, div_out, k_cw);
+
+	ret = fc2580_wr_reg(priv, 0x02, synth_config);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x1a, (k_val_reg >> 8) & 0xff);
+	ret = fc2580_wr_reg(priv, 0x18, div_ref_val << 0 | k_cw >> 16);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x1b, (k_val_reg >> 0) & 0xff);
+	ret = fc2580_wr_reg(priv, 0x1a, (k_cw >> 8) & 0xff);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x1c, n_val);
+	ret = fc2580_wr_reg(priv, 0x1b, (k_cw >> 0) & 0xff);
 	if (ret < 0)
 		goto err;
 
-	if (priv->clk >= 28000000) {
-		ret = fc2580_wr_reg(priv, 0x4b, 0x22);
-		if (ret < 0)
-			goto err;
-	}
-
-	if (fc2580_pll_lut[i].band == 0x00) {
-		if (c->frequency <= 794000000)
-			tmp_val = 0x9f;
-		else
-			tmp_val = 0x8f;
-
-		ret = fc2580_wr_reg(priv, 0x2d, tmp_val);
-		if (ret < 0)
-			goto err;
-	}
+	ret = fc2580_wr_reg(priv, 0x1c, div_n);
+	if (ret < 0)
+		goto err;
 
 	/* registers */
 	for (i = 0; i < ARRAY_SIZE(fc2580_freq_regs_lut); i++) {
 		if (c->frequency <= fc2580_freq_regs_lut[i].freq)
 			break;
 	}
-
-	if (i == ARRAY_SIZE(fc2580_freq_regs_lut))
+	if (i == ARRAY_SIZE(fc2580_freq_regs_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	ret = fc2580_wr_reg_ff(priv, 0x25, fc2580_freq_regs_lut[i].r25_val);
 	if (ret < 0)
@@ -340,16 +338,18 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		if (c->bandwidth_hz <= fc2580_if_filter_lut[i].freq)
 			break;
 	}
-
-	if (i == ARRAY_SIZE(fc2580_if_filter_lut))
+	if (i == ARRAY_SIZE(fc2580_if_filter_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	ret = fc2580_wr_reg(priv, 0x36, fc2580_if_filter_lut[i].r36_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x37, div_u64(1ULL * priv->clk *
-			fc2580_if_filter_lut[i].mul, 1000000000));
+	u8tmp = div_u64((u64) priv->clk * fc2580_if_filter_lut[i].mul,
+			1000000000);
+	ret = fc2580_wr_reg(priv, 0x37, u8tmp);
 	if (ret < 0)
 		goto err;
 
@@ -357,36 +357,25 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	/* calibration? */
-	ret = fc2580_wr_reg(priv, 0x2e, 0x09);
-	if (ret < 0)
-		goto err;
-
-	for (i = 0; i < 5; i++) {
-		ret = fc2580_rd_reg(priv, 0x2f, &tmp_val);
-		if (ret < 0)
+	timeout = jiffies + msecs_to_jiffies(30);
+	for (uitmp = ~0xc0; !time_after(jiffies, timeout) && uitmp != 0xc0;) {
+		/* trigger filter */
+		ret = fc2580_wr_reg(priv, 0x2e, 0x09);
+		if (ret)
 			goto err;
 
-		/* done when [7:6] are set */
-		if ((tmp_val & 0xc0) == 0xc0)
-			break;
-
-		ret = fc2580_wr_reg(priv, 0x2e, 0x01);
-		if (ret < 0)
+		/* locked when [7:6] are set (val: d7 6MHz, d5 7MHz, cd 8MHz) */
+		ret = fc2580_rd_reg(priv, 0x2f, &u8tmp);
+		if (ret)
 			goto err;
+		uitmp = u8tmp & 0xc0;
 
-		ret = fc2580_wr_reg(priv, 0x2e, 0x09);
-		if (ret < 0)
+		ret = fc2580_wr_reg(priv, 0x2e, 0x01);
+		if (ret)
 			goto err;
-
-		usleep_range(5000, 25000);
 	}
-
-	dev_dbg(&priv->i2c->dev, "%s: loop=%i\n", __func__, i);
-
-	ret = fc2580_wr_reg(priv, 0x2e, 0x01);
-	if (ret < 0)
-		goto err;
+	if (uitmp != 0xc0)
+		dev_dbg(&client->dev, "filter did not lock %02x\n", uitmp);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -396,7 +385,7 @@ err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index a22ffc6..068531b 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -50,7 +50,7 @@ static const struct fc2580_reg_val fc2580_init_reg_vals[] = {
 
 struct fc2580_pll {
 	u32 freq;
-	u8 div;
+	u8 div_out;
 	u8 band;
 };
 
@@ -110,15 +110,15 @@ static const struct fc2580_freq_regs fc2580_freq_regs_lut[] = {
 		0x50, 0x0f, 0x07, 0x00, 0x15, 0x03, 0x05, 0x10, 0x12, 0x08,
 		0x0a, 0x78, 0x32, 0x54},
 	{ 538000000,
-		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0x9f, 0x09, 0xff, 0x8c,
 		0x50, 0x13, 0x07, 0x06, 0x15, 0x06, 0x08, 0x10, 0x12, 0x0b,
 		0x0c, 0x78, 0x32, 0x14},
 	{ 794000000,
-		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0x9f, 0x09, 0xff, 0x8c,
 		0x50, 0x15, 0x03, 0x03, 0x15, 0x03, 0x05, 0x0c, 0x0e, 0x0b,
 		0x0c, 0x78, 0x32, 0x14},
 	{1000000000,
-		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0x8f, 0x09, 0xff, 0x8c,
 		0x50, 0x15, 0x07, 0x06, 0x15, 0x07, 0x09, 0x10, 0x12, 0x0b,
 		0x0c, 0x78, 0x32, 0x14},
 	{0xffffffff,
-- 
http://palosaari.fi/

