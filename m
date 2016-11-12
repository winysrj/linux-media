Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49353 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753115AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/9] af9033: style related and minor changes
Date: Sat, 12 Nov 2016 12:33:56 +0200
Message-Id: <1478946841-2807-4-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix coding style and other small issues.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      | 313 +++++++++++++++---------------
 drivers/media/dvb-frontends/af9033.h      |   3 +-
 drivers/media/dvb-frontends/af9033_priv.h |  82 +++++---
 3 files changed, 211 insertions(+), 187 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index e9ff0f6..b86a01e 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -41,18 +41,19 @@ struct af9033_dev {
 	u64 total_block_count;
 };
 
-/* write reg val table using reg addr auto increment */
+/* Write reg val table using reg addr auto increment */
 static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
-		const struct reg_val *tab, int tab_len)
+				 const struct reg_val *tab, int tab_len)
 {
+	struct i2c_client *client = dev->client;
 #define MAX_TAB_LEN 212
 	int ret, i, j;
 	u8 buf[1 + MAX_TAB_LEN];
 
-	dev_dbg(&dev->client->dev, "tab_len=%d\n", tab_len);
+	dev_dbg(&client->dev, "tab_len=%d\n", tab_len);
 
 	if (tab_len > sizeof(buf)) {
-		dev_warn(&dev->client->dev, "tab len %d is too big\n", tab_len);
+		dev_warn(&client->dev, "tab len %d is too big\n", tab_len);
 		return -EINVAL;
 	}
 
@@ -72,51 +73,52 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 	}
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_init(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, len;
 	unsigned int utmp;
 	const struct reg_val *init;
 	u8 buf[4];
 	struct reg_val_mask tab[] = {
-		{ 0x80fb24, 0x00, 0x08 },
-		{ 0x80004c, 0x00, 0xff },
-		{ 0x00f641, dev->cfg.tuner, 0xff },
-		{ 0x80f5ca, 0x01, 0x01 },
-		{ 0x80f715, 0x01, 0x01 },
-		{ 0x00f41f, 0x04, 0x04 },
-		{ 0x00f41a, 0x01, 0x01 },
-		{ 0x80f731, 0x00, 0x01 },
-		{ 0x00d91e, 0x00, 0x01 },
-		{ 0x00d919, 0x00, 0x01 },
-		{ 0x80f732, 0x00, 0x01 },
-		{ 0x00d91f, 0x00, 0x01 },
-		{ 0x00d91a, 0x00, 0x01 },
-		{ 0x80f730, 0x00, 0x01 },
-		{ 0x80f778, 0x00, 0xff },
-		{ 0x80f73c, 0x01, 0x01 },
-		{ 0x80f776, 0x00, 0x01 },
-		{ 0x00d8fd, 0x01, 0xff },
-		{ 0x00d830, 0x01, 0xff },
-		{ 0x00d831, 0x00, 0xff },
-		{ 0x00d832, 0x00, 0xff },
-		{ 0x80f985, dev->ts_mode_serial, 0x01 },
-		{ 0x80f986, dev->ts_mode_parallel, 0x01 },
-		{ 0x00d827, 0x00, 0xff },
-		{ 0x00d829, 0x00, 0xff },
-		{ 0x800045, dev->cfg.adc_multiplier, 0xff },
+		{0x80fb24, 0x00, 0x08},
+		{0x80004c, 0x00, 0xff},
+		{0x00f641, dev->cfg.tuner, 0xff},
+		{0x80f5ca, 0x01, 0x01},
+		{0x80f715, 0x01, 0x01},
+		{0x00f41f, 0x04, 0x04},
+		{0x00f41a, 0x01, 0x01},
+		{0x80f731, 0x00, 0x01},
+		{0x00d91e, 0x00, 0x01},
+		{0x00d919, 0x00, 0x01},
+		{0x80f732, 0x00, 0x01},
+		{0x00d91f, 0x00, 0x01},
+		{0x00d91a, 0x00, 0x01},
+		{0x80f730, 0x00, 0x01},
+		{0x80f778, 0x00, 0xff},
+		{0x80f73c, 0x01, 0x01},
+		{0x80f776, 0x00, 0x01},
+		{0x00d8fd, 0x01, 0xff},
+		{0x00d830, 0x01, 0xff},
+		{0x00d831, 0x00, 0xff},
+		{0x00d832, 0x00, 0xff},
+		{0x80f985, dev->ts_mode_serial, 0x01},
+		{0x80f986, dev->ts_mode_parallel, 0x01},
+		{0x00d827, 0x00, 0xff},
+		{0x00d829, 0x00, 0xff},
+		{0x800045, dev->cfg.adc_multiplier, 0xff},
 	};
 
-	/* program clock control */
+	dev_dbg(&client->dev, "\n");
+
+	/* Main clk control */
 	utmp = div_u64((u64)dev->cfg.clock * 0x80000, 1000000);
 	buf[0] = (utmp >>  0) & 0xff;
 	buf[1] = (utmp >>  8) & 0xff;
@@ -126,17 +128,15 @@ static int af9033_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "clk=%u clk_cw=%08x\n",
-		dev->cfg.clock, utmp);
+	dev_dbg(&client->dev, "clk=%u clk_cw=%08x\n", dev->cfg.clock, utmp);
 
