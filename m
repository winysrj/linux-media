Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57192 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751739AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/15] af9013: add i2c client bindings
Date: Thu, 15 Jun 2017 06:30:53 +0300
Message-Id: <20170615033105.13517-3-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add kernel i2c driver bindings.
That allows dev_* logging, regmap and more.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 321 ++++++++++++++++++++++-------------
 drivers/media/dvb-frontends/af9013.h |  84 +++++----
 2 files changed, 241 insertions(+), 164 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 7880a63..f644182 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -24,9 +24,8 @@
 #define MAX_XFER_SIZE  64
 
 struct af9013_state {
-	struct i2c_adapter *i2c;
+	struct i2c_client *client;
 	struct dvb_frontend fe;
-	u8 i2c_addr;
 	u32 clk;
 	u8 tuner;
 	u32 if_frequency;
@@ -59,7 +58,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 3 + len,
 			.buf = buf,
@@ -67,7 +66,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	};
 
 	if (3 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&priv->client->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -78,11 +77,11 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	buf[2] = mbox;
 	memcpy(&buf[3], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(priv->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%04x " \
+		dev_warn(&priv->client->dev, "%s: i2c wr failed=%d reg=%04x " \
 				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
@@ -97,12 +96,12 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	u8 buf[3];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = 0,
 			.len = 3,
 			.buf = buf,
 		}, {
-			.addr = priv->i2c_addr,
+			.addr = priv->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val,
@@ -113,11 +112,11 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = mbox;
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(priv->client->adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%04x " \
+		dev_warn(&priv->client->dev, "%s: i2c rd failed=%d reg=%04x " \
 				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
@@ -231,7 +230,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	u8 pos;
 	u16 addr;
 
-	dev_dbg(&state->i2c->dev, "%s: gpio=%d gpioval=%02x\n",
+	dev_dbg(&state->client->dev, "%s: gpio=%d gpioval=%02x\n",
 			__func__, gpio, gpioval);
 
 	/*
@@ -250,7 +249,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 		break;
 
 	default:
-		dev_err(&state->i2c->dev, "%s: invalid gpio=%d\n",
+		dev_err(&state->client->dev, "%s: invalid gpio=%d\n",
 				KBUILD_MODNAME, gpio);
 		ret = -EINVAL;
 		goto err;
@@ -274,7 +273,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -282,7 +281,7 @@ static u32 af9013_div(struct af9013_state *state, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
 
-	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
+	dev_dbg(&state->client->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
 
 	if (a > b) {
 		c = a / b;
@@ -299,7 +298,7 @@ static u32 af9013_div(struct af9013_state *state, u32 a, u32 b, u32 x)
 	}
 	r = (c << (u32)x) + r;
 
-	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
+	dev_dbg(&state->client->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
 			__func__, a, b, x, r, r);
 
 	return r;
@@ -310,7 +309,7 @@ static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 	int ret, i;
 	u8 tmp;
 
-	dev_dbg(&state->i2c->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&state->client->dev, "%s: onoff=%d\n", __func__, onoff);
 
 	/* enable reset */
 	ret = af9013_wr_reg_bits(state, 0xd417, 4, 1, 1);
@@ -355,7 +354,7 @@ static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -364,7 +363,7 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	/* reset and start BER counter */
 	ret = af9013_wr_reg_bits(state, 0xd391, 4, 1, 1);
@@ -373,7 +372,7 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -383,7 +382,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[5];
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	/* check if error bit count is ready */
 	ret = af9013_rd_reg_bits(state, 0xd391, 4, 1, &buf[0]);
@@ -391,7 +390,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 		goto err;
 
 	if (!buf[0]) {
-		dev_dbg(&state->i2c->dev, "%s: not ready\n", __func__);
+		dev_dbg(&state->client->dev, "%s: not ready\n", __func__);
 		return 0;
 	}
 
@@ -404,7 +403,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -413,7 +412,7 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	/* start SNR meas */
 	ret = af9013_wr_reg_bits(state, 0xd2e1, 3, 1, 1);
@@ -422,7 +421,7 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -434,7 +433,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	u32 snr_val;
 	const struct af9013_snr *uninitialized_var(snr_lut);
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	/* check if SNR ready */
 	ret = af9013_rd_reg_bits(state, 0xd2e1, 3, 1, &tmp);
@@ -442,7 +441,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 		goto err;
 
 	if (!tmp) {
-		dev_dbg(&state->i2c->dev, "%s: not ready\n", __func__);
+		dev_dbg(&state->client->dev, "%s: not ready\n", __func__);
 		return 0;
 	}
 
@@ -485,7 +484,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -496,7 +495,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 	u8 buf[2], rf_gain, if_gain;
 	int signal_strength;
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	if (!state->signal_strength_en)
 		return 0;
@@ -522,7 +521,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -592,7 +591,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	u8 buf[6];
 	u32 if_frequency, freq_cw;
 
-	dev_dbg(&state->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
+	dev_dbg(&state->client->dev, "%s: frequency=%d bandwidth_hz=%d\n",
 			__func__, c->frequency, c->bandwidth_hz);
 
 	/* program tuner */
@@ -624,7 +623,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		else
 			if_frequency = state->if_frequency;
 
-		dev_dbg(&state->i2c->dev, "%s: if_frequency=%d\n",
+		dev_dbg(&state->client->dev, "%s: if_frequency=%d\n",
 				__func__, if_frequency);
 
 		sampling_freq = if_frequency;
@@ -698,7 +697,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (1 << 0);
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid transmission_mode\n",
+		dev_dbg(&state->client->dev, "%s: invalid transmission_mode\n",
 				__func__);
 		auto_mode = true;
 	}
@@ -719,7 +718,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (3 << 2);
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid guard_interval\n",
+		dev_dbg(&state->client->dev, "%s: invalid guard_interval\n",
 				__func__);
 		auto_mode = true;
 	}
@@ -740,7 +739,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (3 << 4);
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid hierarchy\n", __func__);
+		dev_dbg(&state->client->dev, "%s: invalid hierarchy\n", __func__);
 		auto_mode = true;
 	}
 
@@ -757,7 +756,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[1] |= (2 << 6);
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid modulation\n", __func__);
+		dev_dbg(&state->client->dev, "%s: invalid modulation\n", __func__);
 		auto_mode = true;
 	}
 
@@ -783,7 +782,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[2] |= (4 << 0);
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid code_rate_HP\n",
+		dev_dbg(&state->client->dev, "%s: invalid code_rate_HP\n",
 				__func__);
 		auto_mode = true;
 	}
@@ -809,7 +808,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	case FEC_NONE:
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid code_rate_LP\n",
+		dev_dbg(&state->client->dev, "%s: invalid code_rate_LP\n",
 				__func__);
 		auto_mode = true;
 	}
@@ -824,7 +823,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[1] |= (2 << 2);
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid bandwidth_hz\n",
+		dev_dbg(&state->client->dev, "%s: invalid bandwidth_hz\n",
 				__func__);
 		ret = -EINVAL;
 		goto err;
@@ -840,7 +839,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&state->i2c->dev, "%s: auto params\n", __func__);
+		dev_dbg(&state->client->dev, "%s: auto params\n", __func__);
 	} else {
 		/* set easy mode flag */
 		ret = af9013_wr_reg(state, 0xaefd, 1);
@@ -851,7 +850,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&state->i2c->dev, "%s: manual params\n", __func__);
+		dev_dbg(&state->client->dev, "%s: manual params\n", __func__);
 	}
 
 	/* tune */
