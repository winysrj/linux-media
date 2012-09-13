Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60687 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/16] af9013: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:43 +0300
Message-Id: <1347495837-3244-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c      | 155 +++++++++++++++++-------------
 drivers/media/dvb-frontends/af9013.h      |   2 +-
 drivers/media/dvb-frontends/af9013_priv.h |  13 ---
 3 files changed, 89 insertions(+), 81 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index b30ca2d..e9f04a3 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -24,10 +24,6 @@
 
 #include "af9013_priv.h"
 
-int af9013_debug;
-module_param_named(debug, af9013_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 struct af9013_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
@@ -73,7 +69,8 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		warn("i2c wr failed=%d reg=%04x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%04x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -107,7 +104,8 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		warn("i2c rd failed=%d reg=%04x len=%d", ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%04x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -220,7 +218,8 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	u8 pos;
 	u16 addr;
 
-	dbg("%s: gpio=%d gpioval=%02x", __func__, gpio, gpioval);
+	dev_dbg(&state->i2c->dev, "%s: gpio=%d gpioval=%02x\n",
+			__func__, gpio, gpioval);
 
 	/*
 	 * GPIO0 & GPIO1 0xd735
@@ -238,7 +237,8 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 		break;
 
 	default:
-		err("invalid gpio:%d\n", gpio);
+		dev_err(&state->i2c->dev, "%s: invalid gpio=%d\n",
+				KBUILD_MODNAME, gpio);
 		ret = -EINVAL;
 		goto err;
 	};
@@ -261,15 +261,15 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
-static u32 af913_div(u32 a, u32 b, u32 x)
+static u32 af9013_div(struct af9013_state *state, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
 
-	dbg("%s: a=%d b=%d x=%d", __func__, a, b, x);
+	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
 
 	if (a > b) {
 		c = a / b;
@@ -286,7 +286,9 @@ static u32 af913_div(u32 a, u32 b, u32 x)
 	}
 	r = (c << (u32)x) + r;
 
-	dbg("%s: a=%d b=%d x=%d r=%x", __func__, a, b, x, r);
+	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
+			__func__, a, b, x, r, r);
+
 	return r;
 }
 
@@ -295,7 +297,7 @@ static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 	int ret, i;
 	u8 tmp;
 
-	dbg("%s: onoff=%d", __func__, onoff);
+	dev_dbg(&state->i2c->dev, "%s: onoff=%d\n", __func__, onoff);
 
 	/* enable reset */
 	ret = af9013_wr_reg_bits(state, 0xd417, 4, 1, 1);
@@ -340,7 +342,7 @@ static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -349,7 +351,7 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* reset and start BER counter */
 	ret = af9013_wr_reg_bits(state, 0xd391, 4, 1, 1);
@@ -358,7 +360,7 @@ static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -368,7 +370,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[5];
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* check if error bit count is ready */
 	ret = af9013_rd_reg_bits(state, 0xd391, 4, 1, &buf[0]);
@@ -376,7 +378,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 		goto err;
 
 	if (!buf[0]) {
-		dbg("%s: not ready", __func__);
+		dev_dbg(&state->i2c->dev, "%s: not ready\n", __func__);
 		return 0;
 	}
 
@@ -389,7 +391,7 @@ static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -398,7 +400,7 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* start SNR meas */
 	ret = af9013_wr_reg_bits(state, 0xd2e1, 3, 1, 1);
@@ -407,7 +409,7 @@ static int af9013_statistics_snr_start(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -419,7 +421,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	u32 snr_val;
 	const struct af9013_snr *uninitialized_var(snr_lut);
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* check if SNR ready */
 	ret = af9013_rd_reg_bits(state, 0xd2e1, 3, 1, &tmp);
@@ -427,7 +429,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 		goto err;
 
 	if (!tmp) {
-		dbg("%s: not ready", __func__);
+		dev_dbg(&state->i2c->dev, "%s: not ready\n", __func__);
 		return 0;
 	}
 
@@ -471,7 +473,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -482,7 +484,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 	u8 buf[2], rf_gain, if_gain;
 	int signal_strength;
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	if (!state->signal_strength_en)
 		return 0;
@@ -508,7 +510,7 @@ static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -578,8 +580,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	u8 buf[6];
 	u32 if_frequency, freq_cw;
 
-	dbg("%s: frequency=%d bandwidth_hz=%d", __func__,
-		c->frequency, c->bandwidth_hz);
+	dev_dbg(&state->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
+			__func__, c->frequency, c->bandwidth_hz);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -606,7 +608,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		else
 			if_frequency = state->config.if_frequency;
 
-		dbg("%s: if_frequency=%d", __func__, if_frequency);
+		dev_dbg(&state->i2c->dev, "%s: if_frequency=%d\n",
+				__func__, if_frequency);
 
 		sampling_freq = if_frequency;
 
@@ -620,7 +623,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 			spec_inv = !state->config.spec_inv;
 		}
 
-		freq_cw = af913_div(sampling_freq, state->config.clock, 23);
+		freq_cw = af9013_div(state, sampling_freq, state->config.clock,
+				23);
 
 		if (spec_inv)
 			freq_cw = 0x800000 - freq_cw;
@@ -678,7 +682,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (1 << 0);
 		break;
 	default:
-		dbg("%s: invalid transmission_mode", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid transmission_mode\n",
+				__func__);
 		auto_mode = 1;
 	}
 
@@ -698,7 +703,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (3 << 2);
 		break;
 	default:
-		dbg("%s: invalid guard_interval", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid guard_interval\n",
+				__func__);
 		auto_mode = 1;
 	}
 
