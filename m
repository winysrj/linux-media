Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59951 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab2IBBJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 21:09:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] Elonics E4000 silicon tuner driver
Date: Sun,  2 Sep 2012 04:09:21 +0300
Message-Id: <1346548162-21168-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig      |   7 +
 drivers/media/tuners/Makefile     |   1 +
 drivers/media/tuners/e4000.c      | 408 ++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/e4000.h      |  52 +++++
 drivers/media/tuners/e4000_priv.h | 147 ++++++++++++++
 5 files changed, 615 insertions(+)
 create mode 100644 drivers/media/tuners/e4000.c
 create mode 100644 drivers/media/tuners/e4000.h
 create mode 100644 drivers/media/tuners/e4000_priv.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 80238b9..f9e299c 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -222,6 +222,13 @@ config MEDIA_TUNER_TDA18212
 	help
 	  NXP TDA18212 silicon tuner driver.
 
+config MEDIA_TUNER_E4000
+	tristate "Elonics E4000 silicon tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Elonics E4000 silicon tuner driver.
+
 config MEDIA_TUNER_TUA9001
 	tristate "Infineon TUA 9001 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 112aeee..9f7b2c2 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
+obj-$(CONFIG_MEDIA_TUNER_E4000) += e4000.o
 obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
 obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
