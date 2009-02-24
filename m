Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40077 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZBXPfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 10:35:21 -0500
Message-Id: <20090224153514.665266478@gentoo.org>
Date: Tue, 24 Feb 2009 16:35:15 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [patch 1/2] Add support for Zarlink ZL10036 DVB-S tuner.
References: <20090224153514.090816655@gentoo.org>
Content-Disposition: inline; filename=zl10036.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is based on initial work by Tino Reichardt and was heavily changed.
The datasheet of the zl10036 can be found here and on other places on the net:

http://www.mcmilk.de/projects/dvb-card/datasheets/ZL10036.pdf

The zl10038 is similar to the zl10036, so it is maybe possible to write a common
driver of necessary.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/dvb/frontends/Kconfig
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/Kconfig
+++ v4l-dvb/linux/drivers/media/dvb/frontends/Kconfig
@@ -55,6 +55,13 @@ config DVB_MT312
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
+config DVB_ZL10036
+	tristate "Zarlink ZL10036 silicon tuner"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DVB-S tuner module. Say Y when you want to support this frontend.
+
 config DVB_S5H1420
 	tristate "Samsung S5H1420 based"
 	depends on DVB_CORE && I2C
Index: v4l-dvb/linux/drivers/media/dvb/frontends/Makefile
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/Makefile
+++ v4l-dvb/linux/drivers/media/dvb/frontends/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_DVB_TDA1004X) += tda1004x.o
 obj-$(CONFIG_DVB_SP887X) += sp887x.o
 obj-$(CONFIG_DVB_NXT6000) += nxt6000.o
 obj-$(CONFIG_DVB_MT352) += mt352.o
+obj-$(CONFIG_DVB_ZL10036) += zl10036.o
 obj-$(CONFIG_DVB_ZL10353) += zl10353.o
 obj-$(CONFIG_DVB_CX22702) += cx22702.o
 obj-$(CONFIG_DVB_DRX397XD) += drx397xD.o
