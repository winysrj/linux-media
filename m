Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33861 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbFFL7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/8] m88ds3103: rename variables and correct logging
Date: Sat,  6 Jun 2015 14:58:46 +0300
Message-Id: <1433591928-30915-6-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename driver state from priv to dev.
Use I2C client for correct logging.
Use adapter and address from I2C client structure where needed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig          |   2 +-
 drivers/media/dvb-frontends/m88ds3103.c      | 538 +++++++++++++--------------
 drivers/media/dvb-frontends/m88ds3103.h      |   2 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   5 +-
 4 files changed, 267 insertions(+), 280 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index ba65a00..b7627ca 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -36,7 +36,7 @@ config DVB_STV6110x
 	  A Silicon tuner that supports DVB-S and DVB-S2 modes
 
 config DVB_M88DS3103
-	tristate "Montage M88DS3103"
+	tristate "Montage Technology M88DS3103"
 	depends on DVB_CORE && I2C && I2C_MUX
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 7b21f1a..c4d5a7a 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1,5 +1,5 @@
 /*
- * Montage M88DS3103/M88RS6000 demodulator driver
+ * Montage Technology M88DS3103/M88RS6000 demodulator driver
  *
  * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
  *
@@ -19,16 +19,17 @@
 static struct dvb_frontend_ops m88ds3103_ops;
 
 /* write multiple registers */
-static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
+static int m88ds3103_wr_regs(struct m88ds3103_dev *dev,
 		u8 reg, const u8 *val, int len)
 {
 #define MAX_WR_LEN 32
 #define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_WR_XFER_LEN];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -41,15 +42,14 @@ static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	mutex_lock(&priv->i2c_mutex);
-	ret = i2c_transfer(priv->i2c, msg, 1);
-	mutex_unlock(&priv->i2c_mutex);
+	mutex_lock(&dev->i2c_mutex);
+	ret = i2c_transfer(client->adapter, msg, 1);
+	mutex_unlock(&dev->i2c_mutex);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -57,21 +57,22 @@ static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
 }
 
 /* read multiple registers */
-static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
+static int m88ds3103_rd_regs(struct m88ds3103_dev *dev,
 		u8 reg, u8 *val, int len)
 {
 #define MAX_RD_LEN 3
 #define MAX_RD_XFER_LEN (MAX_RD_LEN)
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_RD_XFER_LEN];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg->i2c_addr,
+			.addr = client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -81,16 +82,15 @@ static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
 	if (WARN_ON(len > MAX_RD_LEN))
 		return -EINVAL;
 
-	mutex_lock(&priv->i2c_mutex);
-	ret = i2c_transfer(priv->i2c, msg, 2);
-	mutex_unlock(&priv->i2c_mutex);
+	mutex_lock(&dev->i2c_mutex);
+	ret = i2c_transfer(client->adapter, msg, 2);
+	mutex_unlock(&dev->i2c_mutex);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -98,19 +98,19 @@ static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
 }
 
 /* write single register */