new file mode 100644
index 0000000..ffaa482
--- /dev/null
+++ b/drivers/media/tuners/e4000.c
@@ -0,0 +1,408 @@
+/*
+ * Elonics E4000 silicon tuner driver
+ *
+ * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "e4000_priv.h"
+
+/* write multiple registers */
+static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
+{
+	int ret;
+	u8 buf[1 + len];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = priv->cfg->i2c_addr,
+			.flags = 0,
+			.len = sizeof(buf),
+			.buf = buf,
+		}
+	};
+
+	buf[0] = reg;
+	memcpy(&buf[1], val, len);
+
+	ret = i2c_transfer(priv->i2c, msg, 1);
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+	return ret;
+}
+
+/* read multiple registers */
+static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
+{
+	int ret;
+	u8 buf[len];
+	struct i2c_msg msg[2] = {
+		{
+			.addr = priv->cfg->i2c_addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &reg,
+		}, {
+			.addr = priv->cfg->i2c_addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(buf),
+			.buf = buf,
+		}
+	};
+
+	ret = i2c_transfer(priv->i2c, msg, 2);
+	if (ret == 2) {
+		memcpy(val, buf, len);
+		ret = 0;
+	} else {
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+
+	return ret;
+}
+
+/* write single register */
+static int e4000_wr_reg(struct e4000_priv *priv, u8 reg, u8 val)
+{
+	return e4000_wr_regs(priv, reg, &val, 1);
+}
+
+/* read single register */
+static int e4000_rd_reg(struct e4000_priv *priv, u8 reg, u8 *val)
+{
+	return e4000_rd_regs(priv, reg, val, 1);
+}
+
+static int e4000_init(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	int ret;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* dummy I2C to ensure I2C wakes up */
+	ret = e4000_wr_reg(priv, 0x02, 0x40);
+
+	/* reset */
+	ret = e4000_wr_reg(priv, 0x00, 0x01);
+	if (ret < 0)
+		goto err;
+
+	/* disable output clock */
+	ret = e4000_wr_reg(priv, 0x06, 0x00);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x7a, 0x96);
+	if (ret < 0)
+		goto err;
+
+	/* configure gains */
+	ret = e4000_wr_regs(priv, 0x7e, "\x01\xfe", 2);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x82, 0x00);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x24, 0x05);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_regs(priv, 0x87, "\x20\x01", 2);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_regs(priv, 0x9f, "\x7f\x07", 2);
+	if (ret < 0)
+		goto err;
+
+	/*
+	 * TODO: Implement DC offset control correctly.
+	 * DC offsets has quite much effect for received signal quality in case
+	 * of direct conversion tuners (Zero-IF). Surely we will now lose few
+	 * decimals or even decibels from SNR...
+	 */
+	/* DC offset control */
+	ret = e4000_wr_reg(priv, 0x2d, 0x0c);
+	if (ret < 0)
+		goto err;
+
+	/* gain control */
+	ret = e4000_wr_reg(priv, 0x1a, 0x17);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x1f, 0x1a);
+	if (ret < 0)
+		goto err;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int e4000_sleep(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	int ret;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = e4000_wr_reg(priv, 0x00, 0x00);
+	if (ret < 0)
+		goto err;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int e4000_set_params(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, i, sigma_delta;
+	unsigned int f_VCO;
+	u8 buf[5];
+
+	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
+			"bandwidth_hz=%d\n", __func__,
+			c->delivery_system, c->frequency, c->bandwidth_hz);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* gain control manual */
+	ret = e4000_wr_reg(priv, 0x1a, 0x00);
+	if (ret < 0)
+		goto err;
+
+	/* PLL */
+	for (i = 0; i < ARRAY_SIZE(e4000_pll_lut); i++) {
+		if (c->frequency <= e4000_pll_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(e4000_pll_lut))
+		goto err;
+
+	/*
+	 * Note: Currently f_VCO overflows when c->frequency is 1 073 741 824 Hz
+	 * or more.
+	 */
+	f_VCO = c->frequency * e4000_pll_lut[i].mul;
+	sigma_delta = 0x10000UL * (f_VCO % priv->cfg->clock) / priv->cfg->clock;
+	buf[0] = f_VCO / priv->cfg->clock;
+	buf[1] = (sigma_delta >> 0) & 0xff;
+	buf[2] = (sigma_delta >> 8) & 0xff;
+	buf[3] = 0x00;
+	buf[4] = e4000_pll_lut[i].div;
+
+	dev_dbg(&priv->i2c->dev, "%s: f_VCO=%u pll div=%d sigma_delta=%04x\n",
+			__func__, f_VCO, buf[0], sigma_delta);
+
+	ret = e4000_wr_regs(priv, 0x09, buf, 5);
+	if (ret < 0)
+		goto err;
+
+	/* LNA filter (RF filter) */
+	for (i = 0; i < ARRAY_SIZE(e400_lna_filter_lut); i++) {
+		if (c->frequency <= e400_lna_filter_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(e400_lna_filter_lut))
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x10, e400_lna_filter_lut[i].val);
+	if (ret < 0)
+		goto err;
+
+	/* IF filters */
+	for (i = 0; i < ARRAY_SIZE(e4000_if_filter_lut); i++) {
+		if (c->bandwidth_hz <= e4000_if_filter_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(e4000_if_filter_lut))
+		goto err;
+
+	buf[0] = e4000_if_filter_lut[i].reg11_val;
+	buf[1] = e4000_if_filter_lut[i].reg12_val;
+
+	ret = e4000_wr_regs(priv, 0x11, buf, 2);
+	if (ret < 0)
+		goto err;
+
+	/* frequency band */
+	for (i = 0; i < ARRAY_SIZE(e4000_band_lut); i++) {
+		if (c->frequency <= e4000_band_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(e4000_band_lut))
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x07, e4000_band_lut[i].reg07_val);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_reg(priv, 0x78, e4000_band_lut[i].reg78_val);
+	if (ret < 0)
+		goto err;
+
+	/* gain control auto */
+	ret = e4000_wr_reg(priv, 0x1a, 0x17);
+	if (ret < 0)
+		goto err;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	*frequency = 0; /* Zero-IF */
+
+	return 0;
+}
+
+static int e4000_release(struct dvb_frontend *fe)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	kfree(fe->tuner_priv);
+
+	return 0;
+}
+
+static const struct dvb_tuner_ops e4000_tuner_ops = {
+	.info = {
+		.name           = "Elonics E4000",
+		.frequency_min  = 174000000,
+		.frequency_max  = 862000000,
+	},
+
+	.release = e4000_release,
+
+	.init = e4000_init,
+	.sleep = e4000_sleep,
+	.set_params = e4000_set_params,
+
+	.get_if_frequency = e4000_get_if_frequency,
+};
+
+struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
+		struct i2c_adapter *i2c, const struct e4000_config *cfg)
+{
+	struct e4000_priv *priv;
+	int ret;
+	u8 chip_id;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	priv = kzalloc(sizeof(struct e4000_priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
+
+	priv->cfg = cfg;
+	priv->i2c = i2c;
+	fe->tuner_priv = priv;
+	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
+	/* check if the tuner is there */
+	ret = e4000_rd_reg(priv, 0x02, &chip_id);
+	if (ret < 0)
+		goto err;
+
+	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+
+	if (chip_id != 0x40)
+		goto err;
+
+	/* put sleep as chip seems to be in normal mode by default */
+	ret = e4000_wr_reg(priv, 0x00, 0x00);
+	if (ret < 0)
+		goto err;
+
+	dev_info(&priv->i2c->dev,
+			"%s: Elonics E4000 successfully identified\n",
+			KBUILD_MODNAME);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return fe;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	kfree(priv);
+	return NULL;
+}
+EXPORT_SYMBOL(e4000_attach);
+
+MODULE_DESCRIPTION("Elonics E4000 silicon tuner driver");
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
new file mode 100644
index 0000000..71b1935
--- /dev/null
+++ b/drivers/media/tuners/e4000.h
@@ -0,0 +1,52 @@
+/*
+ * Elonics E4000 silicon tuner driver
+ *
+ * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef E4000_H
+#define E4000_H
+
+#include "dvb_frontend.h"
+
+struct e4000_config {
+	/*
+	 * I2C address
+	 * 0x64, 0x65, 0x66, 0x67
+	 */
+	u8 i2c_addr;
+
+	/*
+	 * clock
+	 */
+	u32 clock;
+};
+
+#if defined(CONFIG_MEDIA_TUNER_E4000) || \
+	(defined(CONFIG_MEDIA_TUNER_E4000_MODULE) && defined(MODULE))
+extern struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
+		struct i2c_adapter *i2c, const struct e4000_config *cfg);
+#else
+static inline struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
+		struct i2c_adapter *i2c, const struct e4000_config *cfg)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
new file mode 100644
index 0000000..a385505
--- /dev/null
+++ b/drivers/media/tuners/e4000_priv.h
@@ -0,0 +1,147 @@
+/*
+ * Elonics E4000 silicon tuner driver
+ *
+ * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef E4000_PRIV_H
+#define E4000_PRIV_H
+
+#include "e4000.h"
+
+struct e4000_priv {
+	const struct e4000_config *cfg;
+	struct i2c_adapter *i2c;
+};
+
+struct e4000_pll {
+	u32 freq;
+	u8 div;
+	u8 mul;
+};
+
+static const struct e4000_pll e4000_pll_lut[] = {
+/*                                      VCO min    VCO max */
+	{   72400000, 0x0f, 48 }, /* .......... 3475200000 */
+	{   81200000, 0x0e, 40 }, /* 2896000000 3248000000 */
+	{  108300000, 0x0d, 32 }, /* 2598400000 3465600000 */
+	{  162500000, 0x0c, 24 }, /* 2599200000 3900000000 */
+	{  216600000, 0x0b, 16 }, /* 2600000000 3465600000 */
+	{  325000000, 0x0a, 12 }, /* 2599200000 3900000000 */
+	{  350000000, 0x09,  8 }, /* 2600000000 2800000000 */
+	{  432000000, 0x03,  8 }, /* 2800000000 3456000000 */
+	{  667000000, 0x02,  6 }, /* 2592000000 4002000000 */
+	{ 1200000000, 0x01,  4 }, /* 2668000000 4800000000 */
+	{ 0xffffffff, 0x00,  2 }, /* 2400000000 .......... */
+};
+
+struct e4000_lna_filter {
+	u32 freq;
+	u8 val;
+};
+
+static const struct e4000_lna_filter e400_lna_filter_lut[] = {
+	{  370000000,  0 },
+	{  392500000,  1 },
+	{  415000000,  2 },
+	{  437500000,  3 },
+	{  462500000,  4 },
+	{  490000000,  5 },
+	{  522500000,  6 },
+	{  557500000,  7 },
+	{  595000000,  8 },
+	{  642500000,  9 },
+	{  695000000, 10 },
+	{  740000000, 11 },
+	{  800000000, 12 },
+	{  865000000, 13 },
+	{  930000000, 14 },
+	{ 1000000000, 15 },
+	{ 1310000000,  0 },
+	{ 1340000000,  1 },
+	{ 1385000000,  2 },
+	{ 1427500000,  3 },
+	{ 1452500000,  4 },
+	{ 1475000000,  5 },
+	{ 1510000000,  6 },
+	{ 1545000000,  7 },
+	{ 1575000000,  8 },
+	{ 1615000000,  9 },
+	{ 1650000000, 10 },
+	{ 1670000000, 11 },
+	{ 1690000000, 12 },
+	{ 1710000000, 13 },
+	{ 1735000000, 14 },
+	{ 0xffffffff, 15 },
+};
+
+struct e4000_band {
+	u32 freq;
+	u8 reg07_val;
+	u8 reg78_val;
+};
+
+static const struct e4000_band e4000_band_lut[] = {
+	{  140000000, 0x01, 0x03 },
+	{  350000000, 0x03, 0x03 },
+	{ 1000000000, 0x05, 0x03 },
+	{ 0xffffffff, 0x07, 0x00 },
+};
+
+struct e4000_if_filter {
+	u32 freq;
+	u8 reg11_val;
+	u8 reg12_val;
+};
+
+static const struct e4000_if_filter e4000_if_filter_lut[] = {
+	{    4300000, 0xfd, 0x1f },
+	{    4400000, 0xfd, 0x1e },
+	{    4480000, 0xfc, 0x1d },
+	{    4560000, 0xfc, 0x1c },
+	{    4600000, 0xfc, 0x1b },
+	{    4800000, 0xfc, 0x1a },
+	{    4900000, 0xfc, 0x19 },
+	{    5000000, 0xfc, 0x18 },
+	{    5100000, 0xfc, 0x17 },
+	{    5200000, 0xfc, 0x16 },
+	{    5400000, 0xfc, 0x15 },
+	{    5500000, 0xfc, 0x14 },
+	{    5600000, 0xfc, 0x13 },
+	{    5800000, 0xfb, 0x12 },
+	{    5900000, 0xfb, 0x11 },
+	{    6000000, 0xfb, 0x10 },
+	{    6200000, 0xfb, 0x0f },
+	{    6400000, 0xfa, 0x0e },
+	{    6600000, 0xfa, 0x0d },
+	{    6800000, 0xf9, 0x0c },
+	{    7200000, 0xf9, 0x0b },
+	{    7400000, 0xf9, 0x0a },
+	{    7600000, 0xf8, 0x09 },
+	{    7800000, 0xf8, 0x08 },
+	{    8200000, 0xf8, 0x07 },
+	{    8600000, 0xf7, 0x06 },
+	{    8800000, 0xf7, 0x05 },
+	{    9200000, 0xf7, 0x04 },
+	{    9600000, 0xf6, 0x03 },
+	{   10000000, 0xf6, 0x02 },
+	{   10600000, 0xf5, 0x01 },
+	{   11000000, 0xf5, 0x00 },
+	{ 0xffffffff, 0x00, 0x20 },
+};
+
+#endif
-- 
1.7.11.4

