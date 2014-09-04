Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43732 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbaIDChD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 23/37] af9033: rename 'state' to 'dev'
Date: Thu,  4 Sep 2014 05:36:31 +0300
Message-Id: <1409798205-25645-23-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

foo_dev seems to be most correct term for the structure holding data
of each device instance. It is most used term in Kernel codebase and also
examples from book Linux Device Drivers, Third Edition, uses it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 328 +++++++++++++++++------------------
 1 file changed, 164 insertions(+), 164 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 7d637b9..43b7335 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -24,7 +24,7 @@
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
 
-struct af9033_state {
+struct af9033_dev {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	struct af9033_config cfg;
@@ -39,14 +39,14 @@ struct af9033_state {
 };
 
 /* write multiple registers */
-static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
+static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
 		int len)
 {
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = state->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = 3 + len,
 			.buf = buf,
@@ -54,7 +54,7 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 	};
 
 	if (3 + len > sizeof(buf)) {
-		dev_warn(&state->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -65,11 +65,11 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 	buf[2] = (reg >>  0) & 0xff;
 	memcpy(&buf[3], val, len);
 
-	ret = i2c_transfer(state->i2c, msg, 1);
+	ret = i2c_transfer(dev->i2c, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&state->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 				"%s: i2c wr failed=%d reg=%06x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -79,30 +79,30 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 }
 
 /* read multiple registers */
-static int af9033_rd_regs(struct af9033_state *state, u32 reg, u8 *val, int len)
+static int af9033_rd_regs(struct af9033_dev *dev, u32 reg, u8 *val, int len)
 {
 	int ret;
 	u8 buf[3] = { (reg >> 16) & 0xff, (reg >> 8) & 0xff,
 			(reg >> 0) & 0xff };
 	struct i2c_msg msg[2] = {
 		{
-			.addr = state->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf
 		}, {
-			.addr = state->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val
 		}
 	};
 
-	ret = i2c_transfer(state->i2c, msg, 2);
+	ret = i2c_transfer(dev->i2c, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&state->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 				"%s: i2c rd failed=%d reg=%06x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -113,19 +113,19 @@ static int af9033_rd_regs(struct af9033_state *state, u32 reg, u8 *val, int len)
 
 
 /* write single register */
-static int af9033_wr_reg(struct af9033_state *state, u32 reg, u8 val)
+static int af9033_wr_reg(struct af9033_dev *dev, u32 reg, u8 val)
 {
-	return af9033_wr_regs(state, reg, &val, 1);
+	return af9033_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register */
-static int af9033_rd_reg(struct af9033_state *state, u32 reg, u8 *val)
+static int af9033_rd_reg(struct af9033_dev *dev, u32 reg, u8 *val)
 {
-	return af9033_rd_regs(state, reg, val, 1);
+	return af9033_rd_regs(dev, reg, val, 1);
 }
 
 /* write single register with mask */
-static int af9033_wr_reg_mask(struct af9033_state *state, u32 reg, u8 val,
+static int af9033_wr_reg_mask(struct af9033_dev *dev, u32 reg, u8 val,
 		u8 mask)
 {
 	int ret;
@@ -133,7 +133,7 @@ static int af9033_wr_reg_mask(struct af9033_state *state, u32 reg, u8 val,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = af9033_rd_regs(state, reg, &tmp, 1);
+		ret = af9033_rd_regs(dev, reg, &tmp, 1);
 		if (ret)
 			return ret;
 
@@ -142,17 +142,17 @@ static int af9033_wr_reg_mask(struct af9033_state *state, u32 reg, u8 val,
 		val |= tmp;
 	}
 
-	return af9033_wr_regs(state, reg, &val, 1);
+	return af9033_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register with mask */
-static int af9033_rd_reg_mask(struct af9033_state *state, u32 reg, u8 *val,
+static int af9033_rd_reg_mask(struct af9033_dev *dev, u32 reg, u8 *val,
 		u8 mask)
 {
 	int ret, i;
 	u8 tmp;
 
-	ret = af9033_rd_regs(state, reg, &tmp, 1);
+	ret = af9033_rd_regs(dev, reg, &tmp, 1);
 	if (ret)
 		return ret;
 
@@ -169,17 +169,17 @@ static int af9033_rd_reg_mask(struct af9033_state *state, u32 reg, u8 *val,
 }
 
 /* write reg val table using reg addr auto increment */
-static int af9033_wr_reg_val_tab(struct af9033_state *state,
+static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 		const struct reg_val *tab, int tab_len)
 {
 #define MAX_TAB_LEN 212
 	int ret, i, j;
 	u8 buf[1 + MAX_TAB_LEN];
 
-	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
+	dev_dbg(&dev->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
 	if (tab_len > sizeof(buf)) {
-		dev_warn(&state->i2c->dev, "%s: tab len %d is too big\n",
+		dev_warn(&dev->i2c->dev, "%s: tab len %d is too big\n",
 				KBUILD_MODNAME, tab_len);
 		return -EINVAL;
 	}
@@ -188,7 +188,7 @@ static int af9033_wr_reg_val_tab(struct af9033_state *state,
 		buf[j] = tab[i].val;
 
 		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1) {
-			ret = af9033_wr_regs(state, tab[i].reg - j, buf, j + 1);
+			ret = af9033_wr_regs(dev, tab[i].reg - j, buf, j + 1);
 			if (ret < 0)
 				goto err;
 
@@ -201,16 +201,16 @@ static int af9033_wr_reg_val_tab(struct af9033_state *state,
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
-static u32 af9033_div(struct af9033_state *state, u32 a, u32 b, u32 x)
+static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
 
-	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
+	dev_dbg(&dev->i2c->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
 
 	if (a > b) {
 		c = a / b;
@@ -227,7 +227,7 @@ static u32 af9033_div(struct af9033_state *state, u32 a, u32 b, u32 x)
 	}
 	r = (c << (u32)x) + r;
 
-	dev_dbg(&state->i2c->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
+	dev_dbg(&dev->i2c->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
 			__func__, a, b, x, r, r);
 
 	return r;
@@ -235,14 +235,14 @@ static u32 af9033_div(struct af9033_state *state, u32 a, u32 b, u32 x)
 
 static void af9033_release(struct dvb_frontend *fe)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 
-	kfree(state);
+	kfree(dev);
 }
 
 static int af9033_init(struct dvb_frontend *fe)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret, i, len;
 	const struct reg_val *init;
 	u8 buf[4];
@@ -250,7 +250,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	struct reg_val_mask tab[] = {
 		{ 0x80fb24, 0x00, 0x08 },
 		{ 0x80004c, 0x00, 0xff },
-		{ 0x00f641, state->cfg.tuner, 0xff },
+		{ 0x00f641, dev->cfg.tuner, 0xff },
 		{ 0x80f5ca, 0x01, 0x01 },
 		{ 0x80f715, 0x01, 0x01 },
 		{ 0x00f41f, 0x04, 0x04 },
@@ -269,82 +269,82 @@ static int af9033_init(struct dvb_frontend *fe)
 		{ 0x00d830, 0x01, 0xff },
 		{ 0x00d831, 0x00, 0xff },
 		{ 0x00d832, 0x00, 0xff },
-		{ 0x80f985, state->ts_mode_serial, 0x01 },
-		{ 0x80f986, state->ts_mode_parallel, 0x01 },
+		{ 0x80f985, dev->ts_mode_serial, 0x01 },
+		{ 0x80f986, dev->ts_mode_parallel, 0x01 },
 		{ 0x00d827, 0x00, 0xff },
 		{ 0x00d829, 0x00, 0xff },
-		{ 0x800045, state->cfg.adc_multiplier, 0xff },
+		{ 0x800045, dev->cfg.adc_multiplier, 0xff },
 	};
 
 	/* program clock control */
-	clock_cw = af9033_div(state, state->cfg.clock, 1000000ul, 19ul);
+	clock_cw = af9033_div(dev, dev->cfg.clock, 1000000ul, 19ul);
 	buf[0] = (clock_cw >>  0) & 0xff;
 	buf[1] = (clock_cw >>  8) & 0xff;
 	buf[2] = (clock_cw >> 16) & 0xff;
 	buf[3] = (clock_cw >> 24) & 0xff;
 
-	dev_dbg(&state->i2c->dev, "%s: clock=%d clock_cw=%08x\n",
-			__func__, state->cfg.clock, clock_cw);
+	dev_dbg(&dev->i2c->dev, "%s: clock=%d clock_cw=%08x\n",
+			__func__, dev->cfg.clock, clock_cw);
 
-	ret = af9033_wr_regs(state, 0x800025, buf, 4);
+	ret = af9033_wr_regs(dev, 0x800025, buf, 4);
 	if (ret < 0)
 		goto err;
 
 	/* program ADC control */
 	for (i = 0; i < ARRAY_SIZE(clock_adc_lut); i++) {
-		if (clock_adc_lut[i].clock == state->cfg.clock)
+		if (clock_adc_lut[i].clock == dev->cfg.clock)
 			break;
 	}
 
-	adc_cw = af9033_div(state, clock_adc_lut[i].adc, 1000000ul, 19ul);
+	adc_cw = af9033_div(dev, clock_adc_lut[i].adc, 1000000ul, 19ul);
 	buf[0] = (adc_cw >>  0) & 0xff;
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
 
-	dev_dbg(&state->i2c->dev, "%s: adc=%d adc_cw=%06x\n",
+	dev_dbg(&dev->i2c->dev, "%s: adc=%d adc_cw=%06x\n",
 			__func__, clock_adc_lut[i].adc, adc_cw);
 
-	ret = af9033_wr_regs(state, 0x80f1cd, buf, 3);
+	ret = af9033_wr_regs(dev, 0x80f1cd, buf, 3);
 	if (ret < 0)
 		goto err;
 
 	/* program register table */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = af9033_wr_reg_mask(state, tab[i].reg, tab[i].val,
+		ret = af9033_wr_reg_mask(dev, tab[i].reg, tab[i].val,
 				tab[i].mask);
 		if (ret < 0)
 			goto err;
 	}
 
 	/* clock output */
-	if (state->cfg.dyn0_clk) {
-		ret = af9033_wr_reg(state, 0x80fba8, 0x00);
+	if (dev->cfg.dyn0_clk) {
+		ret = af9033_wr_reg(dev, 0x80fba8, 0x00);
 		if (ret < 0)
 			goto err;
 	}
 
 	/* settings for TS interface */
-	if (state->cfg.ts_mode == AF9033_TS_MODE_USB) {
-		ret = af9033_wr_reg_mask(state, 0x80f9a5, 0x00, 0x01);
+	if (dev->cfg.ts_mode == AF9033_TS_MODE_USB) {
+		ret = af9033_wr_reg_mask(dev, 0x80f9a5, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 
-		ret = af9033_wr_reg_mask(state, 0x80f9b5, 0x01, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x80f9b5, 0x01, 0x01);
 		if (ret < 0)
 			goto err;
 	} else {
-		ret = af9033_wr_reg_mask(state, 0x80f990, 0x00, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x80f990, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 
-		ret = af9033_wr_reg_mask(state, 0x80f9b5, 0x00, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x80f9b5, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 	}
 
 	/* load OFSM settings */
-	dev_dbg(&state->i2c->dev, "%s: load ofsm settings\n", __func__);
-	switch (state->cfg.tuner) {
+	dev_dbg(&dev->i2c->dev, "%s: load ofsm settings\n", __func__);
+	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
@@ -363,14 +363,14 @@ static int af9033_init(struct dvb_frontend *fe)
 		break;
 	}
 
-	ret = af9033_wr_reg_val_tab(state, init, len);
+	ret = af9033_wr_reg_val_tab(dev, init, len);
 	if (ret < 0)
 		goto err;
 
 	/* load tuner specific settings */
-	dev_dbg(&state->i2c->dev, "%s: load tuner specific settings\n",
+	dev_dbg(&dev->i2c->dev, "%s: load tuner specific settings\n",
 			__func__);
-	switch (state->cfg.tuner) {
+	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_TUA9001:
 		len = ARRAY_SIZE(tuner_init_tua9001);
 		init = tuner_init_tua9001;
@@ -420,90 +420,90 @@ static int af9033_init(struct dvb_frontend *fe)
 		init = tuner_init_it9135_62;
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: unsupported tuner ID=%d\n",
-				__func__, state->cfg.tuner);
+		dev_dbg(&dev->i2c->dev, "%s: unsupported tuner ID=%d\n",
+				__func__, dev->cfg.tuner);
 		ret = -ENODEV;
 		goto err;
 	}
 
-	ret = af9033_wr_reg_val_tab(state, init, len);
+	ret = af9033_wr_reg_val_tab(dev, init, len);
 	if (ret < 0)
 		goto err;
 
-	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
-		ret = af9033_wr_reg_mask(state, 0x00d91c, 0x01, 0x01);
+	if (dev->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
+		ret = af9033_wr_reg_mask(dev, 0x00d91c, 0x01, 0x01);
 		if (ret < 0)
 			goto err;
 
-		ret = af9033_wr_reg_mask(state, 0x00d917, 0x00, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x00d917, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 
-		ret = af9033_wr_reg_mask(state, 0x00d916, 0x00, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x00d916, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 	}
 
-	switch (state->cfg.tuner) {
+	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
-		ret = af9033_wr_reg(state, 0x800000, 0x01);
+		ret = af9033_wr_reg(dev, 0x800000, 0x01);
 		if (ret < 0)
 			goto err;
 	}
 
-	state->bandwidth_hz = 0; /* force to program all parameters */
+	dev->bandwidth_hz = 0; /* force to program all parameters */
 
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_sleep(struct dvb_frontend *fe)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret, i;
 	u8 tmp;
 
-	ret = af9033_wr_reg(state, 0x80004c, 1);
+	ret = af9033_wr_reg(dev, 0x80004c, 1);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg(state, 0x800000, 0);
+	ret = af9033_wr_reg(dev, 0x800000, 0);
 	if (ret < 0)
 		goto err;
 
 	for (i = 100, tmp = 1; i && tmp; i--) {
-		ret = af9033_rd_reg(state, 0x80004c, &tmp);
+		ret = af9033_rd_reg(dev, 0x80004c, &tmp);
 		if (ret < 0)
 			goto err;
 
 		usleep_range(200, 10000);
 	}
 
-	dev_dbg(&state->i2c->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&dev->i2c->dev, "%s: loop=%d\n", __func__, i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
 		goto err;
 	}
 
-	ret = af9033_wr_reg_mask(state, 0x80fb24, 0x08, 0x08);
+	ret = af9033_wr_reg_mask(dev, 0x80fb24, 0x08, 0x08);
 	if (ret < 0)
 		goto err;
 
 	/* prevent current leak (?) */
-	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
+	if (dev->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
 		/* enable parallel TS */
-		ret = af9033_wr_reg_mask(state, 0x00d917, 0x00, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x00d917, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
 
-		ret = af9033_wr_reg_mask(state, 0x00d916, 0x01, 0x01);
+		ret = af9033_wr_reg_mask(dev, 0x00d916, 0x01, 0x01);
 		if (ret < 0)
 			goto err;
 	}
@@ -511,7 +511,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -529,13 +529,13 @@ static int af9033_get_tune_settings(struct dvb_frontend *fe,
 
 static int af9033_set_frontend(struct dvb_frontend *fe)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, spec_inv, sampling_freq;
 	u8 tmp, buf[3], bandwidth_reg_val;
 	u32 if_frequency, freq_cw, adc_freq;
 
-	dev_dbg(&state->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
+	dev_dbg(&dev->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
 			__func__, c->frequency, c->bandwidth_hz);
 
 	/* check bandwidth */
@@ -550,7 +550,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		bandwidth_reg_val = 0x02;
 		break;
 	default:
-		dev_dbg(&state->i2c->dev, "%s: invalid bandwidth_hz\n",
+		dev_dbg(&dev->i2c->dev, "%s: invalid bandwidth_hz\n",
 				__func__);
 		ret = -EINVAL;
 		goto err;
@@ -561,23 +561,23 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* program CFOE coefficients */
-	if (c->bandwidth_hz != state->bandwidth_hz) {
+	if (c->bandwidth_hz != dev->bandwidth_hz) {
 		for (i = 0; i < ARRAY_SIZE(coeff_lut); i++) {
-			if (coeff_lut[i].clock == state->cfg.clock &&
+			if (coeff_lut[i].clock == dev->cfg.clock &&
 				coeff_lut[i].bandwidth_hz == c->bandwidth_hz) {
 				break;
 			}
 		}
-		ret =  af9033_wr_regs(state, 0x800001,
+		ret =  af9033_wr_regs(dev, 0x800001,
 				coeff_lut[i].val, sizeof(coeff_lut[i].val));
 	}
 
 	/* program frequency control */
-	if (c->bandwidth_hz != state->bandwidth_hz) {
-		spec_inv = state->cfg.spec_inv ? -1 : 1;
+	if (c->bandwidth_hz != dev->bandwidth_hz) {
+		spec_inv = dev->cfg.spec_inv ? -1 : 1;
 
 		for (i = 0; i < ARRAY_SIZE(clock_adc_lut); i++) {
-			if (clock_adc_lut[i].clock == state->cfg.clock)
+			if (clock_adc_lut[i].clock == dev->cfg.clock)
 				break;
 		}
 		adc_freq = clock_adc_lut[i].adc;
@@ -598,12 +598,12 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		else
 			sampling_freq *= -1;
 
-		freq_cw = af9033_div(state, sampling_freq, adc_freq, 23ul);
+		freq_cw = af9033_div(dev, sampling_freq, adc_freq, 23ul);
 
 		if (spec_inv == -1)
 			freq_cw = 0x800000 - freq_cw;
 
-		if (state->cfg.adc_multiplier == AF9033_ADC_MULTIPLIER_2X)
+		if (dev->cfg.adc_multiplier == AF9033_ADC_MULTIPLIER_2X)
 			freq_cw /= 2;
 
 		buf[0] = (freq_cw >>  0) & 0xff;
@@ -614,26 +614,26 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		if (if_frequency == 0)
 			buf[2] = 0;
 
-		ret = af9033_wr_regs(state, 0x800029, buf, 3);
+		ret = af9033_wr_regs(dev, 0x800029, buf, 3);
 		if (ret < 0)
 			goto err;
 
-		state->bandwidth_hz = c->bandwidth_hz;
+		dev->bandwidth_hz = c->bandwidth_hz;
 	}
 
-	ret = af9033_wr_reg_mask(state, 0x80f904, bandwidth_reg_val, 0x03);
+	ret = af9033_wr_reg_mask(dev, 0x80f904, bandwidth_reg_val, 0x03);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg(state, 0x800040, 0x00);
+	ret = af9033_wr_reg(dev, 0x800040, 0x00);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg(state, 0x800047, 0x00);
+	ret = af9033_wr_reg(dev, 0x800047, 0x00);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg_mask(state, 0x80f999, 0x00, 0x01);
+	ret = af9033_wr_reg_mask(dev, 0x80f999, 0x00, 0x01);
 	if (ret < 0)
 		goto err;
 
@@ -642,33 +642,33 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	else
 		tmp = 0x01; /* UHF */
 
-	ret = af9033_wr_reg(state, 0x80004b, tmp);
+	ret = af9033_wr_reg(dev, 0x80004b, tmp);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg(state, 0x800000, 0x00);
+	ret = af9033_wr_reg(dev, 0x800000, 0x00);
 	if (ret < 0)
 		goto err;
 
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_get_frontend(struct dvb_frontend *fe)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[8];
 
-	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
 
 	/* read all needed registers */
-	ret = af9033_rd_regs(state, 0x80f900, buf, sizeof(buf));
+	ret = af9033_rd_regs(dev, 0x80f900, buf, sizeof(buf));
 	if (ret < 0)
 		goto err;
 
@@ -780,21 +780,21 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 tmp;
 
 	*status = 0;
 
 	/* radio channel status, 0=no result, 1=has signal, 2=no signal */
-	ret = af9033_rd_reg(state, 0x800047, &tmp);
+	ret = af9033_rd_reg(dev, 0x800047, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -804,7 +804,7 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	if (tmp != 0x02) {
 		/* TPS lock */
-		ret = af9033_rd_reg_mask(state, 0x80f5a9, &tmp, 0x01);
+		ret = af9033_rd_reg_mask(dev, 0x80f5a9, &tmp, 0x01);
 		if (ret < 0)
 			goto err;
 
@@ -813,7 +813,7 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 					FE_HAS_VITERBI;
 
 		/* full lock */
-		ret = af9033_rd_reg_mask(state, 0x80f999, &tmp, 0x01);
+		ret = af9033_rd_reg_mask(dev, 0x80f999, &tmp, 0x01);
 		if (ret < 0)
 			goto err;
 
@@ -826,28 +826,28 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret, i, len;
 	u8 buf[3], tmp;
 	u32 snr_val;
 	const struct val_snr *snr_lut;
 
 	/* read value */
-	ret = af9033_rd_regs(state, 0x80002c, buf, 3);
+	ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
 	if (ret < 0)
 		goto err;
 
 	snr_val = (buf[2] << 16) | (buf[1] << 8) | buf[0];
 
 	/* read current modulation */
-	ret = af9033_rd_reg(state, 0x80f903, &tmp);
+	ret = af9033_rd_reg(dev, 0x80f903, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -880,19 +880,19 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 strength2;
 
 	/* read signal strength of 0-100 scale */
-	ret = af9033_rd_reg(state, 0x800048, &strength2);
+	ret = af9033_rd_reg(dev, 0x800048, &strength2);
 	if (ret < 0)
 		goto err;
 
@@ -902,12 +902,12 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
-static int af9033_update_ch_stat(struct af9033_state *state)
+static int af9033_update_ch_stat(struct af9033_dev *dev)
 {
 	int ret = 0;
 	u32 err_cnt, bit_cnt;
@@ -915,8 +915,8 @@ static int af9033_update_ch_stat(struct af9033_state *state)
 	u8 buf[7];
 
 	/* only update data every half second */
-	if (time_after(jiffies, state->last_stat_check + msecs_to_jiffies(500))) {
-		ret = af9033_rd_regs(state, 0x800032, buf, sizeof(buf));
+	if (time_after(jiffies, dev->last_stat_check + msecs_to_jiffies(500))) {
+		ret = af9033_rd_regs(dev, 0x800032, buf, sizeof(buf));
 		if (ret < 0)
 			goto err;
 		/* in 8 byte packets? */
@@ -928,93 +928,93 @@ static int af9033_update_ch_stat(struct af9033_state *state)
 
 		if (bit_cnt < abort_cnt) {
 			abort_cnt = 1000;
-			state->ber = 0xffffffff;
+			dev->ber = 0xffffffff;
 		} else {
 			/*
 			 * 8 byte packets, that have not been rejected already
 			 */
 			bit_cnt -= (u32)abort_cnt;
 			if (bit_cnt == 0) {
-				state->ber = 0xffffffff;
+				dev->ber = 0xffffffff;
 			} else {
 				err_cnt -= (u32)abort_cnt * 8 * 8;
 				bit_cnt *= 8 * 8;
-				state->ber = err_cnt * (0xffffffff / bit_cnt);
+				dev->ber = err_cnt * (0xffffffff / bit_cnt);
 			}
 		}
-		state->ucb += abort_cnt;
-		state->last_stat_check = jiffies;
+		dev->ucb += abort_cnt;
+		dev->last_stat_check = jiffies;
 	}
 
 	return 0;
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	ret = af9033_update_ch_stat(state);
+	ret = af9033_update_ch_stat(dev);
 	if (ret < 0)
 		return ret;
 
-	*ber = state->ber;
+	*ber = dev->ber;
 
 	return 0;
 }
 
 static int af9033_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	ret = af9033_update_ch_stat(state);
+	ret = af9033_update_ch_stat(dev);
 	if (ret < 0)
 		return ret;
 
-	*ucblocks = state->ucb;
+	*ucblocks = dev->ucb;
 
 	return 0;
 }
 
 static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&state->i2c->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&dev->i2c->dev, "%s: enable=%d\n", __func__, enable);
 
-	ret = af9033_wr_reg_mask(state, 0x00fa04, enable, 0x01);
+	ret = af9033_wr_reg_mask(dev, 0x00fa04, enable, 0x01);
 	if (ret < 0)
 		goto err;
 
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
 static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&state->i2c->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&dev->i2c->dev, "%s: onoff=%d\n", __func__, onoff);
 
-	ret = af9033_wr_reg_mask(state, 0x80f993, onoff, 0x01);
+	ret = af9033_wr_reg_mask(dev, 0x80f993, onoff, 0x01);
 	if (ret < 0)
 		goto err;
 
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -1022,32 +1022,32 @@ err:
 static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 		int onoff)
 {
-	struct af9033_state *state = fe->demodulator_priv;
+	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
 
-	dev_dbg(&state->i2c->dev, "%s: index=%d pid=%04x onoff=%d\n",
+	dev_dbg(&dev->i2c->dev, "%s: index=%d pid=%04x onoff=%d\n",
 			__func__, index, pid, onoff);
 
 	if (pid > 0x1fff)
 		return 0;
 
-	ret = af9033_wr_regs(state, 0x80f996, wbuf, 2);
+	ret = af9033_wr_regs(dev, 0x80f996, wbuf, 2);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg(state, 0x80f994, onoff);
+	ret = af9033_wr_reg(dev, 0x80f994, onoff);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_wr_reg(state, 0x80f995, index);
+	ret = af9033_wr_reg(dev, 0x80f995, index);
 	if (ret < 0)
 		goto err;
 
 	return 0;
 
 err:
-	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -1059,30 +1059,30 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 				   struct af9033_ops *ops)
 {
 	int ret;
-	struct af9033_state *state;
+	struct af9033_dev *dev;
 	u8 buf[8];
 	u32 reg;
 
 	dev_dbg(&i2c->dev, "%s:\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct af9033_state), GFP_KERNEL);
-	if (state == NULL)
+	dev = kzalloc(sizeof(struct af9033_dev), GFP_KERNEL);
+	if (dev == NULL)
 		goto err;
 
 	/* setup the state */
-	state->i2c = i2c;
-	memcpy(&state->cfg, config, sizeof(struct af9033_config));
+	dev->i2c = i2c;
+	memcpy(&dev->cfg, config, sizeof(struct af9033_config));
 
-	if (state->cfg.clock != 12000000) {
-		dev_err(&state->i2c->dev,
+	if (dev->cfg.clock != 12000000) {
+		dev_err(&dev->i2c->dev,
 				"%s: af9033: unsupported clock=%d, only 12000000 Hz is supported currently\n",
-				KBUILD_MODNAME, state->cfg.clock);
+				KBUILD_MODNAME, dev->cfg.clock);
 		goto err;
 	}
 
 	/* firmware version */
-	switch (state->cfg.tuner) {
+	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
@@ -1096,21 +1096,21 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 		break;
 	}
 
-	ret = af9033_rd_regs(state, reg, &buf[0], 4);
+	ret = af9033_rd_regs(dev, reg, &buf[0], 4);
 	if (ret < 0)
 		goto err;
 
-	ret = af9033_rd_regs(state, 0x804191, &buf[4], 4);
+	ret = af9033_rd_regs(dev, 0x804191, &buf[4], 4);
 	if (ret < 0)
 		goto err;
 
-	dev_info(&state->i2c->dev,
+	dev_info(&dev->i2c->dev,
 			"%s: firmware version: LINK=%d.%d.%d.%d OFDM=%d.%d.%d.%d\n",
 			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3], buf[4],
 			buf[5], buf[6], buf[7]);
 
 	/* sleep */
-	switch (state->cfg.tuner) {
+	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
@@ -1120,22 +1120,22 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 		/* IT9135 did not like to sleep at that early */
 		break;
 	default:
-		ret = af9033_wr_reg(state, 0x80004c, 1);
+		ret = af9033_wr_reg(dev, 0x80004c, 1);
 		if (ret < 0)
 			goto err;
 
-		ret = af9033_wr_reg(state, 0x800000, 0);
+		ret = af9033_wr_reg(dev, 0x800000, 0);
 		if (ret < 0)
 			goto err;
 	}
 
 	/* configure internal TS mode */
-	switch (state->cfg.ts_mode) {
+	switch (dev->cfg.ts_mode) {
 	case AF9033_TS_MODE_PARALLEL:
-		state->ts_mode_parallel = true;
+		dev->ts_mode_parallel = true;
 		break;
 	case AF9033_TS_MODE_SERIAL:
-		state->ts_mode_serial = true;
+		dev->ts_mode_serial = true;
 		break;
 	case AF9033_TS_MODE_USB:
 		/* usb mode for AF9035 */
@@ -1144,18 +1144,18 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	}
 
 	/* create dvb_frontend */
-	memcpy(&state->fe.ops, &af9033_ops, sizeof(struct dvb_frontend_ops));
-	state->fe.demodulator_priv = state;
+	memcpy(&dev->fe.ops, &af9033_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.demodulator_priv = dev;
 
 	if (ops) {
 		ops->pid_filter = af9033_pid_filter;
 		ops->pid_filter_ctrl = af9033_pid_filter_ctrl;
 	}
 
-	return &state->fe;
+	return &dev->fe;
 
 err:
-	kfree(state);
+	kfree(dev);
 	return NULL;
 }
 EXPORT_SYMBOL(af9033_attach);
-- 
http://palosaari.fi/

