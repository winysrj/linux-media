Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43976 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/8] ts2020: convert to regmap I2C API
Date: Sat,  6 Jun 2015 14:58:44 +0300
Message-Id: <1433591928-30915-4-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap to cover I2C register access.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig  |   3 +-
 drivers/media/dvb-frontends/ts2020.c | 260 ++++++++++++++++-------------------
 2 files changed, 124 insertions(+), 139 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 65034a8..ba65a00 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -239,7 +239,8 @@ config DVB_SI21XX
 
 config DVB_TS2020
 	tristate "Montage Tehnology TS2020 based tuners"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/S2 silicon tuner. Say Y when you want to support this tuner.
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 7b2f301..797112b 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -21,12 +21,16 @@
 
 #include "dvb_frontend.h"
 #include "ts2020.h"
+#include <linux/regmap.h>
 
 #define TS2020_XTAL_FREQ   27000 /* in kHz */
 #define FREQ_OFFSET_LOW_SYM_RATE 3000
 
 struct ts2020_priv {
 	struct i2c_client *client;
+	struct mutex regmap_mutex;
+	struct regmap_config regmap_config;
+	struct regmap *regmap;
 	struct dvb_frontend *fe;
 	/* i2c details */
 	int i2c_address;
@@ -57,74 +61,6 @@ static int ts2020_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int ts2020_writereg(struct dvb_frontend *fe, int reg, int data)
-{
-	struct ts2020_priv *priv = fe->tuner_priv;
-	u8 buf[] = { reg, data };
-	struct i2c_msg msg[] = {
-		{
-			.addr = priv->i2c_address,
-			.flags = 0,
-			.buf = buf,
-			.len = 2
-		}
-	};
-	int err;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	err = i2c_transfer(priv->i2c, msg, 1);
-	if (err != 1) {
-		printk(KERN_ERR
-		       "%s: writereg error(err == %i, reg == 0x%02x, value == 0x%02x)\n",
-		       __func__, err, reg, data);
-		return -EREMOTEIO;
-	}
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return 0;
-}
-
-static int ts2020_readreg(struct dvb_frontend *fe, u8 reg)
-{
-	struct ts2020_priv *priv = fe->tuner_priv;
-	int ret;
-	u8 b0[] = { reg };
-	u8 b1[] = { 0 };
-	struct i2c_msg msg[] = {
-		{
-			.addr = priv->i2c_address,
-			.flags = 0,
-			.buf = b0,
-			.len = 1
-		}, {
-			.addr = priv->i2c_address,
-			.flags = I2C_M_RD,
-			.buf = b1,
-			.len = 1
-		}
-	};
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	ret = i2c_transfer(priv->i2c, msg, 2);
-
-	if (ret != 2) {
-		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n",
-		       __func__, reg, ret);
-		return ret;
-	}
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return b1[0];
-}
-
 static int ts2020_sleep(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
@@ -135,7 +71,7 @@ static int ts2020_sleep(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x00;
 
-	return ts2020_writereg(fe, u8tmp, 0x00);
+	return regmap_write(priv->regmap, u8tmp, 0x00);
 }
 
 static int ts2020_init(struct dvb_frontend *fe)
@@ -145,14 +81,14 @@ static int ts2020_init(struct dvb_frontend *fe)
 	u8 u8tmp;
 
 	if (priv->tuner == TS2020_M88TS2020) {
-		ts2020_writereg(fe, 0x42, 0x73);
-		ts2020_writereg(fe, 0x05, priv->clk_out_div);
-		ts2020_writereg(fe, 0x20, 0x27);
-		ts2020_writereg(fe, 0x07, 0x02);
-		ts2020_writereg(fe, 0x11, 0xff);
-		ts2020_writereg(fe, 0x60, 0xf9);
-		ts2020_writereg(fe, 0x08, 0x01);
-		ts2020_writereg(fe, 0x00, 0x41);
+		regmap_write(priv->regmap, 0x42, 0x73);
+		regmap_write(priv->regmap, 0x05, priv->clk_out_div);
+		regmap_write(priv->regmap, 0x20, 0x27);
+		regmap_write(priv->regmap, 0x07, 0x02);
+		regmap_write(priv->regmap, 0x11, 0xff);
+		regmap_write(priv->regmap, 0x60, 0xf9);
+		regmap_write(priv->regmap, 0x08, 0x01);
+		regmap_write(priv->regmap, 0x00, 0x41);
 	} else {
 		static const struct ts2020_reg_val reg_vals[] = {
 			{0x7d, 0x9d},
@@ -168,8 +104,8 @@ static int ts2020_init(struct dvb_frontend *fe)
 			{0x12, 0xa0},
 		};
 
-		ts2020_writereg(fe, 0x00, 0x01);
-		ts2020_writereg(fe, 0x00, 0x03);
+		regmap_write(priv->regmap, 0x00, 0x01);
+		regmap_write(priv->regmap, 0x00, 0x03);
 
 		switch (priv->clk_out) {
 		case TS2020_CLK_OUT_DISABLED:
@@ -177,7 +113,7 @@ static int ts2020_init(struct dvb_frontend *fe)
 			break;
 		case TS2020_CLK_OUT_ENABLED:
 			u8tmp = 0x70;
-			ts2020_writereg(fe, 0x05, priv->clk_out_div);
+			regmap_write(priv->regmap, 0x05, priv->clk_out_div);
 			break;
 		case TS2020_CLK_OUT_ENABLED_XTALOUT:
 			u8tmp = 0x6c;
@@ -187,17 +123,18 @@ static int ts2020_init(struct dvb_frontend *fe)
 			break;
 		}
 
-		ts2020_writereg(fe, 0x42, u8tmp);
+		regmap_write(priv->regmap, 0x42, u8tmp);
 
 		if (priv->loop_through)
 			u8tmp = 0xec;
 		else
 			u8tmp = 0x6c;
 
-		ts2020_writereg(fe, 0x62, u8tmp);
+		regmap_write(priv->regmap, 0x62, u8tmp);
 
 		for (i = 0; i < ARRAY_SIZE(reg_vals); i++)
-			ts2020_writereg(fe, reg_vals[i].reg, reg_vals[i].val);
+			regmap_write(priv->regmap, reg_vals[i].reg,
+				     reg_vals[i].val);
 	}
 
 	return 0;
@@ -205,32 +142,35 @@ static int ts2020_init(struct dvb_frontend *fe)
 
 static int ts2020_tuner_gate_ctrl(struct dvb_frontend *fe, u8 offset)
 {
+	struct ts2020_priv *priv = fe->tuner_priv;
 	int ret;
-	ret = ts2020_writereg(fe, 0x51, 0x1f - offset);
-	ret |= ts2020_writereg(fe, 0x51, 0x1f);
-	ret |= ts2020_writereg(fe, 0x50, offset);
-	ret |= ts2020_writereg(fe, 0x50, 0x00);
+	ret = regmap_write(priv->regmap, 0x51, 0x1f - offset);
+	ret |= regmap_write(priv->regmap, 0x51, 0x1f);
+	ret |= regmap_write(priv->regmap, 0x50, offset);
+	ret |= regmap_write(priv->regmap, 0x50, 0x00);
 	msleep(20);
 	return ret;
 }
 
 static int ts2020_set_tuner_rf(struct dvb_frontend *fe)
 {
-	int reg;
-
-	reg = ts2020_readreg(fe, 0x3d);
-	reg &= 0x7f;
-	if (reg < 0x16)
-		reg = 0xa1;
-	else if (reg == 0x16)
-		reg = 0x99;
+	struct ts2020_priv *dev = fe->tuner_priv;
+	int ret;
+	unsigned int utmp;
+
+	ret = regmap_read(dev->regmap, 0x3d, &utmp);
+	utmp &= 0x7f;
+	if (utmp < 0x16)
+		utmp = 0xa1;
+	else if (utmp == 0x16)
+		utmp = 0x99;
 	else
-		reg = 0xf9;
+		utmp = 0xf9;
 
-	ts2020_writereg(fe, 0x60, reg);
-	reg = ts2020_tuner_gate_ctrl(fe, 0x08);
+	regmap_write(dev->regmap, 0x60, utmp);
+	ret = ts2020_tuner_gate_ctrl(fe, 0x08);
 
-	return reg;
+	return ret;
 }
 
 static int ts2020_set_params(struct dvb_frontend *fe)
@@ -238,6 +178,7 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct ts2020_priv *priv = fe->tuner_priv;
 	int ret;
+	unsigned int utmp;
 	u32 f3db, gdiv28;
 	u16 u16tmp, value, lpf_coeff;
 	u8 buf[3], reg10, lpf_mxdiv, mlpf_max, mlpf_min, nlpf;
@@ -272,12 +213,12 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	if (priv->tuner == TS2020_M88TS2020) {
 		lpf_coeff = 2766;
 		reg10 |= 0x01;
-		ret = ts2020_writereg(fe, 0x10, reg10);
+		ret = regmap_write(priv->regmap, 0x10, reg10);
 	} else {
 		lpf_coeff = 3200;
 		reg10 |= 0x0b;
-		ret = ts2020_writereg(fe, 0x10, reg10);
-		ret |= ts2020_writereg(fe, 0x11, 0x40);
+		ret = regmap_write(priv->regmap, 0x10, reg10);
+		ret |= regmap_write(priv->regmap, 0x11, 0x40);
 	}
 
 	u16tmp = pll_n - 1024;
@@ -285,9 +226,9 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	buf[1] = (u16tmp >> 0) & 0xff;
 	buf[2] = div_ref - 8;
 
-	ret |= ts2020_writereg(fe, 0x01, buf[0]);
-	ret |= ts2020_writereg(fe, 0x02, buf[1]);
-	ret |= ts2020_writereg(fe, 0x03, buf[2]);
+	ret |= regmap_write(priv->regmap, 0x01, buf[0]);
+	ret |= regmap_write(priv->regmap, 0x02, buf[1]);
+	ret |= regmap_write(priv->regmap, 0x03, buf[2]);
 
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x10);
 	if (ret < 0)
