Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42860 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/16] af9033: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:42 +0300
Message-Id: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 83 +++++++++++++++++++-----------------
 drivers/media/dvb-frontends/af9033.h |  2 +-
 2 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index a389982..0979ada 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -59,8 +59,8 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		printk(KERN_WARNING "%s: i2c wr failed=%d reg=%06x len=%d\n",
-				__func__, ret, reg, len);
+		dev_warn(&state->i2c->dev, "%s: i2c wr failed=%d reg=%06x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -91,8 +91,8 @@ static int af9033_rd_regs(struct af9033_state *state, u32 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		printk(KERN_WARNING "%s: i2c rd failed=%d reg=%06x len=%d\n",
-				__func__, ret, reg, len);
+		dev_warn(&state->i2c->dev, "%s: i2c rd failed=%d reg=%06x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -156,11 +156,11 @@ static int af9033_rd_reg_mask(struct af9033_state *state, u32 reg, u8 *val,
 	return 0;
 }
 
-static u32 af9033_div(u32 a, u32 b, u32 x)
+static u32 af9033_div(struct af9033_state *state, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
 
-	pr_debug("%s: a=%d b=%d x=%d\n", __func__, a, b, x);
+	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
 
 	if (a > b) {
 		c = a / b;
@@ -177,7 +177,8 @@ static u32 af9033_div(u32 a, u32 b, u32 x)
 	}
 	r = (c << (u32)x) + r;
 
-	pr_debug("%s: a=%d b=%d x=%d r=%d r=%x\n", __func__, a, b, x, r, r);
+	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
+			__func__, a, b, x, r, r);
 
 	return r;
 }
@@ -225,14 +226,14 @@ static int af9033_init(struct dvb_frontend *fe)
 	};
 
 	/* program clock control */
-	clock_cw = af9033_div(state->cfg.clock, 1000000ul, 19ul);
+	clock_cw = af9033_div(state, state->cfg.clock, 1000000ul, 19ul);
 	buf[0] = (clock_cw >>  0) & 0xff;
 	buf[1] = (clock_cw >>  8) & 0xff;
 	buf[2] = (clock_cw >> 16) & 0xff;
 	buf[3] = (clock_cw >> 24) & 0xff;
 
-	pr_debug("%s: clock=%d clock_cw=%08x\n", __func__, state->cfg.clock,
-			clock_cw);
+	dev_dbg(&state->i2c->dev, "%s: clock=%d clock_cw=%08x\n",
+			__func__, state->cfg.clock, clock_cw);
 
 	ret = af9033_wr_regs(state, 0x800025, buf, 4);
 	if (ret < 0)
@@ -244,13 +245,13 @@ static int af9033_init(struct dvb_frontend *fe)
 			break;
 	}
 
-	adc_cw = af9033_div(clock_adc_lut[i].adc, 1000000ul, 19ul);
+	adc_cw = af9033_div(state, clock_adc_lut[i].adc, 1000000ul, 19ul);
 	buf[0] = (adc_cw >>  0) & 0xff;
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
 
-	pr_debug("%s: adc=%d adc_cw=%06x\n", __func__, clock_adc_lut[i].adc,
-			adc_cw);
+	dev_dbg(&state->i2c->dev, "%s: adc=%d adc_cw=%06x\n",
+			__func__, clock_adc_lut[i].adc, adc_cw);
 
 	ret = af9033_wr_regs(state, 0x80f1cd, buf, 3);
 	if (ret < 0)
