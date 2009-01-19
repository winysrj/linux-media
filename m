Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:51125 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZASSf0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 13:35:26 -0500
Message-ID: <4974C7FE.4050909@scram.de>
Date: Mon, 19 Jan 2009 19:35:42 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv5] Add Freescale MC44S803 tuner driver
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/media/common/tuners/Kconfig         |    8 +
 drivers/media/common/tuners/Makefile        |    1 +
 drivers/media/common/tuners/mc44s803.c      |  371 +++++++++++++++++++++++++++
 drivers/media/common/tuners/mc44s803.h      |   46 ++++
 drivers/media/common/tuners/mc44s803_priv.h |  208 +++++++++++++++
 5 files changed, 634 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/common/tuners/mc44s803.c
 create mode 100644 drivers/media/common/tuners/mc44s803.h
 create mode 100644 drivers/media/common/tuners/mc44s803_priv.h

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 6f92bea..7969b69 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -29,6 +29,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMIZE
+	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMIZE
 
 menuconfig MEDIA_TUNER_CUSTOMIZE
 	bool "Customize analog and hybrid tuner modules to build"
@@ -164,4 +165,11 @@ config MEDIA_TUNER_MXL5007T
 	help
 	  A driver for the silicon tuner MxL5007T from MaxLinear.
 
+config MEDIA_TUNER_MC44S803
+	tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
+	depends on VIDEO_MEDIA && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  Say Y here to support the Freescale MC44S803 based tuners
+
 endif # MEDIA_TUNER_CUSTOMIZE
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index 4dfbe5b..4132b2b 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_MEDIA_TUNER_QT1010) += qt1010.o
 obj-$(CONFIG_MEDIA_TUNER_MT2131) += mt2131.o
 obj-$(CONFIG_MEDIA_TUNER_MXL5005S) += mxl5005s.o
 obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
+obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/common/tuners/mc44s803.c b/drivers/media/common/tuners/mc44s803.c
new file mode 100644
index 0000000..20c4485
--- /dev/null
+++ b/drivers/media/common/tuners/mc44s803.c
@@ -0,0 +1,371 @@
+/*
+ *  Driver for Freescale MC44S803 Low Power CMOS Broadband Tuner
+ *
+ *  Copyright (c) 2009 Jochen Friedrich <jochen@scram.de>
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
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/dvb/frontend.h>
+#include <linux/i2c.h>
+
+#include "dvb_frontend.h"
+
+#include "mc44s803.h"
+#include "mc44s803_priv.h"
+
+#define mc_printk(level, format, arg...)	\
+	printk(level "mc44s803: " format , ## arg)
+
+/* Writes a single register */
+static int mc44s803_writereg(struct mc44s803_priv *priv, u32 val)
+{
+	u8 buf[3];
+	struct i2c_msg msg = {
+		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 3
+	};
+
+	buf[0] = (val & 0xff0000) >> 16;
+	buf[1] = (val & 0xff00) >> 8;
+	buf[2] = (val & 0xff);
+
+	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
+		mc_printk(KERN_WARNING, "I2C write failed\n");
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+/* Reads a single register */
+static int mc44s803_readreg(struct mc44s803_priv *priv, u8 reg, u32 *val)
+{
+	u32 wval;
+	u8 buf[3];
+	int ret;
+	struct i2c_msg msg[] = {
+		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD,
+		  .buf = buf, .len = 3 },
+	};
+
+	wval = MC44S803_REG_SM(MC44S803_REG_DATAREG, MC44S803_ADDR) |
+	       MC44S803_REG_SM(reg, MC44S803_D);
+
+	ret = mc44s803_writereg(priv, wval);
+	if (ret)
+		return ret;
+
+	if (i2c_transfer(priv->i2c, msg, 1) != 1) {
+		mc_printk(KERN_WARNING, "I2C read failed\n");
+		return -EREMOTEIO;
+	}
+
+	*val = (buf[0] << 16) | (buf[1] << 8) | buf[2];
+
+	return 0;
+}
+
+static int mc44s803_release(struct dvb_frontend *fe)
+{
+	struct mc44s803_priv *priv = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(priv);
+
+	return 0;
+}
+
+static int mc44s803_init(struct dvb_frontend *fe)
+{
+	struct mc44s803_priv *priv = fe->tuner_priv;
+	u32 val;
+	int err;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+/* Reset chip */
+	val = MC44S803_REG_SM(MC44S803_REG_RESET, MC44S803_ADDR) |
+	      MC44S803_REG_SM(1, MC44S803_RS);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_RESET, MC44S803_ADDR);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+/* Power Up and Start Osc */
+
+	val = MC44S803_REG_SM(MC44S803_REG_REFOSC, MC44S803_ADDR) |
+	      MC44S803_REG_SM(0xC0, MC44S803_REFOSC) |
+	      MC44S803_REG_SM(1, MC44S803_OSCSEL);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_POWER, MC44S803_ADDR) |
+	      MC44S803_REG_SM(0x200, MC44S803_POWER);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	msleep(10);
+
+	val = MC44S803_REG_SM(MC44S803_REG_REFOSC, MC44S803_ADDR) |
+	      MC44S803_REG_SM(0x40, MC44S803_REFOSC) |
+	      MC44S803_REG_SM(1, MC44S803_OSCSEL);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	msleep(20);
+
+/* Setup Mixer */
+
+	val = MC44S803_REG_SM(MC44S803_REG_MIXER, MC44S803_ADDR) |
+	      MC44S803_REG_SM(1, MC44S803_TRI_STATE) |
+	      MC44S803_REG_SM(0x7F, MC44S803_MIXER_RES);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+/* Setup Cirquit Adjust */
+
+	val = MC44S803_REG_SM(MC44S803_REG_CIRCADJ, MC44S803_ADDR) |
+	      MC44S803_REG_SM(1, MC44S803_G1) |
+	      MC44S803_REG_SM(1, MC44S803_G3) |
+	      MC44S803_REG_SM(0x3, MC44S803_CIRCADJ_RES) |
+	      MC44S803_REG_SM(1, MC44S803_G6) |
+	      MC44S803_REG_SM(priv->cfg->dig_out, MC44S803_S1) |
+	      MC44S803_REG_SM(0x3, MC44S803_LP) |
+	      MC44S803_REG_SM(1, MC44S803_CLRF) |
+	      MC44S803_REG_SM(1, MC44S803_CLIF);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_CIRCADJ, MC44S803_ADDR) |
+	      MC44S803_REG_SM(1, MC44S803_G1) |
+	      MC44S803_REG_SM(1, MC44S803_G3) |
+	      MC44S803_REG_SM(0x3, MC44S803_CIRCADJ_RES) |
+	      MC44S803_REG_SM(1, MC44S803_G6) |
+	      MC44S803_REG_SM(priv->cfg->dig_out, MC44S803_S1) |
+	      MC44S803_REG_SM(0x3, MC44S803_LP);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+/* Setup Digtune */
+
+	val = MC44S803_REG_SM(MC44S803_REG_DIGTUNE, MC44S803_ADDR) |
+	      MC44S803_REG_SM(3, MC44S803_XOD);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+/* Setup AGC */
+
+	val = MC44S803_REG_SM(MC44S803_REG_LNAAGC, MC44S803_ADDR) |
+	      MC44S803_REG_SM(1, MC44S803_AT1) |
+	      MC44S803_REG_SM(1, MC44S803_AT2) |
+	      MC44S803_REG_SM(1, MC44S803_AGC_AN_DIG) |
+	      MC44S803_REG_SM(1, MC44S803_AGC_READ_EN) |
+	      MC44S803_REG_SM(1, MC44S803_LNA0);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+	return 0;
+
+exit:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	mc_printk(KERN_WARNING, "I/O Error\n");
+	return err;
+}
+
+static int mc44s803_set_params(struct dvb_frontend *fe,
+			       struct dvb_frontend_parameters *params)
+{
+	struct mc44s803_priv *priv = fe->tuner_priv;
+	u32 r1, r2, n1, n2, lo1, lo2, freq, val;
+	int err;
+
+	priv->frequency = params->frequency;
+
+	r1 = MC44S803_OSC / 1000000;
+	r2 = MC44S803_OSC /  100000;
+
+	n1 = (params->frequency + MC44S803_IF1 + 500000) / 1000000;
+	freq = MC44S803_OSC / r1 * n1;
+	lo1 = ((60 * n1) + (r1 / 2)) / r1;
+	freq = freq - params->frequency;
+
+	n2 = (freq - MC44S803_IF2 + 50000) / 100000;
+	lo2 = ((60 * n2) + (r2 / 2)) / r2;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	val = MC44S803_REG_SM(MC44S803_REG_REFDIV, MC44S803_ADDR) |
+	      MC44S803_REG_SM(r1-1, MC44S803_R1) |
+	      MC44S803_REG_SM(r2-1, MC44S803_R2) |
+	      MC44S803_REG_SM(1, MC44S803_REFBUF_EN);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_LO1, MC44S803_ADDR) |
+	      MC44S803_REG_SM(n1-2, MC44S803_LO1);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_LO2, MC44S803_ADDR) |
+	      MC44S803_REG_SM(n2-2, MC44S803_LO2);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_DIGTUNE, MC44S803_ADDR) |
+	      MC44S803_REG_SM(1, MC44S803_DA) |
+	      MC44S803_REG_SM(lo1, MC44S803_LO_REF) |
+	      MC44S803_REG_SM(1, MC44S803_AT);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	val = MC44S803_REG_SM(MC44S803_REG_DIGTUNE, MC44S803_ADDR) |
+	      MC44S803_REG_SM(2, MC44S803_DA) |
+	      MC44S803_REG_SM(lo2, MC44S803_LO_REF) |
+	      MC44S803_REG_SM(1, MC44S803_AT);
+
+	err = mc44s803_writereg(priv, val);
+	if (err)
+		goto exit;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+
+exit:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	mc_printk(KERN_WARNING, "I/O Error\n");
+	return err;
+}
+
+static int mc44s803_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct mc44s803_priv *priv = fe->tuner_priv;
+	*frequency = priv->frequency;
+	return 0;
+}
+
+static const struct dvb_tuner_ops mc44s803_tuner_ops = {
+	.info = {
+		.name           = "Freescale MC44S803",
+		.frequency_min  =   48000000,
+		.frequency_max  = 1000000000,
+		.frequency_step =     100000,
+	},
+
+	.release       = mc44s803_release,
+	.init          = mc44s803_init,
+	.set_params    = mc44s803_set_params,
+	.get_frequency = mc44s803_get_frequency
+};
+
+/* This functions tries to identify a MC44S803 tuner by reading the ID
+   register. This is hasty. */
+struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
+	 struct i2c_adapter *i2c, struct mc44s803_config *cfg)
+{
+	struct mc44s803_priv *priv;
+	u32 reg;
+	u8 id;
+	int ret;
+
+	reg = 0;
+
+	priv = kzalloc(sizeof(struct mc44s803_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	priv->cfg = cfg;
+	priv->i2c = i2c;
+	priv->fe  = fe;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = mc44s803_readreg(priv, MC44S803_REG_ID, &reg);
+	if (ret)
+		goto error;
+
+	id = MC44S803_REG_MS(reg, MC44S803_ID);
+
+	if (id != 0x14) {
+		mc_printk(KERN_ERR, "unsupported ID "
+		       "(%x should be 0x14)\n", id);
+		goto error;
+	}
+
+	mc_printk(KERN_INFO, "successfully identified (ID = %x)\n", id);
+	memcpy(&fe->ops.tuner_ops, &mc44s803_tuner_ops,
+	       sizeof(struct dvb_tuner_ops));
+
+	fe->tuner_priv = priv;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return fe;
+
+error:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	kfree(priv);
+	return NULL;
+}
+EXPORT_SYMBOL(mc44s803_attach);
+
+MODULE_AUTHOR("Jochen Friedrich");
+MODULE_DESCRIPTION("Freescale MC44S803 silicon tuner driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/common/tuners/mc44s803.h b/drivers/media/common/tuners/mc44s803.h
new file mode 100644
index 0000000..34f3892
--- /dev/null
+++ b/drivers/media/common/tuners/mc44s803.h
@@ -0,0 +1,46 @@
+/*
+ *  Driver for Freescale MC44S803 Low Power CMOS Broadband Tuner
+ *
+ *  Copyright (c) 2009 Jochen Friedrich <jochen@scram.de>
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
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
+ */
+
+#ifndef MC44S803_H
+#define MC44S803_H
+
+struct dvb_frontend;
+struct i2c_adapter;
+
+struct mc44s803_config {
+	u8 i2c_address;
+	u8 dig_out;
+};
+
+#if defined(CONFIG_MEDIA_TUNER_MC44S803) || \
+    (defined(CONFIG_MEDIA_TUNER_MC44S803_MODULE) && defined(MODULE))
+extern struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
+	 struct i2c_adapter *i2c, struct mc44s803_config *cfg);
+#else
+static inline struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
+	 struct i2c_adapter *i2c, struct mc44s803_config *cfg)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_MEDIA_TUNER_MC44S803 */
+
+#endif
diff --git a/drivers/media/common/tuners/mc44s803_priv.h b/drivers/media/common/tuners/mc44s803_priv.h
new file mode 100644
index 0000000..14a9278
--- /dev/null
+++ b/drivers/media/common/tuners/mc44s803_priv.h
@@ -0,0 +1,208 @@
+/*
+ *  Driver for Freescale MC44S803 Low Power CMOS Broadband Tuner
+ *
+ *  Copyright (c) 2009 Jochen Friedrich <jochen@scram.de>
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
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
+ */
+
+#ifndef MC44S803_PRIV_H
+#define MC44S803_PRIV_H
+
+/* This driver is based on the information available in the datasheet
+   http://www.freescale.com/files/rf_if/doc/data_sheet/MC44S803.pdf
+
+   SPI or I2C Address : 0xc0-0xc6
+
+   Reg.No | Function
+   -------------------------------------------
+       00 | Power Down
+       01 | Reference Oszillator
+       02 | Reference Dividers
+       03 | Mixer and Reference Buffer
+       04 | Reset/Serial Out
+       05 | LO 1
+       06 | LO 2
+       07 | Circuit Adjust
+       08 | Test
+       09 | Digital Tune
+       0A | LNA AGC
+       0B | Data Register Address
+       0C | Regulator Test
+       0D | VCO Test
+       0E | LNA Gain/Input Power
+       0F | ID Bits
+
+*/
+
+#define MC44S803_OSC 26000000	/* 26 MHz */
+#define MC44S803_IF1 1086000000 /* 1086 MHz */
+#define MC44S803_IF2 36125000	/* 36.125 MHz */
+
+#define MC44S803_REG_POWER	0
+#define MC44S803_REG_REFOSC	1
+#define MC44S803_REG_REFDIV	2
+#define MC44S803_REG_MIXER	3
+#define MC44S803_REG_RESET	4
+#define MC44S803_REG_LO1	5
+#define MC44S803_REG_LO2	6
+#define MC44S803_REG_CIRCADJ	7
+#define MC44S803_REG_TEST	8
+#define MC44S803_REG_DIGTUNE	9
+#define MC44S803_REG_LNAAGC	0x0A
+#define MC44S803_REG_DATAREG	0x0B
+#define MC44S803_REG_REGTEST	0x0C
+#define MC44S803_REG_VCOTEST	0x0D
+#define MC44S803_REG_LNAGAIN	0x0E
+#define MC44S803_REG_ID		0x0F
+
+/* Register definitions */
+#define MC44S803_ADDR		0x0F
+#define MC44S803_ADDR_S		0
+/* REG_POWER */
+#define MC44S803_POWER		0xFFFFF0
+#define MC44S803_POWER_S	4
+/* REG_REFOSC */
+#define MC44S803_REFOSC		0x1FF0
+#define MC44S803_REFOSC_S	4
+#define MC44S803_OSCSEL		0x2000
+#define MC44S803_OSCSEL_S	13
+/* REG_REFDIV */
+#define MC44S803_R2		0x1FF0
+#define MC44S803_R2_S		4
+#define MC44S803_REFBUF_EN	0x2000
+#define MC44S803_REFBUF_EN_S	13
+#define MC44S803_R1		0x7C000
+#define MC44S803_R1_S		14
+/* REG_MIXER */
+#define MC44S803_R3		0x70
+#define MC44S803_R3_S		4
+#define MC44S803_MUX3		0x80
+#define MC44S803_MUX3_S		7
+#define MC44S803_MUX4		0x100
+#define MC44S803_MUX4_S		8
+#define MC44S803_OSC_SCR	0x200
+#define MC44S803_OSC_SCR_S	9
+#define MC44S803_TRI_STATE	0x400
+#define MC44S803_TRI_STATE_S	10
+#define MC44S803_BUF_GAIN	0x800
+#define MC44S803_BUF_GAIN_S	11
+#define MC44S803_BUF_IO		0x1000
+#define MC44S803_BUF_IO_S	12
+#define MC44S803_MIXER_RES	0xFE000
+#define MC44S803_MIXER_RES_S	13
+/* REG_RESET */
+#define MC44S803_RS		0x10
+#define MC44S803_RS_S		4
+#define MC44S803_SO		0x20
+#define MC44S803_SO_S		5
+/* REG_LO1 */
+#define MC44S803_LO1		0xFFF0
+#define MC44S803_LO1_S		4
+/* REG_LO2 */
+#define MC44S803_LO2		0x7FFF0
+#define MC44S803_LO2_S		4
+/* REG_CIRCADJ */
+#define MC44S803_G1		0x20
+#define MC44S803_G1_S		5
+#define MC44S803_G3		0x80
+#define MC44S803_G3_S		7
+#define MC44S803_CIRCADJ_RES	0x300
+#define MC44S803_CIRCADJ_RES_S	8
+#define MC44S803_G6		0x400
+#define MC44S803_G6_S		10
+#define MC44S803_G7		0x800
+#define MC44S803_G7_S		11
+#define MC44S803_S1		0x1000
+#define MC44S803_S1_S		12
+#define MC44S803_LP		0x7E000
+#define MC44S803_LP_S		13
+#define MC44S803_CLRF		0x80000
+#define MC44S803_CLRF_S		19
+#define MC44S803_CLIF		0x100000
+#define MC44S803_CLIF_S		20
+/* REG_TEST */
+/* REG_DIGTUNE */
+#define MC44S803_DA		0xF0
+#define MC44S803_DA_S		4
+#define MC44S803_XOD		0x300
+#define MC44S803_XOD_S		8
+#define MC44S803_RST		0x10000
+#define MC44S803_RST_S		16
+#define MC44S803_LO_REF		0x1FFF00
+#define MC44S803_LO_REF_S	8
+#define MC44S803_AT		0x200000
+#define MC44S803_AT_S		21
+#define MC44S803_MT		0x400000
+#define MC44S803_MT_S		22
+/* REG_LNAAGC */
+#define MC44S803_G		0x3F0
+#define MC44S803_G_S		4
+#define MC44S803_AT1		0x400
+#define MC44S803_AT1_S		10
+#define MC44S803_AT2		0x800
+#define MC44S803_AT2_S		11
+#define MC44S803_HL_GR_EN	0x8000
+#define MC44S803_HL_GR_EN_S	15
+#define MC44S803_AGC_AN_DIG	0x10000
+#define MC44S803_AGC_AN_DIG_S	16
+#define MC44S803_ATTEN_EN	0x20000
+#define MC44S803_ATTEN_EN_S	17
+#define MC44S803_AGC_READ_EN	0x40000
+#define MC44S803_AGC_READ_EN_S	18
+#define MC44S803_LNA0		0x80000
+#define MC44S803_LNA0_S		19
+#define MC44S803_AGC_SEL	0x100000
+#define MC44S803_AGC_SEL_S	20
+#define MC44S803_AT0		0x200000
+#define MC44S803_AT0_S		21
+#define MC44S803_B		0xC00000
+#define MC44S803_B_S		22
+/* REG_DATAREG */
+#define MC44S803_D		0xF0
+#define MC44S803_D_S		4
+/* REG_REGTEST */
+/* REG_VCOTEST */
+/* REG_LNAGAIN */
+#define MC44S803_IF_PWR		0x700
+#define MC44S803_IF_PWR_S	8
+#define MC44S803_RF_PWR		0x3800
+#define MC44S803_RF_PWR_S	11
+#define MC44S803_LNA_GAIN	0xFC000
+#define MC44S803_LNA_GAIN_S	14
+/* REG_ID */
+#define MC44S803_ID		0x3E00
+#define MC44S803_ID_S		9
+
+/* Some macros to read/write fields */
+
+/* First shift, then mask */
+#define MC44S803_REG_SM(_val, _reg)					\
+	(((_val) << _reg##_S) & (_reg))
+
+/* First mask, then shift */
+#define MC44S803_REG_MS(_val, _reg)					\
+	(((_val) & (_reg)) >> _reg##_S)
+
+struct mc44s803_priv {
+	struct mc44s803_config *cfg;
+	struct i2c_adapter *i2c;
+	struct dvb_frontend *fe;
+
+	u32 frequency;
+};
+
+#endif
-- 
1.5.6.5

