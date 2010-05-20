Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0ETJw6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 05:52:58 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4K9qwcA012031
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 May 2010 05:52:58 -0400
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: linux-media@vger.kernel.org
Cc: Nikola Pajkovsky <npajkovs@redhat.com>
Subject: [PATCH] V4L/DVB: New NXP tda18218 tuner
Date: Thu, 20 May 2010 11:52:54 +0200
Message-Id: <1274349174-3961-1-git-send-email-npajkovs@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
---
 drivers/media/common/tuners/Kconfig         |    7 +
 drivers/media/common/tuners/Makefile        |    1 +
 drivers/media/common/tuners/tda18218.c      |  432 +++++++++++++++++++++++++++
 drivers/media/common/tuners/tda18218.h      |   44 +++
 drivers/media/common/tuners/tda18218_priv.h |   36 +++
 drivers/media/dvb/dvb-usb/af9015.c          |   13 +-
 drivers/media/dvb/frontends/af9013.c        |   15 +
 drivers/media/dvb/frontends/af9013_priv.h   |    5 +-
 8 files changed, 548 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/common/tuners/tda18218.c
 create mode 100644 drivers/media/common/tuners/tda18218.h
 create mode 100644 drivers/media/common/tuners/tda18218_priv.h

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 409a426..b00c63c 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -179,4 +179,11 @@ config MEDIA_TUNER_MAX2165
 	help
 	  A driver for the silicon tuner MAX2165 from Maxim.
 
+config MEDIA_TUNER_TDA18218
+	tristate "NXP TDA18218 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  A driver for the silicon tuner TDA18218 from NXP.
+
 endif # MEDIA_TUNER_CUSTOMISE
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index a543852..96da03d 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_MEDIA_TUNER_MXL5005S) += mxl5005s.o
 obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
 obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
+obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
new file mode 100644
index 0000000..1860b18
--- /dev/null
+++ b/drivers/media/common/tuners/tda18218.c
@@ -0,0 +1,432 @@
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
+static int tda18218_read_regs(struct dvb_frontend *fe)
+{
+	struct tda18218_priv *priv = fe->tuner_priv;
+	u8 *regs = priv->tda18218_regs;
+	u8 buf = 0x00;
+	int ret;
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
diff --git a/drivers/media/common/tuners/tda18218.h b/drivers/media/common/tuners/tda18218.h
new file mode 100644
index 0000000..694f20e
--- /dev/null
+++ b/drivers/media/common/tuners/tda18218.h
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
diff --git a/drivers/media/common/tuners/tda18218_priv.h b/drivers/media/common/tuners/tda18218_priv.h
new file mode 100644
index 0000000..e93c28b
--- /dev/null
+++ b/drivers/media/common/tuners/tda18218_priv.h
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
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 1580997..01f0cd8 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -30,6 +30,7 @@
 #include "tda18271.h"
 #include "mxl5005s.h"
 #include "mc44s803.h"
+#include "tda18218.h"
 
 static int dvb_usb_af9015_debug;
 module_param_named(debug, dvb_usb_af9015_debug, int, 0644);
@@ -991,6 +992,7 @@ static int af9015_read_config(struct usb_device *udev)
 		case AF9013_TUNER_MT2060_2:
 		case AF9013_TUNER_TDA18271:
 		case AF9013_TUNER_QT1010A:
+		case AF9013_TUNER_TDA18218:
 			af9015_af9013_config[i].rf_spec_inv = 1;
 			break;
 		case AF9013_TUNER_MXL5003D:
@@ -1002,9 +1004,6 @@ static int af9015_read_config(struct usb_device *udev)
 			af9015_af9013_config[i].gpio[1] = AF9013_GPIO_LO;
 			af9015_af9013_config[i].rf_spec_inv = 1;
 			break;
-		case AF9013_TUNER_TDA18218:
-			warn("tuner NXP TDA18218 not supported yet");
-			return -ENODEV;
 		default:
 			warn("tuner id:%d not supported, please report!", val);
 			return -ENODEV;
@@ -1207,6 +1206,10 @@ static struct mc44s803_config af9015_mc44s803_config = {
 	.dig_out = 1,
 };
 
+static struct tda18218_config af9015_tda18218_config = {
+        .i2c_address = 0xc0,
+};
+
 static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct af9015_state *state = adap->dev->priv;
@@ -1237,6 +1240,10 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
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
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 12e018b..a4b4174 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -487,6 +487,20 @@ static int af9013_set_freq_ctrl(struct af9013_state *state, fe_bandwidth_t bw)
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
@@ -1389,6 +1403,7 @@ static int af9013_init(struct dvb_frontend *fe)
 		init = tuner_init_mt2060_2;
 		break;
 	case AF9013_TUNER_TDA18271:
+	case AF9013_TUNER_TDA18218:
 		len = ARRAY_SIZE(tuner_init_tda18271);
 		init = tuner_init_tda18271;
 		break;
diff --git a/drivers/media/dvb/frontends/af9013_priv.h b/drivers/media/dvb/frontends/af9013_priv.h
index 163e251..c2910b0 100644
--- a/drivers/media/dvb/frontends/af9013_priv.h
+++ b/drivers/media/dvb/frontends/af9013_priv.h
@@ -789,8 +789,9 @@ static struct regdesc tuner_init_unknown[] = {
 	{ 0x9bd9, 0, 8, 0x08 },
 };
 
-/* NXP TDA18271 tuner init
-   AF9013_TUNER_TDA18271   = 156 */
+/* NXP TDA18271 & TDA18218 tuner init
+   AF9013_TUNER_TDA18271   = 156
+   AF9013_TUNER_TDA18218   = 179 */
 static struct regdesc tuner_init_tda18271[] = {
 	{ 0x9bd5, 0, 8, 0x01 },
 	{ 0x9bd6, 0, 8, 0x04 },
-- 
1.6.5.2

