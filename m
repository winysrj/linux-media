Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40584 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2IICHy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Sep 2012 22:07:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] FCI FC2580 silicon tuner driver
Date: Sun,  9 Sep 2012 05:07:24 +0300
Message-Id: <1347156446-12439-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig       |   7 +
 drivers/media/tuners/Makefile      |   1 +
 drivers/media/tuners/fc2580.c      | 524 +++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/fc2580.h      |  52 ++++
 drivers/media/tuners/fc2580_priv.h | 134 ++++++++++
 5 files changed, 718 insertions(+)
 create mode 100644 drivers/media/tuners/fc2580.c
 create mode 100644 drivers/media/tuners/fc2580.h
 create mode 100644 drivers/media/tuners/fc2580_priv.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index f9e299c..622375e 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -229,6 +229,13 @@ config MEDIA_TUNER_E4000
 	help
 	  Elonics E4000 silicon tuner driver.
 
+config MEDIA_TUNER_FC2580
+	tristate "FCI FC2580 silicon tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  FCI FC2580 silicon tuner driver.
+
 config MEDIA_TUNER_TUA9001
 	tristate "Infineon TUA 9001 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 9f7b2c2..5e569b1 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
 obj-$(CONFIG_MEDIA_TUNER_E4000) += e4000.o
+obj-$(CONFIG_MEDIA_TUNER_FC2580) += fc2580.o
 obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
 obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