-static int m88ds3103_wr_reg(struct m88ds3103_priv *priv, u8 reg, u8 val)
+static int m88ds3103_wr_reg(struct m88ds3103_dev *dev, u8 reg, u8 val)
 {
-	return m88ds3103_wr_regs(priv, reg, &val, 1);
+	return m88ds3103_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register */
-static int m88ds3103_rd_reg(struct m88ds3103_priv *priv, u8 reg, u8 *val)
+static int m88ds3103_rd_reg(struct m88ds3103_dev *dev, u8 reg, u8 *val)
 {
-	return m88ds3103_rd_regs(priv, reg, val, 1);
+	return m88ds3103_rd_regs(dev, reg, val, 1);
 }
 
 /* write single register with mask */
-static int m88ds3103_wr_reg_mask(struct m88ds3103_priv *priv,
+static int m88ds3103_wr_reg_mask(struct m88ds3103_dev *dev,
 		u8 reg, u8 val, u8 mask)
 {
 	int ret;
@@ -118,7 +118,7 @@ static int m88ds3103_wr_reg_mask(struct m88ds3103_priv *priv,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = m88ds3103_rd_regs(priv, reg, &u8tmp, 1);
+		ret = m88ds3103_rd_regs(dev, reg, &u8tmp, 1);
 		if (ret)
 			return ret;
 
@@ -127,17 +127,17 @@ static int m88ds3103_wr_reg_mask(struct m88ds3103_priv *priv,
 		val |= u8tmp;
 	}
 
-	return m88ds3103_wr_regs(priv, reg, &val, 1);
+	return m88ds3103_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register with mask */
-static int m88ds3103_rd_reg_mask(struct m88ds3103_priv *priv,
+static int m88ds3103_rd_reg_mask(struct m88ds3103_dev *dev,
 		u8 reg, u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 u8tmp;
 
-	ret = m88ds3103_rd_regs(priv, reg, &u8tmp, 1);
+	ret = m88ds3103_rd_regs(dev, reg, &u8tmp, 1);
 	if (ret)
 		return ret;
 
@@ -154,13 +154,14 @@ static int m88ds3103_rd_reg_mask(struct m88ds3103_priv *priv,
 }
 
 /* write reg val table using reg addr auto increment */
-static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
+static int m88ds3103_wr_reg_val_tab(struct m88ds3103_dev *dev,
 		const struct m88ds3103_reg_val *tab, int tab_len)
 {
+	struct i2c_client *client = dev->client;
 	int ret, i, j;
 	u8 buf[83];
 
-	dev_dbg(&priv->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
+	dev_dbg(&client->dev, "tab_len=%d\n", tab_len);
 
 	if (tab_len > 86) {
 		ret = -EINVAL;
@@ -171,8 +172,8 @@ static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
 		buf[j] = tab[i].val;
 
 		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1 ||
-				!((j + 1) % (priv->cfg->i2c_wr_max - 1))) {
-			ret = m88ds3103_wr_regs(priv, tab[i].reg - j, buf, j + 1);
+				!((j + 1) % (dev->cfg->i2c_wr_max - 1))) {
+			ret = m88ds3103_wr_regs(dev, tab[i].reg - j, buf, j + 1);
 			if (ret)
 				goto err;
 
@@ -182,13 +183,14 @@ static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, itmp;
 	u8 u8tmp;
@@ -196,14 +198,14 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	*status = 0;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		ret = m88ds3103_rd_reg_mask(priv, 0xd1, &u8tmp, 0x07);
+		ret = m88ds3103_rd_reg_mask(dev, 0xd1, &u8tmp, 0x07);
 		if (ret)
 			goto err;
 
@@ -213,7 +215,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 					FE_HAS_LOCK;
 		break;
 	case SYS_DVBS2:
-		ret = m88ds3103_rd_reg_mask(priv, 0x0d, &u8tmp, 0x8f);
+		ret = m88ds3103_rd_reg_mask(dev, 0x0d, &u8tmp, 0x8f);
 		if (ret)
 			goto err;
 
@@ -223,19 +225,17 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 					FE_HAS_LOCK;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid delivery_system\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	priv->fe_status = *status;
+	dev->fe_status = *status;
 
-	dev_dbg(&priv->i2c->dev, "%s: lock=%02x status=%02x\n",
-			__func__, u8tmp, *status);
+	dev_dbg(&client->dev, "lock=%02x status=%02x\n", u8tmp, *status);
 
 	/* CNR */
-	if (priv->fe_status & FE_HAS_VITERBI) {
+	if (dev->fe_status & FE_HAS_VITERBI) {
 		unsigned int cnr, noise, signal, noise_tot, signal_tot;
 
 		cnr = 0;
@@ -247,7 +247,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 			itmp = 0;
 
 			for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
-				ret = m88ds3103_rd_reg(priv, 0xff, &buf[0]);
+				ret = m88ds3103_rd_reg(dev, 0xff, &buf[0]);
 				if (ret)
 					goto err;
 
@@ -265,7 +265,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 			signal_tot = 0;
 
 			for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
-				ret = m88ds3103_rd_regs(priv, 0x8c, buf, 3);
+				ret = m88ds3103_rd_regs(dev, 0x8c, buf, 3);
 				if (ret)
 					goto err;
 
@@ -289,8 +289,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 			}
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev,
-				"%s: invalid delivery_system\n", __func__);
+			dev_dbg(&client->dev, "invalid delivery_system\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -306,40 +305,40 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	}
 
 	/* BER */
-	if (priv->fe_status & FE_HAS_LOCK) {
+	if (dev->fe_status & FE_HAS_LOCK) {
 		unsigned int utmp, post_bit_error, post_bit_count;
 
 		switch (c->delivery_system) {
 		case SYS_DVBS:
-			ret = m88ds3103_wr_reg(priv, 0xf9, 0x04);
+			ret = m88ds3103_wr_reg(dev, 0xf9, 0x04);
 			if (ret)
 				goto err;
 
-			ret = m88ds3103_rd_reg(priv, 0xf8, &u8tmp);
+			ret = m88ds3103_rd_reg(dev, 0xf8, &u8tmp);
 			if (ret)
 				goto err;
 
 			/* measurement ready? */
 			if (!(u8tmp & 0x10)) {
-				ret = m88ds3103_rd_regs(priv, 0xf6, buf, 2);
+				ret = m88ds3103_rd_regs(dev, 0xf6, buf, 2);
 				if (ret)
 					goto err;
 
 				post_bit_error = buf[1] << 8 | buf[0] << 0;
 				post_bit_count = 0x800000;
-				priv->post_bit_error += post_bit_error;
-				priv->post_bit_count += post_bit_count;
-				priv->dvbv3_ber = post_bit_error;
+				dev->post_bit_error += post_bit_error;
+				dev->post_bit_count += post_bit_count;
+				dev->dvbv3_ber = post_bit_error;
 
 				/* restart measurement */
 				u8tmp |= 0x10;
-				ret = m88ds3103_wr_reg(priv, 0xf8, u8tmp);
+				ret = m88ds3103_wr_reg(dev, 0xf8, u8tmp);
 				if (ret)
 					goto err;
 			}
 			break;
 		case SYS_DVBS2:
-			ret = m88ds3103_rd_regs(priv, 0xd5, buf, 3);
+			ret = m88ds3103_rd_regs(dev, 0xd5, buf, 3);
 			if (ret)
 				goto err;
 
@@ -347,45 +346,44 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 			/* enough data? */
 			if (utmp > 4000) {
-				ret = m88ds3103_rd_regs(priv, 0xf7, buf, 2);
+				ret = m88ds3103_rd_regs(dev, 0xf7, buf, 2);
 				if (ret)
 					goto err;
 
 				post_bit_error = buf[1] << 8 | buf[0] << 0;
 				post_bit_count = 32 * utmp; /* TODO: FEC */
-				priv->post_bit_error += post_bit_error;
-				priv->post_bit_count += post_bit_count;
-				priv->dvbv3_ber = post_bit_error;
+				dev->post_bit_error += post_bit_error;
+				dev->post_bit_count += post_bit_count;
+				dev->dvbv3_ber = post_bit_error;
 
 				/* restart measurement */
-				ret = m88ds3103_wr_reg(priv, 0xd1, 0x01);
+				ret = m88ds3103_wr_reg(dev, 0xd1, 0x01);
 				if (ret)
 					goto err;
 
-				ret = m88ds3103_wr_reg(priv, 0xf9, 0x01);
+				ret = m88ds3103_wr_reg(dev, 0xf9, 0x01);
 				if (ret)
 					goto err;
 
-				ret = m88ds3103_wr_reg(priv, 0xf9, 0x00);
+				ret = m88ds3103_wr_reg(dev, 0xf9, 0x00);
 				if (ret)
 					goto err;
 
-				ret = m88ds3103_wr_reg(priv, 0xd1, 0x00);
+				ret = m88ds3103_wr_reg(dev, 0xd1, 0x00);
 				if (ret)
 					goto err;
 			}
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev,
-				"%s: invalid delivery_system\n", __func__);
+			dev_dbg(&client->dev, "invalid delivery_system\n");
 			ret = -EINVAL;
 			goto err;
 		}
 
 		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[0].uvalue = priv->post_bit_error;
+		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
 		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[0].uvalue = priv->post_bit_count;
+		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
 	} else {
 		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
@@ -393,13 +391,14 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len;
 	const struct m88ds3103_reg_val *init;
@@ -409,29 +408,28 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u32 tuner_frequency, target_mclk;
 	s32 s32tmp;
 
-	dev_dbg(&priv->i2c->dev,
-			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
-			__func__, c->delivery_system,
-			c->modulation, c->frequency, c->symbol_rate,
-			c->inversion, c->pilot, c->rolloff);
+	dev_dbg(&client->dev,
+		"delivery_system=%d modulation=%d frequency=%u symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
+		c->delivery_system, c->modulation, c->frequency, c->symbol_rate,
+		c->inversion, c->pilot, c->rolloff);
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
 
 	/* reset */
-	ret = m88ds3103_wr_reg(priv, 0x07, 0x80);
+	ret = m88ds3103_wr_reg(dev, 0x07, 0x80);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0x07, 0x00);
+	ret = m88ds3103_wr_reg(dev, 0x07, 0x00);
 	if (ret)
 		goto err;
 
 	/* Disable demod clock path */
-	if (priv->chip_id == M88RS6000_CHIP_ID) {
-		ret = m88ds3103_wr_reg(priv, 0x06, 0xe0);
+	if (dev->chip_id == M88RS6000_CHIP_ID) {
+		ret = m88ds3103_wr_reg(dev, 0x06, 0xe0);
 		if (ret)
 			goto err;
 	}
@@ -457,11 +455,11 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* select M88RS6000 demod main mclk and ts mclk from tuner die. */
-	if (priv->chip_id == M88RS6000_CHIP_ID) {
+	if (dev->chip_id == M88RS6000_CHIP_ID) {
 		if (c->symbol_rate > 45010000)
-			priv->mclk_khz = 110250;
+			dev->mclk_khz = 110250;
 		else
-			priv->mclk_khz = 96000;
+			dev->mclk_khz = 96000;
 
 		if (c->delivery_system == SYS_DVBS)
 			target_mclk = 96000;
@@ -469,18 +467,18 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			target_mclk = 144000;
 
 		/* Enable demod clock path */
-		ret = m88ds3103_wr_reg(priv, 0x06, 0x00);
+		ret = m88ds3103_wr_reg(dev, 0x06, 0x00);
 		if (ret)
 			goto err;
 		usleep_range(10000, 20000);
 	} else {
 	/* set M88DS3103 mclk and ts mclk. */
-		priv->mclk_khz = 96000;
+		dev->mclk_khz = 96000;
 
-		switch (priv->cfg->ts_mode) {
+		switch (dev->cfg->ts_mode) {
 		case M88DS3103_TS_SERIAL:
 		case M88DS3103_TS_SERIAL_D7:
-			target_mclk = priv->cfg->ts_clk;
+			target_mclk = dev->cfg->ts_clk;
 			break;
 		case M88DS3103_TS_PARALLEL:
 		case M88DS3103_TS_CI:
@@ -496,8 +494,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			}
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid ts_mode\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -516,25 +513,25 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			u8tmp2 = 0x00; /* 0b00 */
 			break;
 		}
-		ret = m88ds3103_wr_reg_mask(priv, 0x22, u8tmp1 << 6, 0xc0);
+		ret = m88ds3103_wr_reg_mask(dev, 0x22, u8tmp1 << 6, 0xc0);
 		if (ret)
 			goto err;
-		ret = m88ds3103_wr_reg_mask(priv, 0x24, u8tmp2 << 6, 0xc0);
+		ret = m88ds3103_wr_reg_mask(dev, 0x24, u8tmp2 << 6, 0xc0);
 		if (ret)
 			goto err;
 	}
 
-	ret = m88ds3103_wr_reg(priv, 0xb2, 0x01);
+	ret = m88ds3103_wr_reg(dev, 0xb2, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0x00, 0x01);
+	ret = m88ds3103_wr_reg(dev, 0x00, 0x01);
 	if (ret)
 		goto err;
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		if (priv->chip_id == M88RS6000_CHIP_ID) {
+		if (dev->chip_id == M88RS6000_CHIP_ID) {
 			len = ARRAY_SIZE(m88rs6000_dvbs_init_reg_vals);
 			init = m88rs6000_dvbs_init_reg_vals;
 		} else {
@@ -543,7 +540,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		}
 		break;
 	case SYS_DVBS2:
-		if (priv->chip_id == M88RS6000_CHIP_ID) {
+		if (dev->chip_id == M88RS6000_CHIP_ID) {
 			len = ARRAY_SIZE(m88rs6000_dvbs2_init_reg_vals);
 			init = m88rs6000_dvbs2_init_reg_vals;
 		} else {
@@ -552,44 +549,43 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		}
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid delivery_system\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
 	/* program init table */
-	if (c->delivery_system != priv->delivery_system) {
-		ret = m88ds3103_wr_reg_val_tab(priv, init, len);
+	if (c->delivery_system != dev->delivery_system) {
+		ret = m88ds3103_wr_reg_val_tab(dev, init, len);
 		if (ret)
 			goto err;
 	}
 
-	if (priv->chip_id == M88RS6000_CHIP_ID) {
+	if (dev->chip_id == M88RS6000_CHIP_ID) {
 		if ((c->delivery_system == SYS_DVBS2)
 			&& ((c->symbol_rate / 1000) <= 5000)) {
-			ret = m88ds3103_wr_reg(priv, 0xc0, 0x04);
+			ret = m88ds3103_wr_reg(dev, 0xc0, 0x04);
 			if (ret)
 				goto err;
 			buf[0] = 0x09;
 			buf[1] = 0x22;
 			buf[2] = 0x88;
-			ret = m88ds3103_wr_regs(priv, 0x8a, buf, 3);
+			ret = m88ds3103_wr_regs(dev, 0x8a, buf, 3);
 			if (ret)
 				goto err;
 		}
-		ret = m88ds3103_wr_reg_mask(priv, 0x9d, 0x08, 0x08);
+		ret = m88ds3103_wr_reg_mask(dev, 0x9d, 0x08, 0x08);
 		if (ret)
 			goto err;
-		ret = m88ds3103_wr_reg(priv, 0xf1, 0x01);
+		ret = m88ds3103_wr_reg(dev, 0xf1, 0x01);
 		if (ret)
 			goto err;
-		ret = m88ds3103_wr_reg_mask(priv, 0x30, 0x80, 0x80);
+		ret = m88ds3103_wr_reg_mask(dev, 0x30, 0x80, 0x80);
 		if (ret)
 			goto err;
 	}
 
-	switch (priv->cfg->ts_mode) {
+	switch (dev->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 		u8tmp1 = 0x00;
 		u8tmp = 0x06;
@@ -605,39 +601,39 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		u8tmp = 0x03;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n", __func__);
+		dev_dbg(&client->dev, "invalid ts_mode\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	if (priv->cfg->ts_clk_pol)
+	if (dev->cfg->ts_clk_pol)
 		u8tmp |= 0x40;
 
 	/* TS mode */
-	ret = m88ds3103_wr_reg(priv, 0xfd, u8tmp);
+	ret = m88ds3103_wr_reg(dev, 0xfd, u8tmp);
 	if (ret)
 		goto err;
 
-	switch (priv->cfg->ts_mode) {
+	switch (dev->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 	case M88DS3103_TS_SERIAL_D7:
-		ret = m88ds3103_wr_reg_mask(priv, 0x29, u8tmp1, 0x20);
+		ret = m88ds3103_wr_reg_mask(dev, 0x29, u8tmp1, 0x20);
 		if (ret)
 			goto err;
 		u8tmp1 = 0;
 		u8tmp2 = 0;
 		break;
 	default:
-		if (priv->cfg->ts_clk) {
-			divide_ratio = DIV_ROUND_UP(target_mclk, priv->cfg->ts_clk);
+		if (dev->cfg->ts_clk) {
+			divide_ratio = DIV_ROUND_UP(target_mclk, dev->cfg->ts_clk);
 			u8tmp1 = divide_ratio / 2;
 			u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
 		}
 	}
 
-	dev_dbg(&priv->i2c->dev,
-			"%s: target_mclk=%d ts_clk=%d divide_ratio=%d\n",
-			__func__, target_mclk, priv->cfg->ts_clk, divide_ratio);
+	dev_dbg(&client->dev,
+		"target_mclk=%d ts_clk=%d divide_ratio=%d\n",
+		target_mclk, dev->cfg->ts_clk, divide_ratio);
 
 	u8tmp1--;
 	u8tmp2--;
@@ -646,17 +642,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	/* u8tmp2[5:0] => ea[5:0] */
 	u8tmp2 &= 0x3f;
 
-	ret = m88ds3103_rd_reg(priv, 0xfe, &u8tmp);
+	ret = m88ds3103_rd_reg(dev, 0xfe, &u8tmp);
 	if (ret)
 		goto err;
 
 	u8tmp = ((u8tmp  & 0xf0) << 0) | u8tmp1 >> 2;
-	ret = m88ds3103_wr_reg(priv, 0xfe, u8tmp);
+	ret = m88ds3103_wr_reg(dev, 0xfe, u8tmp);
 	if (ret)
 		goto err;
 
 	u8tmp = ((u8tmp1 & 0x03) << 6) | u8tmp2 >> 0;
-	ret = m88ds3103_wr_reg(priv, 0xea, u8tmp);
+	ret = m88ds3103_wr_reg(dev, 0xea, u8tmp);
 	if (ret)
 		goto err;
 
@@ -667,182 +663,181 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x06;
 
-	ret = m88ds3103_wr_reg(priv, 0xc3, 0x08);
+	ret = m88ds3103_wr_reg(dev, 0xc3, 0x08);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0xc8, u8tmp);
+	ret = m88ds3103_wr_reg(dev, 0xc8, u8tmp);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0xc4, 0x08);
+	ret = m88ds3103_wr_reg(dev, 0xc4, 0x08);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0xc7, 0x00);
+	ret = m88ds3103_wr_reg(dev, 0xc7, 0x00);
 	if (ret)
 		goto err;
 
-	u16tmp = DIV_ROUND_CLOSEST((c->symbol_rate / 1000) << 15, priv->mclk_khz / 2);
+	u16tmp = DIV_ROUND_CLOSEST((c->symbol_rate / 1000) << 15, dev->mclk_khz / 2);
 	buf[0] = (u16tmp >> 0) & 0xff;
 	buf[1] = (u16tmp >> 8) & 0xff;
-	ret = m88ds3103_wr_regs(priv, 0x61, buf, 2);
+	ret = m88ds3103_wr_regs(dev, 0x61, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(priv, 0x4d, priv->cfg->spec_inv << 1, 0x02);
+	ret = m88ds3103_wr_reg_mask(dev, 0x4d, dev->cfg->spec_inv << 1, 0x02);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(priv, 0x30, priv->cfg->agc_inv << 4, 0x10);
+	ret = m88ds3103_wr_reg_mask(dev, 0x30, dev->cfg->agc_inv << 4, 0x10);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0x33, priv->cfg->agc);
+	ret = m88ds3103_wr_reg(dev, 0x33, dev->cfg->agc);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: carrier offset=%d\n", __func__,
-			(tuner_frequency - c->frequency));
+	dev_dbg(&client->dev, "carrier offset=%d\n",
+		(tuner_frequency - c->frequency));
 
 	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
-	s32tmp = DIV_ROUND_CLOSEST(s32tmp, priv->mclk_khz);
+	s32tmp = DIV_ROUND_CLOSEST(s32tmp, dev->mclk_khz);
 	if (s32tmp < 0)
 		s32tmp += 0x10000;
 
 	buf[0] = (s32tmp >> 0) & 0xff;
 	buf[1] = (s32tmp >> 8) & 0xff;
-	ret = m88ds3103_wr_regs(priv, 0x5e, buf, 2);
+	ret = m88ds3103_wr_regs(dev, 0x5e, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0x00, 0x00);
+	ret = m88ds3103_wr_reg(dev, 0x00, 0x00);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0xb2, 0x00);
+	ret = m88ds3103_wr_reg(dev, 0xb2, 0x00);
 	if (ret)
 		goto err;
 
-	priv->delivery_system = c->delivery_system;
+	dev->delivery_system = c->delivery_system;
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_init(struct dvb_frontend *fe)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
 	u8 u8tmp;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* set cold state by default */
-	priv->warm = false;
+	dev->warm = false;
 
 	/* wake up device from sleep */
-	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x01, 0x01);
+	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x01, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x00, 0x01);
+	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x00, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x00, 0x10);
+	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x00, 0x10);
 	if (ret)
 		goto err;
 
 	/* firmware status */
-	ret = m88ds3103_rd_reg(priv, 0xb9, &u8tmp);
+	ret = m88ds3103_rd_reg(dev, 0xb9, &u8tmp);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: firmware=%02x\n", __func__, u8tmp);
+	dev_dbg(&client->dev, "firmware=%02x\n", u8tmp);
 
 	if (u8tmp)
 		goto skip_fw_download;
 
 	/* global reset, global diseqc reset, golbal fec reset */
-	ret = m88ds3103_wr_reg(priv, 0x07, 0xe0);
+	ret = m88ds3103_wr_reg(dev, 0x07, 0xe0);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0x07, 0x00);
+	ret = m88ds3103_wr_reg(dev, 0x07, 0x00);
 	if (ret)
 		goto err;
 
 	/* cold state - try to download firmware */
-	dev_info(&priv->i2c->dev, "%s: found a '%s' in cold state\n",
-			KBUILD_MODNAME, m88ds3103_ops.info.name);
+	dev_info(&client->dev, "found a '%s' in cold state\n",
+		 m88ds3103_ops.info.name);
 
-	if (priv->chip_id == M88RS6000_CHIP_ID)
+	if (dev->chip_id == M88RS6000_CHIP_ID)
 		fw_file = M88RS6000_FIRMWARE;
 	else
 		fw_file = M88DS3103_FIRMWARE;
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
+	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
-		dev_err(&priv->i2c->dev, "%s: firmware file '%s' not found\n",
-				KBUILD_MODNAME, fw_file);
+		dev_err(&client->dev, "firmare file '%s' not found\n", fw_file);
 		goto err;
 	}
 
-	dev_info(&priv->i2c->dev, "%s: downloading firmware from file '%s'\n",
-			KBUILD_MODNAME, fw_file);
+	dev_info(&client->dev, "downloading firmware from file '%s'\n",
+		 fw_file);
 
-	ret = m88ds3103_wr_reg(priv, 0xb2, 0x01);
+	ret = m88ds3103_wr_reg(dev, 0xb2, 0x01);
 	if (ret)
 		goto error_fw_release;
 
 	for (remaining = fw->size; remaining > 0;
-			remaining -= (priv->cfg->i2c_wr_max - 1)) {
+			remaining -= (dev->cfg->i2c_wr_max - 1)) {
 		len = remaining;
-		if (len > (priv->cfg->i2c_wr_max - 1))
-			len = (priv->cfg->i2c_wr_max - 1);
+		if (len > (dev->cfg->i2c_wr_max - 1))
+			len = (dev->cfg->i2c_wr_max - 1);
 
-		ret = m88ds3103_wr_regs(priv, 0xb0,
+		ret = m88ds3103_wr_regs(dev, 0xb0,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
-			dev_err(&priv->i2c->dev,
-					"%s: firmware download failed=%d\n",
-					KBUILD_MODNAME, ret);
+			dev_err(&client->dev, "firmware download failed=%d\n",
+				ret);
 			goto error_fw_release;
 		}
 	}
 
-	ret = m88ds3103_wr_reg(priv, 0xb2, 0x00);
+	ret = m88ds3103_wr_reg(dev, 0xb2, 0x00);
 	if (ret)
 		goto error_fw_release;
 
 	release_firmware(fw);
 	fw = NULL;
 
-	ret = m88ds3103_rd_reg(priv, 0xb9, &u8tmp);
+	ret = m88ds3103_rd_reg(dev, 0xb9, &u8tmp);
 	if (ret)
 		goto err;
 
 	if (!u8tmp) {
-		dev_info(&priv->i2c->dev, "%s: firmware did not run\n",
-				KBUILD_MODNAME);
+		dev_info(&client->dev, "firmware did not run\n");
 		ret = -EFAULT;
 		goto err;
 	}
 
-	dev_info(&priv->i2c->dev, "%s: found a '%s' in warm state\n",
-			KBUILD_MODNAME, m88ds3103_ops.info.name);
-	dev_info(&priv->i2c->dev, "%s: firmware version %X.%X\n",
-			KBUILD_MODNAME, (u8tmp >> 4) & 0xf, (u8tmp >> 0 & 0xf));
+	dev_info(&client->dev, "found a '%s' in warm state\n",
+		 m88ds3103_ops.info.name);
+	dev_info(&client->dev, "firmware version: %X.%X\n",
+		 (u8tmp >> 4) & 0xf, (u8tmp >> 0 & 0xf));
 
 skip_fw_download:
 	/* warm state */
-	priv->warm = true;
+	dev->warm = true;
+
 	/* init stats here in order signal app which stats are supported */
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
@@ -850,75 +845,77 @@ skip_fw_download:
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_count.len = 1;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	return 0;
 
+	return 0;
 error_fw_release:
 	release_firmware(fw);
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_sleep(struct dvb_frontend *fe)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
-	priv->fe_status = 0;
-	priv->delivery_system = SYS_UNDEFINED;
+	dev->fe_status = 0;
+	dev->delivery_system = SYS_UNDEFINED;
 
 	/* TS Hi-Z */
-	if (priv->chip_id == M88RS6000_CHIP_ID)
+	if (dev->chip_id == M88RS6000_CHIP_ID)
 		u8tmp = 0x29;
 	else
 		u8tmp = 0x27;
-	ret = m88ds3103_wr_reg_mask(priv, u8tmp, 0x00, 0x01);
+	ret = m88ds3103_wr_reg_mask(dev, u8tmp, 0x00, 0x01);
 	if (ret)
 		goto err;
 
 	/* sleep */
-	ret = m88ds3103_wr_reg_mask(priv, 0x08, 0x00, 0x01);
+	ret = m88ds3103_wr_reg_mask(dev, 0x08, 0x00, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(priv, 0x04, 0x01, 0x01);
+	ret = m88ds3103_wr_reg_mask(dev, 0x04, 0x01, 0x01);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg_mask(priv, 0x23, 0x10, 0x10);
+	ret = m88ds3103_wr_reg_mask(dev, 0x23, 0x10, 0x10);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
-	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
+	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		ret = 0;
 		goto err;
 	}
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-		ret = m88ds3103_rd_reg(priv, 0xe0, &buf[0]);
+		ret = m88ds3103_rd_reg(dev, 0xe0, &buf[0]);
 		if (ret)
 			goto err;
 
-		ret = m88ds3103_rd_reg(priv, 0xe6, &buf[1]);
+		ret = m88ds3103_rd_reg(dev, 0xe6, &buf[1]);
 		if (ret)
 			goto err;
 
@@ -948,23 +945,22 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 			c->fec_inner = FEC_1_2;
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid fec_inner\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid fec_inner\n");
 		}
 
 		c->modulation = QPSK;
 
 		break;
 	case SYS_DVBS2:
-		ret = m88ds3103_rd_reg(priv, 0x7e, &buf[0]);
+		ret = m88ds3103_rd_reg(dev, 0x7e, &buf[0]);
 		if (ret)
 			goto err;
 
-		ret = m88ds3103_rd_reg(priv, 0x89, &buf[1]);
+		ret = m88ds3103_rd_reg(dev, 0x89, &buf[1]);
 		if (ret)
 			goto err;
 
-		ret = m88ds3103_rd_reg(priv, 0xf2, &buf[2]);
+		ret = m88ds3103_rd_reg(dev, 0xf2, &buf[2]);
 		if (ret)
 			goto err;
 
@@ -997,8 +993,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 			c->fec_inner = FEC_9_10;
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid fec_inner\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid fec_inner\n");
 		}
 
 		switch ((buf[0] >> 5) & 0x01) {
@@ -1024,8 +1019,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 			c->modulation = APSK_32;
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid modulation\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid modulation\n");
 		}
 
 		switch ((buf[1] >> 7) & 0x01) {
@@ -1048,27 +1042,25 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 			c->rolloff = ROLLOFF_20;
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid rolloff\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid rolloff\n");
 		}
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid delivery_system\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	ret = m88ds3103_rd_regs(priv, 0x6d, buf, 2);
+	ret = m88ds3103_rd_regs(dev, 0x6d, buf, 2);
 	if (ret)
 		goto err;
 
 	c->symbol_rate = 1ull * ((buf[1] << 8) | (buf[0] << 0)) *
-			priv->mclk_khz * 1000 / 0x10000;
+			dev->mclk_khz * 1000 / 0x10000;
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1086,9 +1078,9 @@ static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 static int m88ds3103_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
 
-	*ber = priv->dvbv3_ber;
+	*ber = dev->dvbv3_ber;
 
 	return 0;
 }
@@ -1096,14 +1088,14 @@ static int m88ds3103_read_ber(struct dvb_frontend *fe, u32 *ber)
 static int m88ds3103_set_tone(struct dvb_frontend *fe,
 	fe_sec_tone_mode_t fe_sec_tone_mode)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 u8tmp, tone, reg_a1_mask;
 
-	dev_dbg(&priv->i2c->dev, "%s: fe_sec_tone_mode=%d\n", __func__,
-			fe_sec_tone_mode);
+	dev_dbg(&client->dev, "fe_sec_tone_mode=%d\n", fe_sec_tone_mode);
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -1118,40 +1110,39 @@ static int m88ds3103_set_tone(struct dvb_frontend *fe,
 		reg_a1_mask = 0x00;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_tone_mode\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid fe_sec_tone_mode\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	u8tmp = tone << 7 | priv->cfg->envelope_mode << 5;
-	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0xe0);
+	u8tmp = tone << 7 | dev->cfg->envelope_mode << 5;
+	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0xe0);
 	if (ret)
 		goto err;
 
 	u8tmp = 1 << 2;
-	ret = m88ds3103_wr_reg_mask(priv, 0xa1, u8tmp, reg_a1_mask);
+	ret = m88ds3103_wr_reg_mask(dev, 0xa1, u8tmp, reg_a1_mask);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_set_voltage(struct dvb_frontend *fe,
 	fe_sec_voltage_t fe_sec_voltage)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 u8tmp;
 	bool voltage_sel, voltage_dis;
 
-	dev_dbg(&priv->i2c->dev, "%s: fe_sec_voltage=%d\n", __func__,
-			fe_sec_voltage);
+	dev_dbg(&client->dev, "fe_sec_voltage=%d\n", fe_sec_voltage);
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -1170,39 +1161,39 @@ static int m88ds3103_set_voltage(struct dvb_frontend *fe,
 		voltage_dis = true;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_voltage\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid fe_sec_voltage\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
 	/* output pin polarity */
-	voltage_sel ^= priv->cfg->lnb_hv_pol;
-	voltage_dis ^= priv->cfg->lnb_en_pol;
+	voltage_sel ^= dev->cfg->lnb_hv_pol;
+	voltage_dis ^= dev->cfg->lnb_en_pol;
 
 	u8tmp = voltage_dis << 1 | voltage_sel << 0;
-	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0x03);
+	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0x03);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		struct dvb_diseqc_master_cmd *diseqc_cmd)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	unsigned long timeout;
 	u8 u8tmp;
 
-	dev_dbg(&priv->i2c->dev, "%s: msg=%*ph\n", __func__,
-			diseqc_cmd->msg_len, diseqc_cmd->msg);
+	dev_dbg(&client->dev, "msg=%*ph\n",
+		diseqc_cmd->msg_len, diseqc_cmd->msg);
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -1212,17 +1203,17 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		goto err;
 	}
 
-	u8tmp = priv->cfg->envelope_mode << 5;
-	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0xe0);
+	u8tmp = dev->cfg->envelope_mode << 5;
+	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0xe0);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_regs(priv, 0xa3, diseqc_cmd->msg,
+	ret = m88ds3103_wr_regs(dev, 0xa3, diseqc_cmd->msg,
 			diseqc_cmd->msg_len);
 	if (ret)
 		goto err;
 
-	ret = m88ds3103_wr_reg(priv, 0xa1,
+	ret = m88ds3103_wr_reg(dev, 0xa1,
 			(diseqc_cmd->msg_len - 1) << 3 | 0x07);
 	if (ret)
 		goto err;
@@ -1235,24 +1226,24 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	usleep_range(50000, 54000);
 
 	for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
-		ret = m88ds3103_rd_reg_mask(priv, 0xa1, &u8tmp, 0x40);
+		ret = m88ds3103_rd_reg_mask(dev, 0xa1, &u8tmp, 0x40);
 		if (ret)
 			goto err;
 	}
 
 	if (u8tmp == 0) {
-		dev_dbg(&priv->i2c->dev, "%s: diseqc tx took %u ms\n", __func__,
+		dev_dbg(&client->dev, "diseqc tx took %u ms\n",
 			jiffies_to_msecs(jiffies) -
 			(jiffies_to_msecs(timeout) - SEND_MASTER_CMD_TIMEOUT));
 	} else {
-		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
+		dev_dbg(&client->dev, "diseqc tx timeout\n");
 
-		ret = m88ds3103_wr_reg_mask(priv, 0xa1, 0x40, 0xc0);
+		ret = m88ds3103_wr_reg_mask(dev, 0xa1, 0x40, 0xc0);
 		if (ret)
 			goto err;
 	}
 
-	ret = m88ds3103_wr_reg_mask(priv, 0xa2, 0x80, 0xc0);
+	ret = m88ds3103_wr_reg_mask(dev, 0xa2, 0x80, 0xc0);
 	if (ret)
 		goto err;
 
@@ -1263,28 +1254,28 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	fe_sec_mini_cmd_t fe_sec_mini_cmd)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	unsigned long timeout;
 	u8 u8tmp, burst;
 
-	dev_dbg(&priv->i2c->dev, "%s: fe_sec_mini_cmd=%d\n", __func__,
-			fe_sec_mini_cmd);
+	dev_dbg(&client->dev, "fe_sec_mini_cmd=%d\n", fe_sec_mini_cmd);
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
 
-	u8tmp = priv->cfg->envelope_mode << 5;
-	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0xe0);
+	u8tmp = dev->cfg->envelope_mode << 5;
+	ret = m88ds3103_wr_reg_mask(dev, 0xa2, u8tmp, 0xe0);
 	if (ret)
 		goto err;
 
@@ -1296,13 +1287,12 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 		burst = 0x01;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_mini_cmd\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid fe_sec_mini_cmd\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	ret = m88ds3103_wr_reg(priv, 0xa1, burst);
+	ret = m88ds3103_wr_reg(dev, 0xa1, burst);
 	if (ret)
 		goto err;
 
@@ -1314,24 +1304,24 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	usleep_range(8500, 12500);
 
 	for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
-		ret = m88ds3103_rd_reg_mask(priv, 0xa1, &u8tmp, 0x40);
+		ret = m88ds3103_rd_reg_mask(dev, 0xa1, &u8tmp, 0x40);
 		if (ret)
 			goto err;
 	}
 
 	if (u8tmp == 0) {
-		dev_dbg(&priv->i2c->dev, "%s: diseqc tx took %u ms\n", __func__,
+		dev_dbg(&client->dev, "diseqc tx took %u ms\n",
 			jiffies_to_msecs(jiffies) -
 			(jiffies_to_msecs(timeout) - SEND_BURST_TIMEOUT));
 	} else {
-		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
+		dev_dbg(&client->dev, "diseqc tx timeout\n");
 
-		ret = m88ds3103_wr_reg_mask(priv, 0xa1, 0x40, 0xc0);
+		ret = m88ds3103_wr_reg_mask(dev, 0xa1, 0x40, 0xc0);
 		if (ret)
 			goto err;
 	}
 
-	ret = m88ds3103_wr_reg_mask(priv, 0xa2, 0x80, 0xc0);
+	ret = m88ds3103_wr_reg_mask(dev, 0xa2, 0x80, 0xc0);
 	if (ret)
 		goto err;
 
@@ -1342,7 +1332,7 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1356,32 +1346,32 @@ static int m88ds3103_get_tune_settings(struct dvb_frontend *fe,
 
 static void m88ds3103_release(struct dvb_frontend *fe)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 
 	i2c_unregister_device(client);
 }
 
 static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
-	struct m88ds3103_priv *priv = mux_priv;
+	struct m88ds3103_dev *dev = mux_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	struct i2c_msg gate_open_msg[1] = {
 		{
-			.addr = priv->cfg->i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 2,
 			.buf = "\x03\x11",
 		}
 	};
 
-	mutex_lock(&priv->i2c_mutex);
+	mutex_lock(&dev->i2c_mutex);
 
 	/* open tuner I2C repeater for 1 xfer, closes automatically */
-	ret = __i2c_transfer(priv->i2c, gate_open_msg, 1);
+	ret = __i2c_transfer(client->adapter, gate_open_msg, 1);
 	if (ret != 1) {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d\n",
-				KBUILD_MODNAME, ret);
+		dev_warn(&client->dev, "i2c wr failed=%d\n", ret);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 
@@ -1394,9 +1384,9 @@ static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 static int m88ds3103_deselect(struct i2c_adapter *adap, void *mux_priv,
 		u32 chan)
 {
-	struct m88ds3103_priv *priv = mux_priv;
+	struct m88ds3103_dev *dev = mux_priv;
 
-	mutex_unlock(&priv->i2c_mutex);
+	mutex_unlock(&dev->i2c_mutex);
 
 	return 0;
 }
@@ -1441,9 +1431,9 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 EXPORT_SYMBOL(m88ds3103_attach);
 
 static struct dvb_frontend_ops m88ds3103_ops = {
-	.delsys = { SYS_DVBS, SYS_DVBS2 },
+	.delsys = {SYS_DVBS, SYS_DVBS2},
 	.info = {
-		.name = "Montage M88DS3103",
+		.name = "Montage Technology M88DS3103",
 		.frequency_min =  950000,
 		.frequency_max = 2150000,
 		.frequency_tolerance = 5000,
@@ -1487,7 +1477,7 @@ static struct dvb_frontend_ops m88ds3103_ops = {
 
 static struct dvb_frontend *m88ds3103_get_dvb_frontend(struct i2c_client *client)
 {
-	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
+	struct m88ds3103_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
@@ -1496,7 +1486,7 @@ static struct dvb_frontend *m88ds3103_get_dvb_frontend(struct i2c_client *client
 
 static struct i2c_adapter *m88ds3103_get_i2c_adapter(struct i2c_client *client)
 {
-	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
+	struct m88ds3103_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
@@ -1506,7 +1496,7 @@ static struct i2c_adapter *m88ds3103_get_i2c_adapter(struct i2c_client *client)
 static int m88ds3103_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct m88ds3103_priv *dev;
+	struct m88ds3103_dev *dev;
 	struct m88ds3103_platform_data *pdata = client->dev.platform_data;
 	int ret;
 	u8 chip_id, u8tmp;
@@ -1518,8 +1508,6 @@ static int m88ds3103_probe(struct i2c_client *client,
 	}
 
 	dev->client = client;
-	dev->i2c = client->adapter;
-	dev->config.i2c_addr = client->addr;
 	dev->config.clock = pdata->clk;
 	dev->config.i2c_wr_max = pdata->i2c_wr_max;
 	dev->config.ts_mode = pdata->ts_mode;
@@ -1599,8 +1587,8 @@ static int m88ds3103_probe(struct i2c_client *client,
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
 	if (dev->chip_id == M88RS6000_CHIP_ID)
-		strncpy(dev->fe.ops.info.name,
-			"Montage M88RS6000", sizeof(dev->fe.ops.info.name));
+		strncpy(dev->fe.ops.info.name, "Montage Technology M88RS6000",
+			sizeof(dev->fe.ops.info.name));
 	if (!pdata->attach_in_use)
 		dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = dev;
@@ -1619,7 +1607,7 @@ err:
 
 static int m88ds3103_remove(struct i2c_client *client)
 {
-	struct m88ds3103_priv *dev = i2c_get_clientdata(client);
+	struct m88ds3103_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
@@ -1649,7 +1637,7 @@ static struct i2c_driver m88ds3103_driver = {
 module_i2c_driver(m88ds3103_driver);
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
-MODULE_DESCRIPTION("Montage M88DS3103 DVB-S/S2 demodulator driver");
+MODULE_DESCRIPTION("Montage Technology M88DS3103 DVB-S/S2 demodulator driver");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(M88DS3103_FIRMWARE);
 MODULE_FIRMWARE(M88RS6000_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index 3811468..ff03905 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -1,5 +1,5 @@
 /*
- * Montage M88DS3103 demodulator driver
+ * Montage Technology M88DS3103/M88RS6000 demodulator driver
  *
  * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
  *
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 6217d92..7461e6b 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -1,5 +1,5 @@
 /*
- * Montage M88DS3103 demodulator driver
+ * Montage Technology M88DS3103/M88RS6000 demodulator driver
  *
  * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
  *
@@ -30,8 +30,7 @@
 #define M88RS6000_CHIP_ID 0x74
 #define M88DS3103_CHIP_ID 0x70
 
-struct m88ds3103_priv {
-	struct i2c_adapter *i2c;
+struct m88ds3103_dev {
 	struct i2c_client *client;
 	/* mutex needed due to own tuner I2C adapter */
 	struct mutex i2c_mutex;
-- 
http://palosaari.fi/

