Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51921 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab0KNNWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:22:53 -0500
Received: by wyb28 with SMTP id 28so3520273wyb.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 05:22:51 -0800 (PST)
Date: Sun, 14 Nov 2010 14:22:45 +0100
From: Davor Emard <davoremard@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] terratec cinergy t-stick RC (with TDA18218)
Message-ID: <20101114132244.GA18203@emard.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

HI

This patch applies to lates v4l tree and seems to work for me.
I created it with diff -pur --new-file

No time to read docs about submitting patches yet for me, i'm sorrry...

Best regards, Davor

diff -pur --new-file v4l-dvb.orig/linux/drivers/media/common/tuners/Kconfig v4l-dvb/linux/drivers/media/common/tuners/Kconfig
--- v4l-dvb.orig/linux/drivers/media/common/tuners/Kconfig	2010-11-14 10:07:34.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/Kconfig	2010-11-14 14:05:34.223928063 +0100
@@ -70,6 +70,13 @@ config MEDIA_TUNER_TDA827X
 	help
 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
 
+config MEDIA_TUNER_TDA18218
+	tristate "NXP TDA18218 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  A driver for the silicon tuner TDA18218 from NXP.
+
 config MEDIA_TUNER_TDA18271
 	tristate "NXP TDA18271 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/common/tuners/Makefile v4l-dvb/linux/drivers/media/common/tuners/Makefile
--- v4l-dvb.orig/linux/drivers/media/common/tuners/Makefile	2010-11-14 10:07:34.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/Makefile	2010-11-14 14:05:34.223928063 +0100
@@ -14,6 +14,7 @@ obj-$(CONFIG_MEDIA_TUNER_TEA5767) += tea
 obj-$(CONFIG_MEDIA_TUNER_TEA5761) += tea5761.o
 obj-$(CONFIG_MEDIA_TUNER_TDA9887) += tda9887.o
 obj-$(CONFIG_MEDIA_TUNER_TDA827X) += tda827x.o
+obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18271) += tda18271.o
 obj-$(CONFIG_MEDIA_TUNER_XC5000) += xc5000.o
 obj-$(CONFIG_MEDIA_TUNER_MT2060) += mt2060.o
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/common/tuners/tda18218.c v4l-dvb/linux/drivers/media/common/tuners/tda18218.c
--- v4l-dvb.orig/linux/drivers/media/common/tuners/tda18218.c	1970-01-01 01:00:00.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/tda18218.c	2010-11-14 14:05:34.246930323 +0100
@@ -0,0 +1,471 @@
+/*
+ *  Driver for NXP TDA18218 silicon tuner
+ *
+ *  Copyright (C) 2010 Lauris Ding <lding@gmx.de>
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include "tda18218.h"
+#include "compat.h"
+#include "tda18218_priv.h"
+
+static int tda18218_write_reg(struct dvb_frontend *fe, u8 reg, u8 val)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	u8 buf[2] = { reg, val };
+	struct i2c_msg msg = { .addr = priv->cfg->i2c_address, .flags = 0,
+			       .buf = buf, .len = 2 };
+	int ret;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	/* write register */
+	ret = i2c_transfer(priv->i2c, &msg, 1);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (ret != 1)
+		printk(KERN_WARNING "I2C write failed ret: %d reg: %02x\n", ret, reg);
+
+	return (ret == 1 ? 0 : ret);
+}
+
+static int tda18218_write_regs(struct dvb_frontend *fe, u8 reg,
+	u8 *val, u8 len)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	u8 buf[1+len];
+	struct i2c_msg msg = {
+		.addr = priv->cfg->i2c_address,
+		.flags = 0,
+		.len = sizeof(buf),
+		.buf = buf };
+		
+	int ret;
+
+	buf[0] = reg;
+	memcpy(&buf[1], val, len);
+	
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	ret = i2c_transfer(priv->i2c, &msg, 1);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (ret != 1)
+		printk(KERN_WARNING "I2C write failed ret: %d reg: %02x len: %d\n", ret, reg, len);
+	
+	return (ret == 1 ? 0 : ret);
+}
+
+/*static int tda18218_read_reg(struct tda18218_priv *priv, u16 reg, u8 *val)
+{
+	u8 obuf[3] = { reg >> 8, reg & 0xff, 0 };
+	u8 ibuf[1];
+	struct i2c_msg msg[2] = {
+		{
+			.addr = 0x3a,
+			.flags = 0,
+			.len = sizeof(obuf),
+			.buf = obuf
+		}, {
+			.addr = 0x3a,
+			.flags = I2C_M_RD,
+			.len = sizeof(ibuf),
+			.buf = ibuf
+		}
+	};
+
+	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
+		printk(KERN_WARNING "I2C read failed reg:%04x\n", reg);
+		return -EREMOTEIO;
+	}
+	*val = ibuf[0];
+	return 0;
+}*/
+
+static int tda18218_read_regs(struct dvb_frontend *fe)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	u8 *regs = priv->tda18218_regs;
+	u8 buf = 0x00;
+	int ret;
+	//int i;
+	struct i2c_msg msg[] = {
+		{ .addr = 0xc0, .flags = 0,
+		  .buf = &buf, .len = 1 },
+		{ .addr = 0xc0, .flags = I2C_M_RD,
+		  .buf = regs, .len = 59 }
+	};
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* read all registers */
+	ret = i2c_transfer(priv->i2c, msg, 2);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (ret != 2)
+		printk(KERN_WARNING "I2C read failed ret: %d\n", ret);
+	
+	/*for(i = 0; i <= 58; i++)
+		printk("Register %d: %02x\n", i, 0xff & regs[i]);*/
+
+	return (ret == 2 ? 0 : ret);
+}
+
+static int tda18218_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	u8 *regs = priv->tda18218_regs;
+	u8 Fc, BP;
+	int i, ret;
+	u16 if1, bw;
+	u32 freq;
+	
+	u8 paramsbuf[4][6] = {
+		{ 0x03, 0x1a },
+		{ 0x04, 0x0a },
+		{ 0x01, 0x0f },
+		{ 0x01, 0x0f },
+	};
+	
+	u8 agcbuf[][2] = {
+		{ 0x1a, 0x0e },
+		{ 0x20, 0x60 },
+		{ 0x23, 0x02 },
+		{ 0x20, 0xa0 },
+		{ 0x23, 0x09 },
+		{ 0x20, 0xe0 },
+		{ 0x23, 0x0c },
+		{ 0x20, 0x40 },
+		{ 0x23, 0x01 },
+		{ 0x20, 0x80 },
+		{ 0x23, 0x08 },
+		{ 0x20, 0xc0 },
+		{ 0x23, 0x0b },
+		{ 0x24, 0x1c },
+		{ 0x24, 0x0c },
+	};
+	
+	switch (params->u.ofdm.bandwidth) {
+	case BANDWIDTH_6_MHZ:
+		bw = 6000;
+		Fc = 0;
+		break;
+	case BANDWIDTH_7_MHZ:
+		bw = 7000;
+		Fc = 1;
+		break;
+	case BANDWIDTH_8_MHZ:
+		bw = 8000;
+		Fc = 2;
+		break;
+	default:
+		printk(KERN_WARNING "Invalid bandwidth");
+		return -EINVAL;
+	}
+	
+	if1 = bw / 2;
+	
+	if((params->frequency >= 174000000) && (params->frequency < 188000000)) {
+		BP = 3;
+	}
+	else if((params->frequency >= 188000000) && (params->frequency < 253000000)) {
+		BP = 4;
+	}
+	else if((params->frequency >= 253000000) && (params->frequency < 343000000)) {
+		BP = 5;
+	}
+	else if((params->frequency >= 343000000) && (params->frequency <= 870000000)) {
+		BP = 6;
+	}
+	else {
+		printk(KERN_WARNING "Frequency out of range");
+		return -EINVAL;
+	}
+	
+	freq = params->frequency;
+	freq /= 1000;
+	freq +=if1;
+	freq *= 16;
+	
+	tda18218_read_regs(fe);
+	
+	paramsbuf[0][2] = regs[0x1a] | BP;
+	paramsbuf[0][3] = regs[0x1b] & ~3;
+	paramsbuf[0][3] = regs[0x1b] | Fc;
+	paramsbuf[0][4] = regs[0x1c] | 0x0a;
+	
+	paramsbuf[1][2] = freq >> 16;
+	paramsbuf[1][3] = freq >> 8;
+	paramsbuf[1][4] = (freq & 0xf0) | (regs[0x0c] & 0x0f);
+	paramsbuf[1][5] = 0xff;
+	paramsbuf[2][2] = regs[0x0f] | 0x40;
+	paramsbuf[3][2] = 0x09;
+	
+	tda18218_write_reg(fe, 0x04, 0x03);
+
+	for(i = 0; i < ARRAY_SIZE(paramsbuf); i++) {
+
+		/* write registers */
+		ret = tda18218_write_regs(fe, paramsbuf[i][1], &paramsbuf[i][2], paramsbuf[i][0]);
+
+		if (ret)
+			goto error;
+	}
+	for(i = 0; i < ARRAY_SIZE(agcbuf); i++) {
+		tda18218_write_reg(fe, agcbuf[i][0], agcbuf[i][1]);
+	}
+	
+	//tda18218_write_reg(fe, 0x03, 0x00);
+	//tda18218_write_reg(fe, 0x04, 0x00);
+	//tda18218_write_reg(fe, 0x20, 0xc7);
+	
+	msleep(60);
+	i = 0;
+	while(i < 10) {
+		tda18218_read_regs(fe);
+		if((regs[0x01] & 0x60) == 0x60)
+			printk(KERN_INFO "We've got a lock!"); break;
+		msleep(20);
+		i++;
+	}
+	
+	priv->bandwidth = params->u.ofdm.bandwidth;
+	priv->frequency = params->frequency;
+	return 0;
+error:
+	return ret;
+}
+
+static int tda18218_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	*frequency = priv->frequency;
+	return 0;
+}
+
+static int tda18218_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	*bandwidth = priv->bandwidth;
+	return 0;
+}
+
+static int tda18218_init(struct dvb_frontend *fe)
+{
+	//struct tda18218_priv *priv = fe->tuner_priv;
+	//u8 *regs = priv->tda18218_regs;
+	int i;
+	int ret;
+	
+	u8 initbuf[][18] = {
+		{ 0x10, 0x05, 0x00, 0x00, 0xd0, 0x00, 0x40, 0x00, 0x00, 0x07, 0xff, 0x84, 0x09, 0x00, 0x13, 0x00, 0x00, 0x01 },
+		{ 0x0b, 0x15, 0x84, 0x09, 0xf0, 0x19, 0x0a, 0x0e, 0x29, 0x98, 0x00, 0x00, 0x58 },
+		{ 0x10, 0x24, 0x0c, 0x48, 0x85, 0xc9, 0xa7, 0x00, 0x00, 0x00, 0x30, 0x81, 0x80, 0x00, 0x39, 0x00, 0x8a, 0x00 },
+		{ 0x07, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf6, 0xf6 },
+	};
+	
+	u8 initbuf2[4];
+
+	for(i = 0; i < ARRAY_SIZE(initbuf); i++) {
+		
+		/* write registers */
+		ret = tda18218_write_regs(fe, initbuf[i][1], &initbuf[i][2], initbuf[i][0]);
+
+		if (ret != 0) {
+			printk(KERN_ERR "init: ERROR: i2c_transfer returned: %d\n", ret);
+			return -EREMOTEIO;
+		}
+		if(i == 1) {
+			tda18218_write_reg(fe, 0x22, 0x8c);
+		}
+	}
+	
+	tda18218_write_reg(fe, 0x05, 0x80);
+	tda18218_write_reg(fe, 0x05, 0x00);
+	tda18218_write_reg(fe, 0x05, 0x20);
+	tda18218_write_reg(fe, 0x05, 0x00);
+	tda18218_write_reg(fe, 0x27, 0xde);
+	tda18218_write_reg(fe, 0x17, 0xf8);
+	tda18218_write_reg(fe, 0x18, 0x0f);
+	tda18218_write_reg(fe, 0x1c, 0x8b);
+	tda18218_write_reg(fe, 0x29, 0x02);
+	tda18218_write_reg(fe, 0x19, 0x1a);
+	tda18218_write_reg(fe, 0x11, 0x13);
+
+	initbuf2[0] = 0x0a;
+	initbuf2[1] = 0x5c;
+	initbuf2[2] = 0xc6;
+	initbuf2[3] = 0x07;
+	tda18218_write_regs(fe, initbuf2[0], &initbuf2[1], 3);
+	tda18218_write_reg(fe, 0x0f, 0x49);
+	tda18218_write_reg(fe, 0x05, 0x40);
+	tda18218_write_reg(fe, 0x05, 0x00);
+	tda18218_write_reg(fe, 0x05, 0x20);
+	tda18218_write_reg(fe, 0x11, 0xed);
+	tda18218_write_reg(fe, 0x0f, 0x49);
+	tda18218_write_reg(fe, 0x19, 0x2a);
+	tda18218_write_reg(fe, 0x05, 0x58);
+	tda18218_write_reg(fe, 0x05, 0x18);
+	tda18218_write_reg(fe, 0x05, 0x38);
+	tda18218_write_reg(fe, 0x29, 0x03);
+	tda18218_write_reg(fe, 0x19, 0x1a);
+	tda18218_write_reg(fe, 0x11, 0x13);
+	initbuf2[0] = 0x0a;
+	initbuf2[1] = 0xbe;
+	initbuf2[2] = 0x6e;
+	initbuf2[3] = 0x07;
+	tda18218_write_regs(fe, initbuf2[0], &initbuf2[1], 3);
+	tda18218_write_reg(fe, 0x0f, 0x49);
+	tda18218_write_reg(fe, 0x05, 0x58);
+	tda18218_write_reg(fe, 0x05, 0x18);
+	tda18218_write_reg(fe, 0x05, 0x38);
+	tda18218_write_reg(fe, 0x11, 0xed);
+	tda18218_write_reg(fe, 0x0f, 0x49);
+	tda18218_write_reg(fe, 0x19, 0x2a);
+	tda18218_write_reg(fe, 0x05, 0x58);
+	tda18218_write_reg(fe, 0x05, 0x18);
+	tda18218_write_reg(fe, 0x05, 0x38);
+	tda18218_write_reg(fe, 0x19, 0x0a);
+	tda18218_write_reg(fe, 0x27, 0xc9);
+	tda18218_write_reg(fe, 0x11, 0x13);
+	initbuf2[0] = 0x17;
+	initbuf2[1] = 0xf0;
+	initbuf2[2] = 0x19;
+	initbuf2[3] = 0x00;
+	tda18218_write_regs(fe, initbuf2[0], &initbuf2[1], 2);
+	tda18218_write_reg(fe, 0x1c, 0x98);
+	tda18218_write_reg(fe, 0x29, 0x03);
+	tda18218_write_reg(fe, 0x2a, 0x00);
+	tda18218_write_reg(fe, 0x2a, 0x01);
+	tda18218_write_reg(fe, 0x2a, 0x02);
+	tda18218_write_reg(fe, 0x2a, 0x03);
+	tda18218_write_reg(fe, 0x1c, 0x98);
+	tda18218_write_reg(fe, 0x18, 0x19);
+	tda18218_write_reg(fe, 0x22, 0x9c);
+	tda18218_write_reg(fe, 0x1f, 0x58);
+	tda18218_write_reg(fe, 0x24, 0x0c);
+	tda18218_write_reg(fe, 0x1c, 0x88);
+	tda18218_write_reg(fe, 0x20, 0x10);
+	tda18218_write_reg(fe, 0x21, 0x4c);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x21, 0x48);
+	tda18218_write_reg(fe, 0x1f, 0x5b);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x1f, 0x59);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x1f, 0x5a);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x1f, 0x5f);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x1f, 0x5d);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x1f, 0x5e);
+	tda18218_write_reg(fe, 0x20, 0x00);
+	tda18218_write_reg(fe, 0x20, 0x60);
+	tda18218_write_reg(fe, 0x23, 0x02);
+	tda18218_write_reg(fe, 0x20, 0xa0);
+	tda18218_write_reg(fe, 0x23, 0x09);
+	tda18218_write_reg(fe, 0x20, 0xe0);
+	tda18218_write_reg(fe, 0x23, 0x0c);
+	tda18218_write_reg(fe, 0x20, 0x40);
+	tda18218_write_reg(fe, 0x23, 0x01);
+	tda18218_write_reg(fe, 0x20, 0x80);
+	tda18218_write_reg(fe, 0x23, 0x08);
+	tda18218_write_reg(fe, 0x20, 0xc0);
+	tda18218_write_reg(fe, 0x23, 0x0b);
+	tda18218_write_reg(fe, 0x1c, 0x98);
+	tda18218_write_reg(fe, 0x22, 0x8c);
+	initbuf2[0] = 0x17;
+	initbuf2[1] = 0xb0;
+	initbuf2[2] = 0x59;
+	initbuf2[3] = 0x00;
+	//tda18218_write_regs(fe, initbuf2[0], &initbuf2[1], 2);
+	initbuf2[0] = 0x1a;
+	initbuf2[1] = 0x0e;
+	initbuf2[2] = 0x2a;
+	initbuf2[3] = 0x98;
+	tda18218_write_regs(fe, initbuf2[0], &initbuf2[1], 3);
+	initbuf2[0] = 0x17;
+	initbuf2[1] = 0xb0;
+	initbuf2[2] = 0x59;
+	initbuf2[3] = 0x00;
+	tda18218_write_regs(fe, initbuf2[0], &initbuf2[1], 2);
+	tda18218_write_reg(fe, 0x2d, 0x81);
+	tda18218_write_reg(fe, 0x29, 0x02);
+	
+	return 0;
+}
+	
+static int tda18218_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static const struct dvb_tuner_ops tda18218_tuner_ops = {
+	.info = {
+		.name           = "NXP TDA18218",
+		.frequency_min  = TDA18218_MIN_FREQ,
+		.frequency_max  = TDA18218_MAX_FREQ,
+		.frequency_step = TDA18218_STEP,
+	},
+
+	.release       = tda18218_release,
+	.init          = tda18218_init,
+	
+	.set_params = tda18218_set_params,
+	.get_frequency = tda18218_get_frequency,
+	.get_bandwidth = tda18218_get_bandwidth,
+};
+
+struct dvb_frontend * tda18218_attach(struct dvb_frontend *fe,
+				    struct i2c_adapter *i2c,
+				    struct tda18218_config *cfg)
+{
+	struct tda18218_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(struct tda18218_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	priv->cfg = cfg;
+	priv->i2c = i2c;
+
+	fe->tuner_priv = priv;
+	
+	tda18218_read_regs(fe);
+	if (priv->tda18218_regs[0x00] != 0xc0) {
+		printk(KERN_WARNING "Device is not a TDA18218!\n");
+		kfree(priv);
+		return NULL;
+	}
+	
+	printk(KERN_INFO "NXP TDA18218 successfully identified.\n");
+	memcpy(&fe->ops.tuner_ops, &tda18218_tuner_ops,
+	       sizeof(struct dvb_tuner_ops));
+	
+	return fe;
+}
+EXPORT_SYMBOL(tda18218_attach);
+
+MODULE_DESCRIPTION("NXP TDA18218 silicon tuner driver");
+MODULE_AUTHOR("Lauris Ding <lding@gmx.de>");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/common/tuners/tda18218.h v4l-dvb/linux/drivers/media/common/tuners/tda18218.h
--- v4l-dvb.orig/linux/drivers/media/common/tuners/tda18218.h	1970-01-01 01:00:00.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/tda18218.h	2010-11-14 14:05:34.248930520 +0100
@@ -0,0 +1,44 @@
+/*
+ *  Driver for  NXP TDA18218 silicon tuner
+ *
+ *  Copyright (C) 2010 Lauris Ding <lding@gmx.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef TDA18218_H
+#define TDA18218_H
+
+#include "dvb_frontend.h"
+
+struct tda18218_config {
+	u8 i2c_address;
+};
+
+#if defined(CONFIG_MEDIA_TUNER_TDA18218) || (defined(CONFIG_MEDIA_TUNER_TDA18218_MODULE) && defined(MODULE))
+extern struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
+					  struct i2c_adapter *i2c,
+					  struct tda18218_config *cfg);
+#else
+static inline struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
+						 struct i2c_adapter *i2c,
+						 struct tda18218_config *cfg)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif // CONFIG_MEDIA_TUNER_TDA18218
+
+#endif
\ No newline at end of file
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/common/tuners/tda18218_priv.h v4l-dvb/linux/drivers/media/common/tuners/tda18218_priv.h
--- v4l-dvb.orig/linux/drivers/media/common/tuners/tda18218_priv.h	1970-01-01 01:00:00.000000000 +0100
+++ v4l-dvb/linux/drivers/media/common/tuners/tda18218_priv.h	2010-11-14 14:05:34.249930619 +0100
@@ -0,0 +1,36 @@
+/*
+ *  Driver for NXP TDA18218 silicon tuner
+ *
+ *  Copyright (C) 2010 Lauris Ding <lding@gmx.de>
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef TDA18218_PRIV_H
+#define TDA18218_PRIV_H
+
+#define TDA18218_STEP         1000 /* 1 kHz */
+#define TDA18218_MIN_FREQ   174000000 /*   174 MHz */
+#define TDA18218_MAX_FREQ  864000000 /*  864 MHz */
+
+struct tda18218_priv {
+	u8 tda18218_regs[0x3b];
+	struct tda18218_config *cfg;
+	struct i2c_adapter *i2c;
+
+	u32 frequency;
+	u32 bandwidth;
+};
+
+#endif
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/af9015.c v4l-dvb/linux/drivers/media/dvb/dvb-usb/af9015.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/af9015.c	2010-11-14 10:07:34.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/af9015.c	2010-11-14 14:05:34.253931011 +0100
@@ -30,6 +30,7 @@
 #include "af9013.h"
 #include "mt2060.h"
 #include "qt1010.h"
+#include "tda18218.h"
 #include "tda18271.h"
 #include "mxl5005s.h"
 #include "mc44s803.h"
@@ -1025,6 +1026,7 @@ static int af9015_read_config(struct usb
 		case AF9013_TUNER_QT1010:
 		case AF9013_TUNER_UNKNOWN:
 		case AF9013_TUNER_MT2060_2:
+		case AF9013_TUNER_TDA18218:
 		case AF9013_TUNER_TDA18271:
 		case AF9013_TUNER_QT1010A:
 			af9015_af9013_config[i].rf_spec_inv = 1;
@@ -1038,9 +1040,6 @@ static int af9015_read_config(struct usb
 			af9015_af9013_config[i].gpio[1] = AF9013_GPIO_LO;
 			af9015_af9013_config[i].rf_spec_inv = 1;
 			break;
-		case AF9013_TUNER_TDA18218:
-			warn("tuner NXP TDA18218 not supported yet");
-			return -ENODEV;
 		default:
 			warn("tuner id:%d not supported, please report!", val);
 			return -ENODEV;
@@ -1248,6 +1247,10 @@ static struct mc44s803_config af9015_mc4
 	.dig_out = 1,
 };
 
+static struct tda18218_config af9015_tda18218_config = {
+	.i2c_address = 0xc0,
+};
+
 static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct af9015_state *state = adap->dev->priv;
@@ -1278,6 +1281,10 @@ static int af9015_tuner_attach(struct dv
 		ret = dvb_attach(tda18271_attach, adap->fe, 0xc0, i2c_adap,
 			&af9015_tda18271_config) == NULL ? -ENODEV : 0;
 		break;
+	case AF9013_TUNER_TDA18218:
+		ret = dvb_attach(tda18218_attach, adap->fe, i2c_adap,
+			&af9015_tda18218_config) == NULL ? -ENODEV : 0;
+		break;
 	case AF9013_TUNER_MXL5003D:
 		ret = dvb_attach(mxl5005s_attach, adap->fe, i2c_adap,
 			&af9015_mxl5003_config) == NULL ? -ENODEV : 0;
@@ -1339,6 +1346,7 @@ static struct usb_device_id af9015_usb_t
 	{USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV2000DS)},
 /* 30 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_UB383_T)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_4)},
+	{USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_STICK_RC)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1612,7 +1620,7 @@ static struct dvb_usb_device_properties
 
 		.i2c_algo = &af9015_i2c_algo,
 
-		.num_device_descs = 8, /* max 9 */
+		.num_device_descs = 9, /* max 9 */
 		.devices = {
 			{
 				.name = "AverMedia AVerTV Volar GPS 805 (A805)",
@@ -1657,6 +1665,11 @@ static struct dvb_usb_device_properties
 				.cold_ids = {&af9015_usb_table[30], NULL},
 				.warm_ids = {NULL},
 			},
+			{
+				.name = "TerraTec Cinergy T Stick RC",
+				.cold_ids = {&af9015_usb_table[32], NULL},
+				.warm_ids = {NULL},
+			},
 		}
 	},
 };
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-11-14 10:07:34.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-11-14 14:05:34.255931207 +0100
@@ -205,6 +205,7 @@
 #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS		0x0060
 #define USB_PID_TERRATEC_CINERGY_T_EXPRESS		0x0062
 #define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
