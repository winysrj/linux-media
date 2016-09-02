Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33566 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753944AbcIBWht (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/9] cxd2820r: correct logging
Date: Sat,  3 Sep 2016 01:37:22 +0300
Message-Id: <1472855844-8665-7-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use correct device for logging functions as we now have it due to
proper I2C client bindings.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_c.c    |  33 +++++---
 drivers/media/dvb-frontends/cxd2820r_core.c | 115 +++++++++++++++-------------
 drivers/media/dvb-frontends/cxd2820r_t.c    |  32 +++++---
 drivers/media/dvb-frontends/cxd2820r_t2.c   |  34 ++++----
 4 files changed, 123 insertions(+), 91 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 0d036e1..beb46a6 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -24,6 +24,7 @@
 int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	unsigned int utmp;
@@ -47,8 +48,10 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 		{ 0x10071, !priv->ts_clk_inv << 4, 0x10 },
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s: frequency=%d symbol_rate=%d\n", __func__,
-			c->frequency, c->symbol_rate);
+	dev_dbg(&client->dev,
+		"delivery_system=%d modulation=%d frequency=%u symbol_rate=%u inversion=%d\n",
+		c->delivery_system, c->modulation, c->frequency,
+		c->symbol_rate, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -71,8 +74,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		if (ret)
 			goto error;
-		dev_dbg(&priv->i2c->dev, "%s: if_frequency=%u\n", __func__,
-			if_frequency);
+		dev_dbg(&client->dev, "if_frequency=%u\n", if_frequency);
 	} else {
 		ret = -EINVAL;
 		goto error;
@@ -95,7 +97,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -103,9 +105,12 @@ int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
 			    struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret;
 	u8 buf[2];
 
+	dev_dbg(&client->dev, "\n");
+
 	ret = cxd2820r_rd_regs(priv, 0x1001a, buf, 2);
 	if (ret)
 		goto error;
@@ -145,13 +150,14 @@ int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	unsigned int utmp;
@@ -172,8 +178,7 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 		}
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: lock=%02x %02x\n", __func__, buf[0],
-			buf[1]);
+	dev_dbg(&client->dev, "lock=%*ph\n", 2, buf);
 
 	/* Signal strength */
 	if (*status & FE_HAS_SIGNAL) {
@@ -275,28 +280,32 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_init_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret;
 
+	dev_dbg(&client->dev, "\n");
+
 	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
 	if (ret)
 		goto error;
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_sleep_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret, i;
 	struct reg_val_mask tab[] = {
 		{ 0x000ff, 0x1f, 0xff },
@@ -306,7 +315,7 @@ int cxd2820r_sleep_c(struct dvb_frontend *fe)
 		{ 0x00080, 0x00, 0xff },
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	priv->delivery_system = SYS_UNDEFINED;
 
@@ -319,7 +328,7 @@ int cxd2820r_sleep_c(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index cf5eed4..e222217 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -28,6 +28,7 @@
 static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
 {
+	struct i2c_client *client = priv->client[0];
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
@@ -40,9 +41,8 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
+			 reg, len);
 		return -EINVAL;
 	}
 
@@ -53,8 +53,8 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -64,6 +64,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
 {
+	struct i2c_client *client = priv->client[0];
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
@@ -81,9 +82,8 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	};
 
 	if (len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
+			 reg, len);
 		return -EINVAL;
 	}
 
@@ -92,8 +92,8 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -188,11 +188,12 @@ int cxd2820r_wr_reg_mask(struct cxd2820r_priv *priv, u32 reg, u8 val,
 int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 tmp0, tmp1;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	/* update GPIOs only when needed */
 	if (!memcmp(gpio, priv->gpio, sizeof(priv->gpio)))
@@ -219,12 +220,10 @@ int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio)
 		else
 			tmp1 |= (0 << (0 + i));
 
-		dev_dbg(&priv->i2c->dev, "%s: gpio i=%d %02x %02x\n", __func__,
-				i, tmp0, tmp1);
+		dev_dbg(&client->dev, "gpio i=%d %02x %02x\n", i, tmp0, tmp1);
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: wr gpio=%02x %02x\n", __func__, tmp0,
-			tmp1);
+	dev_dbg(&client->dev, "wr gpio=%02x %02x\n", tmp0, tmp1);
 
 	/* write bits [7:2] */
 	ret = cxd2820r_wr_reg_mask(priv, 0x00089, tmp0, 0xfc);