@@ -284,7 +285,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	/* load OFSM settings */
-	pr_debug("%s: load ofsm settings\n", __func__);
+	dev_dbg(&state->i2c->dev, "%s: load ofsm settings\n", __func__);
 	len = ARRAY_SIZE(ofsm_init);
 	init = ofsm_init;
 	for (i = 0; i < len; i++) {
@@ -294,7 +295,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	pr_debug("%s: load tuner specific settings\n",
+	dev_dbg(&state->i2c->dev, "%s: load tuner specific settings\n",
 			__func__);
 	switch (state->cfg.tuner) {
 	case AF9033_TUNER_TUA9001:
@@ -314,8 +315,8 @@ static int af9033_init(struct dvb_frontend *fe)
 		init = tuner_init_tda18218;
 		break;
 	default:
-		pr_debug("%s: unsupported tuner ID=%d\n", __func__,
-				state->cfg.tuner);
+		dev_dbg(&state->i2c->dev, "%s: unsupported tuner ID=%d\n",
+				__func__, state->cfg.tuner);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -331,7 +332,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -358,7 +359,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 		usleep_range(200, 10000);
 	}
 
-	pr_debug("%s: loop=%d\n", __func__, i);
+	dev_dbg(&state->i2c->dev, "%s: loop=%d\n", __func__, i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -384,7 +385,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -407,8 +408,8 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	u8 tmp, buf[3], bandwidth_reg_val;
 	u32 if_frequency, freq_cw, adc_freq;
 
-	pr_debug("%s: frequency=%d bandwidth_hz=%d\n", __func__, c->frequency,
-			c->bandwidth_hz);
+	dev_dbg(&state->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
+			__func__, c->frequency, c->bandwidth_hz);
 
 	/* check bandwidth */
 	switch (c->bandwidth_hz) {
@@ -422,7 +423,8 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		bandwidth_reg_val = 0x02;
 		break;
 	default:
-		pr_debug("%s: invalid bandwidth_hz\n", __func__);
+		dev_dbg(&state->i2c->dev, "%s: invalid bandwidth_hz\n",
+				__func__);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -467,7 +469,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		else
 			if_frequency *= -1;
 
-		freq_cw = af9033_div(if_frequency, adc_freq, 23ul);
+		freq_cw = af9033_div(state, if_frequency, adc_freq, 23ul);
 
 		if (spec_inv == -1)
 			freq_cw *= -1;
@@ -522,7 +524,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -534,7 +536,7 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[8];
 
-	pr_debug("%s\n", __func__);
+	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
 	/* read all needed registers */
 	ret = af9033_rd_regs(state, 0x80f900, buf, sizeof(buf));
@@ -649,7 +651,7 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -695,7 +697,7 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -749,7 +751,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -771,7 +773,7 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -815,7 +817,8 @@ static int af9033_update_ch_stat(struct af9033_state *state)
 
 	return 0;
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+
 	return ret;
 }
 
@@ -852,7 +855,7 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct af9033_state *state = fe->demodulator_priv;
 	int ret;
 
-	pr_debug("%s: enable=%d\n", __func__, enable);
+	dev_dbg(&state->i2c->dev, "%s: enable=%d\n", __func__, enable);
 
 	ret = af9033_wr_reg_mask(state, 0x00fa04, enable, 0x01);
 	if (ret < 0)
@@ -861,7 +864,7 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -875,7 +878,7 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	struct af9033_state *state;
 	u8 buf[8];
 
-	pr_debug("%s:\n", __func__);
+	dev_dbg(&i2c->dev, "%s:\n", __func__);
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct af9033_state), GFP_KERNEL);
@@ -887,9 +890,9 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	memcpy(&state->cfg, config, sizeof(struct af9033_config));
 
 	if (state->cfg.clock != 12000000) {
-		printk(KERN_INFO "af9033: unsupported clock=%d, only " \
-				"12000000 Hz is supported currently\n",
-				state->cfg.clock);
+		dev_err(&state->i2c->dev, "%s: af9033: unsupported clock=%d, " \
+				"only 12000000 Hz is supported currently\n",
+				KBUILD_MODNAME, state->cfg.clock);
 		goto err;
 	}
 
@@ -902,9 +905,9 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	if (ret < 0)
 		goto err;
 
-	printk(KERN_INFO "af9033: firmware version: LINK=%d.%d.%d.%d " \
-			"OFDM=%d.%d.%d.%d\n", buf[0], buf[1], buf[2], buf[3],
-			buf[4], buf[5], buf[6], buf[7]);
+	dev_info(&state->i2c->dev, "%s: firmware version: LINK=%d.%d.%d.%d " \
+			"OFDM=%d.%d.%d.%d\n", KBUILD_MODNAME, buf[0], buf[1],
+			buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
 
 	/* configure internal TS mode */
 	switch (state->cfg.ts_mode) {
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 9e302c3..288622b 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -67,7 +67,7 @@ extern struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 static inline struct dvb_frontend *af9033_attach(
 	const struct af9033_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
-- 
1.7.11.4

