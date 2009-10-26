Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:36350 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZJZJur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 05:50:47 -0400
Received: by pxi9 with SMTP id 9so1060469pxi.4
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 02:50:52 -0700 (PDT)
Message-ID: <4AE570F7.6030303@gmail.com>
Date: Mon, 26 Oct 2009 17:50:47 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: [PATCH] Maxium MAX2165 silicon tuner
Content-Type: multipart/mixed;
 boundary="------------040304060708040806010905"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040304060708040806010905
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   This patch adds support for Maxim MAX2165 silicon tuner.

   It is tested on Mygica X8558Pro, which has MAX2165, ATBM8830 and CX23885

Regards
David

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>

--------------040304060708040806010905
Content-Type: text/x-patch;
 name="max2165.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="max2165.patch"

changeset:   13165:1371c005205b
tag:         tip
user:        David T.L. Wong <davidtlwong@gmail.com>
date:        Mon Oct 26 17:42:34 2009 +0800
summary:     add Maxim MAX2165 silicon tuner support

diff --git a/linux/drivers/media/common/tuners/Kconfig b/linux/drivers/media/common/tuners/Kconfig
--- a/linux/drivers/media/common/tuners/Kconfig
+++ b/linux/drivers/media/common/tuners/Kconfig
@@ -172,4 +172,11 @@
 	help
 	  Say Y here to support the Freescale MC44S803 based tuners
 
+config MEDIA_TUNER_MAX2165
+	tristate "Maxim MAX2165 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  A driver for the silicon tuner MAX2165 from Maxim.
+
 endif # MEDIA_TUNER_CUSTOMISE
diff --git a/linux/drivers/media/common/tuners/Makefile b/linux/drivers/media/common/tuners/Makefile
--- a/linux/drivers/media/common/tuners/Makefile
+++ b/linux/drivers/media/common/tuners/Makefile
@@ -23,6 +23,7 @@
 obj-$(CONFIG_MEDIA_TUNER_MXL5005S) += mxl5005s.o
 obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
 obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
+obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/linux/drivers/media/common/tuners/max2165.c b/linux/drivers/media/common/tuners/max2165.c
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/common/tuners/max2165.c
@@ -0,0 +1,445 @@
+/*
+ *  Driver for Maxim MAX2165 silicon tuner
+ *
+ *  Copyright (c) 2009 David T. L. Wong <davidtlwong@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/videodev2.h>
+#include <linux/delay.h>
+#include <linux/dvb/frontend.h>
+#include <linux/i2c.h>
+
+#include "dvb_frontend.h"
+
+#include "max2165.h"
+#include "max2165_priv.h"
+#include "tuner-i2c.h"
+
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "max2165: " args); \
+	} while (0)
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+static int max2165_write_reg(struct max2165_priv *priv, u8 reg, u8 data)
+{
+	int ret;
+	u8 buf[] = { reg, data };
+	struct i2c_msg msg = { .flags = 0, .buf = buf, .len = 2 };
+
+	msg.addr = priv->config->i2c_address;
+
+	if (debug >= 2)
+		printk(KERN_DEBUG "%s: reg=0x%02X, data=0x%02X\n",
+			__func__, reg, data);
+
+	ret = i2c_transfer(priv->i2c, &msg, 1);
+
+	if (ret != 1)
+		dprintk(KERN_DEBUG "%s: error reg=0x%x, data=0x%x, ret=%i\n",
+			__func__, reg, data, ret);
+
+	return (ret != 1) ? -EIO : 0;
+}
+
+static int max2165_read_reg(struct max2165_priv *priv, u8 reg, u8 *p_data)
+{
+	int ret;
+	u8 dev_addr = priv->config->i2c_address;
+
+	u8 b0[] = { reg };
+	u8 b1[] = { 0 };
+	struct i2c_msg msg[] = {
+		{ .addr = dev_addr, .flags = 0, .buf = b0, .len = 1 },
+		{ .addr = dev_addr, .flags = I2C_M_RD, .buf = b1, .len = 1 },
+	};
+
+	ret = i2c_transfer(priv->i2c, msg, 2);
+	if (ret != 2) {
+		dprintk(KERN_DEBUG "%s: error reg=0x%x, ret=%i\n",
+			__func__, reg, ret);
+		return -EIO;
+	}
+
+	*p_data = b1[0];
+	if (debug >= 2)
+		printk(KERN_DEBUG "%s: reg=0x%02X, data=0x%02X\n",
+			__func__, reg, b1[0]);
+	return 0;
+}
+
+static int max2165_mask_write_reg(struct max2165_priv *priv, u8 reg,
+	u8 mask, u8 data)
+{
+	int ret;
+	u8 v;
+
+	data &= mask;
+	ret = max2165_read_reg(priv, reg, &v);
+	if (ret != 0)
+		return ret;
+	v &= ~mask;
+	v |= data;
+	ret = max2165_write_reg(priv, reg, v);
+
+	return ret;
+}
+
+static int max2165_read_rom_table(struct max2165_priv *priv)
+{
+	u8 dat[3];
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		max2165_write_reg(priv, REG_ROM_TABLE_ADDR, i + 1);
+		max2165_read_reg(priv, REG_ROM_TABLE_DATA, &dat[i]);
+	}
+
+	priv->tf_ntch_low_cfg = dat[0] >> 4;
+	priv->tf_ntch_hi_cfg = dat[0] & 0x0F;
+	priv->tf_balun_low_ref = dat[1] & 0x0F;
+	priv->tf_balun_hi_ref = dat[1] >> 4;
+	priv->bb_filter_7mhz_cfg = dat[2] & 0x0F;
+	priv->bb_filter_8mhz_cfg = dat[2] >> 4;
+
+	dprintk("tf_ntch_low_cfg = 0x%X\n", priv->tf_ntch_low_cfg);
+	dprintk("tf_ntch_hi_cfg = 0x%X\n", priv->tf_ntch_hi_cfg);
+	dprintk("tf_balun_low_ref = 0x%X\n", priv->tf_balun_low_ref);
+	dprintk("tf_balun_hi_ref = 0x%X\n", priv->tf_balun_hi_ref);
+	dprintk("bb_filter_7mhz_cfg = 0x%X\n", priv->bb_filter_7mhz_cfg);
+	dprintk("bb_filter_8mhz_cfg = 0x%X\n", priv->bb_filter_8mhz_cfg);
+
+	return 0;
+}
+
+static int max2165_set_osc(struct max2165_priv *priv, u8 osc /*MHz*/)
+{
+	u8 v;
+
+	v = (osc / 2);
+	if (v == 2)
+		v = 0x7;
+	else
+		v -= 8;
+
+	max2165_mask_write_reg(priv, REG_PLL_CFG, 0x07, v);
+
+	return 0;
+}
+
+static int max2165_set_bandwidth(struct max2165_priv *priv, u32 bw)
+{
+	u8 val;
+
+	if (bw == BANDWIDTH_8_MHZ)
+		val = priv->bb_filter_8mhz_cfg;
+	else
+		val = priv->bb_filter_7mhz_cfg;
+
+	max2165_mask_write_reg(priv, REG_BASEBAND_CTRL, 0xF0, val << 4);
+
+	return 0;
+}
+
+int fixpt_div32(u32 dividend, u32 divisor, u32 *quotient, u32 *fraction)
+{
+	u32 remainder;
+	u32 q, f = 0;
+	int i;
+
+	if (0 == divisor)
+		return -1;
+
+	q = dividend / divisor;
+	remainder = dividend - q * divisor;
+
+	for (i = 0; i < 31; i++) {
+		remainder <<= 1;
+		if (remainder >= divisor) {
+			f += 1;
+			remainder -= divisor;
+		}
+		f <<= 1;
+	}
+
+	*quotient = q;
+	*fraction = f;
+
+	return 0;
+}
+
+static int max2165_set_rf(struct max2165_priv *priv, u32 freq)
+{
+	u8 tf;
+	u8 tf_ntch;
+	double t;
+	u32 quotient, fraction;
+
+	/* Set PLL divider according to RF frequency */
+	fixpt_div32(freq / 1000, priv->config->osc_clk * 1000,
+		&quotient, &fraction);
+
+	/* 20-bit fraction */
+	fraction >>= 12;
+
+	max2165_write_reg(priv, REG_NDIV_INT, quotient);
+	max2165_mask_write_reg(priv, REG_NDIV_FRAC2, 0x0F, fraction >> 16);
+	max2165_write_reg(priv, REG_NDIV_FRAC1, fraction >> 8);
+	max2165_write_reg(priv, REG_NDIV_FRAC0, fraction);
+
+	/* Norch Filter */
+	tf_ntch = (freq < 725000000) ?
+		priv->tf_ntch_low_cfg : priv->tf_ntch_hi_cfg;
+
+	/* Tracking filter balun */
+	t = priv->tf_balun_low_ref;
+	t += (priv->tf_balun_hi_ref - priv->tf_balun_low_ref)
+		* (freq / 1000 - 470000) / (780000 - 470000);
+
+#if 0
+	tf = t + 0.5; /* round up */
+#endif
+	tf = t;
+	dprintk("tf = %X\n", tf);
+	tf |= tf_ntch << 4;
+
+	max2165_write_reg(priv, REG_TRACK_FILTER, tf);
+
+	return 0;
+}
+
+static void max2165_debug_status(struct max2165_priv *priv)
+{
+	u8 status, autotune;
+	u8 auto_vco_success, auto_vco_active;
+	u8 pll_locked;
+	u8 dc_offset_low, dc_offset_hi;
+	u8 signal_lv_over_threshold;
+	u8 vco, vco_sub_band, adc;
+
+	max2165_read_reg(priv, REG_STATUS, &status);
+	max2165_read_reg(priv, REG_AUTOTUNE, &autotune);
+
+	auto_vco_success = (status >> 6) & 0x01;
+	auto_vco_active = (status >> 5) & 0x01;
+	pll_locked = (status >> 4) & 0x01;
+	dc_offset_low = (status >> 3) & 0x01;
+	dc_offset_hi = (status >> 2) & 0x01;
+	signal_lv_over_threshold = status & 0x01;
+
+	vco = autotune >> 6;
+	vco_sub_band = (autotune >> 3) & 0x7;
+	adc = autotune & 0x7;
+
+	dprintk("auto VCO active: %d, auto VCO success: %d\n",
+		auto_vco_active, auto_vco_success);
+	dprintk("PLL locked: %d\n", pll_locked);
+	dprintk("DC offset low: %d, DC offset high: %d\n",
+		dc_offset_low, dc_offset_hi);
+	dprintk("Signal lvl over threshold: %d\n", signal_lv_over_threshold);
+	dprintk("VCO: %d, VCO Sub-band: %d, ADC: %d\n", vco, vco_sub_band, adc);
+}
+
+static int max2165_set_params(struct dvb_frontend *fe,
+	struct dvb_frontend_parameters *params)
+{
+	struct max2165_priv *priv = fe->tuner_priv;
+	int ret;
+
+	dprintk("%s() frequency=%d (Hz)\n", __func__, params->frequency);
+	if (fe->ops.info.type == FE_ATSC) {
+			return -EINVAL;
+	} else if (fe->ops.info.type == FE_OFDM) {
+		dprintk("%s() OFDM\n", __func__);
+		switch (params->u.ofdm.bandwidth) {
+		case BANDWIDTH_6_MHZ:
+			return -EINVAL;
+		case BANDWIDTH_7_MHZ:
+		case BANDWIDTH_8_MHZ:
+			priv->frequency = params->frequency;
+			priv->bandwidth = params->u.ofdm.bandwidth;
+			break;
+		default:
+			printk(KERN_ERR "MAX2165 bandwidth not set!\n");
+			return -EINVAL;
+		}
+	} else {
+		printk(KERN_ERR "MAX2165 modulation type not supported!\n");
+		return -EINVAL;
+	}
+
+	dprintk("%s() frequency=%d\n", __func__, priv->frequency);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	max2165_set_bandwidth(priv, priv->bandwidth);
+	ret = max2165_set_rf(priv, priv->frequency);
+	mdelay(50);
+	max2165_debug_status(priv);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (ret != 0)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int max2165_get_frequency(struct dvb_frontend *fe, u32 *freq)
+{
+	struct max2165_priv *priv = fe->tuner_priv;
+	dprintk("%s()\n", __func__);
+	*freq = priv->frequency;
+	return 0;
+}
+
+static int max2165_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
+{
+	struct max2165_priv *priv = fe->tuner_priv;
+	dprintk("%s()\n", __func__);
+
+	*bw = priv->bandwidth;
+	return 0;
+}
+
+static int max2165_get_status(struct dvb_frontend *fe, u32 *status)
+{
+	struct max2165_priv *priv = fe->tuner_priv;
+	u16 lock_status = 0;
+
+	dprintk("%s()\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+
+	max2165_debug_status(priv);
+	*status = lock_status;
+
+	if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+}
+
+static int max2165_sleep(struct dvb_frontend *fe)
+{
+	dprintk("%s()\n", __func__);
+	return 0;
+}
+
+static int max2165_init(struct dvb_frontend *fe)
+{
+	struct max2165_priv *priv = fe->tuner_priv;
+	dprintk("%s()\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* Setup initial values */
+	/* Fractional Mode on */
+	max2165_write_reg(priv, REG_NDIV_FRAC2, 0x18);
+	/* LNA on */
+	max2165_write_reg(priv, REG_LNA, 0x01);
+	max2165_write_reg(priv, REG_PLL_CFG, 0x7A);
+	max2165_write_reg(priv, REG_TEST, 0x08);
+	max2165_write_reg(priv, REG_SHUTDOWN, 0x40);
+	max2165_write_reg(priv, REG_VCO_CTRL, 0x84);
+	max2165_write_reg(priv, REG_BASEBAND_CTRL, 0xC3);
+	max2165_write_reg(priv, REG_DC_OFFSET_CTRL, 0x75);
+	max2165_write_reg(priv, REG_DC_OFFSET_DAC, 0x00);
+	max2165_write_reg(priv, REG_ROM_TABLE_ADDR, 0x00);
+
+	max2165_set_osc(priv, priv->config->osc_clk);
+
+	max2165_read_rom_table(priv);
+
+	max2165_set_bandwidth(priv, BANDWIDTH_8_MHZ);
+
+	if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+}
+
+static int max2165_release(struct dvb_frontend *fe)
+{
+	struct max2165_priv *priv = fe->tuner_priv;
+	dprintk("%s()\n", __func__);
+
+	kfree(priv);
+	fe->tuner_priv = NULL;
+
+	return 0;
+}
+
+static const struct dvb_tuner_ops max2165_tuner_ops = {
+	.info = {
+		.name           = "Maxim MAX2165",
+		.frequency_min  = 470000000,
+		.frequency_max  = 780000000,
+		.frequency_step =     50000,
+	},
+
+	.release	   = max2165_release,
+	.init		   = max2165_init,
+	.sleep		   = max2165_sleep,
+
+	.set_params	   = max2165_set_params,
+	.set_analog_params = NULL,
+	.get_frequency	   = max2165_get_frequency,
+	.get_bandwidth	   = max2165_get_bandwidth,
+	.get_status	   = max2165_get_status
+};
+
+struct dvb_frontend *max2165_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   struct max2165_config *cfg)
+{
+	struct max2165_priv *priv = NULL;
+
+	dprintk("%s(%d-%04x)\n", __func__,
+		i2c ? i2c_adapter_id(i2c) : -1,
+		cfg ? cfg->i2c_address : -1);
+
+	priv = kzalloc(sizeof(struct max2165_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	memcpy(&fe->ops.tuner_ops, &max2165_tuner_ops,
+		sizeof(struct dvb_tuner_ops));
+
+	priv->config = cfg;
+	priv->i2c = i2c;
+	fe->tuner_priv = priv;
+
+	max2165_init(fe);
+	max2165_debug_status(priv);
+
+	return fe;
+}
+EXPORT_SYMBOL(max2165_attach);
+
+MODULE_AUTHOR("David T. L. Wong <davidtlwong@gmail.com>");
+MODULE_DESCRIPTION("Maxim MAX2165 silicon tuner driver");
+MODULE_LICENSE("GPL");
diff --git a/linux/drivers/media/common/tuners/max2165.h b/linux/drivers/media/common/tuners/max2165.h
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/common/tuners/max2165.h
@@ -0,0 +1,48 @@
+/*
+ *  Driver for Maxim MAX2165 silicon tuner
+ *
+ *  Copyright (c) 2009 David T. L. Wong <davidtlwong@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MAX2165_H__
+#define __MAX2165_H__
+
+struct dvb_frontend;
+struct i2c_adapter;
+
+struct max2165_config {
+	u8 i2c_address;
+	u8 osc_clk; /* in MHz, selectable values: 4,16,18,20,22,24,26,28 */
+};
+
+#if defined(CONFIG_MEDIA_TUNER_MAX2165) || \
+    (defined(CONFIG_MEDIA_TUNER_MAX2165_MODULE) && defined(MODULE))
+extern struct dvb_frontend *max2165_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c,
+	struct max2165_config *cfg);
+#else
+static inline struct dvb_frontend *max2165_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c,
+	struct max2165_config *cfg)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/linux/drivers/media/common/tuners/max2165_priv.h b/linux/drivers/media/common/tuners/max2165_priv.h
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/common/tuners/max2165_priv.h
@@ -0,0 +1,60 @@
+/*
+ *  Driver for Maxim MAX2165 silicon tuner
+ *
+ *  Copyright (c) 2009 David T. L. Wong <davidtlwong@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MAX2165_PRIV_H__
+#define __MAX2165_PRIV_H__
+
+#define REG_NDIV_INT 0x00
+#define REG_NDIV_FRAC2 0x01
+#define REG_NDIV_FRAC1 0x02
+#define REG_NDIV_FRAC0 0x03
+#define REG_TRACK_FILTER 0x04
+#define REG_LNA 0x05
+#define REG_PLL_CFG 0x06
+#define REG_TEST 0x07
+#define REG_SHUTDOWN 0x08
+#define REG_VCO_CTRL 0x09
+#define REG_BASEBAND_CTRL 0x0A
+#define REG_DC_OFFSET_CTRL 0x0B
+#define REG_DC_OFFSET_DAC 0x0C
+#define REG_ROM_TABLE_ADDR 0x0D
+
+/* Read Only Registers */
+#define REG_ROM_TABLE_DATA 0x10
+#define REG_STATUS 0x11
+#define REG_AUTOTUNE 0x12
+
+struct max2165_priv {
+	struct max2165_config *config;
+	struct i2c_adapter *i2c;
+
+	u32 frequency;
+	u32 bandwidth;
+
+	u8 tf_ntch_low_cfg;
+	u8 tf_ntch_hi_cfg;
+	u8 tf_balun_low_ref;
+	u8 tf_balun_hi_ref;
+	u8 bb_filter_7mhz_cfg;
+	u8 bb_filter_8mhz_cfg;
+};
+
+#endif


--------------040304060708040806010905--