Index: v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.c
===================================================================
--- /dev/null
+++ v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.c
@@ -0,0 +1,519 @@
+/**
+ * Driver for Zarlink zl10036 DVB-S silicon tuner
+ *
+ * Copyright (C) 2006 Tino Reichardt
+ * Copyright (C) 2007-2009 Matthias Schwarzott <zzam@gentoo.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ **
+ * The data sheet for this tuner can be found at:
+ *    http://www.mcmilk.de/projects/dvb-card/datasheets/ZL10036.pdf
+ *
+ * This one is working: (at my Avermedia DVB-S Pro)
+ * - zl10036 (40pin, FTA)
+ *
+ * A driver for zl10038 should be very similar.
+ */
+
+#include <linux/module.h>
+#include <linux/dvb/frontend.h>
+#include <asm/types.h>
+
+#include "zl10036.h"
+
+static int zl10036_debug;
+#define dprintk(level, args...) \
+	do { if (zl10036_debug & level) printk(KERN_DEBUG "zl10036: " args); \
+	} while (0)
+
+#define deb_info(args...)  dprintk(0x01, args)
+#define deb_i2c(args...)  dprintk(0x02, args)
+
+struct zl10036_state {
+	struct i2c_adapter *i2c;
+	const struct zl10036_config *config;
+	u32 frequency;
+	u8 br, bf;
+};
+
+
+/* This driver assumes the tuner is driven by a 10.111MHz Cristal */
+#define _XTAL 10111
+
+/* Some of the possible dividers:
+ *   64, (write 0x05 to reg), freq step size   158kHz
+ *   10, (write 0x0a to reg), freq step size 1.011kHz (used here)
+ *    5, (write 0x09 to reg), freq step size 2.022kHz
+ */
+
+#define _RDIV 10
+#define _RDIV_REG 0x0a
+#define _FR   (_XTAL/_RDIV)
+
+#define STATUS_POR 0x80 /* Power on Reset */
+#define STATUS_FL  0x40 /* Frequency & Phase Lock */
+
+/* read/write for zl10036 and zl10038 */
+
+static int zl10036_read_status_reg(struct zl10036_state *state)
+{
+	u8 status;
+	struct i2c_msg msg[1] = {
+		{ .addr = state->config->tuner_address, .flags = I2C_M_RD,
+		  .buf = &status, .len = sizeof(status) },
+	};
+
+	if (i2c_transfer(state->i2c, msg, 1) != 1) {
+		printk(KERN_ERR "%s: i2c read failed at addr=%02x\n",
+			__func__, state->config->tuner_address);
+		return -EIO;
+	}
+
+	deb_i2c("R(status): %02x  [FL=%d]\n", status,
+		(status & STATUS_FL) ? 1 : 0);
+	if (status & STATUS_POR)
+		deb_info("%s: Power-On-Reset bit enabled - "
+			"need to initialize the tuner\n", __func__);
+
+	return status;
+}
+
+static int zl10036_write(struct zl10036_state *state, u8 buf[], u8 count)
+{
+	struct i2c_msg msg[1] = {
+		{ .addr = state->config->tuner_address, .flags = 0,
+		  .buf = buf, .len = count },
+	};
+	u8 reg = 0;
+	int ret;
+
+	if (zl10036_debug & 0x02) {
+		/* every 8bit-value satisifes this!
+		 * so only check for debug log */
+		if ((buf[0] & 0x80) == 0x00)
+			reg = 2;
+		else if ((buf[0] & 0xc0) == 0x80)
+			reg = 4;
+		else if ((buf[0] & 0xf0) == 0xc0)
+			reg = 6;
+		else if ((buf[0] & 0xf0) == 0xd0)
+			reg = 8;
+		else if ((buf[0] & 0xf0) == 0xe0)
+			reg = 10;
+		else if ((buf[0] & 0xf0) == 0xf0)
+			reg = 12;
+
+		deb_i2c("W(%d):", reg);
+		{
+			int i;
+			for (i = 0; i < count; i++)
+				printk(KERN_CONT " %02x", buf[i]);
+			printk(KERN_CONT "\n");
+		}
+	}
+
+	ret = i2c_transfer(state->i2c, msg, 1);
+	if (ret != 1) {
+		printk(KERN_ERR "%s: i2c error, ret=%d\n", __func__, ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int zl10036_release(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+
+	return 0;
+}
+
+static int zl10036_sleep(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	u8 buf[] = { 0xf0, 0x80 }; /* regs 12/13 */
+	int ret;
+
+	deb_info("%s\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_write(state, buf, sizeof(buf));
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return ret;
+}
+
+/**
+ * register map of the ZL10036/ZL10038
+ *
+ * reg[default] content
+ *  2[0x00]:   0 | N14 | N13 | N12 | N11 | N10 |  N9 |  N8
+ *  3[0x00]:  N7 |  N6 |  N5 |  N4 |  N3 |  N2 |  N1 |  N0
+ *  4[0x80]:   1 |   0 | RFG | BA1 | BA0 | BG1 | BG0 | LEN
+ *  5[0x00]:  P0 |  C1 |  C0 |  R4 |  R3 |  R2 |  R1 |  R0
+ *  6[0xc0]:   1 |   1 |   0 |   0 | RSD |   0 |   0 |   0
+ *  7[0x20]:  P1 | BF6 | BF5 | BF4 | BF3 | BF2 | BF1 |   0
+ *  8[0xdb]:   1 |   1 |   0 |   1 |   0 |  CC |   1 |   1
+ *  9[0x30]: VSD |  V2 |  V1 |  V0 |  S3 |  S2 |  S1 |  S0
+ * 10[0xe1]:   1 |   1 |   1 |   0 |   0 | LS2 | LS1 | LS0
+ * 11[0xf5]:  WS | WH2 | WH1 | WH0 | WL2 | WL1 | WL0 | WRE
+ * 12[0xf0]:   1 |   1 |   1 |   1 |   0 |   0 |   0 |   0
+ * 13[0x28]:  PD | BR4 | BR3 | BR2 | BR1 | BR0 | CLR |  TL
+ */
+
+static int zl10036_set_frequency(struct zl10036_state *state, u32 frequency)
+{
+	u8 buf[2];
+	u32 div, foffset;
+
+	div = (frequency + _FR/2) / _FR;
+	state->frequency = div * _FR;
+
+	foffset = frequency - state->frequency;
+
+	buf[0] = (div >> 8) & 0x7f;
+	buf[1] = (div >> 0) & 0xff;
+
+	deb_info("%s: ftodo=%u fpriv=%u ferr=%d div=%u\n", __func__,
+		frequency, state->frequency, foffset, div);
+
+	return zl10036_write(state, buf, sizeof(buf));
+}
+
+static int zl10036_set_bandwidth(struct zl10036_state *state, u32 fbw)
+{
+	/* fbw is measured in kHz */
+	u8 br, bf;
+	int ret;
+	u8 buf_bf[] = {
+		0xc0, 0x00, /*   6/7: rsd=0 bf=0 */
+	};
+	u8 buf_br[] = {
+		0xf0, 0x00, /* 12/13: br=0xa clr=0 tl=0*/
+	};
+	u8 zl10036_rsd_off[] = { 0xc8 }; /* set RSD=1 */
+
+	/* ensure correct values */
+	if (fbw > 35000)
+		fbw = 35000;
+	if (fbw <  8000)
+		fbw =  8000;
+
+#define _BR_MAXIMUM (_XTAL/575) /* _XTAL / 575kHz = 17 */
+
+	/* <= 28,82 MHz */
+	if (fbw <= 28820) {
+		br = _BR_MAXIMUM;
+	} else {
+		/**
+		 *  f(bw)=34,6MHz f(xtal)=10.111MHz
+		 *  br = (10111/34600) * 63 * 1/K = 14;
+		 */
+		br = ((_XTAL * 21 * 1000) / (fbw * 419));
+	}
+
+	/* ensure correct values */
+	if (br < 4)
+		br = 4;
+	if (br > _BR_MAXIMUM)
+		br = _BR_MAXIMUM;
+
+	/*
+	 * k = 1.257
+	 * bf = fbw/_XTAL * br * k - 1 */
+
+	bf = (fbw * br * 1257) / (_XTAL * 1000) - 1;
+
+	/* ensure correct values */
+	if (bf > 62)
+		bf = 62;
+
+	buf_bf[1] = (bf << 1) & 0x7e;
+	buf_br[1] = (br << 2) & 0x7c;
+	deb_info("%s: BW=%d br=%u bf=%u\n", __func__, fbw, br, bf);
+
+	if (br != state->br) {
+		ret = zl10036_write(state, buf_br, sizeof(buf_br));
+		if (ret < 0)
+			return ret;
+	}
+
+	if (bf != state->bf) {
+		ret = zl10036_write(state, buf_bf, sizeof(buf_bf));
+		if (ret < 0)
+			return ret;
+
+		/* time = br/(32* fxtal) */
+		/* minimal sleep time to be calculated
+		 * maximum br is 63 -> max time = 2 /10 MHz = 2e-7 */
+		msleep(1);
+
+		ret = zl10036_write(state, zl10036_rsd_off,
+			sizeof(zl10036_rsd_off));
+		if (ret < 0)
+			return ret;
+	}
+
+	state->br = br;
+	state->bf = bf;
+
+	return 0;
+}
+
+static int zl10036_set_gain_params(struct zl10036_state *state,
+	int c)
+{
+	u8 buf[2];
+	u8 rfg, ba, bg;
+
+	/* default values */
+	rfg = 0; /* enable when using an lna */
+	ba = 1;
+	bg = 1;
+
+	/* reg 4 */
+	buf[0] = 0x80 | ((rfg << 5) & 0x20)
+		| ((ba  << 3) & 0x18) | ((bg  << 1) & 0x06);
+
+	if (!state->config->rf_loop_enable)
+		buf[0] |= 0x01;
+
+	/* P0=0 */
+	buf[1] = _RDIV_REG | ((c << 5) & 0x60);
+
+	deb_info("%s: c=%u rfg=%u ba=%u bg=%u\n", __func__, c, rfg, ba, bg);
+	return zl10036_write(state, buf, sizeof(buf));
+}
+
+static int zl10036_set_params(struct dvb_frontend *fe,
+		struct dvb_frontend_parameters *params)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	int ret = 0;
+	u32 frequency = params->frequency;
+	u32 fbw;
+	int i;
+	u8 c;
+
+	/* ensure correct values
+	 * maybe redundant as core already checks this */
+	if ((frequency < fe->ops.info.frequency_min)
+	||  (frequency > fe->ops.info.frequency_max))
+		return -EINVAL;
+
+	/**
+	 * alpha = 1.35 for dvb-s
+	 * fBW = (alpha*symbolrate)/(2*0.8)
+	 * 1.35 / (2*0.8) = 27 / 32
+	 */
+	fbw = (27 * params->u.qpsk.symbol_rate) / 32;
+
+	/* scale to kHz */
+	fbw /= 1000;
+
+	/* Add safe margin of 3MHz */
+	fbw += 3000;
+
+	/* setting the charge pump - guessed values */
+	if (frequency < 950000)
+		return -EINVAL;
+	else if (frequency < 1250000)
+		c = 0;
+	else if (frequency < 1750000)
+		c = 1;
+	else if (frequency < 2175000)
+		c = 2;
+	else
+		return -EINVAL;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_set_gain_params(state, c);
+	if (ret < 0)
+		goto error;
+
+	ret = zl10036_set_frequency(state, params->frequency);
+	if (ret < 0)
+		goto error;
+
+	ret = zl10036_set_bandwidth(state, fbw);
+	if (ret < 0)
+		goto error;
+
+	/* wait for tuner lock - no idea if this is really needed */
+	for (i = 0; i < 20; i++) {
+		ret = zl10036_read_status_reg(state);
+		if (ret < 0)
+			goto error;
+
+		/* check Frequency & Phase Lock Bit */
+		if (ret & STATUS_FL)
+			break;
+
+		msleep(10);
+	}
+
+error:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return ret;
+}
+
+static int zl10036_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+
+	*frequency = state->frequency;
+
+	return 0;
+}
+
+static int zl10036_init_regs(struct zl10036_state *state)
+{
+	int ret;
+	int i;
+
+	/* could also be one block from reg 2 to 13 and additional 10/11 */
+	u8 zl10036_init_tab[][2] = {
+		{ 0x04, 0x00 },		/*   2/3: div=0x400 - arbitrary value */
+		{ 0x8b, _RDIV_REG },	/*   4/5: rfg=0 ba=1 bg=1 len=? */
+					/*        p0=0 c=0 r=_RDIV_REG */
+		{ 0xc0, 0x20 },		/*   6/7: rsd=0 bf=0x10 */
+		{ 0xd3, 0x40 },		/*   8/9: from datasheet */
+		{ 0xe3, 0x5b },		/* 10/11: lock window level */
+		{ 0xf0, 0x28 },		/* 12/13: br=0xa clr=0 tl=0*/
+		{ 0xe3, 0xf9 },		/* 10/11: unlock window level */
+	};
+
+	/* invalid values to trigger writing */
+	state->br = 0xff;
+	state->bf = 0xff;
+
+	if (!state->config->rf_loop_enable)
+		zl10036_init_tab[1][2] |= 0x01;
+
+	deb_info("%s\n", __func__);
+
+	for (i = 0; i < ARRAY_SIZE(zl10036_init_tab); i++) {
+		ret = zl10036_write(state, zl10036_init_tab[i], 2);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int zl10036_init(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	int ret = 0;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_read_status_reg(state);
+	if (ret < 0)
+		return ret;
+
+	/* Only init if Power-on-Reset bit is set? */
+	ret = zl10036_init_regs(state);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return ret;
+}
+
+static struct dvb_tuner_ops zl10036_tuner_ops = {
+	.info = {
+		.name = "Zarlink ZL10036",
+		.frequency_min = 950000,
+		.frequency_max = 2175000
+	},
+	.init = zl10036_init,
+	.release = zl10036_release,
+	.sleep = zl10036_sleep,
+	.set_params = zl10036_set_params,
+	.get_frequency = zl10036_get_frequency,
+};
+
+struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
+				    const struct zl10036_config *config,
+				    struct i2c_adapter *i2c)
+{
+	struct zl10036_state *state = NULL;
+	int ret;
+
+	if (NULL == config) {
+		printk(KERN_ERR "%s: no config specified", __func__);
+		goto error;
+	}
+
+	state = kzalloc(sizeof(struct zl10036_state), GFP_KERNEL);
+	if (NULL == state)
+		return NULL;
+
+	state->config = config;
+	state->i2c = i2c;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_read_status_reg(state);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: No zl10036 found\n", __func__);
+		goto error;
+	}
+
+	ret = zl10036_init_regs(state);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: tuner initialization failed\n",
+			__func__);
+		goto error;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	fe->tuner_priv = state;
+
+	memcpy(&fe->ops.tuner_ops, &zl10036_tuner_ops,
+		sizeof(struct dvb_tuner_ops));
+	printk(KERN_INFO "%s: tuner initialization (%s addr=0x%02x) ok\n",
+		__func__, fe->ops.tuner_ops.info.name, config->tuner_address);
+
+	return fe;
+
+error:
+	zl10036_release(fe);
+	return NULL;
+}
+EXPORT_SYMBOL(zl10036_attach);
+
+module_param_named(debug, zl10036_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+MODULE_DESCRIPTION("DVB ZL10036 driver");
+MODULE_AUTHOR("Tino Reichardt");
+MODULE_AUTHOR("Matthias Schwarzott");
+MODULE_LICENSE("GPL");
Index: v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.h
===================================================================
--- /dev/null
+++ v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.h
@@ -0,0 +1,53 @@
+/**
+ * Driver for Zarlink ZL10036 DVB-S silicon tuner
+ *
+ * Copyright (C) 2006 Tino Reichardt
+ * Copyright (C) 2007-2009 Matthias Schwarzott <zzam@gentoo.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
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
+#ifndef DVB_ZL10036_H
+#define DVB_ZL10036_H
+
+#include <linux/i2c.h>
+#include "dvb_frontend.h"
+
+/**
+ * Attach a zl10036 tuner to the supplied frontend structure.
+ *
+ * @param fe Frontend to attach to.
+ * @param config zl10036_config structure
+ * @return FE pointer on success, NULL on failure.
+ */
+
+struct zl10036_config {
+	u8 tuner_address;
+	int rf_loop_enable;
+};
+
+#if defined(CONFIG_DVB_ZL10036) || \
+	(defined(CONFIG_DVB_ZL10036_MODULE) && defined(MODULE))
+extern struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
+	const struct zl10036_config *config, struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
+	const struct zl10036_config *config, struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif /* DVB_ZL10036_H */

