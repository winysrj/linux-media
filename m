Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34584 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/15] af9013: fix logging
Date: Thu, 15 Jun 2017 06:30:55 +0300
Message-Id: <20170615033105.13517-5-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can simplify logging as we now have a proper i2c client
to pass for kernel dev_* logging functions.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 202 +++++++++++++++++------------------
 1 file changed, 100 insertions(+), 102 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index dd7ac0a..781e958 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -51,14 +51,15 @@ struct af9013_state {
 };
 
 /* write multiple registers */
-static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
+static int af9013_wr_regs_i2c(struct af9013_state *state, u8 mbox, u16 reg,
 	const u8 *val, int len)
 {
+	struct i2c_client *client = state->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->client->addr,
+			.addr = state->client->addr,
 			.flags = 0,
 			.len = 3 + len,
 			.buf = buf,
@@ -66,9 +67,8 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	};
 
 	if (3 + len > sizeof(buf)) {
-		dev_warn(&priv->client->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg %04x, len %d, is too big!\n",
+			 reg, len);
 		return -EINVAL;
 	}
 
@@ -77,31 +77,32 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	buf[2] = mbox;
 	memcpy(&buf[3], val, len);
 
-	ret = i2c_transfer(priv->client->adapter, msg, 1);
+	ret = i2c_transfer(state->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev, "%s: i2c wr failed=%d reg=%04x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c wr failed %d, reg %04x, len %d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
 }
 
 /* read multiple registers */