+#define USB_PID_TERRATEC_CINERGY_T_STICK_RC		0x0097
 #define USB_PID_TERRATEC_CINERGY_T_XXS_2		0x00ab
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
diff -pur --new-file v4l-dvb.orig/linux/drivers/media/dvb/frontends/af9013.c v4l-dvb/linux/drivers/media/dvb/frontends/af9013.c
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/af9013.c	2010-11-14 10:07:34.000000000 +0100
+++ v4l-dvb/linux/drivers/media/dvb/frontends/af9013.c	2010-11-14 14:05:34.258931503 +0100
@@ -488,6 +488,20 @@ static int af9013_set_freq_ctrl(struct a
 				break;
 			}
 		}
+		else if(state->config.tuner == AF9013_TUNER_TDA18218) {
+			switch (bw) {
+			case BANDWIDTH_6_MHZ:
+				if_sample_freq = 3000000; /* 3 MHz */
+				break;
+			case BANDWIDTH_7_MHZ:
+				if_sample_freq = 3500000; /* 3.5 MHz */
+				break;
+			case BANDWIDTH_8_MHZ:
+			default:
+				if_sample_freq = 4000000; /* 4 MHz */
+				break;
+			}
+		}
 
 		while (if_sample_freq > (adc_freq / 2))
 			if_sample_freq = if_sample_freq - adc_freq;
@@ -1390,6 +1404,7 @@ static int af9013_init(struct dvb_fronte
 		init = tuner_init_mt2060_2;
 		break;
 	case AF9013_TUNER_TDA18271:
+	case AF9013_TUNER_TDA18218:
 		len = ARRAY_SIZE(tuner_init_tda18271);
 		init = tuner_init_tda18271;
 		break;