@@ -300,21 +241,22 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 		ret |= ts2020_set_tuner_rf(fe);
 
 	gdiv28 = (TS2020_XTAL_FREQ / 1000 * 1694 + 500) / 1000;
-	ret |= ts2020_writereg(fe, 0x04, gdiv28 & 0xff);
+	ret |= regmap_write(priv->regmap, 0x04, gdiv28 & 0xff);
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x04);
 	if (ret < 0)
 		return -ENODEV;
 
 	if (priv->tuner == TS2020_M88TS2022) {
-		ret = ts2020_writereg(fe, 0x25, 0x00);
-		ret |= ts2020_writereg(fe, 0x27, 0x70);
-		ret |= ts2020_writereg(fe, 0x41, 0x09);
-		ret |= ts2020_writereg(fe, 0x08, 0x0b);
+		ret = regmap_write(priv->regmap, 0x25, 0x00);
+		ret |= regmap_write(priv->regmap, 0x27, 0x70);
+		ret |= regmap_write(priv->regmap, 0x41, 0x09);
+		ret |= regmap_write(priv->regmap, 0x08, 0x0b);
 		if (ret < 0)
 			return -ENODEV;
 	}
 
-	value = ts2020_readreg(fe, 0x26);
+	regmap_read(priv->regmap, 0x26, &utmp);
+	value = utmp;
 
 	f3db = (c->bandwidth_hz / 1000 / 2) + 2000;
 	f3db += FREQ_OFFSET_LOW_SYM_RATE; /* FIXME: ~always too wide filter */