@@ -240,18 +239,18 @@ int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
@@ -279,8 +278,7 @@ static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 			goto err;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: error state=%d\n", __func__,
-				fe->dtv_property_cache.delivery_system);
+		dev_dbg(&client->dev, "invalid delivery_system\n");
 		ret = -EINVAL;
 		break;
 	}
@@ -291,12 +289,13 @@ err:
 static int cxd2820r_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
+	switch (c->delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_read_status_t(fe, status);
 		break;
@@ -317,15 +316,16 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe,
 				 struct dtv_frontend_properties *p)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	if (priv->delivery_system == SYS_UNDEFINED)
 		return 0;
 
-	switch (fe->dtv_property_cache.delivery_system) {
+	switch (c->delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_get_frontend_t(fe, p);
 		break;
@@ -345,9 +345,10 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe,
 static int cxd2820r_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	*ber = (priv->post_bit_error - priv->post_bit_error_prev_dvbv3);
 	priv->post_bit_error_prev_dvbv3 = priv->post_bit_error;
@@ -358,10 +359,10 @@ static int cxd2820r_read_ber(struct dvb_frontend *fe, u32 *ber)
 static int cxd2820r_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	if (c->strength.stat[0].scale == FE_SCALE_RELATIVE)
 		*strength = c->strength.stat[0].uvalue;
@@ -374,10 +375,10 @@ static int cxd2820r_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 static int cxd2820r_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
 		*snr = div_s64(c->cnr.stat[0].svalue, 100);
@@ -390,9 +391,10 @@ static int cxd2820r_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int cxd2820r_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	*ucblocks = 0;
 
@@ -407,12 +409,13 @@ static int cxd2820r_init(struct dvb_frontend *fe)
 static int cxd2820r_sleep(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
+	switch (c->delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_sleep_t(fe);
 		break;
@@ -433,12 +436,13 @@ static int cxd2820r_get_tune_settings(struct dvb_frontend *fe,
 				      struct dvb_frontend_tune_settings *s)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
+	switch (c->delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_get_tune_settings_t(fe, s);
 		break;
@@ -458,12 +462,12 @@ static int cxd2820r_get_tune_settings(struct dvb_frontend *fe,
 static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	enum fe_status status = 0;
 
-	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
-			fe->dtv_property_cache.delivery_system);
+	dev_dbg(&client->dev, "delivery_system=%d\n", c->delivery_system);
 
 	/* switch between DVB-T and DVB-T2 when tune fails */
 	if (priv->last_tune_failed) {
@@ -487,7 +491,6 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	if (ret)
 		goto error;
 
-
 	/* frontend lock wait loop count */
 	switch (priv->delivery_system) {
 	case SYS_DVBT:
@@ -505,7 +508,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 
 	/* wait frontend lock */
 	for (; i > 0; i--) {
-		dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+		dev_dbg(&client->dev, "loop=%d\n", i);
 		msleep(50);
 		ret = cxd2820r_read_status(fe, &status);
 		if (ret)
@@ -525,7 +528,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	}
 
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
@@ -539,7 +542,7 @@ static void cxd2820r_release(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 
-	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	i2c_unregister_device(client);
 
@@ -549,8 +552,9 @@ static void cxd2820r_release(struct dvb_frontend *fe)
 static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 
-	dev_dbg(&priv->i2c->dev, "%s: %d\n", __func__, enable);
+	dev_dbg_ratelimited(&client->dev, "enable=%d\n", enable);
 
 	/* Bit 0 of reg 0xdb in bank 0x00 controls I2C repeater */
 	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
@@ -561,9 +565,10 @@ static int cxd2820r_gpio_direction_output(struct gpio_chip *chip, unsigned nr,
 		int val)
 {
 	struct cxd2820r_priv *priv = gpiochip_get_data(chip);
+	struct i2c_client *client = priv->client[0];
 	u8 gpio[GPIO_COUNT];
 
-	dev_dbg(&priv->i2c->dev, "%s: nr=%d val=%d\n", __func__, nr, val);
+	dev_dbg(&client->dev, "nr=%u val=%d\n", nr, val);
 
 	memcpy(gpio, priv->gpio, sizeof(gpio));
 	gpio[nr] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | (val << 2);
@@ -574,9 +579,10 @@ static int cxd2820r_gpio_direction_output(struct gpio_chip *chip, unsigned nr,
 static void cxd2820r_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
 {
 	struct cxd2820r_priv *priv = gpiochip_get_data(chip);
+	struct i2c_client *client = priv->client[0];
 	u8 gpio[GPIO_COUNT];
 
-	dev_dbg(&priv->i2c->dev, "%s: nr=%d val=%d\n", __func__, nr, val);
+	dev_dbg(&client->dev, "nr=%u val=%d\n", nr, val);
 
 	memcpy(gpio, priv->gpio, sizeof(gpio));
 	gpio[nr] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | (val << 2);
@@ -589,8 +595,9 @@ static void cxd2820r_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
 static int cxd2820r_gpio_get(struct gpio_chip *chip, unsigned nr)
 {
 	struct cxd2820r_priv *priv = gpiochip_get_data(chip);
+	struct i2c_client *client = priv->client[0];
 
-	dev_dbg(&priv->i2c->dev, "%s: nr=%d\n", __func__, nr);
+	dev_dbg(&client->dev, "nr=%u\n", nr);
 
 	return (priv->gpio[nr] >> 2) & 0x01;
 }
@@ -738,7 +745,7 @@ static int cxd2820r_probe(struct i2c_client *client,
 #ifdef CONFIG_GPIOLIB
 		/* Add GPIOs */
 		priv->gpio_chip.label = KBUILD_MODNAME;
-		priv->gpio_chip.parent = &priv->i2c->dev;
+		priv->gpio_chip.parent = &client->dev;
 		priv->gpio_chip.owner = THIS_MODULE;
 		priv->gpio_chip.direction_output = cxd2820r_gpio_direction_output;
 		priv->gpio_chip.set = cxd2820r_gpio_set;
@@ -750,8 +757,8 @@ static int cxd2820r_probe(struct i2c_client *client,
 		if (ret)
 			goto err_client_1_i2c_unregister_device;
 
-		dev_dbg(&priv->i2c->dev, "%s: gpio_chip.base=%d\n", __func__,
-				priv->gpio_chip.base);
+		dev_dbg(&client->dev, "gpio_chip.base=%d\n",
+			priv->gpio_chip.base);
 
 		*gpio_chip_base = priv->gpio_chip.base;
 #else
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index e328fe2..174d916 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -24,6 +24,7 @@
 int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, bw_i;
 	unsigned int utmp;
@@ -55,8 +56,10 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 		{ 0x00427, 0x41, 0xff },
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n", __func__,
-			c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev,
+		"delivery_system=%d modulation=%d frequency=%u bandwidth_hz=%u inversion=%d\n",
+		c->delivery_system, c->modulation, c->frequency,
+		c->bandwidth_hz, c->inversion);
 
 	switch (c->bandwidth_hz) {
 	case 6000000:
@@ -96,8 +99,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		if (ret)
 			goto error;
-		dev_dbg(&priv->i2c->dev, "%s: if_frequency=%u\n", __func__,
-			if_frequency);
+		dev_dbg(&client->dev, "if_frequency=%u\n", if_frequency);
 	} else {
 		ret = -EINVAL;
 		goto error;
@@ -133,7 +135,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -141,9 +143,12 @@ int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
 			    struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret;
 	u8 buf[2];
 
+	dev_dbg(&client->dev, "\n");
+
 	ret = cxd2820r_rd_regs(priv, 0x0002f, buf, sizeof(buf));
 	if (ret)
 		goto error;
@@ -250,13 +255,14 @@ int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	unsigned int utmp;
@@ -294,7 +300,7 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 		}
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: lock=%*ph\n", __func__, 4, buf);
+	dev_dbg(&client->dev, "lock=%*ph\n", 4, buf);
 
 	/* Signal strength */
 	if (*status & FE_HAS_SIGNAL) {
@@ -384,28 +390,32 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_init_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret;
 
+	dev_dbg(&client->dev, "\n");
+
 	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
 	if (ret)
 		goto error;
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_sleep_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret, i;
 	struct reg_val_mask tab[] = {
 		{ 0x000ff, 0x1f, 0xff },
@@ -415,7 +425,7 @@ int cxd2820r_sleep_t(struct dvb_frontend *fe)
 		{ 0x00080, 0x00, 0xff },
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	priv->delivery_system = SYS_UNDEFINED;
 
@@ -428,7 +438,7 @@ int cxd2820r_sleep_t(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 3a2c198..939a68d 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -23,8 +23,9 @@
 
 int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, bw_i;
 	unsigned int utmp;
 	u32 if_frequency;
@@ -69,8 +70,10 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 		{ 0x027ef, 0x10, 0x18 },
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n", __func__,
-			c->frequency, c->bandwidth_hz);
+	dev_dbg(&client->dev,
+		"delivery_system=%d modulation=%d frequency=%u bandwidth_hz=%u inversion=%d stream_id=%u\n",
+		c->delivery_system, c->modulation, c->frequency,
+		c->bandwidth_hz, c->inversion, c->stream_id);
 
 	switch (c->bandwidth_hz) {
 	case 5000000:
@@ -113,8 +116,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		if (ret)
 			goto error;
-		dev_dbg(&priv->i2c->dev, "%s: if_frequency=%u\n", __func__,
-			if_frequency);
+		dev_dbg(&client->dev, "if_frequency=%u\n", if_frequency);
 	} else {
 		ret = -EINVAL;
 		goto error;
@@ -130,13 +132,12 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 
 	/* PLP filtering */
 	if (c->stream_id > 255) {
-		dev_dbg(&priv->i2c->dev, "%s: Disable PLP filtering\n", __func__);
+		dev_dbg(&client->dev, "disable PLP filtering\n");
 		ret = cxd2820r_wr_reg(priv, 0x023ad , 0);
 		if (ret)
 			goto error;
 	} else {
-		dev_dbg(&priv->i2c->dev, "%s: Enable PLP filtering = %d\n", __func__,
-				c->stream_id);
+		dev_dbg(&client->dev, "enable PLP filtering\n");
 		ret = cxd2820r_wr_reg(priv, 0x023af , c->stream_id & 0xFF);
 		if (ret)
 			goto error;
@@ -163,7 +164,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 
 }
@@ -172,9 +173,12 @@ int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
 			     struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret;
 	u8 buf[2];
 
+	dev_dbg(&client->dev, "\n");
+
 	ret = cxd2820r_rd_regs(priv, 0x0205c, buf, 2);
 	if (ret)
 		goto error;
@@ -279,7 +283,7 @@ int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -287,6 +291,7 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct i2c_client *client = priv->client[0];
 	int ret;
 	unsigned int utmp;
 	u8 buf[4];
@@ -306,7 +311,7 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 		}
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: lock=%02x\n", __func__, buf[0]);
+	dev_dbg(&client->dev, "lock=%*ph\n", 1, buf);
 
 	/* Signal strength */
 	if (*status & FE_HAS_SIGNAL) {
@@ -383,13 +388,14 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client[0];
 	int ret, i;
 	struct reg_val_mask tab[] = {
 		{ 0x000ff, 0x1f, 0xff },
@@ -400,7 +406,7 @@ int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 		{ 0x00080, 0x00, 0xff },
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
 		ret = cxd2820r_wr_reg_mask(priv, tab[i].reg, tab[i].val,
@@ -413,7 +419,7 @@ int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/