@@ -865,7 +864,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -876,7 +875,7 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 	int ret;
 	u8 buf[3];
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	ret = af9013_rd_regs(state, 0xd3c0, buf, 3);
 	if (ret)
@@ -982,7 +981,7 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1032,7 +1031,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1072,7 +1071,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	u32 adc_cw;
 	const struct af9013_reg_bit *init;
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	/* power on */
 	ret = af9013_power_ctrl(state, 1);
@@ -1104,7 +1103,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		tmp = 3;
 		break;
 	default:
-		dev_err(&state->i2c->dev, "%s: invalid clock\n",
+		dev_err(&state->client->dev, "%s: invalid clock\n",
 				KBUILD_MODNAME);
 		return -EINVAL;
 	}
@@ -1165,7 +1164,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* load OFSM settings */
-	dev_dbg(&state->i2c->dev, "%s: load ofsm settings\n", __func__);
+	dev_dbg(&state->client->dev, "%s: load ofsm settings\n", __func__);
 	len = ARRAY_SIZE(ofsm_init);
 	init = ofsm_init;
 	for (i = 0; i < len; i++) {
@@ -1176,7 +1175,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	dev_dbg(&state->i2c->dev, "%s: load tuner specific settings\n",
+	dev_dbg(&state->client->dev, "%s: load tuner specific settings\n",
 			__func__);
 	switch (state->tuner) {
 	case AF9013_TUNER_MXL5003D:
@@ -1288,7 +1287,7 @@ static int af9013_init(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1297,7 +1296,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&state->client->dev, "%s:\n", __func__);
 
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&state->statistics_work);
@@ -1314,7 +1313,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1323,7 +1322,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int ret;
 	struct af9013_state *state = fe->demodulator_priv;
 
-	dev_dbg(&state->i2c->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&state->client->dev, "%s: enable=%d\n", __func__, enable);
 
 	/* gate already open or close */
 	if (state->i2c_gate_state == enable)
@@ -1340,18 +1339,16 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	return ret;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static void af9013_release(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&state->statistics_work);
-
-	kfree(state);
+	i2c_unregister_device(client);
 }
 
 static const struct dvb_frontend_ops af9013_ops;
@@ -1371,27 +1368,27 @@ static int af9013_download_firmware(struct af9013_state *state)
 	if (ret)
 		goto err;
 	else
-		dev_dbg(&state->i2c->dev, "%s: firmware status=%02x\n",
+		dev_dbg(&state->client->dev, "%s: firmware status=%02x\n",
 				__func__, val);
 
 	if (val == 0x0c) /* fw is running, no need for download */
 		goto exit;
 
-	dev_info(&state->i2c->dev, "%s: found a '%s' in cold state, will try " \
+	dev_info(&state->client->dev, "%s: found a '%s' in cold state, will try " \
 			"to load a firmware\n",
 			KBUILD_MODNAME, af9013_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
+	ret = request_firmware(&fw, fw_file, &state->client->dev);
 	if (ret) {
-		dev_info(&state->i2c->dev, "%s: did not find the firmware " \
+		dev_info(&state->client->dev, "%s: did not find the firmware " \
 			"file. (%s) Please see linux/Documentation/dvb/ for " \
 			"more details on firmware-problems. (%d)\n",
 			KBUILD_MODNAME, fw_file, ret);
 		goto err;
 	}
 
-	dev_info(&state->i2c->dev, "%s: downloading firmware from file '%s'\n",
+	dev_info(&state->client->dev, "%s: downloading firmware from file '%s'\n",
 			KBUILD_MODNAME, fw_file);
 
 	/* calc checksum */
@@ -1420,7 +1417,7 @@ static int af9013_download_firmware(struct af9013_state *state)
 			FW_ADDR + fw->size - remaining,
 			(u8 *) &fw->data[fw->size - remaining], len);
 		if (ret) {
-			dev_err(&state->i2c->dev,
+			dev_err(&state->client->dev,
 					"%s: firmware download failed=%d\n",
 					KBUILD_MODNAME, ret);
 			goto err_release;
@@ -1440,7 +1437,7 @@ static int af9013_download_firmware(struct af9013_state *state)
 		if (ret)
 			goto err_release;
 
-		dev_dbg(&state->i2c->dev, "%s: firmware status=%02x\n",
+		dev_dbg(&state->client->dev, "%s: firmware status=%02x\n",
 				__func__, val);
 
 		if (val == 0x0c || val == 0x04) /* success or fail */
@@ -1448,11 +1445,11 @@ static int af9013_download_firmware(struct af9013_state *state)
 	}
 
 	if (val == 0x04) {
-		dev_err(&state->i2c->dev, "%s: firmware did not run\n",
+		dev_err(&state->client->dev, "%s: firmware did not run\n",
 				KBUILD_MODNAME);
 		ret = -ENODEV;
 	} else if (val != 0x0c) {
-		dev_err(&state->i2c->dev, "%s: firmware boot timeout\n",
+		dev_err(&state->client->dev, "%s: firmware boot timeout\n",
 				KBUILD_MODNAME);
 		ret = -ENODEV;
 	}
@@ -1462,67 +1459,41 @@ static int af9013_download_firmware(struct af9013_state *state)
 err:
 exit:
 	if (!ret)
-		dev_info(&state->i2c->dev, "%s: found a '%s' in warm state\n",
+		dev_info(&state->client->dev, "%s: found a '%s' in warm state\n",
 				KBUILD_MODNAME, af9013_ops.info.name);
 	return ret;
 }
 
+/*
+ * XXX: That is wrapper to af9013_probe() via driver core in order to provide
+ * proper I2C client for legacy media attach binding.
+ * New users must use I2C client binding directly!
+ */
 struct dvb_frontend *af9013_attach(const struct af9013_config *config,
-	struct i2c_adapter *i2c)
+				   struct i2c_adapter *i2c)
 {
-	int ret;
-	struct af9013_state *state = NULL;
-	u8 buf[4], i;
-
-	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct af9013_state), GFP_KERNEL);
-	if (state == NULL)
-		goto err;
-
-	/* setup the state */
-	state->i2c = i2c;
-	state->i2c_addr = config->i2c_addr;
-	state->clk = config->clock;
-	state->tuner = config->tuner;
-	state->if_frequency = config->if_frequency;
-	state->ts_mode = config->ts_mode;
-	state->spec_inv = config->spec_inv;
-	memcpy(&state->api_version, config->api_version, sizeof(state->api_version));
-	memcpy(&state->gpio, config->gpio, sizeof(state->gpio));
-
-	/* download firmware */
-	if (state->ts_mode != AF9013_TS_USB) {
-		ret = af9013_download_firmware(state);
-		if (ret)
-			goto err;
-	}
-
-	/* firmware version */
-	ret = af9013_rd_regs(state, 0x5103, buf, 4);
-	if (ret)
-		goto err;
-
-	dev_info(&state->i2c->dev, "%s: firmware version %d.%d.%d.%d\n",
-			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3]);
-
-	/* set GPIOs */
-	for (i = 0; i < sizeof(state->gpio); i++) {
-		ret = af9013_set_gpio(state, i, state->gpio[i]);
-		if (ret)
-			goto err;
-	}
-
-	/* create dvb_frontend */
-	memcpy(&state->fe.ops, &af9013_ops,
-		sizeof(struct dvb_frontend_ops));
-	state->fe.demodulator_priv = state;
-
-	INIT_DELAYED_WORK(&state->statistics_work, af9013_statistics_work);
-
-	return &state->fe;
-err:
-	kfree(state);
-	return NULL;
+	struct i2c_client *client;
+	struct i2c_board_info board_info;
+	struct af9013_platform_data pdata;
+
+	pdata.clk = config->clock;
+	pdata.tuner = config->tuner;
+	pdata.if_frequency = config->if_frequency;
+	pdata.ts_mode = config->ts_mode;
+	pdata.spec_inv = config->spec_inv;
+	memcpy(&pdata.api_version, config->api_version, sizeof(pdata.api_version));
+	memcpy(&pdata.gpio, config->gpio, sizeof(pdata.gpio));
+	pdata.attach_in_use = true;
+
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "af9013", sizeof(board_info.type));
+	board_info.addr = config->i2c_addr;
+	board_info.platform_data = &pdata;
+	client = i2c_new_device(i2c, &board_info);
+	if (!client || !client->dev.driver)
+		return NULL;
+
+	return pdata.get_dvb_frontend(client);
 }
 EXPORT_SYMBOL(af9013_attach);
 
@@ -1569,6 +1540,114 @@ static const struct dvb_frontend_ops af9013_ops = {
 	.i2c_gate_ctrl = af9013_i2c_gate_ctrl,
 };
 
+static struct dvb_frontend *af9013_get_dvb_frontend(struct i2c_client *client)
+{
+	struct af9013_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return &state->fe;
+}
+
+static int af9013_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct af9013_state *state;
+	struct af9013_platform_data *pdata = client->dev.platform_data;
+	int ret, i;
+	u8 firmware_version[4];
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Setup the state */
+	state->client = client;
+	i2c_set_clientdata(client, state);
+	state->clk = pdata->clk;
+	state->tuner = pdata->tuner;
+	state->if_frequency = pdata->if_frequency;
+	state->ts_mode = pdata->ts_mode;
+	state->spec_inv = pdata->spec_inv;
+	memcpy(&state->api_version, pdata->api_version, sizeof(state->api_version));
+	memcpy(&state->gpio, pdata->gpio, sizeof(state->gpio));
+	INIT_DELAYED_WORK(&state->statistics_work, af9013_statistics_work);
+
+	/* Download firmware */
+	if (state->ts_mode != AF9013_TS_USB) {
+		ret = af9013_download_firmware(state);
+		if (ret)
+			goto err_kfree;
+	}
+
+	/* Firmware version */
+	ret = af9013_rd_regs(state, 0x5103, firmware_version,
+			     sizeof(firmware_version));
+	if (ret)
+		goto err_kfree;
+
+	/* Set GPIOs */
+	for (i = 0; i < sizeof(state->gpio); i++) {
+		ret = af9013_set_gpio(state, i, state->gpio[i]);
+		if (ret)
+			goto err_kfree;
+	}
+
+	/* Create dvb frontend */
+	memcpy(&state->fe.ops, &af9013_ops, sizeof(state->fe.ops));
+	if (!pdata->attach_in_use)
+		state->fe.ops.release = NULL;
+	state->fe.demodulator_priv = state;
+
+	/* Setup callbacks */
+	pdata->get_dvb_frontend = af9013_get_dvb_frontend;
+
+	dev_info(&client->dev, "Afatech AF9013 successfully attached\n");
+	dev_info(&client->dev, "firmware version: %d.%d.%d.%d\n",
+		 firmware_version[0], firmware_version[1],
+		 firmware_version[2], firmware_version[3]);
+	return 0;
+err_kfree:
+	kfree(state);
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9013_remove(struct i2c_client *client)
+{
+	struct af9013_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	/* Stop statistics polling */
+	cancel_delayed_work_sync(&state->statistics_work);
+
+	kfree(state);
+
+	return 0;
+}
+
+static const struct i2c_device_id af9013_id_table[] = {
+	{"af9013", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, af9013_id_table);
+
+static struct i2c_driver af9013_driver = {
+	.driver = {
+		.name	= "af9013",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= af9013_probe,
+	.remove		= af9013_remove,
+	.id_table	= af9013_id_table,
+};
+
+module_i2c_driver(af9013_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9013 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index 2771128..3f18258 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -23,29 +23,26 @@
 
 #include <linux/dvb/frontend.h>
 
-/* AF9013/5 GPIOs (mostly guessed)
-   demod#1-gpio#0 - set demod#2 i2c-addr for dual devices
-   demod#1-gpio#1 - xtal setting (?)
-   demod#1-gpio#3 - tuner#1
-   demod#2-gpio#0 - tuner#2
-   demod#2-gpio#1 - xtal setting (?)
-*/
-
-struct af9013_config {
-	/*
-	 * I2C address
-	 */
-	u8 i2c_addr;
+/*
+ * I2C address: 0x1c, 0x1d
+ */
 
+/**
+ * struct af9013_platform_data - Platform data for the af9013 driver
+ * @clk: Clock frequency.
+ * @tuner: Used tuner model.
+ * @if_frequency: IF frequency.
+ * @ts_mode: TS mode.
+ * @spec_inv: Input spectrum inverted.
+ * @api_version: Firmware API version.
+ * @gpio: GPIOs.
+ * @get_dvb_frontend: Get DVB frontend callback.
+ */
+struct af9013_platform_data {
 	/*
-	 * clock
 	 * 20480000, 25000000, 28000000, 28800000
 	 */
-	u32 clock;
-
-	/*
-	 * tuner
-	 */
+	u32 clk;
 #define AF9013_TUNER_MXL5003D      3 /* MaxLinear */
 #define AF9013_TUNER_MXL5005D     13 /* MaxLinear */
 #define AF9013_TUNER_MXL5005R     30 /* MaxLinear */
@@ -60,33 +57,13 @@ struct af9013_config {
 #define AF9013_TUNER_MXL5007T    177 /* MaxLinear */
 #define AF9013_TUNER_TDA18218    179 /* NXP */
 	u8 tuner;
-
-	/*
-	 * IF frequency
-	 */
 	u32 if_frequency;
-
-	/*
-	 * TS settings
-	 */
-#define AF9013_TS_USB       0
-#define AF9013_TS_PARALLEL  1
-#define AF9013_TS_SERIAL    2
-	u8 ts_mode:2;
-
-	/*
-	 * input spectrum inversion
-	 */
+#define AF9013_TS_MODE_USB       0
+#define AF9013_TS_MODE_PARALLEL  1
+#define AF9013_TS_MODE_SERIAL    2
+	u8 ts_mode;
 	bool spec_inv;
-
-	/*
-	 * firmware API version
-	 */
 	u8 api_version[4];
-
-	/*
-	 * GPIOs
-	 */
 #define AF9013_GPIO_ON (1 << 0)
 #define AF9013_GPIO_EN (1 << 1)
 #define AF9013_GPIO_O  (1 << 2)
@@ -96,8 +73,29 @@ struct af9013_config {
 #define AF9013_GPIO_TUNER_ON  (AF9013_GPIO_ON|AF9013_GPIO_EN)
 #define AF9013_GPIO_TUNER_OFF (AF9013_GPIO_ON|AF9013_GPIO_EN|AF9013_GPIO_O)
 	u8 gpio[4];
+
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+
+/* private: For legacy media attach wrapper. Do not set value. */
+	bool attach_in_use;
+	u8 i2c_addr;
+	u32 clock;
 };
 
+#define af9013_config       af9013_platform_data
+#define AF9013_TS_USB       AF9013_TS_MODE_USB
+#define AF9013_TS_PARALLEL  AF9013_TS_MODE_PARALLEL
+#define AF9013_TS_SERIAL    AF9013_TS_MODE_SERIAL
+
+/*
+ * AF9013/5 GPIOs (mostly guessed)
+ * demod#1-gpio#0 - set demod#2 i2c-addr for dual devices
+ * demod#1-gpio#1 - xtal setting (?)
+ * demod#1-gpio#3 - tuner#1
+ * demod#2-gpio#0 - tuner#2
+ * demod#2-gpio#1 - xtal setting (?)
+ */
+
 #if IS_REACHABLE(CONFIG_DVB_AF9013)
 extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	struct i2c_adapter *i2c);
-- 
http://palosaari.fi/
