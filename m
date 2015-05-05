Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43884 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/21] fc2580: cleanups and variable renames
Date: Wed,  6 May 2015 00:58:27 +0300
Message-Id: <1430863122-9888-6-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename driver state from priv to dev.
Remove legacy i2c-gate control.
Use I2C client for proper dev_() logging.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c      | 172 ++++++++++++++++---------------------
 drivers/media/tuners/fc2580_priv.h |   2 +-
 2 files changed, 76 insertions(+), 98 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 9324855..f4b31db5 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -36,13 +36,14 @@
  */
 
 /* write multiple registers */
-static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
+static int fc2580_wr_regs(struct fc2580_dev *dev, u8 reg, u8 *val, int len)
 {
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->i2c_addr,
+			.addr = dev->i2c_addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -50,7 +51,7 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&client->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -59,30 +60,31 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(dev->i2c, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&dev->i2c->dev, "%s: i2c wr failed=%d reg=%02x len=%d\n",
+			 KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
 }
 
 /* read multiple registers */
-static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
+static int fc2580_rd_regs(struct fc2580_dev *dev, u8 reg, u8 *val, int len)
 {
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->i2c_addr,
+			.addr = dev->i2c_addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->i2c_addr,
+			.addr = dev->i2c_addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -90,19 +92,19 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 	};
 
 	if (len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&client->dev,
 			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
 	}
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(dev->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "%s: i2c rd failed=%d reg=%02x len=%d\n",
+			 KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -110,33 +112,33 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 }
 
 /* write single register */
-static int fc2580_wr_reg(struct fc2580_priv *priv, u8 reg, u8 val)
+static int fc2580_wr_reg(struct fc2580_dev *dev, u8 reg, u8 val)
 {
-	return fc2580_wr_regs(priv, reg, &val, 1);
+	return fc2580_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register */
-static int fc2580_rd_reg(struct fc2580_priv *priv, u8 reg, u8 *val)
+static int fc2580_rd_reg(struct fc2580_dev *dev, u8 reg, u8 *val)
 {
-	return fc2580_rd_regs(priv, reg, val, 1);
+	return fc2580_rd_regs(dev, reg, val, 1);
 }
 
 /* write single register conditionally only when value differs from 0xff
  * XXX: This is special routine meant only for writing fc2580_freq_regs_lut[]
  * values. Do not use for the other purposes. */
-static int fc2580_wr_reg_ff(struct fc2580_priv *priv, u8 reg, u8 val)
+static int fc2580_wr_reg_ff(struct fc2580_dev *dev, u8 reg, u8 val)
 {
 	if (val == 0xff)
 		return 0;
 	else
-		return fc2580_wr_regs(priv, reg, &val, 1);
+		return fc2580_wr_regs(dev, reg, &val, 1);
 }
 
 
 static int fc2580_set_params(struct dvb_frontend *fe)
 {
-	struct fc2580_priv *priv = fe->tuner_priv;
-	struct i2c_client *client = priv->client;
+	struct fc2580_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	unsigned int uitmp, div_ref, div_ref_val, div_n, k, k_cw, div_out;
@@ -148,9 +150,6 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		"delivery_system=%u frequency=%u bandwidth_hz=%u\n",
 		c->delivery_system, c->frequency, c->bandwidth_hz);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	/*
 	 * Fractional-N synthesizer
 	 *
@@ -176,7 +175,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	}
 
 	#define DIV_PRE_N 2
-	#define F_REF priv->clk
+	#define F_REF dev->clk
 	div_out = fc2580_pll_lut[i].div_out;
 	f_vco = (u64) c->frequency * div_out;
 	synth_config = fc2580_pll_lut[i].band;
@@ -207,23 +206,23 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		"frequency=%u f_vco=%llu F_REF=%u div_ref=%u div_n=%u k=%u div_out=%u k_cw=%0x\n",
 		c->frequency, f_vco, F_REF, div_ref, div_n, k, div_out, k_cw);
 
-	ret = fc2580_wr_reg(priv, 0x02, synth_config);
+	ret = fc2580_wr_reg(dev, 0x02, synth_config);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x18, div_ref_val << 0 | k_cw >> 16);
+	ret = fc2580_wr_reg(dev, 0x18, div_ref_val << 0 | k_cw >> 16);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x1a, (k_cw >> 8) & 0xff);
+	ret = fc2580_wr_reg(dev, 0x1a, (k_cw >> 8) & 0xff);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x1b, (k_cw >> 0) & 0xff);
+	ret = fc2580_wr_reg(dev, 0x1b, (k_cw >> 0) & 0xff);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x1c, div_n);
+	ret = fc2580_wr_reg(dev, 0x1c, div_n);
 	if (ret < 0)
 		goto err;
 
@@ -237,99 +236,99 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = fc2580_wr_reg_ff(priv, 0x25, fc2580_freq_regs_lut[i].r25_val);
+	ret = fc2580_wr_reg_ff(dev, 0x25, fc2580_freq_regs_lut[i].r25_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x27, fc2580_freq_regs_lut[i].r27_val);
+	ret = fc2580_wr_reg_ff(dev, 0x27, fc2580_freq_regs_lut[i].r27_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x28, fc2580_freq_regs_lut[i].r28_val);
+	ret = fc2580_wr_reg_ff(dev, 0x28, fc2580_freq_regs_lut[i].r28_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x29, fc2580_freq_regs_lut[i].r29_val);
+	ret = fc2580_wr_reg_ff(dev, 0x29, fc2580_freq_regs_lut[i].r29_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x2b, fc2580_freq_regs_lut[i].r2b_val);
+	ret = fc2580_wr_reg_ff(dev, 0x2b, fc2580_freq_regs_lut[i].r2b_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x2c, fc2580_freq_regs_lut[i].r2c_val);
+	ret = fc2580_wr_reg_ff(dev, 0x2c, fc2580_freq_regs_lut[i].r2c_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x2d, fc2580_freq_regs_lut[i].r2d_val);
+	ret = fc2580_wr_reg_ff(dev, 0x2d, fc2580_freq_regs_lut[i].r2d_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x30, fc2580_freq_regs_lut[i].r30_val);
+	ret = fc2580_wr_reg_ff(dev, 0x30, fc2580_freq_regs_lut[i].r30_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x44, fc2580_freq_regs_lut[i].r44_val);
+	ret = fc2580_wr_reg_ff(dev, 0x44, fc2580_freq_regs_lut[i].r44_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x50, fc2580_freq_regs_lut[i].r50_val);
+	ret = fc2580_wr_reg_ff(dev, 0x50, fc2580_freq_regs_lut[i].r50_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x53, fc2580_freq_regs_lut[i].r53_val);
+	ret = fc2580_wr_reg_ff(dev, 0x53, fc2580_freq_regs_lut[i].r53_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x5f, fc2580_freq_regs_lut[i].r5f_val);
+	ret = fc2580_wr_reg_ff(dev, 0x5f, fc2580_freq_regs_lut[i].r5f_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x61, fc2580_freq_regs_lut[i].r61_val);
+	ret = fc2580_wr_reg_ff(dev, 0x61, fc2580_freq_regs_lut[i].r61_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x62, fc2580_freq_regs_lut[i].r62_val);
+	ret = fc2580_wr_reg_ff(dev, 0x62, fc2580_freq_regs_lut[i].r62_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x63, fc2580_freq_regs_lut[i].r63_val);
+	ret = fc2580_wr_reg_ff(dev, 0x63, fc2580_freq_regs_lut[i].r63_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x67, fc2580_freq_regs_lut[i].r67_val);
+	ret = fc2580_wr_reg_ff(dev, 0x67, fc2580_freq_regs_lut[i].r67_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x68, fc2580_freq_regs_lut[i].r68_val);
+	ret = fc2580_wr_reg_ff(dev, 0x68, fc2580_freq_regs_lut[i].r68_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x69, fc2580_freq_regs_lut[i].r69_val);
+	ret = fc2580_wr_reg_ff(dev, 0x69, fc2580_freq_regs_lut[i].r69_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x6a, fc2580_freq_regs_lut[i].r6a_val);
+	ret = fc2580_wr_reg_ff(dev, 0x6a, fc2580_freq_regs_lut[i].r6a_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x6b, fc2580_freq_regs_lut[i].r6b_val);
+	ret = fc2580_wr_reg_ff(dev, 0x6b, fc2580_freq_regs_lut[i].r6b_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x6c, fc2580_freq_regs_lut[i].r6c_val);
+	ret = fc2580_wr_reg_ff(dev, 0x6c, fc2580_freq_regs_lut[i].r6c_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x6d, fc2580_freq_regs_lut[i].r6d_val);
+	ret = fc2580_wr_reg_ff(dev, 0x6d, fc2580_freq_regs_lut[i].r6d_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x6e, fc2580_freq_regs_lut[i].r6e_val);
+	ret = fc2580_wr_reg_ff(dev, 0x6e, fc2580_freq_regs_lut[i].r6e_val);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg_ff(priv, 0x6f, fc2580_freq_regs_lut[i].r6f_val);
+	ret = fc2580_wr_reg_ff(dev, 0x6f, fc2580_freq_regs_lut[i].r6f_val);
 	if (ret < 0)
 		goto err;
 
@@ -343,112 +342,91 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = fc2580_wr_reg(priv, 0x36, fc2580_if_filter_lut[i].r36_val);
+	ret = fc2580_wr_reg(dev, 0x36, fc2580_if_filter_lut[i].r36_val);
 	if (ret < 0)
 		goto err;
 
-	u8tmp = div_u64((u64) priv->clk * fc2580_if_filter_lut[i].mul,
+	u8tmp = div_u64((u64) dev->clk * fc2580_if_filter_lut[i].mul,
 			1000000000);
-	ret = fc2580_wr_reg(priv, 0x37, u8tmp);
+	ret = fc2580_wr_reg(dev, 0x37, u8tmp);
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x39, fc2580_if_filter_lut[i].r39_val);
+	ret = fc2580_wr_reg(dev, 0x39, fc2580_if_filter_lut[i].r39_val);
 	if (ret < 0)
 		goto err;
 
 	timeout = jiffies + msecs_to_jiffies(30);
 	for (uitmp = ~0xc0; !time_after(jiffies, timeout) && uitmp != 0xc0;) {
 		/* trigger filter */
-		ret = fc2580_wr_reg(priv, 0x2e, 0x09);
+		ret = fc2580_wr_reg(dev, 0x2e, 0x09);
 		if (ret)
 			goto err;
 
 		/* locked when [7:6] are set (val: d7 6MHz, d5 7MHz, cd 8MHz) */
-		ret = fc2580_rd_reg(priv, 0x2f, &u8tmp);
+		ret = fc2580_rd_reg(dev, 0x2f, &u8tmp);
 		if (ret)
 			goto err;
 		uitmp = u8tmp & 0xc0;
 
-		ret = fc2580_wr_reg(priv, 0x2e, 0x01);
+		ret = fc2580_wr_reg(dev, 0x2e, 0x01);
 		if (ret)
 			goto err;
 	}
 	if (uitmp != 0xc0)
 		dev_dbg(&client->dev, "filter did not lock %02x\n", uitmp);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int fc2580_init(struct dvb_frontend *fe)
 {
-	struct fc2580_priv *priv = fe->tuner_priv;
+	struct fc2580_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret, i;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	dev_dbg(&client->dev, "\n");
 
 	for (i = 0; i < ARRAY_SIZE(fc2580_init_reg_vals); i++) {
-		ret = fc2580_wr_reg(priv, fc2580_init_reg_vals[i].reg,
+		ret = fc2580_wr_reg(dev, fc2580_init_reg_vals[i].reg,
 				fc2580_init_reg_vals[i].val);
 		if (ret < 0)
 			goto err;
 	}
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int fc2580_sleep(struct dvb_frontend *fe)
 {
-	struct fc2580_priv *priv = fe->tuner_priv;
+	struct fc2580_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	dev_dbg(&client->dev, "\n");
 
-	ret = fc2580_wr_reg(priv, 0x02, 0x0a);
+	ret = fc2580_wr_reg(dev, 0x02, 0x0a);
 	if (ret < 0)
 		goto err;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	return 0;
 err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int fc2580_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct fc2580_priv *priv = fe->tuner_priv;
+	struct fc2580_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = dev->client;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	*frequency = 0; /* Zero-IF */
 
@@ -472,7 +450,7 @@ static const struct dvb_tuner_ops fc2580_tuner_ops = {
 static int fc2580_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct fc2580_priv *dev;
+	struct fc2580_dev *dev;
 	struct fc2580_platform_data *pdata = client->dev.platform_data;
 	struct dvb_frontend *fe = pdata->dvb_frontend;
 	int ret;
@@ -523,7 +501,7 @@ err:
 
 static int fc2580_remove(struct i2c_client *client)
 {
-	struct fc2580_priv *dev = i2c_get_clientdata(client);
+	struct fc2580_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index 068531b..16245ee 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -127,7 +127,7 @@ static const struct fc2580_freq_regs fc2580_freq_regs_lut[] = {
 		0x0a, 0xa0, 0x50, 0x14},
 };
 
-struct fc2580_priv {
+struct fc2580_dev {
 	u32 clk;
 	struct i2c_client *client;
 	struct i2c_adapter *i2c;
-- 
http://palosaari.fi/