new file mode 100644
index 0000000..afc0491
--- /dev/null
+++ b/drivers/media/tuners/fc2580.c
@@ -0,0 +1,524 @@
+/*
+ * FCI FC2580 silicon tuner driver
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
+#include "fc2580_priv.h"
+
+/*
+ * TODO:
+ * I2C write and read works only for one single register. Multiple registers
+ * could not be accessed using normal register address auto-increment.
+ * There could be (very likely) register to change that behavior....
+ *
+ * Due to that limitation functions:
+ *   fc2580_wr_regs()
+ *   fc2580_rd_regs()
+ * could not be used for accessing more than one register at once.
+ *
+ * TODO:
+ * Currently it blind writes bunch of static registers from the
+ * fc2580_freq_regs_lut[] when fc2580_set_params() is called. Add some
+ * logic to reduce unneeded register writes.
+ * There is also don't-care registers, initialized with value 0xff, and those
+ * are also written to the chip currently (yes, not wise).
+ */
+
+/* write multiple registers */
+static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
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
+static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
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
+static int fc2580_wr_reg(struct fc2580_priv *priv, u8 reg, u8 val)
+{
+	return fc2580_wr_regs(priv, reg, &val, 1);
+}
+
+/* read single register */
+static int fc2580_rd_reg(struct fc2580_priv *priv, u8 reg, u8 *val)
+{
+	return fc2580_rd_regs(priv, reg, val, 1);
+}
+
+static int fc2580_set_params(struct dvb_frontend *fe)
+{
+	struct fc2580_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, i;
+	unsigned int r_val, n_val, k_val, k_val_reg, f_ref;
+	u8 tmp_val, r18_val;
+	u64 f_vco;
+
+	/*
+	 * Fractional-N synthesizer/PLL.
+	 * Most likely all those PLL calculations are not correct. I am not
+	 * sure, but it looks like it is divider based Fractional-N synthesizer.
+	 * There is divider for reference clock too?
+	 * Anyhow, synthesizer calculation results seems to be quite correct.
+	 */
+
+	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
+			"bandwidth_hz=%d\n", __func__,
+			c->delivery_system, c->frequency, c->bandwidth_hz);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* PLL */
+	for (i = 0; i < ARRAY_SIZE(fc2580_pll_lut); i++) {
+		if (c->frequency <= fc2580_pll_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(fc2580_pll_lut))
+		goto err;
+
+	f_vco = c->frequency;
+	f_vco *= fc2580_pll_lut[i].div;
+
+	if (f_vco >= 2600000000)
+		tmp_val = 0x0e | fc2580_pll_lut[i].band;
+	else
+		tmp_val = 0x06 | fc2580_pll_lut[i].band;
+
+	ret = fc2580_wr_reg(priv, 0x02, tmp_val);
+	if (ret < 0)
+		goto err;
+
+	if (f_vco >= 2UL * 76 * priv->cfg->clock) {
+		r_val = 1;
+		r18_val = 0x00;
+	} else if (f_vco >= 1UL * 76 * priv->cfg->clock) {
+		r_val = 2;
+		r18_val = 0x10;
+	} else {
+		r_val = 4;
+		r18_val = 0x20;
+	}
+
+	f_ref = 2UL * priv->cfg->clock / r_val;
+	n_val = f_vco / f_ref;
+	k_val = f_vco % f_ref;
+	k_val_reg = 1UL * k_val * (1 << 20) / f_ref;
+
+	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x1a, (k_val_reg >> 8) & 0xff);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x1b, (k_val_reg >> 0) & 0xff);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x1c, n_val);
+	if (ret < 0)
+		goto err;
+
+	if (priv->cfg->clock >= 28000000) {
+		ret = fc2580_wr_reg(priv, 0x4b, 0x22);
+		if (ret < 0)
+			goto err;
+	}
+
+	if (fc2580_pll_lut[i].band == 0x00) {
+		if (c->frequency <= 794000000)
+			tmp_val = 0x9f;
+		else
+			tmp_val = 0x8f;
+
+		ret = fc2580_wr_reg(priv, 0x2d, tmp_val);
+		if (ret < 0)
+			goto err;
+	}
+
+	/* registers */
+	for (i = 0; i < ARRAY_SIZE(fc2580_freq_regs_lut); i++) {
+		if (c->frequency <= fc2580_freq_regs_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(fc2580_freq_regs_lut))
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x25, fc2580_freq_regs_lut[i].r25_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x27, fc2580_freq_regs_lut[i].r27_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x28, fc2580_freq_regs_lut[i].r28_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x29, fc2580_freq_regs_lut[i].r29_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x2b, fc2580_freq_regs_lut[i].r2b_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x2c, fc2580_freq_regs_lut[i].r2c_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x2d, fc2580_freq_regs_lut[i].r2d_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x30, fc2580_freq_regs_lut[i].r30_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x44, fc2580_freq_regs_lut[i].r44_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x50, fc2580_freq_regs_lut[i].r50_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x53, fc2580_freq_regs_lut[i].r53_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x5f, fc2580_freq_regs_lut[i].r5f_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x61, fc2580_freq_regs_lut[i].r61_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x62, fc2580_freq_regs_lut[i].r62_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x63, fc2580_freq_regs_lut[i].r63_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x67, fc2580_freq_regs_lut[i].r67_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x68, fc2580_freq_regs_lut[i].r68_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x69, fc2580_freq_regs_lut[i].r69_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x6a, fc2580_freq_regs_lut[i].r6a_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x6b, fc2580_freq_regs_lut[i].r6b_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x6c, fc2580_freq_regs_lut[i].r6c_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x6d, fc2580_freq_regs_lut[i].r6d_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x6e, fc2580_freq_regs_lut[i].r6e_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x6f, fc2580_freq_regs_lut[i].r6f_val);
+	if (ret < 0)
+		goto err;
+
+	/* IF filters */
+	for (i = 0; i < ARRAY_SIZE(fc2580_if_filter_lut); i++) {
+		if (c->bandwidth_hz <= fc2580_if_filter_lut[i].freq)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(fc2580_if_filter_lut))
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x36, fc2580_if_filter_lut[i].r36_val);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x37, 1UL * priv->cfg->clock * \
+			fc2580_if_filter_lut[i].mul / 1000000000);
+	if (ret < 0)
+		goto err;
+
+	ret = fc2580_wr_reg(priv, 0x39, fc2580_if_filter_lut[i].r39_val);
+	if (ret < 0)
+		goto err;
+
+	/* calibration? */
+	ret = fc2580_wr_reg(priv, 0x2e, 0x09);
+	if (ret < 0)
+		goto err;
+
+	for (i = 0; i < 5; i++) {
+		ret = fc2580_rd_reg(priv, 0x2f, &tmp_val);
+		if (ret < 0)
+			goto err;
+
+		/* done when [7:6] are set */
+		if ((tmp_val & 0xc0) == 0xc0)
+			break;
+
+		ret = fc2580_wr_reg(priv, 0x2e, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = fc2580_wr_reg(priv, 0x2e, 0x09);
+		if (ret < 0)
+			goto err;
+
+		usleep_range(5000, 25000);
+	}
+
+	dev_dbg(&priv->i2c->dev, "%s: loop=%i\n", __func__, i);
+
+	ret = fc2580_wr_reg(priv, 0x2e, 0x01);
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
+static int fc2580_init(struct dvb_frontend *fe)
+{
+	struct fc2580_priv *priv = fe->tuner_priv;
+	int ret, i;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	for (i = 0; i < ARRAY_SIZE(fc2580_init_reg_vals); i++) {
+		ret = fc2580_wr_reg(priv, fc2580_init_reg_vals[i].reg,
+				fc2580_init_reg_vals[i].val);
+		if (ret < 0)
+			goto err;
+	}
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
+static int fc2580_sleep(struct dvb_frontend *fe)
+{
+	struct fc2580_priv *priv = fe->tuner_priv;
+	int ret;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = fc2580_wr_reg(priv, 0x02, 0x0a);
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
+static int fc2580_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct fc2580_priv *priv = fe->tuner_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	*frequency = 0; /* Zero-IF */
+
+	return 0;
+}
+
+static int fc2580_release(struct dvb_frontend *fe)
+{
+	struct fc2580_priv *priv = fe->tuner_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	kfree(fe->tuner_priv);
+
+	return 0;
+}
+
+static const struct dvb_tuner_ops fc2580_tuner_ops = {
+	.info = {
+		.name           = "FCI FC2580",
+		.frequency_min  = 174000000,
+		.frequency_max  = 862000000,
+	},
+
+	.release = fc2580_release,
+
+	.init = fc2580_init,
+	.sleep = fc2580_sleep,
+	.set_params = fc2580_set_params,
+
+	.get_if_frequency = fc2580_get_if_frequency,
+};
+
+struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
+		struct i2c_adapter *i2c, const struct fc2580_config *cfg)
+{
+	struct fc2580_priv *priv;
+	int ret;
+	u8 chip_id;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	priv = kzalloc(sizeof(struct fc2580_priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
+
+	priv->cfg = cfg;
+	priv->i2c = i2c;
+	fe->tuner_priv = priv;
+	memcpy(&fe->ops.tuner_ops, &fc2580_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
+	/* check if the tuner is there */
+	ret = fc2580_rd_reg(priv, 0x01, &chip_id);
+	if (ret < 0)
+		goto err;
+
+	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
+
+	if (chip_id != 0x56)
+		goto err;
+
+	dev_info(&priv->i2c->dev,
+			"%s: FCI FC2580 successfully identified\n",
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
+EXPORT_SYMBOL(fc2580_attach);
+
+MODULE_DESCRIPTION("FCI FC2580 silicon tuner driver");
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
new file mode 100644
index 0000000..222601e
--- /dev/null
+++ b/drivers/media/tuners/fc2580.h
@@ -0,0 +1,52 @@
+/*
+ * FCI FC2580 silicon tuner driver
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
+#ifndef FC2580_H
+#define FC2580_H
+
+#include "dvb_frontend.h"
+
+struct fc2580_config {
+	/*
+	 * I2C address
+	 * 0x56, ...
+	 */
+	u8 i2c_addr;
+
+	/*
+	 * clock
+	 */
+	u32 clock;
+};
+
+#if defined(CONFIG_MEDIA_TUNER_FC2580) || \
+	(defined(CONFIG_MEDIA_TUNER_FC2580_MODULE) && defined(MODULE))
+extern struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c, const struct fc2580_config *cfg);
+#else
+static inline struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c, const struct fc2580_config *cfg)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
new file mode 100644
index 0000000..be38a9e
--- /dev/null
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -0,0 +1,134 @@
+/*
+ * FCI FC2580 silicon tuner driver
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
+#ifndef FC2580_PRIV_H
+#define FC2580_PRIV_H
+
+#include "fc2580.h"
+
+struct fc2580_reg_val {
+	u8 reg;
+	u8 val;
+};
+
+static const struct fc2580_reg_val fc2580_init_reg_vals[] = {
+	{0x00, 0x00},
+	{0x12, 0x86},
+	{0x14, 0x5c},
+	{0x16, 0x3c},
+	{0x1f, 0xd2},
+	{0x09, 0xd7},
+	{0x0b, 0xd5},
+	{0x0c, 0x32},
+	{0x0e, 0x43},
+	{0x21, 0x0a},
+	{0x22, 0x82},
+	{0x45, 0x10},
+	{0x4c, 0x00},
+	{0x3f, 0x88},
+	{0x02, 0x0e},
+	{0x58, 0x14},
+};
+
+struct fc2580_pll {
+	u32 freq;
+	u8 div;
+	u8 band;
+};
+
+static const struct fc2580_pll fc2580_pll_lut[] = {
+	/*                            VCO min    VCO max */
+	{ 400000000, 12, 0x80}, /* .......... 4800000000 */
+	{1000000000,  4, 0x00}, /* 1600000000 4000000000 */
+	{0xffffffff,  2, 0x40}, /* 2000000000 .......... */
+};
+
+struct fc2580_if_filter {
+	u32 freq;
+	u16 mul;
+	u8 r36_val;
+	u8 r39_val;
+};
+
+static const struct fc2580_if_filter fc2580_if_filter_lut[] = {
+	{   6000000, 4400, 0x18, 0x00},
+	{   7000000, 3910, 0x18, 0x80},
+	{   8000000, 3300, 0x18, 0x80},
+	{0xffffffff, 3300, 0x18, 0x80},
+};
+
+struct fc2580_freq_regs {
+	u32 freq;
+	u8 r25_val;
+	u8 r27_val;
+	u8 r28_val;
+	u8 r29_val;
+	u8 r2b_val;
+	u8 r2c_val;
+	u8 r2d_val;
+	u8 r30_val;
+	u8 r44_val;
+	u8 r50_val;
+	u8 r53_val;
+	u8 r5f_val;
+	u8 r61_val;
+	u8 r62_val;
+	u8 r63_val;
+	u8 r67_val;
+	u8 r68_val;
+	u8 r69_val;
+	u8 r6a_val;
+	u8 r6b_val;
+	u8 r6c_val;
+	u8 r6d_val;
+	u8 r6e_val;
+	u8 r6f_val;
+};
+
+/* XXX: 0xff is used for don't-care! */
+static const struct fc2580_freq_regs fc2580_freq_regs_lut[] = {
+	{ 400000000,
+		0xff, 0x77, 0x33, 0x40, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0x50, 0x0f, 0x07, 0x00, 0x15, 0x03, 0x05, 0x10, 0x12, 0x08,
+		0x0a, 0x78, 0x32, 0x54},
+	{ 538000000,
+		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0x50, 0x13, 0x07, 0x06, 0x15, 0x06, 0x08, 0x10, 0x12, 0x0b,
+		0x0c, 0x78, 0x32, 0x14},
+	{ 794000000,
+		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0x50, 0x15, 0x03, 0x03, 0x15, 0x03, 0x05, 0x0c, 0x0e, 0x0b,
+		0x0c, 0x78, 0x32, 0x14},
+	{1000000000,
+		0xf0, 0x77, 0x53, 0x60, 0xff, 0xff, 0xff, 0x09, 0xff, 0x8c,
+		0x50, 0x15, 0x07, 0x06, 0x15, 0x07, 0x09, 0x10, 0x12, 0x0b,
+		0x0c, 0x78, 0x32, 0x14},
+	{0xffffffff,
+		0xff, 0xff, 0xff, 0xff, 0x70, 0x37, 0xe7, 0x09, 0x20, 0x8c,
+		0x50, 0x0f, 0x0f, 0x00, 0x13, 0x00, 0x02, 0x0c, 0x0e, 0x08,
+		0x0a, 0xa0, 0x50, 0x14},
+};
+
+struct fc2580_priv {
+	const struct fc2580_config *cfg;
+	struct i2c_adapter *i2c;
+};
+
+#endif
-- 
1.7.11.4

