Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44546 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752956AbcIBWht (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 9/9] cxd2820r: convert to regmap api
Date: Sat,  3 Sep 2016 01:37:24 +0300
Message-Id: <1472855844-8665-9-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap for I2C register access.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig         |   1 +
 drivers/media/dvb-frontends/cxd2820r_c.c    |  56 +++---
 drivers/media/dvb-frontends/cxd2820r_core.c | 259 ++++++++++------------------
 drivers/media/dvb-frontends/cxd2820r_priv.h |   6 +-
 drivers/media/dvb-frontends/cxd2820r_t.c    |  55 +++---
 drivers/media/dvb-frontends/cxd2820r_t2.c   |  55 +++---
 6 files changed, 173 insertions(+), 259 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index c645aa8..c4b67f7 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -463,6 +463,7 @@ config DVB_STV0367
 config DVB_CXD2820R
 	tristate "Sony CXD2820R"
 	depends on DVB_CORE && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 0f96add..d75b077 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -26,7 +26,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
+	int ret;
 	unsigned int utmp;
 	u8 buf[2];
 	u32 if_frequency;
@@ -58,12 +58,9 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	if (priv->delivery_system !=  SYS_DVBC_ANNEX_A) {
-		for (i = 0; i < ARRAY_SIZE(tab); i++) {
-			ret = cxd2820r_wr_reg_mask(priv, tab[i].reg,
-				tab[i].val, tab[i].mask);
-			if (ret)
-				goto error;
-		}
+		ret = cxd2820r_wr_reg_val_mask_tab(priv, tab, ARRAY_SIZE(tab));
+		if (ret)
+			goto error;
 	}
 
 	priv->delivery_system = SYS_DVBC_ANNEX_A;
@@ -83,15 +80,15 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 	utmp = 0x4000 - DIV_ROUND_CLOSEST_ULL((u64)if_frequency * 0x4000, CXD2820R_CLK);
 	buf[0] = (utmp >> 8) & 0xff;
 	buf[1] = (utmp >> 0) & 0xff;
-	ret = cxd2820r_wr_regs(priv, 0x10042, buf, 2);
+	ret = regmap_bulk_write(priv->regmap[1], 0x0042, buf, 2);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg(priv, 0x000ff, 0x08);
+	ret = regmap_write(priv->regmap[0], 0x00ff, 0x08);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg(priv, 0x000fe, 0x01);
+	ret = regmap_write(priv->regmap[0], 0x00fe, 0x01);
 	if (ret)
 		goto error;
 
@@ -107,21 +104,22 @@ int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 	int ret;
+	unsigned int utmp;
 	u8 buf[2];
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = cxd2820r_rd_regs(priv, 0x1001a, buf, 2);
+	ret = regmap_bulk_read(priv->regmap[1], 0x001a, buf, 2);
 	if (ret)
 		goto error;
 
 	c->symbol_rate = 2500 * ((buf[0] & 0x0f) << 8 | buf[1]);
 
-	ret = cxd2820r_rd_reg(priv, 0x10019, &buf[0]);
+	ret = regmap_read(priv->regmap[1], 0x0019, &utmp);
 	if (ret)
 		goto error;
 
