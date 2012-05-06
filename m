Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39557 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2EFMrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:47:01 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so302894vbb.19
        for <linux-media@vger.kernel.org>; Sun, 06 May 2012 05:47:00 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 6 May 2012 14:47:00 +0200
Message-ID: <CAKZ=SG_d9Oc5uZX6Wo56MRYp3fr5on9wE9v1RoM7k=1UM6zX3Q@mail.gmail.com>
Subject: [PATCH v3 3/3] FC0012 tuner driver.
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: hfvogt@gmx.net, poma <pomidorabelisima@gmail.com>,
	gennarone@gmail.com, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is based on the driver written by Hans-Frieder Vogt. The
following modifications hav been made
- added callback for UHF/VFH band selection in fc0012_set_params
(needed by Cinergy T Stick Black)
- modified some parameters when initialiting the tuner (maybe the
initialization should be done by passing parameters to the init
functions to be usable with different demods)

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/common/tuners/fc0012-priv.h |   42 +++
 drivers/media/common/tuners/fc0012.c      |  398 +++++++++++++++++++++++++++++
 drivers/media/common/tuners/fc0012.h      |   60 +++++
 3 files changed, 500 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/common/tuners/fc0012-priv.h
 create mode 100644 drivers/media/common/tuners/fc0012.c
 create mode 100644 drivers/media/common/tuners/fc0012.h

