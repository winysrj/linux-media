Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40814 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751555AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/15] af9013: move config values directly under driver state
Date: Thu, 15 Jun 2017 06:30:52 +0300
Message-Id: <20170615033105.13517-2-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It shorten, as typed chars, access to config values as there is one
pointer less. Also, when config/platform data is passed to driver there
could be some values that are not relevant to store state as such or
not needed to store at all.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 62 ++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index b978002..7880a63 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -26,7 +26,14 @@
 struct af9013_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
-	struct af9013_config config;
+	u8 i2c_addr;
+	u32 clk;
+	u8 tuner;
+	u32 if_frequency;
+	u8 ts_mode;
+	bool spec_inv;
+	u8 api_version[4];
+	u8 gpio[4];
 
 	/* tuner/demod RF and IF AGC limits used for signal strength calc */
 	u8 signal_strength_en, rf_50, rf_80, if_50, if_80;
@@ -52,7 +59,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->config.i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = 0,
 			.len = 3 + len,
 			.buf = buf,
@@ -90,12 +97,12 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	u8 buf[3];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->config.i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = 0,
 			.len = 3,
 			.buf = buf,
 		}, {
-			.addr = priv->config.i2c_addr,
+			.addr = priv->i2c_addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val,
@@ -124,7 +131,7 @@ static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
 	int ret, i;
 	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);
 
-	if ((priv->config.ts_mode == AF9013_TS_USB) &&
+	if ((priv->ts_mode == AF9013_TS_USB) &&
 		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
 		mbox |= ((len - 1) << 2);
 		ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
@@ -146,7 +153,7 @@ static int af9013_rd_regs(struct af9013_state *priv, u16 reg, u8 *val, int len)
 	int ret, i;
 	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(0 << 0);
 
-	if ((priv->config.ts_mode == AF9013_TS_USB) &&
+	if ((priv->ts_mode == AF9013_TS_USB) &&
 		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
 		mbox |= ((len - 1) << 2);
 		ret = af9013_rd_regs_i2c(priv, mbox, reg, val, len);
@@ -595,7 +602,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	/* program CFOE coefficients */
 	if (c->bandwidth_hz != state->bandwidth_hz) {
 		for (i = 0; i < ARRAY_SIZE(coeff_lut); i++) {
-			if (coeff_lut[i].clock == state->config.clock &&
+			if (coeff_lut[i].clock == state->clk &&
 				coeff_lut[i].bandwidth_hz == c->bandwidth_hz) {
 				break;
 			}
@@ -615,24 +622,24 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		if (fe->ops.tuner_ops.get_if_frequency)
 			fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		else
-			if_frequency = state->config.if_frequency;
+			if_frequency = state->if_frequency;
 
 		dev_dbg(&state->i2c->dev, "%s: if_frequency=%d\n",
 				__func__, if_frequency);
 
 		sampling_freq = if_frequency;
 
-		while (sampling_freq > (state->config.clock / 2))
-			sampling_freq -= state->config.clock;
+		while (sampling_freq > (state->clk / 2))
+			sampling_freq -= state->clk;
 
 		if (sampling_freq < 0) {
 			sampling_freq *= -1;
-			spec_inv = state->config.spec_inv;
+			spec_inv = state->spec_inv;
 		} else {
-			spec_inv = !state->config.spec_inv;
+			spec_inv = !state->spec_inv;
 		}
 
-		freq_cw = af9013_div(state, sampling_freq, state->config.clock,
+		freq_cw = af9013_div(state, sampling_freq, state->clk,
 				23);
 
 		if (spec_inv)
@@ -1078,12 +1085,12 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* write API version to firmware */
-	ret = af9013_wr_regs(state, 0x9bf2, state->config.api_version, 4);
+	ret = af9013_wr_regs(state, 0x9bf2, state->api_version, 4);
 	if (ret)
 		goto err;
 
 	/* program ADC control */
-	switch (state->config.clock) {
+	switch (state->clk) {
 	case 28800000: /* 28.800 MHz */
 		tmp = 0;
 		break;
@@ -1102,7 +1109,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	adc_cw = af9013_div(state, state->config.clock, 1000000ul, 19);
+	adc_cw = af9013_div(state, state->clk, 1000000ul, 19);
 	buf[0] = (adc_cw >>  0) & 0xff;
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
@@ -1136,7 +1143,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* settings for mp2if */
-	if (state->config.ts_mode == AF9013_TS_USB) {
+	if (state->ts_mode == AF9013_TS_USB) {
 		/* AF9015 split PSB to 1.5k + 0.5k */
 		ret = af9013_wr_reg_bits(state, 0xd50b, 2, 1, 1);
 		if (ret)
@@ -1171,7 +1178,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	/* load tuner specific settings */
 	dev_dbg(&state->i2c->dev, "%s: load tuner specific settings\n",
 			__func__);
-	switch (state->config.tuner) {
+	switch (state->tuner) {
 	case AF9013_TUNER_MXL5003D:
 		len = ARRAY_SIZE(tuner_init_mxl5003d);
 		init = tuner_init_mxl5003d;
@@ -1223,7 +1230,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	}
 
 	/* TS mode */
-	ret = af9013_wr_reg_bits(state, 0xd500, 1, 2, state->config.ts_mode);
+	ret = af9013_wr_reg_bits(state, 0xd500, 1, 2, state->ts_mode);
 	if (ret)
 		goto err;
 
@@ -1322,7 +1329,7 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	if (state->i2c_gate_state == enable)
 		return 0;
 
-	if (state->config.ts_mode == AF9013_TS_USB)
+	if (state->ts_mode == AF9013_TS_USB)
 		ret = af9013_wr_reg_bits(state, 0xd417, 3, 1, enable);
 	else
 		ret = af9013_wr_reg_bits(state, 0xd607, 2, 1, enable);
@@ -1474,10 +1481,17 @@ struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 
 	/* setup the state */
 	state->i2c = i2c;
-	memcpy(&state->config, config, sizeof(struct af9013_config));
+	state->i2c_addr = config->i2c_addr;
+	state->clk = config->clock;
+	state->tuner = config->tuner;
+	state->if_frequency = config->if_frequency;
+	state->ts_mode = config->ts_mode;
+	state->spec_inv = config->spec_inv;
+	memcpy(&state->api_version, config->api_version, sizeof(state->api_version));
+	memcpy(&state->gpio, config->gpio, sizeof(state->gpio));
 
 	/* download firmware */
-	if (state->config.ts_mode != AF9013_TS_USB) {
+	if (state->ts_mode != AF9013_TS_USB) {
 		ret = af9013_download_firmware(state);
 		if (ret)
 			goto err;
@@ -1492,8 +1506,8 @@ struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3]);
 
 	/* set GPIOs */
-	for (i = 0; i < sizeof(state->config.gpio); i++) {
-		ret = af9013_set_gpio(state, i, state->config.gpio[i]);
+	for (i = 0; i < sizeof(state->gpio); i++) {
+		ret = af9013_set_gpio(state, i, state->gpio[i]);
 		if (ret)
 			goto err;
 	}
-- 
http://palosaari.fi/