-	switch ((buf[0] >> 0) & 0x07) {
+	switch ((utmp >> 0) & 0x07) {
 	case 0:
 		c->modulation = QAM_16;
 		break;
@@ -139,7 +137,7 @@ int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
 		break;
 	}
 
-	switch ((buf[0] >> 7) & 0x01) {
+	switch ((utmp >> 7) & 0x01) {
 	case 0:
 		c->inversion = INVERSION_OFF;
 		break;
@@ -164,10 +162,10 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 	u8 buf[3];
 
 	/* Lock detection */
-	ret = cxd2820r_rd_reg(priv, 0x10088, &buf[0]);
+	ret = regmap_bulk_read(priv->regmap[1], 0x0088, &buf[0], 1);
 	if (ret)
 		goto error;
-	ret = cxd2820r_rd_reg(priv, 0x10073, &buf[1]);
+	ret = regmap_bulk_read(priv->regmap[1], 0x0073, &buf[1], 1);
 	if (ret)
 		goto error;
 
@@ -191,7 +189,7 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_SIGNAL) {
 		unsigned int strength;
 
-		ret = cxd2820r_rd_regs(priv, 0x10049, buf, 2);
+		ret = regmap_bulk_read(priv->regmap[1], 0x0049, buf, 2);
 		if (ret)
 			goto error;
 
@@ -212,11 +210,11 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_VITERBI) {
 		unsigned int cnr, const_a, const_b;
 
-		ret = cxd2820r_rd_reg(priv, 0x10019, &buf[0]);
+		ret = regmap_read(priv->regmap[1], 0x0019, &utmp);
 		if (ret)
 			goto error;
 
-		if (((buf[0] >> 0) & 0x03) % 2) {
+		if (((utmp >> 0) & 0x03) % 2) {
 			const_a = 8750;
 			const_b = 650;
 		} else {
@@ -224,11 +222,10 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 			const_b = 760;
 		}
 
-		ret = cxd2820r_rd_reg(priv, 0x1004d, &buf[0]);
+		ret = regmap_read(priv->regmap[1], 0x004d, &utmp);
 		if (ret)
 			goto error;
 
-		utmp = buf[0] << 0;
 		#define CXD2820R_LOG2_E_24 24204406 /* log2(e) << 24 */
 		if (utmp)
 			cnr = div_u64((u64)(intlog2(const_b) - intlog2(utmp))
@@ -250,7 +247,7 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 		bool start_ber;
 
 		if (priv->ber_running) {
-			ret = cxd2820r_rd_regs(priv, 0x10076, buf, 3);
+			ret = regmap_bulk_read(priv->regmap[1], 0x0076, buf, 3);
 			if (ret)
 				goto error;
 
@@ -269,7 +266,7 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 		}
 
 		if (start_ber) {
-			ret = cxd2820r_wr_reg(priv, 0x10079, 0x01);
+			ret = regmap_write(priv->regmap[1], 0x0079, 0x01);
 			if (ret)
 				goto error;
 			priv->ber_running = true;
@@ -299,7 +296,7 @@ int cxd2820r_init_c(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
+	ret = regmap_write(priv->regmap[0], 0x0085, 0x07);
 	if (ret)
 		goto error;
 
@@ -313,7 +310,7 @@ int cxd2820r_sleep_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
-	int ret, i;
+	int ret;
 	struct reg_val_mask tab[] = {
 		{ 0x000ff, 0x1f, 0xff },
 		{ 0x00085, 0x00, 0xff },
@@ -326,12 +323,9 @@ int cxd2820r_sleep_c(struct dvb_frontend *fe)
 
 	priv->delivery_system = SYS_UNDEFINED;
 
-	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = cxd2820r_wr_reg_mask(priv, tab[i].reg, tab[i].val,
-			tab[i].mask);
-		if (ret)
-			goto error;
-	}
+	ret = cxd2820r_wr_reg_val_mask_tab(priv, tab, ARRAY_SIZE(tab));
+	if (ret)
+		goto error;
 
 	return ret;
 error:
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index e222217..95267c6 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -21,168 +21,39 @@
 
 #include "cxd2820r_priv.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
-/* write multiple registers */
-static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
-	u8 *val, int len)
+/* Write register table */
+int cxd2820r_wr_reg_val_mask_tab(struct cxd2820r_priv *priv,
+				 const struct reg_val_mask *tab, int tab_len)
 {
 	struct i2c_client *client = priv->client[0];
 	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = i2c,
-			.flags = 0,
-			.len = len + 1,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-			 reg, len);
-		return -EINVAL;
-	}
+	unsigned int i, reg, mask, val;
+	struct regmap *regmap;
 
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
+	dev_dbg(&client->dev, "tab_len=%d\n", tab_len);
 
-	ret = i2c_transfer(priv->client[0]->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
-	u8 *val, int len)
-{
-	struct i2c_client *client = priv->client[0];
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = i2c,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = i2c,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-			 reg, len);
-		return -EINVAL;
-	}
-
-	ret = i2c_transfer(priv->client[0]->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
-			 ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write multiple registers */
-int cxd2820r_wr_regs(struct cxd2820r_priv *priv, u32 reginfo, u8 *val,
-	int len)
-{
-	int ret;
-	u8 i2c_addr;
-	u8 reg = (reginfo >> 0) & 0xff;
-	u8 bank = (reginfo >> 8) & 0xff;
-	u8 i2c = (reginfo >> 16) & 0x01;
-
-	/* select I2C */
-	if (i2c)
-		i2c_addr = priv->client[1]->addr; /* DVB-C */
-	else
-		i2c_addr = priv->client[0]->addr; /* DVB-T/T2 */
-
-	/* switch bank if needed */
-	if (bank != priv->bank[i2c]) {
-		ret = cxd2820r_wr_regs_i2c(priv, i2c_addr, 0x00, &bank, 1);
-		if (ret)
-			return ret;
-		priv->bank[i2c] = bank;
-	}
-	return cxd2820r_wr_regs_i2c(priv, i2c_addr, reg, val, len);
-}
-
-/* read multiple registers */
-int cxd2820r_rd_regs(struct cxd2820r_priv *priv, u32 reginfo, u8 *val,
-	int len)
-{
-	int ret;
-	u8 i2c_addr;
-	u8 reg = (reginfo >> 0) & 0xff;
-	u8 bank = (reginfo >> 8) & 0xff;
-	u8 i2c = (reginfo >> 16) & 0x01;
-
-	/* select I2C */
-	if (i2c)
-		i2c_addr = priv->client[1]->addr; /* DVB-C */
-	else
-		i2c_addr = priv->client[0]->addr; /* DVB-T/T2 */
-
-	/* switch bank if needed */
-	if (bank != priv->bank[i2c]) {
-		ret = cxd2820r_wr_regs_i2c(priv, i2c_addr, 0x00, &bank, 1);
-		if (ret)
-			return ret;
-		priv->bank[i2c] = bank;
-	}
-	return cxd2820r_rd_regs_i2c(priv, i2c_addr, reg, val, len);
-}
-
-/* write single register */
-int cxd2820r_wr_reg(struct cxd2820r_priv *priv, u32 reg, u8 val)
-{
-	return cxd2820r_wr_regs(priv, reg, &val, 1);
-}
-
-/* read single register */
-int cxd2820r_rd_reg(struct cxd2820r_priv *priv, u32 reg, u8 *val)
-{
-	return cxd2820r_rd_regs(priv, reg, val, 1);
-}
+	for (i = 0; i < tab_len; i++) {
+		if ((tab[i].reg >> 16) & 0x1)
+			regmap = priv->regmap[1];
+		else
+			regmap = priv->regmap[0];
 
-/* write single register with mask */
-int cxd2820r_wr_reg_mask(struct cxd2820r_priv *priv, u32 reg, u8 val,
-	u8 mask)
-{
-	int ret;
-	u8 tmp;
+		reg = (tab[i].reg >> 0) & 0xffff;
+		val = tab[i].val;
+		mask = tab[i].mask;
 
-	/* no need for read if whole reg is written */
-	if (mask != 0xff) {
-		ret = cxd2820r_rd_reg(priv, reg, &tmp);
+		if (mask == 0xff)
+			ret = regmap_write(regmap, reg, val);
+		else
+			ret = regmap_write_bits(regmap, reg, mask, val);
 		if (ret)
-			return ret;
-
-		val &= mask;
-		tmp &= ~mask;
-		val |= tmp;
+			goto error;
 	}
 
-	return cxd2820r_wr_reg(priv, reg, val);
+	return 0;
+error:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
 }
 
 int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio)
@@ -226,12 +97,12 @@ int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio)
 	dev_dbg(&client->dev, "wr gpio=%02x %02x\n", tmp0, tmp1);
 
 	/* write bits [7:2] */
-	ret = cxd2820r_wr_reg_mask(priv, 0x00089, tmp0, 0xfc);
+	ret = regmap_update_bits(priv->regmap[0], 0x0089, 0xfc, tmp0);
 	if (ret)
 		goto error;
 
 	/* write bits [5:0] */
-	ret = cxd2820r_wr_reg_mask(priv, 0x0008e, tmp1, 0x3f);
+	ret = regmap_update_bits(priv->regmap[0], 0x008e, 0x3f, tmp1);
 	if (ret)
 		goto error;
 
@@ -556,8 +427,7 @@ static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	dev_dbg_ratelimited(&client->dev, "enable=%d\n", enable);
 
-	/* Bit 0 of reg 0xdb in bank 0x00 controls I2C repeater */
-	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
+	return regmap_update_bits(priv->regmap[0], 0x00db, 0x01, enable ? 1 : 0);
 }
 
 #ifdef CONFIG_GPIOLIB
@@ -696,7 +566,45 @@ static int cxd2820r_probe(struct i2c_client *client,
 	struct cxd2820r_platform_data *pdata = client->dev.platform_data;
 	struct cxd2820r_priv *priv;
 	int ret, *gpio_chip_base;
-	u8 u8tmp;
+	unsigned int utmp;
+	static const struct regmap_range_cfg regmap_range_cfg0[] = {
+		{
+			.range_min        = 0x0000,
+			.range_max        = 0x3fff,
+			.selector_reg     = 0x00,
+			.selector_mask    = 0xff,
+			.selector_shift   = 0,
+			.window_start     = 0x00,
+			.window_len       = 0x100,
+		},
+	};
+	static const struct regmap_range_cfg regmap_range_cfg1[] = {
+		{
+			.range_min        = 0x0000,
+			.range_max        = 0x01ff,
+			.selector_reg     = 0x00,
+			.selector_mask    = 0xff,
+			.selector_shift   = 0,
+			.window_start     = 0x00,
+			.window_len       = 0x100,
+		},
+	};
+	static const struct regmap_config regmap_config0 = {
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0x3fff,
+		.ranges = regmap_range_cfg0,
+		.num_ranges = ARRAY_SIZE(regmap_range_cfg0),
+		.cache_type = REGCACHE_NONE,
+	};
+	static const struct regmap_config regmap_config1 = {
+		.reg_bits = 8,
+		.val_bits = 8,
+		.max_register = 0x01ff,
+		.ranges = regmap_range_cfg1,
+		.num_ranges = ARRAY_SIZE(regmap_range_cfg1),
+		.cache_type = REGCACHE_NONE,
+	};
 
 	dev_dbg(&client->dev, "\n");
 
@@ -712,20 +620,23 @@ static int cxd2820r_probe(struct i2c_client *client,
 	priv->ts_clk_inv = pdata->ts_clk_inv;
 	priv->if_agc_polarity = pdata->if_agc_polarity;
 	priv->spec_inv = pdata->spec_inv;
-	priv->bank[0] = 0xff;
-	priv->bank[1] = 0xff;
 	gpio_chip_base = *pdata->gpio_chip_base;
+	priv->regmap[0] = regmap_init_i2c(priv->client[0], &regmap_config0);
+	if (IS_ERR(priv->regmap[0])) {
+		ret = PTR_ERR(priv->regmap[0]);
+		goto err_kfree;
+	}
 
 	/* Check demod answers with correct chip id */
-	ret = cxd2820r_rd_reg(priv, 0x000fd, &u8tmp);
+	ret = regmap_read(priv->regmap[0], 0x00fd, &utmp);
 	if (ret)
-		goto err_kfree;
+		goto err_regmap_0_regmap_exit;
 
-	dev_dbg(&client->dev, "chip_id=%02x\n", u8tmp);
+	dev_dbg(&client->dev, "chip_id=%02x\n", utmp);
 
-	if (u8tmp != 0xe1) {
+	if (utmp != 0xe1) {
 		ret = -ENODEV;
-		goto err_kfree;
+		goto err_regmap_0_regmap_exit;
 	}
 
 	/*
@@ -738,7 +649,13 @@ static int cxd2820r_probe(struct i2c_client *client,
 		ret = -ENODEV;
 		dev_err(&client->dev, "I2C registration failed\n");
 		if (ret)
-			goto err_kfree;
+			goto err_regmap_0_regmap_exit;
+	}
+
+	priv->regmap[1] = regmap_init_i2c(priv->client[1], &regmap_config1);
+	if (IS_ERR(priv->regmap[1])) {
+		ret = PTR_ERR(priv->regmap[1]);
+		goto err_client_1_i2c_unregister_device;
 	}
 
 	if (gpio_chip_base) {
@@ -755,7 +672,7 @@ static int cxd2820r_probe(struct i2c_client *client,
 		priv->gpio_chip.can_sleep = 1;
 		ret = gpiochip_add_data(&priv->gpio_chip, priv);
 		if (ret)
-			goto err_client_1_i2c_unregister_device;
+			goto err_regmap_1_regmap_exit;
 
 		dev_dbg(&client->dev, "gpio_chip.base=%d\n",
 			priv->gpio_chip.base);
@@ -772,7 +689,7 @@ static int cxd2820r_probe(struct i2c_client *client,
 		gpio[2] = 0;
 		ret = cxd2820r_gpio(&priv->fe, gpio);
 		if (ret)
-			goto err_client_1_i2c_unregister_device;
+			goto err_regmap_1_regmap_exit;
 #endif
 	}
 
@@ -789,8 +706,12 @@ static int cxd2820r_probe(struct i2c_client *client,
 	dev_info(&client->dev, "Sony CXD2820R successfully identified\n");
 
 	return 0;
+err_regmap_1_regmap_exit:
+	regmap_exit(priv->regmap[1]);
 err_client_1_i2c_unregister_device:
 	i2c_unregister_device(priv->client[1]);
+err_regmap_0_regmap_exit:
+	regmap_exit(priv->regmap[0]);
 err_kfree:
 	kfree(priv);
 err:
@@ -808,7 +729,11 @@ static int cxd2820r_remove(struct i2c_client *client)
 	if (priv->gpio_chip.label)
 		gpiochip_remove(&priv->gpio_chip);
 #endif
+	regmap_exit(priv->regmap[1]);
 	i2c_unregister_device(priv->client[1]);
+
+	regmap_exit(priv->regmap[0]);
+
 	kfree(priv);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index f711fbd..0d09620 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -28,6 +28,7 @@
 #include "cxd2820r.h"
 #include <linux/gpio.h>
 #include <linux/math64.h>
+#include <linux/regmap.h>
 
 struct reg_val_mask {
 	u32 reg;
@@ -39,6 +40,7 @@ struct reg_val_mask {
 
 struct cxd2820r_priv {
 	struct i2c_client *client[2];
+	struct regmap *regmap[2];
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	u8 ts_mode;
@@ -51,7 +53,6 @@ struct cxd2820r_priv {
 
 	bool ber_running;
 
-	u8 bank[2];
 #define GPIO_COUNT 3
 	u8 gpio[GPIO_COUNT];
 #ifdef CONFIG_GPIOLIB
@@ -68,6 +69,9 @@ extern int cxd2820r_debug;
 
 int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio);
 
+int cxd2820r_wr_reg_val_mask_tab(struct cxd2820r_priv *priv,
+				 const struct reg_val_mask *tab, int tab_len);
+
 int cxd2820r_wr_reg_mask(struct cxd2820r_priv *priv, u32 reg, u8 val,
 	u8 mask);
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index 19f72cd..c2e7caf 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -26,7 +26,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, bw_i;
+	int ret, bw_i;
 	unsigned int utmp;
 	u32 if_frequency;
 	u8 buf[3], bw_param;
@@ -83,12 +83,9 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	if (priv->delivery_system != SYS_DVBT) {
-		for (i = 0; i < ARRAY_SIZE(tab); i++) {
-			ret = cxd2820r_wr_reg_mask(priv, tab[i].reg,
-				tab[i].val, tab[i].mask);
-			if (ret)
-				goto error;
-		}
+		ret = cxd2820r_wr_reg_val_mask_tab(priv, tab, ARRAY_SIZE(tab));
+		if (ret)
+			goto error;
 	}
 
 	priv->delivery_system = SYS_DVBT;
@@ -109,27 +106,27 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 	buf[0] = (utmp >> 16) & 0xff;
 	buf[1] = (utmp >>  8) & 0xff;
 	buf[2] = (utmp >>  0) & 0xff;
-	ret = cxd2820r_wr_regs(priv, 0x000b6, buf, 3);
+	ret = regmap_bulk_write(priv->regmap[0], 0x00b6, buf, 3);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_regs(priv, 0x0009f, bw_params1[bw_i], 5);
+	ret = regmap_bulk_write(priv->regmap[0], 0x009f, bw_params1[bw_i], 5);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg_mask(priv, 0x000d7, bw_param << 6, 0xc0);
+	ret = regmap_update_bits(priv->regmap[0], 0x00d7, 0xc0, bw_param << 6);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_regs(priv, 0x000d9, bw_params2[bw_i], 2);
+	ret = regmap_bulk_write(priv->regmap[0], 0x00d9, bw_params2[bw_i], 2);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg(priv, 0x000ff, 0x08);
+	ret = regmap_write(priv->regmap[0], 0x00ff, 0x08);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg(priv, 0x000fe, 0x01);
+	ret = regmap_write(priv->regmap[0], 0x00fe, 0x01);
 	if (ret)
 		goto error;
 
@@ -145,11 +142,12 @@ int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 	int ret;
+	unsigned int utmp;
 	u8 buf[2];
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = cxd2820r_rd_regs(priv, 0x0002f, buf, sizeof(buf));
+	ret = regmap_bulk_read(priv->regmap[0], 0x002f, buf, sizeof(buf));
 	if (ret)
 		goto error;
 
@@ -240,11 +238,11 @@ int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
 		break;
 	}
 
-	ret = cxd2820r_rd_reg(priv, 0x007c6, &buf[0]);
+	ret = regmap_read(priv->regmap[0], 0x07c6, &utmp);
 	if (ret)
 		goto error;
 
-	switch ((buf[0] >> 0) & 0x01) {
+	switch ((utmp >> 0) & 0x01) {
 	case 0:
 		c->inversion = INVERSION_OFF;
 		break;
@@ -269,10 +267,10 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 	u8 buf[3];
 
 	/* Lock detection */
-	ret = cxd2820r_rd_reg(priv, 0x00010, &buf[0]);
+	ret = regmap_bulk_read(priv->regmap[0], 0x0010, &buf[0], 1);
 	if (ret)
 		goto error;
-	ret = cxd2820r_rd_reg(priv, 0x00073, &buf[1]);
+	ret = regmap_bulk_read(priv->regmap[0], 0x0073, &buf[1], 1);
 	if (ret)
 		goto error;
 
@@ -296,7 +294,7 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_SIGNAL) {
 		unsigned int strength;
 
-		ret = cxd2820r_rd_regs(priv, 0x00026, buf, 2);
+		ret = regmap_bulk_read(priv->regmap[0], 0x0026, buf, 2);
 		if (ret)
 			goto error;
 
@@ -317,7 +315,7 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_VITERBI) {
 		unsigned int cnr;
 
-		ret = cxd2820r_rd_regs(priv, 0x0002c, buf, 2);
+		ret = regmap_bulk_read(priv->regmap[0], 0x002c, buf, 2);
 		if (ret)
 			goto error;
 
@@ -343,7 +341,7 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 		bool start_ber;
 
 		if (priv->ber_running) {
-			ret = cxd2820r_rd_regs(priv, 0x00076, buf, 3);
+			ret = regmap_bulk_read(priv->regmap[0], 0x0076, buf, 3);
 			if (ret)
 				goto error;
 
@@ -362,7 +360,7 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 		}
 
 		if (start_ber) {
-			ret = cxd2820r_wr_reg(priv, 0x00079, 0x01);
+			ret = regmap_write(priv->regmap[0], 0x0079, 0x01);
 			if (ret)
 				goto error;
 			priv->ber_running = true;
@@ -392,7 +390,7 @@ int cxd2820r_init_t(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
+	ret = regmap_write(priv->regmap[0], 0x0085, 0x07);
 	if (ret)
 		goto error;
 
@@ -406,7 +404,7 @@ int cxd2820r_sleep_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
-	int ret, i;
+	int ret;
 	struct reg_val_mask tab[] = {
 		{ 0x000ff, 0x1f, 0xff },
 		{ 0x00085, 0x00, 0xff },
@@ -419,12 +417,9 @@ int cxd2820r_sleep_t(struct dvb_frontend *fe)
 
 	priv->delivery_system = SYS_UNDEFINED;
 
-	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = cxd2820r_wr_reg_mask(priv, tab[i].reg, tab[i].val,
-			tab[i].mask);
-		if (ret)
-			goto error;
-	}
+	ret = cxd2820r_wr_reg_val_mask_tab(priv, tab, ARRAY_SIZE(tab));
+	if (ret)
+		goto error;
 
 	return ret;
 error:
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 4a6fbf8..e641fde 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -26,7 +26,7 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, bw_i;
+	int ret, bw_i;
 	unsigned int utmp;
 	u32 if_frequency;
 	u8 buf[3], bw_param;
@@ -101,12 +101,9 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	if (priv->delivery_system != SYS_DVBT2) {
-		for (i = 0; i < ARRAY_SIZE(tab); i++) {
-			ret = cxd2820r_wr_reg_mask(priv, tab[i].reg,
-				tab[i].val, tab[i].mask);
-			if (ret)
-				goto error;
-		}
+		ret = cxd2820r_wr_reg_val_mask_tab(priv, tab, ARRAY_SIZE(tab));
+		if (ret)
+			goto error;
 	}
 
 	priv->delivery_system = SYS_DVBT2;
@@ -126,39 +123,39 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 	buf[0] = (utmp >> 16) & 0xff;
 	buf[1] = (utmp >>  8) & 0xff;
 	buf[2] = (utmp >>  0) & 0xff;
-	ret = cxd2820r_wr_regs(priv, 0x020b6, buf, 3);
+	ret = regmap_bulk_write(priv->regmap[0], 0x20b6, buf, 3);
 	if (ret)
 		goto error;
 
 	/* PLP filtering */
 	if (c->stream_id > 255) {
 		dev_dbg(&client->dev, "disable PLP filtering\n");
-		ret = cxd2820r_wr_reg(priv, 0x023ad , 0);
+		ret = regmap_write(priv->regmap[0], 0x23ad, 0x00);
 		if (ret)
 			goto error;
 	} else {
 		dev_dbg(&client->dev, "enable PLP filtering\n");
-		ret = cxd2820r_wr_reg(priv, 0x023af , c->stream_id & 0xFF);
+		ret = regmap_write(priv->regmap[0], 0x23af, c->stream_id & 0xff);
 		if (ret)
 			goto error;
-		ret = cxd2820r_wr_reg(priv, 0x023ad , 1);
+		ret = regmap_write(priv->regmap[0], 0x23ad, 0x01);
 		if (ret)
 			goto error;
 	}
 
-	ret = cxd2820r_wr_regs(priv, 0x0209f, bw_params1[bw_i], 5);
+	ret = regmap_bulk_write(priv->regmap[0], 0x209f, bw_params1[bw_i], 5);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg_mask(priv, 0x020d7, bw_param << 6, 0xc0);
+	ret = regmap_update_bits(priv->regmap[0], 0x20d7, 0xc0, bw_param << 6);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg(priv, 0x000ff, 0x08);
+	ret = regmap_write(priv->regmap[0], 0x00ff, 0x08);
 	if (ret)
 		goto error;
 
-	ret = cxd2820r_wr_reg(priv, 0x000fe, 0x01);
+	ret = regmap_write(priv->regmap[0], 0x00fe, 0x01);
 	if (ret)
 		goto error;
 
@@ -175,11 +172,12 @@ int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
 	int ret;
+	unsigned int utmp;
 	u8 buf[2];
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = cxd2820r_rd_regs(priv, 0x0205c, buf, 2);
+	ret = regmap_bulk_read(priv->regmap[0], 0x205c, buf, 2);
 	if (ret)
 		goto error;
 
@@ -228,7 +226,7 @@ int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
 		break;
 	}
 
-	ret = cxd2820r_rd_regs(priv, 0x0225b, buf, 2);
+	ret = regmap_bulk_read(priv->regmap[0], 0x225b, buf, 2);
 	if (ret)
 		goto error;
 
@@ -268,11 +266,11 @@ int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
 		break;
 	}
 
-	ret = cxd2820r_rd_reg(priv, 0x020b5, &buf[0]);
+	ret = regmap_read(priv->regmap[0], 0x20b5, &utmp);
 	if (ret)
 		goto error;
 
-	switch ((buf[0] >> 4) & 0x01) {
+	switch ((utmp >> 4) & 0x01) {
 	case 0:
 		c->inversion = INVERSION_OFF;
 		break;
@@ -297,7 +295,7 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 	u8 buf[4];
 
 	/* Lock detection */
-	ret = cxd2820r_rd_reg(priv, 0x02010 , &buf[0]);
+	ret = regmap_bulk_read(priv->regmap[0], 0x2010, &buf[0], 1);
 	if (ret)
 		goto error;
 
@@ -321,7 +319,7 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_SIGNAL) {
 		unsigned int strength;
 
-		ret = cxd2820r_rd_regs(priv, 0x02026, buf, 2);
+		ret = regmap_bulk_read(priv->regmap[0], 0x2026, buf, 2);
 		if (ret)
 			goto error;
 
@@ -342,7 +340,7 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_VITERBI) {
 		unsigned int cnr;
 
-		ret = cxd2820r_rd_regs(priv, 0x02028, buf, 2);
+		ret = regmap_bulk_read(priv->regmap[0], 0x2028, buf, 2);
 		if (ret)
 			goto error;
 
@@ -368,7 +366,7 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 	if (*status & FE_HAS_SYNC) {
 		unsigned int post_bit_error;
 
-		ret = cxd2820r_rd_regs(priv, 0x02039, buf, 4);
+		ret = regmap_bulk_read(priv->regmap[0], 0x2039, buf, 4);
 		if (ret)
 			goto error;
 
@@ -400,7 +398,7 @@ int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct i2c_client *client = priv->client[0];
-	int ret, i;
+	int ret;
 	struct reg_val_mask tab[] = {
 		{ 0x000ff, 0x1f, 0xff },
 		{ 0x00085, 0x00, 0xff },
@@ -412,12 +410,9 @@ int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = cxd2820r_wr_reg_mask(priv, tab[i].reg, tab[i].val,
-			tab[i].mask);
-		if (ret)
-			goto error;
-	}
+	ret = cxd2820r_wr_reg_val_mask_tab(priv, tab, ARRAY_SIZE(tab));
+	if (ret)
+		goto error;
 
 	priv->delivery_system = SYS_UNDEFINED;
 
-- 
http://palosaari.fi/