@@ -718,7 +724,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[0] |= (3 << 4);
 		break;
 	default:
-		dbg("%s: invalid hierarchy", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid hierarchy\n", __func__);
 		auto_mode = 1;
 	};
 
@@ -735,7 +741,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[1] |= (2 << 6);
 		break;
 	default:
-		dbg("%s: invalid modulation", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid modulation\n", __func__);
 		auto_mode = 1;
 	}
 
@@ -761,7 +767,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[2] |= (4 << 0);
 		break;
 	default:
-		dbg("%s: invalid code_rate_HP", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid code_rate_HP\n",
+				__func__);
 		auto_mode = 1;
 	}
 
@@ -786,7 +793,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	case FEC_NONE:
 		break;
 	default:
-		dbg("%s: invalid code_rate_LP", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid code_rate_LP\n",
+				__func__);
 		auto_mode = 1;
 	}
 
@@ -800,7 +808,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		buf[1] |= (2 << 2);
 		break;
 	default:
-		dbg("%s: invalid bandwidth_hz", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid bandwidth_hz\n",
+				__func__);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -815,7 +824,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dbg("%s: auto params", __func__);
+		dev_dbg(&state->i2c->dev, "%s: auto params\n", __func__);
 	} else {
 		/* set easy mode flag */
 		ret = af9013_wr_reg(state, 0xaefd, 1);
@@ -826,7 +835,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dbg("%s: manual params", __func__);
+		dev_dbg(&state->i2c->dev, "%s: manual params\n", __func__);
 	}
 
 	/* tune */
@@ -840,7 +849,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -851,7 +860,7 @@ static int af9013_get_frontend(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[3];
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	ret = af9013_rd_regs(state, 0xd3c0, buf, 3);
 	if (ret)
@@ -957,7 +966,7 @@ static int af9013_get_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1007,7 +1016,7 @@ static int af9013_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1047,7 +1056,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	u32 adc_cw;
 	const struct af9013_reg_bit *init;
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* power on */
 	ret = af9013_power_ctrl(state, 1);
@@ -1079,11 +1088,12 @@ static int af9013_init(struct dvb_frontend *fe)
 		tmp = 3;
 		break;
 	default:
-		err("invalid clock");
+		dev_err(&state->i2c->dev, "%s: invalid clock\n",
+				KBUILD_MODNAME);
 		return -EINVAL;
 	}
 