@@ -345,8 +287,8 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	if (lpf_mxdiv > mlpf_max)
 		lpf_mxdiv = mlpf_max;
 
-	ret = ts2020_writereg(fe, 0x04, lpf_mxdiv);
-	ret |= ts2020_writereg(fe, 0x06, nlpf);
+	ret = regmap_write(priv->regmap, 0x04, lpf_mxdiv);
+	ret |= regmap_write(priv->regmap, 0x06, nlpf);
 
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x04);
 
@@ -375,11 +317,15 @@ static int ts2020_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 						u16 *signal_strength)
 {
+	struct ts2020_priv *priv = fe->tuner_priv;
+	unsigned int utmp;
 	u16 sig_reading, sig_strength;
 	u8 rfgain, bbgain;
 
-	rfgain = ts2020_readreg(fe, 0x3d) & 0x1f;
-	bbgain = ts2020_readreg(fe, 0x21) & 0x1f;
+	regmap_read(priv->regmap, 0x3d, &utmp);
+	rfgain = utmp & 0x1f;
+	regmap_read(priv->regmap, 0x21, &utmp);
+	bbgain = utmp & 0x1f;
 
 	if (rfgain > 15)
 		rfgain = 15;
@@ -435,6 +381,29 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 }
 EXPORT_SYMBOL(ts2020_attach);
 
+/*
+ * We implement own regmap locking due to legacy DVB attach which uses frontend
+ * gate control callback to control I2C bus access. We can open / close gate and
+ * serialize whole open / I2C-operation / close sequence at the same.
+ */
+static void ts2020_regmap_lock(void *__dev)
+{
+	struct ts2020_priv *dev = __dev;
+
+	mutex_lock(&dev->regmap_mutex);
+	if (dev->fe->ops.i2c_gate_ctrl)
+		dev->fe->ops.i2c_gate_ctrl(dev->fe, 1);
+}
+
+static void ts2020_regmap_unlock(void *__dev)
+{
+	struct ts2020_priv *dev = __dev;
+
+	if (dev->fe->ops.i2c_gate_ctrl)
+		dev->fe->ops.i2c_gate_ctrl(dev->fe, 0);
+	mutex_unlock(&dev->regmap_mutex);
+}
+
 static int ts2020_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