-	/* program ADC control */
+	/* ADC clk control */
 	for (i = 0; i < ARRAY_SIZE(clock_adc_lut); i++) {
 		if (clock_adc_lut[i].clock == dev->cfg.clock)
 			break;
 	}
 	if (i == ARRAY_SIZE(clock_adc_lut)) {
-		dev_err(&dev->client->dev,
-			"Couldn't find ADC config for clock=%d\n",
+		dev_err(&client->dev, "Couldn't find ADC config for clock %d\n",
 			dev->cfg.clock);
 		goto err;
 	}
@@ -149,10 +149,10 @@ static int af9033_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "adc=%u adc_cw=%06x\n",
+	dev_dbg(&client->dev, "adc=%u adc_cw=%06x\n",
 		clock_adc_lut[i].adc, utmp);
 
-	/* program register table */
+	/* Config register table */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
 		ret = regmap_update_bits(dev->regmap, tab[i].reg, tab[i].mask,
 					 tab[i].val);
@@ -160,14 +160,14 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/* clock output */
+	/* Demod clk output */
 	if (dev->cfg.dyn0_clk) {
 		ret = regmap_write(dev->regmap, 0x80fba8, 0x00);
 		if (ret)
 			goto err;
 	}
 
-	/* settings for TS interface */
+	/* TS interface */
 	if (dev->cfg.ts_mode == AF9033_TS_MODE_USB) {
 		ret = regmap_update_bits(dev->regmap, 0x80f9a5, 0x01, 0x00);
 		if (ret)
@@ -184,8 +184,8 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/* load OFSM settings */
-	dev_dbg(&dev->client->dev, "load ofsm settings\n");
+	/* Demod core settings */
+	dev_dbg(&client->dev, "load ofsm settings\n");
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
@@ -209,8 +209,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* load tuner specific settings */
-	dev_dbg(&dev->client->dev, "load tuner specific settings\n");
+	/* Demod tuner specific settings */
+	dev_dbg(&client->dev, "load tuner specific settings\n");
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_TUA9001:
 		len = ARRAY_SIZE(tuner_init_tua9001);
@@ -261,8 +261,8 @@ static int af9033_init(struct dvb_frontend *fe)
 		init = tuner_init_it9135_62;
 		break;
 	default:
-		dev_dbg(&dev->client->dev, "unsupported tuner ID=%d\n",
-				dev->cfg.tuner);
+		dev_dbg(&client->dev, "unsupported tuner ID=%d\n",
+			dev->cfg.tuner);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -292,8 +292,8 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	dev->bandwidth_hz = 0; /* force to program all parameters */
-	/* init stats here in order signal app which stats are supported */
+	dev->bandwidth_hz = 0; /* Force to program all parameters */
+	/* Init stats here in order signal app which stats are supported */
 	c->strength.len = 1;
 	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->cnr.len = 1;
@@ -308,19 +308,20 @@ static int af9033_init(struct dvb_frontend *fe)
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_sleep(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	unsigned int utmp;
 
+	dev_dbg(&client->dev, "\n");
+
 	ret = regmap_write(dev->regmap, 0x80004c, 0x01);
 	if (ret)
 		goto err;
@@ -335,9 +336,9 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* prevent current leak (?) */
+	/* Prevent current leak by setting TS interface to parallel mode */
 	if (dev->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
-		/* enable parallel TS */
+		/* Enable parallel TS */
 		ret = regmap_update_bits(dev->regmap, 0x00d917, 0x01, 0x00);
 		if (ret)
 			goto err;
@@ -347,15 +348,13 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	}
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_get_tune_settings(struct dvb_frontend *fe,
-		struct dvb_frontend_tune_settings *fesettings)
+				    struct dvb_frontend_tune_settings *fesettings)
 {
 	/* 800 => 2000 because IT9135 v2 is slow to gain lock */
 	fesettings->min_delay_ms = 2000;
@@ -368,16 +367,17 @@ static int af9033_get_tune_settings(struct dvb_frontend *fe,
 static int af9033_set_frontend(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	unsigned int utmp, adc_freq;
 	u8 tmp, buf[3], bandwidth_reg_val;
 	u32 if_frequency;
 
-	dev_dbg(&dev->client->dev, "frequency=%d bandwidth_hz=%d\n",
-			c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev, "frequency=%u bandwidth_hz=%u\n",
+		c->frequency, c->bandwidth_hz);
 
-	/* check bandwidth */
+	/* Check bandwidth */
 	switch (c->bandwidth_hz) {
 	case 6000000:
 		bandwidth_reg_val = 0x00;
@@ -389,26 +389,26 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		bandwidth_reg_val = 0x02;
 		break;
 	default:
-		dev_dbg(&dev->client->dev, "invalid bandwidth_hz\n");
+		dev_dbg(&client->dev, "invalid bandwidth_hz\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	/* program tuner */
+	/* Program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
-	/* program CFOE coefficients */
+	/* Coefficients */
 	if (c->bandwidth_hz != dev->bandwidth_hz) {
 		for (i = 0; i < ARRAY_SIZE(coeff_lut); i++) {
 			if (coeff_lut[i].clock == dev->cfg.clock &&
-				coeff_lut[i].bandwidth_hz == c->bandwidth_hz) {
+			    coeff_lut[i].bandwidth_hz == c->bandwidth_hz) {
 				break;
 			}
 		}
 		if (i == ARRAY_SIZE(coeff_lut)) {
-			dev_err(&dev->client->dev,
-				"Couldn't find LUT config for clock=%d\n",
+			dev_err(&client->dev,
+				"Couldn't find config for clock %u\n",
 				dev->cfg.clock);
 			ret = -EINVAL;
 			goto err;
@@ -420,15 +420,15 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/* program frequency control */
+	/* IF frequency control */
 	if (c->bandwidth_hz != dev->bandwidth_hz) {
 		for (i = 0; i < ARRAY_SIZE(clock_adc_lut); i++) {
 			if (clock_adc_lut[i].clock == dev->cfg.clock)
 				break;
 		}
 		if (i == ARRAY_SIZE(clock_adc_lut)) {
-			dev_err(&dev->client->dev,
-				"Couldn't find ADC clock for clock=%d\n",
+			dev_err(&client->dev,
+				"Couldn't find ADC clock for clock %u\n",
 				dev->cfg.clock);
 			ret = -EINVAL;
 			goto err;
@@ -438,7 +438,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		if (dev->cfg.adc_multiplier == AF9033_ADC_MULTIPLIER_2X)
 			adc_freq = 2 * adc_freq;
 
-		/* get used IF frequency */
+		/* Get used IF frequency */
 		if (fe->ops.tuner_ops.get_if_frequency)
 			fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		else
@@ -457,7 +457,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&dev->client->dev, "if_frequency_cw=%06x\n", utmp);
+		dev_dbg(&client->dev, "if_frequency_cw=%06x\n", utmp);
 
 		dev->bandwidth_hz = c->bandwidth_hz;
 	}
@@ -484,15 +484,14 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	ret = regmap_write(dev->regmap, 0x80004b, tmp);
 	if (ret)
 		goto err;
+	/* Reset FSM */
 	ret = regmap_write(dev->regmap, 0x800000, 0x00);
 	if (ret)
 		goto err;
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -500,12 +499,13 @@ static int af9033_get_frontend(struct dvb_frontend *fe,
 			       struct dtv_frontend_properties *c)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[8];
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
-	/* read all needed registers */
+	/* Read all needed TPS registers */
 	ret = regmap_bulk_read(dev->regmap, 0x80f900, buf, 8);
 	if (ret)
 		goto err;
@@ -616,31 +616,30 @@ static int af9033_get_frontend(struct dvb_frontend *fe,
 	}
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, tmp = 0;
 	u8 buf[7];
 	unsigned int utmp;
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	*status = 0;
 
-	/* radio channel status, 0=no result, 1=has signal, 2=no signal */
+	/* Radio channel status: 0=no result, 1=has signal, 2=no signal */
 	ret = regmap_read(dev->regmap, 0x800047, &utmp);
 	if (ret)
 		goto err;
 
-	/* has signal */
+	/* Has signal */
 	if (utmp == 0x01)
 		*status |= FE_HAS_SIGNAL;
 
@@ -654,7 +653,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI;
 
-		/* full lock */
+		/* Full lock */
 		ret = regmap_read(dev->regmap, 0x80f999, &utmp);
 		if (ret)
 			goto err;
@@ -667,7 +666,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	dev->fe_status = *status;
 
-	/* signal strength */
+	/* Signal strength */
 	if (dev->fe_status & FE_HAS_SIGNAL) {
 		if (dev->is_af9035) {
 			ret = regmap_read(dev->regmap, 0x80004a, &utmp);
@@ -694,14 +693,14 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		u32 snr_val, snr_lut_size;
 		const struct val_snr *snr_lut = NULL;
 
-		/* read value */
+		/* Read raw SNR value */
 		ret = regmap_bulk_read(dev->regmap, 0x80002c, buf, 3);
 		if (ret)
 			goto err;
 
 		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
 
-		/* read superframe number */
+		/* Read superframe number */
 		ret = regmap_read(dev->regmap, 0x80f78b, &utmp);
 		if (ret)
 			goto err;
@@ -709,7 +708,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		if (utmp)
 			snr_val /= utmp;
 
-		/* read current transmission mode */
+		/* Read current transmission mode */
 		ret = regmap_read(dev->regmap, 0x80f900, &utmp);
 		if (ret)
 			goto err;
@@ -729,7 +728,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			break;
 		}
 
-		/* read current modulation */
+		/* Read current modulation */
 		ret = regmap_read(dev->regmap, 0x80f903, &utmp);
 		if (ret)
 			goto err;
@@ -769,9 +768,9 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	/* UCB/PER/BER */
 	if (dev->fe_status & FE_HAS_LOCK) {
-		/* outer FEC, 204 byte packets */
+		/* Outer FEC, 204 byte packets */
 		u16 abort_packet_count, rsd_packet_count;
-		/* inner FEC, bits */
+		/* Inner FEC, bits */
 		u32 rsd_bit_err_count;
 
 		/*
@@ -810,21 +809,22 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	}
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	int ret;
 	unsigned int utmp;
 
-	/* use DVBv5 CNR */
+	dev_dbg(&client->dev, "\n");
+
+	/* Use DVBv5 CNR */
 	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL) {
 		/* Return 0.1 dB for AF9030 and 0-0xffff for IT9130. */
 		if (dev->is_af9035) {
@@ -834,7 +834,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 			/* 1000x => 1x (1 dB) */
 			*snr = div_s64(c->cnr.stat[0].svalue, 1000);
 
-			/* read current modulation */
+			/* Read current modulation */
 			ret = regmap_read(dev->regmap, 0x80f903, &utmp);
 			if (ret)
 				goto err;
@@ -859,28 +859,29 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	}
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	int ret, tmp, power_real;
 	unsigned int utmp;
 	u8 gain_offset, buf[7];
 
+	dev_dbg(&client->dev, "\n");
+
 	if (dev->is_af9035) {
-		/* read signal strength of 0-100 scale */
+		/* Read signal strength of 0-100 scale */
 		ret = regmap_read(dev->regmap, 0x800048, &utmp);
 		if (ret)
 			goto err;
 
-		/* scale value to 0x0000-0xffff */
+		/* Scale value to 0x0000-0xffff */
 		*strength = utmp * 0xffff / 100;
 	} else {
 		ret = regmap_read(dev->regmap, 0x8000f7, &utmp);
@@ -910,15 +911,13 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 		else
 			tmp = 100;
 
-		/* scale value to 0x0000-0xffff */
+		/* Scale value to 0x0000-0xffff */
 		*strength = tmp * 0xffff / 100;
 	}
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -937,56 +936,56 @@ static int af9033_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	struct af9033_dev *dev = fe->demodulator_priv;
 
 	*ucblocks = dev->error_block_count;
+
 	return 0;
 }
 
 static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	dev_dbg(&dev->client->dev, "enable=%d\n", enable);
+	dev_dbg(&client->dev, "enable=%d\n", enable);
 
 	ret = regmap_update_bits(dev->regmap, 0x00fa04, 0x01, enable);
 	if (ret)
 		goto err;
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 
-	dev_dbg(&dev->client->dev, "onoff=%d\n", onoff);
+	dev_dbg(&client->dev, "onoff=%d\n", onoff);
 
 	ret = regmap_update_bits(dev->regmap, 0x80f993, 0x01, onoff);
 	if (ret)
 		goto err;
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
-		int onoff)
+			     int onoff)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
 
-	dev_dbg(&dev->client->dev, "index=%d pid=%04x onoff=%d\n",
-			index, pid, onoff);
+	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d\n",
+		index, pid, onoff);
 
 	if (pid > 0x1fff)
 		return 0;
@@ -1002,15 +1001,13 @@ static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 		goto err;
 
 	return 0;
-
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-static struct dvb_frontend_ops af9033_ops = {
-	.delsys = { SYS_DVBT },
+static const struct dvb_frontend_ops af9033_ops = {
+	.delsys = {SYS_DVBT},
 	.info = {
 		.name = "Afatech AF9033 (DVB-T)",
 		.frequency_min = 174000000,
@@ -1051,7 +1048,7 @@ static struct dvb_frontend_ops af9033_ops = {
 };
 
 static int af9033_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+			const struct i2c_device_id *id)
 {
 	struct af9033_config *cfg = client->dev.platform_data;
 	struct af9033_dev *dev;
@@ -1063,24 +1060,34 @@ static int af9033_probe(struct i2c_client *client,
 		.val_bits    =  8,
 	};
 
-
-	/* allocate memory for the internal state */
-	dev = kzalloc(sizeof(struct af9033_dev), GFP_KERNEL);
-	if (dev == NULL) {
+	/* Allocate memory for the internal state */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "Could not allocate memory for state\n");
 		goto err;
 	}
 
-	/* setup the state */
+	/* Setup the state */
 	dev->client = client;
-	memcpy(&dev->cfg, cfg, sizeof(struct af9033_config));
+	memcpy(&dev->cfg, cfg, sizeof(dev->cfg));
+	switch (dev->cfg.ts_mode) {
+	case AF9033_TS_MODE_PARALLEL:
+		dev->ts_mode_parallel = true;
+		break;
+	case AF9033_TS_MODE_SERIAL:
+		dev->ts_mode_serial = true;
+		break;
+	case AF9033_TS_MODE_USB:
+		/* USB mode for AF9035 */
+	default:
+		break;
+	}
 
 	if (dev->cfg.clock != 12000000) {
 		ret = -ENODEV;
-		dev_err(&dev->client->dev,
-				"unsupported clock %d Hz, only 12000000 Hz is supported currently\n",
-				dev->cfg.clock);
+		dev_err(&client->dev,
+			"Unsupported clock %u Hz. Only 12000000 Hz is supported currently\n",
+			dev->cfg.clock);
 		goto err_kfree;
 	}
 
@@ -1091,7 +1098,7 @@ static int af9033_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
-	/* firmware version */
+	/* Firmware version */
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
@@ -1115,12 +1122,12 @@ static int af9033_probe(struct i2c_client *client,
 	if (ret)
 		goto err_regmap_exit;
 
-	dev_info(&dev->client->dev,
-			"firmware version: LINK %d.%d.%d.%d - OFDM %d.%d.%d.%d\n",
-			buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6],
-			buf[7]);
+	dev_info(&client->dev,
+		 "firmware version: LINK %d.%d.%d.%d - OFDM %d.%d.%d.%d\n",
+		 buf[0], buf[1], buf[2], buf[3],
+		 buf[4], buf[5], buf[6], buf[7]);
 
-	/* sleep */
+	/* Sleep as chip seems to be partly active by default */
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
@@ -1139,22 +1146,8 @@ static int af9033_probe(struct i2c_client *client,
 			goto err_regmap_exit;
 	}
 
-	/* configure internal TS mode */
-	switch (dev->cfg.ts_mode) {
-	case AF9033_TS_MODE_PARALLEL:
-		dev->ts_mode_parallel = true;
-		break;
-	case AF9033_TS_MODE_SERIAL:
-		dev->ts_mode_serial = true;
-		break;
-	case AF9033_TS_MODE_USB:
-		/* usb mode for AF9035 */
-	default:
-		break;
-	}
-
-	/* create dvb_frontend */
-	memcpy(&dev->fe.ops, &af9033_ops, sizeof(struct dvb_frontend_ops));
+	/* Create dvb frontend */
+	memcpy(&dev->fe.ops, &af9033_ops, sizeof(dev->fe.ops));
 	dev->fe.demodulator_priv = dev;
 	*cfg->fe = &dev->fe;
 	if (cfg->ops) {
@@ -1163,7 +1156,8 @@ static int af9033_probe(struct i2c_client *client,
 	}
 	i2c_set_clientdata(client, dev);
 
-	dev_info(&dev->client->dev, "Afatech AF9033 successfully attached\n");
+	dev_info(&client->dev, "Afatech AF9033 successfully attached\n");
+
 	return 0;
 err_regmap_exit:
 	regmap_exit(dev->regmap);
@@ -1178,12 +1172,9 @@ static int af9033_remove(struct i2c_client *client)
 {
 	struct af9033_dev *dev = i2c_get_clientdata(client);
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	regmap_exit(dev->regmap);
-
-	dev->fe.ops.release = NULL;
-	dev->fe.demodulator_priv = NULL;
 	kfree(dev);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 5b83e4f..c87367f 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -23,8 +23,7 @@
 #define AF9033_H
 
 /*
- * I2C address (TODO: are these in 8-bit format?)
- * 0x38, 0x3a, 0x3c, 0x3e
+ * I2C address: 0x1c, 0x1d, 0x1e, 0x1f
  */
 struct af9033_config {
 	/*
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 28d14dc..979b180 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -70,7 +70,7 @@ static const struct clock_adc clock_adc_lut[] = {
 	{ 12000000, 20250000 },
 };
 
-/* pre-calculated coeff lookup table */
+/* Pre-calculated coeff lookup table */
 static const struct coeff coeff_lut[] = {
 	/* 12.000 MHz */
 	{ 12000000, 8000000, {
@@ -189,6 +189,9 @@ static const struct val_snr qam64_snr_lut[] = {
 	{ 0xffffff, 32 },
 };
 
+/*
+ * Afatech AF9033 demod init
+ */
 static const struct reg_val ofsm_init[] = {
 	{ 0x800051, 0x01 },
 	{ 0x800070, 0x0a },
@@ -300,8 +303,10 @@ static const struct reg_val ofsm_init[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* Infineon TUA 9001 tuner init
-   AF9033_TUNER_TUA9001    = 0x27 */
+/*
+ * Infineon TUA 9001 tuner init
+ * AF9033_TUNER_TUA9001    = 0x27
+ */
 static const struct reg_val tuner_init_tua9001[] = {
 	{ 0x800046, 0x27 },
 	{ 0x800057, 0x00 },
@@ -342,8 +347,10 @@ static const struct reg_val tuner_init_tua9001[] = {
 	{ 0x80f1e6, 0x00 },
 };
 
-/* Fitipower fc0011 tuner init
-   AF9033_TUNER_FC0011    = 0x28 */
+/*
+ * Fitipower FC0011 tuner init
+ * AF9033_TUNER_FC0011    = 0x28
+ */
 static const struct reg_val tuner_init_fc0011[] = {
 	{ 0x800046, 0x28 },
 	{ 0x800057, 0x00 },
@@ -403,8 +410,10 @@ static const struct reg_val tuner_init_fc0011[] = {
 	{ 0x80f1e6, 0x00 },
 };
 
-/* Fitipower FC0012 tuner init
-   AF9033_TUNER_FC0012    = 0x2e */
+/*
+ * Fitipower FC0012 tuner init
+ * AF9033_TUNER_FC0012    = 0x2e
+ */
 static const struct reg_val tuner_init_fc0012[] = {
 	{ 0x800046, 0x2e },
 	{ 0x800057, 0x00 },
@@ -446,8 +455,10 @@ static const struct reg_val tuner_init_fc0012[] = {
 	{ 0x80f1e6, 0x00 },
 };
 
-/* MaxLinear MxL5007T tuner init
-   AF9033_TUNER_MXL5007T    = 0xa0 */
+/*
+ * MaxLinear MxL5007T tuner init
+ * AF9033_TUNER_MXL5007T    = 0xa0
+ */
 static const struct reg_val tuner_init_mxl5007t[] = {
 	{ 0x800046, 0x1b },
 	{ 0x800057, 0x01 },
@@ -481,8 +492,10 @@ static const struct reg_val tuner_init_mxl5007t[] = {
 	{ 0x80f1e6, 0x00 },
 };
 
-/* NXP TDA 18218HN tuner init
-   AF9033_TUNER_TDA18218    = 0xa1 */
+/*
+ * NXP TDA18218HN tuner init
+ * AF9033_TUNER_TDA18218    = 0xa1
+ */
 static const struct reg_val tuner_init_tda18218[] = {
 	{0x800046, 0xa1},
 	{0x800057, 0x01},
@@ -515,7 +528,10 @@ static const struct reg_val tuner_init_tda18218[] = {
 	{0x80f1e6, 0x00},
 };
 
-/* FCI FC2580 tuner init */
+/*
+ * FCI FC2580 tuner init
+ * AF9033_TUNER_FC2580      = 0x32
+ */
 static const struct reg_val tuner_init_fc2580[] = {
 	{ 0x800046, 0x32 },
 	{ 0x800057, 0x01 },
@@ -553,6 +569,9 @@ static const struct reg_val tuner_init_fc2580[] = {
 	{ 0x80f1e6, 0x01 },
 };
 
+/*
+ * IT9133 AX demod init
+ */
 static const struct reg_val ofsm_init_it9135_v1[] = {
 	{ 0x800051, 0x01 },
 	{ 0x800070, 0x0a },
@@ -664,8 +683,10 @@ static const struct reg_val ofsm_init_it9135_v1[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* ITE Tech IT9135 Omega tuner init
-   AF9033_TUNER_IT9135_38   = 0x38 */
+/*
+ * ITE Tech IT9133 AX Omega tuner init
+ * AF9033_TUNER_IT9135_38   = 0x38
+ */
 static const struct reg_val tuner_init_it9135_38[] = {
 	{ 0x800043, 0x00 },
 	{ 0x800046, 0x38 },
@@ -881,8 +902,10 @@ static const struct reg_val tuner_init_it9135_38[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* ITE Tech IT9135 Omega LNA config 1 tuner init
-   AF9033_TUNER_IT9135_51   = 0x51 */
+/*
+ * ITE Tech IT9133 AX Omega LNA config 1 tuner init
+ * AF9033_TUNER_IT9135_51   = 0x51
+ */
 static const struct reg_val tuner_init_it9135_51[] = {
 	{ 0x800043, 0x00 },
 	{ 0x800046, 0x51 },
@@ -1098,8 +1121,10 @@ static const struct reg_val tuner_init_it9135_51[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* ITE Tech IT9135 Omega LNA config 2 tuner init
-   AF9033_TUNER_IT9135_52   = 0x52 */
+/*
+ * ITE Tech IT9133 AX Omega LNA config 2 tuner init
+ * AF9033_TUNER_IT9135_52   = 0x52
+ */
 static const struct reg_val tuner_init_it9135_52[] = {
 	{ 0x800043, 0x00 },
 	{ 0x800046, 0x52 },
@@ -1315,6 +1340,9 @@ static const struct reg_val tuner_init_it9135_52[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
+/*
+ * ITE Tech IT9133 BX demod init
+ */
 static const struct reg_val ofsm_init_it9135_v2[] = {
 	{ 0x800051, 0x01 },
 	{ 0x800070, 0x0a },
@@ -1413,8 +1441,10 @@ static const struct reg_val ofsm_init_it9135_v2[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* ITE Tech IT9135 Omega v2 tuner init
-   AF9033_TUNER_IT9135_60   = 0x60 */
+/*
+ * ITE Tech IT9133 BX Omega tuner init
+ * AF9033_TUNER_IT9135_60   = 0x60
+ */
 static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800043, 0x00 },
 	{ 0x800046, 0x60 },
@@ -1627,8 +1657,10 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* ITE Tech IT9135 Omega v2 LNA config 1 tuner init
-   AF9033_TUNER_IT9135_61   = 0x61 */
+/*
+ * ITE Tech IT9133 BX Omega LNA config 1 tuner init
+ * AF9033_TUNER_IT9135_61   = 0x61
+ */
 static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x800043, 0x00 },
 	{ 0x800046, 0x61 },
@@ -1841,8 +1873,10 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
-/* ITE Tech IT9135 Omega v2 LNA config 2 tuner init
-   AF9033_TUNER_IT9135_62   = 0x62 */
+/*
+ * ITE Tech IT9133 BX Omega LNA config 2 tuner init
+ * AF9033_TUNER_IT9135_62   = 0x62
+ */
 static const struct reg_val tuner_init_it9135_62[] = {
 	{ 0x800043, 0x00 },
 	{ 0x800046, 0x62 },
-- 
http://palosaari.fi/