-static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
+static int af9013_rd_regs_i2c(struct af9013_state *state, u8 mbox, u16 reg,
 	u8 *val, int len)
 {
+	struct i2c_client *client = state->client;
 	int ret;
 	u8 buf[3];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->client->addr,
+			.addr = state->client->addr,
 			.flags = 0,
 			.len = 3,
 			.buf = buf,
 		}, {
-			.addr = priv->client->addr,
+			.addr = state->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val,
@@ -112,31 +113,31 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = mbox;
 
-	ret = i2c_transfer(priv->client->adapter, msg, 2);
+	ret = i2c_transfer(state->client->adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->client->dev, "%s: i2c rd failed=%d reg=%04x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c rd failed %d, reg %04x, len %d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
 }
 
 /* write multiple registers */
-static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
+static int af9013_wr_regs(struct af9013_state *state, u16 reg, const u8 *val,
 	int len)
 {
 	int ret, i;
 	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);
 
-	if ((priv->ts_mode == AF9013_TS_USB) &&
+	if ((state->ts_mode == AF9013_TS_USB) &&
 		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
 		mbox |= ((len - 1) << 2);
-		ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
+		ret = af9013_wr_regs_i2c(state, mbox, reg, val, len);
 	} else {
 		for (i = 0; i < len; i++) {
-			ret = af9013_wr_regs_i2c(priv, mbox, reg+i, val+i, 1);
+			ret = af9013_wr_regs_i2c(state, mbox, reg+i, val+i, 1);
 			if (ret)
 				goto err;
 		}
@@ -147,18 +148,18 @@ static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
 }
 
 /* read multiple registers */
-static int af9013_rd_regs(struct af9013_state *priv, u16 reg, u8 *val, int len)
+static int af9013_rd_regs(struct af9013_state *state, u16 reg, u8 *val, int len)
 {
 	int ret, i;
 	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(0 << 0);
 
-	if ((priv->ts_mode == AF9013_TS_USB) &&
+	if ((state->ts_mode == AF9013_TS_USB) &&
 		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
 		mbox |= ((len - 1) << 2);
-		ret = af9013_rd_regs_i2c(priv, mbox, reg, val, len);
+		ret = af9013_rd_regs_i2c(state, mbox, reg, val, len);
 	} else {
 		for (i = 0; i < len; i++) {
-			ret = af9013_rd_regs_i2c(priv, mbox, reg+i, val+i, 1);
+			ret = af9013_rd_regs_i2c(state, mbox, reg+i, val+i, 1);
 			if (ret)
 				goto err;
 		}
@@ -169,15 +170,15 @@ static int af9013_rd_regs(struct af9013_state *priv, u16 reg, u8 *val, int len)
 }
 
 /* write single register */
-static int af9013_wr_reg(struct af9013_state *priv, u16 reg, u8 val)
+static int af9013_wr_reg(struct af9013_state *state, u16 reg, u8 val)
 {
-	return af9013_wr_regs(priv, reg, &val, 1);
+	return af9013_wr_regs(state, reg, &val, 1);
 }
 
 /* read single register */
-static int af9013_rd_reg(struct af9013_state *priv, u16 reg, u8 *val)
+static int af9013_rd_reg(struct af9013_state *state, u16 reg, u8 *val)
 {
-	return af9013_rd_regs(priv, reg, val, 1);
+	return af9013_rd_regs(state, reg, val, 1);
 }
 
 static int af9013_write_ofsm_regs(struct af9013_state *state, u16 reg, u8 *val,
@@ -226,12 +227,12 @@ static int af9013_rd_reg_bits(struct af9013_state *state, u16 reg, int pos,
 
 static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 {
+	struct i2c_client *client = state->client;
 	int ret;
 	u8 pos;
 	u16 addr;
 
-	dev_dbg(&state->client->dev, "%s: gpio=%d gpioval=%02x\n",
-			__func__, gpio, gpioval);
+	dev_dbg(&client->dev, "gpio %u, gpioval %02x\n", gpio, gpioval);
 
 	/*
 	 * GPIO0 & GPIO1 0xd735
@@ -249,8 +250,6 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 		break;
 
 	default:
-		dev_err(&state->client->dev, "%s: invalid gpio=%d\n",
-				KBUILD_MODNAME, gpio);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -273,16 +272,17 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 {
+	struct i2c_client *client = state->client;
 	int ret, i;
 	u8 tmp;
 
-	dev_dbg(&state->client->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&client->dev, "onoff %d\n", onoff);
 
 	/* enable reset */
 	ret = af9013_wr_reg_bits(state, 0xd417, 4, 1, 1);
@@ -327,16 +327,17 @@ static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret;
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* reset and start BER counter */
 	ret = af9013_wr_reg_bits(state, 0xd391, 4, 1, 1);
@@ -345,17 +346,18 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret;
 	u8 buf[5];
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* check if error bit count is ready */
 	ret = af9013_rd_reg_bits(state, 0xd391, 4, 1, &buf[0]);
@@ -363,7 +365,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 		goto err;
 
 	if (!buf[0]) {
-		dev_dbg(&state->client->dev, "%s: not ready\n", __func__);
+		dev_dbg(&client->dev, "not ready\n");
 		return 0;
 	}
 
@@ -376,16 +378,17 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret;
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* start SNR meas */
 	ret = af9013_wr_reg_bits(state, 0xd2e1, 3, 1, 1);
@@ -394,19 +397,20 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret, i, len;
 	u8 buf[3], tmp;
 	u32 snr_val;
 	const struct af9013_snr *uninitialized_var(snr_lut);
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* check if SNR ready */
 	ret = af9013_rd_reg_bits(state, 0xd2e1, 3, 1, &tmp);
@@ -414,7 +418,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 		goto err;
 
 	if (!tmp) {
-		dev_dbg(&state->client->dev, "%s: not ready\n", __func__);
+		dev_dbg(&client->dev, "not ready\n");
 		return 0;
 	}
 
@@ -457,18 +461,19 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret = 0;
 	u8 buf[2], rf_gain, if_gain;
 	int signal_strength;
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	if (!state->signal_strength_en)
 		return 0;
@@ -494,7 +499,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -558,14 +563,15 @@ static int af9013_get_tune_settings(struct dvb_frontend *fe,
 static int af9013_set_frontend(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, sampling_freq;
 	bool auto_mode, spec_inv;
 	u8 buf[6];
 	u32 if_frequency, freq_cw;
 
-	dev_dbg(&state->client->dev, "%s: frequency=%d bandwidth_hz=%d\n",
-			__func__, c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev, "frequency %u, bandwidth_hz %u\n",
+		c->frequency, c->bandwidth_hz);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -596,8 +602,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		else
 			if_frequency = state->if_frequency;
 
-		dev_dbg(&state->client->dev, "%s: if_frequency=%d\n",
-				__func__, if_frequency);
+		dev_dbg(&client->dev, "if_frequency %u\n", if_frequency);
 
 		sampling_freq = if_frequency;
 
@@ -670,8 +675,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (1 << 0);
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid transmission_mode\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid transmission_mode\n");
 		auto_mode = true;
 	}
 
@@ -691,8 +695,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (3 << 2);
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid guard_interval\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid guard_interval\n");
 		auto_mode = true;
 	}
 
@@ -712,7 +715,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (3 << 4);
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid hierarchy\n", __func__);
+		dev_dbg(&client->dev, "invalid hierarchy\n");
 		auto_mode = true;
 	}
 
@@ -729,7 +732,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[1] |= (2 << 6);
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid modulation\n", __func__);
+		dev_dbg(&client->dev, "invalid modulation\n");
 		auto_mode = true;
 	}
 
@@ -755,8 +758,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[2] |= (4 << 0);
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid code_rate_HP\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid code_rate_HP\n");
 		auto_mode = true;
 	}
 
@@ -781,8 +783,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	case FEC_NONE:
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid code_rate_LP\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid code_rate_LP\n");
 		auto_mode = true;
 	}
 
@@ -796,8 +797,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[1] |= (2 << 2);
 		break;
 	default:
-		dev_dbg(&state->client->dev, "%s: invalid bandwidth_hz\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid bandwidth_hz\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -812,7 +812,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&state->client->dev, "%s: auto params\n", __func__);
+		dev_dbg(&client->dev, "auto params\n");
 	} else {
 		/* set easy mode flag */
 		ret = af9013_wr_reg(state, 0xaefd, 1);
@@ -823,7 +823,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&state->client->dev, "%s: manual params\n", __func__);
+		dev_dbg(&client->dev, "manual params\n");
 	}
 
 	/* tune */
@@ -837,7 +837,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -845,10 +845,11 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 			       struct dtv_frontend_properties *c)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret;
 	u8 buf[3];
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	ret = af9013_rd_regs(state, 0xd3c0, buf, 3);
 	if (ret)
@@ -954,13 +955,14 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret;
 	u8 tmp;
 
@@ -1004,7 +1006,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -1039,12 +1041,13 @@ static int af9013_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int af9013_init(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret, i, len;
 	u8 buf[3], tmp;
 	u32 adc_cw;
 	const struct af9013_reg_bit *init;
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* power on */
 	ret = af9013_power_ctrl(state, 1);
@@ -1076,9 +1079,8 @@ static int af9013_init(struct dvb_frontend *fe)
 		tmp = 3;
 		break;
 	default:
-		dev_err(&state->client->dev, "%s: invalid clock\n",
-				KBUILD_MODNAME);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	adc_cw = div_u64((u64)state->clk * 0x80000, 1000000);
@@ -1136,7 +1138,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* load OFSM settings */
-	dev_dbg(&state->client->dev, "%s: load ofsm settings\n", __func__);
+	dev_dbg(&client->dev, "load ofsm settings\n");
 	len = ARRAY_SIZE(ofsm_init);
 	init = ofsm_init;
 	for (i = 0; i < len; i++) {
@@ -1147,8 +1149,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	dev_dbg(&state->client->dev, "%s: load tuner specific settings\n",
-			__func__);
+	dev_dbg(&client->dev, "load tuner specific settings\n");
 	switch (state->tuner) {
 	case AF9013_TUNER_MXL5003D:
 		len = ARRAY_SIZE(tuner_init_mxl5003d);
@@ -1259,16 +1260,17 @@ static int af9013_init(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9013_sleep(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 	int ret;
 
-	dev_dbg(&state->client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&state->statistics_work);
@@ -1285,7 +1287,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -1293,8 +1295,9 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	int ret;
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 
-	dev_dbg(&state->client->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&client->dev, "enable %d\n", enable);
 
 	/* gate already open or close */
 	if (state->i2c_gate_state == enable)
@@ -1311,7 +1314,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	return ret;
 err:
-	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -1320,6 +1323,8 @@ static void af9013_release(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 
+	dev_dbg(&client->dev, "\n");
+
 	i2c_unregister_device(client);
 }
 
@@ -1327,6 +1332,7 @@ static const struct dvb_frontend_ops af9013_ops;
 
 static int af9013_download_firmware(struct af9013_state *state)
 {
+	struct i2c_client *client = state->client;
 	int i, len, remaining, ret;
 	const struct firmware *fw;
 	u16 checksum = 0;
@@ -1340,28 +1346,24 @@ static int af9013_download_firmware(struct af9013_state *state)
 	if (ret)
 		goto err;
 	else
-		dev_dbg(&state->client->dev, "%s: firmware status=%02x\n",
-				__func__, val);
+		dev_dbg(&client->dev, "firmware status %02x\n", val);
 
 	if (val == 0x0c) /* fw is running, no need for download */
 		goto exit;
 
-	dev_info(&state->client->dev, "%s: found a '%s' in cold state, will try " \
-			"to load a firmware\n",
-			KBUILD_MODNAME, af9013_ops.info.name);
+	dev_info(&client->dev, "found a '%s' in cold state, will try to load a firmware\n",
+		 af9013_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &state->client->dev);
+	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
-		dev_info(&state->client->dev, "%s: did not find the firmware " \
-			"file. (%s) Please see linux/Documentation/dvb/ for " \
-			"more details on firmware-problems. (%d)\n",
-			KBUILD_MODNAME, fw_file, ret);
+		dev_info(&client->dev, "firmware file '%s' not found %d\n",
+			 fw_file, ret);
 		goto err;
 	}
 
-	dev_info(&state->client->dev, "%s: downloading firmware from file '%s'\n",
-			KBUILD_MODNAME, fw_file);
+	dev_info(&client->dev, "downloading firmware from file '%s'\n",
+		 fw_file);
 
 	/* calc checksum */
 	for (i = 0; i < fw->size; i++)
@@ -1389,9 +1391,8 @@ static int af9013_download_firmware(struct af9013_state *state)
 			FW_ADDR + fw->size - remaining,
 			(u8 *) &fw->data[fw->size - remaining], len);
 		if (ret) {
-			dev_err(&state->client->dev,
-					"%s: firmware download failed=%d\n",
-					KBUILD_MODNAME, ret);
+			dev_err(&client->dev, "firmware download failed %d\n",
+				ret);
 			goto err_release;
 		}
 	}
@@ -1409,20 +1410,17 @@ static int af9013_download_firmware(struct af9013_state *state)
 		if (ret)
 			goto err_release;
 
-		dev_dbg(&state->client->dev, "%s: firmware status=%02x\n",
-				__func__, val);
+		dev_dbg(&client->dev, "firmware status %02x\n", val);
 
 		if (val == 0x0c || val == 0x04) /* success or fail */
 			break;
 	}
 
 	if (val == 0x04) {
-		dev_err(&state->client->dev, "%s: firmware did not run\n",
-				KBUILD_MODNAME);
+		dev_err(&client->dev, "firmware did not run\n");
 		ret = -ENODEV;
 	} else if (val != 0x0c) {
-		dev_err(&state->client->dev, "%s: firmware boot timeout\n",
-				KBUILD_MODNAME);
+		dev_err(&client->dev, "firmware boot timeout\n");
 		ret = -ENODEV;
 	}
 
@@ -1431,8 +1429,8 @@ static int af9013_download_firmware(struct af9013_state *state)
 err:
 exit:
 	if (!ret)
-		dev_info(&state->client->dev, "%s: found a '%s' in warm state\n",
-				KBUILD_MODNAME, af9013_ops.info.name);
+		dev_info(&client->dev, "found a '%s' in warm state\n",
+			 af9013_ops.info.name);
 	return ret;
 }
 
-- 
http://palosaari.fi/