@@ -452,6 +421,19 @@ static int ts2020_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	/* create regmap */
+	mutex_init(&dev->regmap_mutex);
+	dev->regmap_config.reg_bits = 8,
+	dev->regmap_config.val_bits = 8,
+	dev->regmap_config.lock = ts2020_regmap_lock,
+	dev->regmap_config.unlock = ts2020_regmap_unlock,
+	dev->regmap_config.lock_arg = dev,
+	dev->regmap = regmap_init_i2c(client, &dev->regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
+
 	dev->i2c = client->adapter;
 	dev->i2c_address = client->addr;
 	dev->clk_out = pdata->clk_out;
@@ -462,29 +444,27 @@ static int ts2020_probe(struct i2c_client *client,
 	dev->client = client;
 
 	/* check if the tuner is there */
-	ret = ts2020_readreg(fe, 0x00);
-	if (ret < 0)
-		goto err;
-	utmp = ret;
+	ret = regmap_read(dev->regmap, 0x00, &utmp);
+	if (ret)
+		goto err_regmap_exit;
 
 	if ((utmp & 0x03) == 0x00) {
-		ret = ts2020_writereg(fe, 0x00, 0x01);
+		ret = regmap_write(dev->regmap, 0x00, 0x01);
 		if (ret)
-			goto err;
+			goto err_regmap_exit;
 
 		usleep_range(2000, 50000);
 	}
 
-	ret = ts2020_writereg(fe, 0x00, 0x03);
+	ret = regmap_write(dev->regmap, 0x00, 0x03);
 	if (ret)
-		goto err;
+		goto err_regmap_exit;
 
 	usleep_range(2000, 50000);
 
-	ret = ts2020_readreg(fe, 0x00);
-	if (ret < 0)
-		goto err;
-	utmp = ret;
+	ret = regmap_read(dev->regmap, 0x00, &utmp);
+	if (ret)
+		goto err_regmap_exit;
 
 	dev_dbg(&client->dev, "chip_id=%02x\n", utmp);
 
@@ -506,7 +486,7 @@ static int ts2020_probe(struct i2c_client *client,
 		break;
 	default:
 		ret = -ENODEV;
-		goto err;
+		goto err_regmap_exit;
 	}
 
 	if (dev->tuner == TS2020_M88TS2022) {
@@ -516,36 +496,36 @@ static int ts2020_probe(struct i2c_client *client,
 			break;
 		case TS2020_CLK_OUT_ENABLED:
 			u8tmp = 0x70;
-			ret = ts2020_writereg(fe, 0x05, dev->clk_out_div);
+			ret = regmap_write(dev->regmap, 0x05, dev->clk_out_div);
 			if (ret)
-				goto err;
+				goto err_regmap_exit;
 			break;
 		case TS2020_CLK_OUT_ENABLED_XTALOUT:
 			u8tmp = 0x6c;
 			break;
 		default:
 			ret = -EINVAL;
-			goto err;
+			goto err_regmap_exit;
 		}
 
-		ret = ts2020_writereg(fe, 0x42, u8tmp);
+		ret = regmap_write(dev->regmap, 0x42, u8tmp);
 		if (ret)
-			goto err;
+			goto err_regmap_exit;
 
 		if (dev->loop_through)
 			u8tmp = 0xec;
 		else
 			u8tmp = 0x6c;
 
-		ret = ts2020_writereg(fe, 0x62, u8tmp);
+		ret = regmap_write(dev->regmap, 0x62, u8tmp);
 		if (ret)
-			goto err;
+			goto err_regmap_exit;
 	}
 
 	/* sleep */
-	ret = ts2020_writereg(fe, 0x00, 0x00);
+	ret = regmap_write(dev->regmap, 0x00, 0x00);
 	if (ret)
-		goto err;
+		goto err_regmap_exit;
 
 	dev_info(&client->dev,
 		 "Montage Technology %s successfully identified\n", chip_str);
@@ -557,9 +537,12 @@ static int ts2020_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, dev);
 	return 0;
+err_regmap_exit:
+	regmap_exit(dev->regmap);
+err_kfree:
+	kfree(dev);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-	kfree(dev);
 	return ret;
 }
 
@@ -569,6 +552,7 @@ static int ts2020_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	regmap_exit(dev->regmap);
 	kfree(dev);
 	return 0;
 }
-- 
http://palosaari.fi/