-	adc_cw = af913_div(state->config.clock, 1000000ul, 19);
+	adc_cw = af9013_div(state, state->config.clock, 1000000ul, 19);
 	buf[0] = (adc_cw >>  0) & 0xff;
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
@@ -1139,7 +1149,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* load OFSM settings */
-	dbg("%s: load ofsm settings", __func__);
+	dev_dbg(&state->i2c->dev, "%s: load ofsm settings\n", __func__);
 	len = ARRAY_SIZE(ofsm_init);
 	init = ofsm_init;
 	for (i = 0; i < len; i++) {
@@ -1150,7 +1160,8 @@ static int af9013_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	dbg("%s: load tuner specific settings", __func__);
+	dev_dbg(&state->i2c->dev, "%s: load tuner specific settings\n",
+			__func__);
 	switch (state->config.tuner) {
 	case AF9013_TUNER_MXL5003D:
 		len = ARRAY_SIZE(tuner_init_mxl5003d);
@@ -1261,7 +1272,7 @@ static int af9013_init(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1270,7 +1281,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 
-	dbg("%s", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&state->statistics_work);
@@ -1287,7 +1298,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1296,7 +1307,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int ret;
 	struct af9013_state *state = fe->demodulator_priv;
 
-	dbg("%s: enable=%d", __func__, enable);
+	dev_dbg(&state->i2c->dev, "%s: enable=%d\n", __func__, enable);
 
 	/* gate already open or close */
 	if (state->i2c_gate_state == enable)
@@ -1313,7 +1324,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	return ret;
 err:
-	dbg("%s: failed=%d", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -1340,25 +1351,28 @@ static int af9013_download_firmware(struct af9013_state *state)
 	if (ret)
 		goto err;
 	else
-		dbg("%s: firmware status=%02x", __func__, val);
+		dev_dbg(&state->i2c->dev, "%s: firmware status=%02x\n",
+				__func__, val);
 
 	if (val == 0x0c) /* fw is running, no need for download */
 		goto exit;
 
-	info("found a '%s' in cold state, will try to load a firmware",
-		af9013_ops.info.name);
+	dev_info(&state->i2c->dev, "%s: found a '%s' in cold state, will try " \
+			"to load a firmware\n",
+			KBUILD_MODNAME, af9013_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
 	if (ret) {
-		err("did not find the firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details" \
-			" on firmware-problems. (%d)",
-			fw_file, ret);
+		dev_info(&state->i2c->dev, "%s: did not find the firmware " \
+			"file. (%s) Please see linux/Documentation/dvb/ for " \
+			"more details on firmware-problems. (%d)\n",
+			KBUILD_MODNAME, fw_file, ret);
 		goto err;
 	}
 
-	info("downloading firmware from file '%s'", fw_file);
+	dev_info(&state->i2c->dev, "%s: downloading firmware from file '%s'\n",
+			KBUILD_MODNAME, fw_file);
 
 	/* calc checksum */
 	for (i = 0; i < fw->size; i++)
@@ -1386,7 +1400,9 @@ static int af9013_download_firmware(struct af9013_state *state)
 			FW_ADDR + fw->size - remaining,
 			(u8 *) &fw->data[fw->size - remaining], len);
 		if (ret) {
-			err("firmware download failed:%d", ret);
+			dev_err(&state->i2c->dev,
+					"%s: firmware download failed=%d\n",
+					KBUILD_MODNAME, ret);
 			goto err_release;
 		}
 	}
@@ -1404,17 +1420,20 @@ static int af9013_download_firmware(struct af9013_state *state)
 		if (ret)
 			goto err_release;
 
-		dbg("%s: firmware status=%02x", __func__, val);
+		dev_dbg(&state->i2c->dev, "%s: firmware status=%02x\n",
+				__func__, val);
 
 		if (val == 0x0c || val == 0x04) /* success or fail */
 			break;
 	}
 
 	if (val == 0x04) {
-		err("firmware did not run");
+		dev_err(&state->i2c->dev, "%s: firmware did not run\n",
+				KBUILD_MODNAME);
 		ret = -ENODEV;
 	} else if (val != 0x0c) {
-		err("firmware boot timeout");
+		dev_err(&state->i2c->dev, "%s: firmware boot timeout\n",
+				KBUILD_MODNAME);
 		ret = -ENODEV;
 	}
 
@@ -1423,7 +1442,8 @@ err_release:
 err:
 exit:
 	if (!ret)
-		info("found a '%s' in warm state.", af9013_ops.info.name);
+		dev_info(&state->i2c->dev, "%s: found a '%s' in warm state\n",
+				KBUILD_MODNAME, af9013_ops.info.name);
 	return ret;
 }
 
@@ -1455,7 +1475,8 @@ struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	if (ret)
 		goto err;
 
-	info("firmware version %d.%d.%d.%d", buf[0], buf[1], buf[2], buf[3]);
+	dev_info(&state->i2c->dev, "%s: firmware version %d.%d.%d.%d\n",
+			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3]);
 
 	/* set GPIOs */
 	for (i = 0; i < sizeof(state->config.gpio); i++) {
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index b973fc5..dc837d9 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -110,7 +110,7 @@ extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 static inline struct dvb_frontend *af9013_attach(
 const struct af9013_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_AF9013 */
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index 04ee6ce..8b9392c 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -29,19 +29,6 @@
 #include "af9013.h"
 #include <linux/firmware.h>
 
-#define LOG_PREFIX "af9013"
-
-#undef dbg
-#define dbg(f, arg...) \
-	if (af9013_debug) \
-		printk(KERN_INFO   LOG_PREFIX": " f "\n" , ## arg)
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
 #define AF9013_FIRMWARE "dvb-fe-af9013.fw"
 
 struct af9013_reg_bit {
-- 
1.7.11.4