diff --git a/drivers/media/common/tuners/fc0012-priv.h
b/drivers/media/common/tuners/fc0012-priv.h
new file mode 100644
index 0000000..c2c3c47
--- /dev/null
+++ b/drivers/media/common/tuners/fc0012-priv.h
@@ -0,0 +1,42 @@
+/*
+ * Fitipower FC0012 tuner driver - private includes
+ *
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfv...@gmx.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _FC0012_PRIV_H_
+#define _FC0012_PRIV_H_
+
+#define LOG_PREFIX "fc0012"
+
+#undef err
+#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
+#undef info
+#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
+#undef warn
+#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
+
+struct fc0012_priv {
+       struct i2c_adapter *i2c;
+       u8 addr;
+       u8 xtal_freq;
+
+       u32 frequency;
+       u32 bandwidth;
+};
+
+#endif
diff --git a/drivers/media/common/tuners/fc0012.c
b/drivers/media/common/tuners/fc0012.c
new file mode 100644
index 0000000..5beae31
--- /dev/null
+++ b/drivers/media/common/tuners/fc0012.c
@@ -0,0 +1,398 @@
+/*
+ * Fitipower FC0012 tuner driver
+ *
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfv...@gmx.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "fc0012.h"
+#include "fc0012-priv.h"
+
+static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
+{
+	u8 buf[2] = {reg, val};
+	struct i2c_msg msg = { .addr = priv->addr, .flags = 0, .buf = buf,
+		.len = 2 };
+
+	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
+		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
+	return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
+{
+	struct i2c_msg msg[2] = {
+		{ .addr = priv->addr, .flags = 0, .buf = &reg, .len = 1 },
+		{ .addr = priv->addr, .flags = I2C_M_RD, .buf = val,
+		.len = 1 },
+	};
+
+	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
+		err("I2C read failed, reg: %02x", reg);
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int fc0012_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static int fc0012_init(struct dvb_frontend *fe)
+{
+	struct fc0012_priv *priv = fe->tuner_priv;
+	int i, ret = 0;
+	unsigned char reg[] = {
+		0x00,   /* dummy reg. 0 */
+		0x05,   /* reg. 0x01 */
+		0x10,   /* reg. 0x02 */
+		0x00,   /* reg. 0x03 */
+		0x00,   /* reg. 0x04 */
+		0x0f,   /* reg. 0x05 CHECK: correct? */
+			/* changed for rtl2832 */
+		0x00,   /* reg. 0x06: divider 2, VCO slow */
+		0x00,   /* reg. 0x07 */
+			/* changed for rtl2832 */
+		0xff,   /* reg. 0x08: AGC Clock divide by 256, AGC gain 1/256,
+			   Loop Bw 1/8 */
+		0x6e,   /* reg. 0x09: Disable LoopThrough,
+			   Enable LoopThrough: 0x6f */
+		0xb8,   /* reg. 0x0a: Disable LO Test Buffer */
+		0x82,   /* reg. 0x0b: Output Clock is same as clock
+			   frequency */
+			/* changed for rtl2832 */
+		0xfc,   /* reg. 0x0c: depending on AGC Up-Down mode,
+			   may need 0xf8 */
+			/* changed for rtl2832 */
+		0x02,   /* reg. 0x0d: AGC Not Forcing & LNA Forcing,
+			   0x02 for DVB-T */
+		0x00,   /* reg. 0x0e */
+		0x00,   /* reg. 0x0f */
+		0x00,   /* reg. 0x10 */
+			/* changed for rtl2832 */
+		0x00,   /* reg. 0x11 */
+		0x1f,   /* reg. 0x12: Set to maximum gain */
+		0x08,   /* reg. 0x13: Enable IX2, Set to Middle Gain: 0x08,
+			   Low Gain: 0x00, High Gain: 0x10 */
+		0x00,   /* reg. 0x14 */
+		0x04,   /* reg. 0x15: Enable LNA COMPS */
+	};
+
+	info("%s", __func__);
+
+	switch (priv->xtal_freq) {
+	case FC_XTAL_27_MHZ:
+	case FC_XTAL_28_8_MHZ:
+		reg[0x07] |= 0x20;
+		break;
+	case FC_XTAL_36_MHZ:
+	default:
+		break;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
+
+	for (i = 1; i < sizeof(reg); i++) {
+		ret = fc0012_writereg(priv, i, reg[i]);
+	if (ret)
+		break;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
+
+	if (ret)
+		warn("%s: failed: %d", __func__, ret);
+	return ret;
+}
+
+static int fc0012_sleep(struct dvb_frontend *fe)
+{
+	/* nothing to do here */
+	return 0;
+}
+
+static int fc0012_set_params(struct dvb_frontend *fe)
+{
+	struct fc0012_priv *priv = fe->tuner_priv;
+	int i, ret = 0;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 freq = p->frequency / 1000;
+	u32 delsys = p->delivery_system;
+	unsigned char reg[0x16], am, pm, multi;
+	unsigned long fVCO;
+	unsigned short xtal_freq_khz_2, xin, xdiv;
+	int vco_select = false;
+
+	info("%s", __func__);
+
+	if (fe->callback) {
+		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+			FC0012_FE_CALLBACK_UHF_ENABLE,
+			(freq > 300000 ? 0 : 1));
+		if (ret)
+			goto exit;
+	}
+
+	switch (priv->xtal_freq) {
+	case FC_XTAL_27_MHZ:
+		xtal_freq_khz_2 = 27000 / 2;
+		break;
+	case FC_XTAL_36_MHZ:
+		xtal_freq_khz_2 = 36000 / 2;
+		break;
+	case FC_XTAL_28_8_MHZ:
+	default:
+		xtal_freq_khz_2 = 28800 / 2;
+		break;
+	}
+
+	/* select frequency divider and the frequency of VCO */
+	if (freq * 96 < 3560000) {
+		multi = 96;
+		reg[5] = 0x82;
+		reg[6] = 0x00;
+	} else if (freq * 64 < 3560000) {
+		multi = 64;
+		reg[5] = 0x82;
+		reg[6] = 0x02;
+	} else if (freq * 48 < 3560000) {
+		multi = 48;
+		reg[5] = 0x42;
+		reg[6] = 0x00;
+	} else if (freq * 32 < 3560000) {
+		multi = 32;
+		reg[5] = 0x42;
+		reg[6] = 0x02;
+	} else if (freq * 24 < 3560000) {
+		multi = 24;
+		reg[5] = 0x22;
+		reg[6] = 0x00;
+	} else if (freq * 16 < 3560000) {
+		multi = 16;
+		reg[5] = 0x22;
+		reg[6] = 0x02;
+	} else if (freq * 12 < 3560000) {
+		multi = 12;
+		reg[5] = 0x12;
+		reg[6] = 0x00;
+	} else if (freq * 8 < 3560000) {
+		multi = 8;
+		reg[5] = 0x12;
+		reg[6] = 0x02;
+	} else if (freq * 6 < 3560000) {
+		multi = 6;
+		reg[5] = 0x0a;
+		reg[6] = 0x00;
+	} else {
+		multi = 4;
+		reg[5] = 0x0a;
+		reg[6] = 0x02;
+	}
+
+	fVCO = freq * multi;
+
+	reg[6] |= 0x08;
+	vco_select = true;
+
+	/* From divided value (XDIV) determined the FA and FP value */
+	xdiv = (unsigned short)(fVCO / xtal_freq_khz_2);
+	if ((fVCO - xdiv * xtal_freq_khz_2) >= (xtal_freq_khz_2 / 2))
+		xdiv++;
+
+	pm = (unsigned char)(xdiv / 8);
+	am = (unsigned char)(xdiv - (8 * pm));
+
+	if (am < 2) {
+		reg[1] = am + 8;
+		reg[2] = pm - 1;
+	} else {
+		reg[1] = am;
+		reg[2] = pm;
+	}
+
+
+	/* From VCO frequency determines the XIN ( fractional part of Delta
+	Sigma PLL) and divided value (XDIV) */
+	xin = (unsigned short)(fVCO - (fVCO / xtal_freq_khz_2) *
+		xtal_freq_khz_2);
+	xin = (xin << 15) / xtal_freq_khz_2;
+	if (xin >= 16384)
+		xin += 32768;
+
+	reg[3] = xin >> 8;      /* xin with 9 bit resolution */
+	reg[4] = xin & 0xff;
+
+	if (delsys == SYS_DVBT) {
+		reg[6] &= 0x3f; /* bits 6 and 7 describe the bandwidth */
+		switch (p->bandwidth_hz) {
+		case 6000000:
+			reg[6] |= 0x80;
+			break;
+		case 7000000:
+			reg[6] &= ~0x80;
+			reg[6] |= 0x40;
+			break;
+		case 8000000:
+		default:
+			reg[6] &= ~0xc0;
+			break;
+	}
+	} else {
+		err("%s: modulation type not supported!", __func__);
+		return -EINVAL;
+	}
+
+	/* modified for Realtek demod */
+	reg[5] |= 0x07;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
+
+	for (i = 1; i <= 6; i++) {
+		ret = fc0012_writereg(priv, i, reg[i]);
+		if (ret)
+			goto exit;
+      }
+
+	/* VCO Calibration */
+	ret = fc0012_writereg(priv, 0x0e, 0x80);
+	if (!ret)
+		ret = fc0012_writereg(priv, 0x0e, 0x00);
+
+	/* VCO Re-Calibration if needed */
+	if (!ret)
+		ret = fc0012_writereg(priv, 0x0e, 0x00);
+
+	if (!ret) {
+		msleep(10);
+		ret = fc0012_readreg(priv, 0x0e, &reg[0x0e]);
+	}
+	if (ret)
+		goto exit;
+
+	/* vco selection */
+	reg[0x0e] &= 0x3f;
+
+	if (vco_select) {
+		if (reg[0x0e] > 0x3c) {
+			reg[6] &= ~0x08;
+			ret = fc0012_writereg(priv, 0x06, reg[6]);
+		if (!ret)
+			ret = fc0012_writereg(priv, 0x0e, 0x80);
+		if (!ret)
+			ret = fc0012_writereg(priv, 0x0e, 0x00);
+	       }
+	} else {
+		if (reg[0x0e] < 0x02) {
+			reg[6] |= 0x08;
+			ret = fc0012_writereg(priv, 0x06, reg[6]);
+			if (!ret)
+				ret = fc0012_writereg(priv, 0x0e, 0x80);
+			if (!ret)
+				ret = fc0012_writereg(priv, 0x0e, 0x00);
+		}
+	}
+
+	priv->frequency = p->frequency;
+	priv->bandwidth = p->bandwidth_hz;
+
+exit:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
+	if (ret)
+		pr_debug("%s: failed: %d", __func__, ret);
+	return ret;
+}
+
+static int fc0012_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct fc0012_priv *priv = fe->tuner_priv;
+	*frequency = priv->frequency;
+	return 0;
+}
+
+static int fc0012_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	/* CHECK: always ? */
+	*frequency = 0;
+	return 0;
+}
+
+static int fc0012_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+	struct fc0012_priv *priv = fe->tuner_priv;
+	*bandwidth = priv->bandwidth;
+	return 0;
+}
+
+
+static const struct dvb_tuner_ops fc0012_tuner_ops = {
+	.info = {
+		.name = "Fitipower FC0012",
+
+		.frequency_min	= 170000000,
+		.frequency_max	= 860000000,
+		.frequency_step	= 0,
+	},
+
+	.release	= fc0012_release,
+
+	.init = fc0012_init,
+	.sleep = fc0012_sleep,
+
+	.set_params = fc0012_set_params,
+
+	.get_frequency = fc0012_get_frequency,
+	.get_if_frequency = fc0012_get_if_frequency,
+	.get_bandwidth = fc0012_get_bandwidth,
+};
+
+struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
+	struct i2c_adapter *i2c, u8 i2c_address,
+	enum fc0012_xtal_freq xtal_freq)
+{
+	struct fc0012_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(struct fc0012_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	priv->i2c = i2c;
+	priv->addr = i2c_address;
+	priv->xtal_freq = xtal_freq;
+
+	info("Fitipower FC0012 successfully attached.");
+
+	fe->tuner_priv = priv;
+
+	memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
+		sizeof(struct dvb_tuner_ops));
+
+	return fe;
+}
+EXPORT_SYMBOL(fc0012_attach);
+
+MODULE_DESCRIPTION("Fitipower FC0012 silicon tuner driver");
+MODULE_AUTHOR("Hans-Frieder Vogt <hfv...@gmx.net>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.4");
