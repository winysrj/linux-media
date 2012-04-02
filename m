Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44209 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab2DBQPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 12:15:05 -0400
Date: Mon, 2 Apr 2012 18:14:32 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] Add fc0011 tuner driver
Message-ID: <20120402181432.74e8bd50@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/upE1cKfYNrmZEGmdS5CM7DQ"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/upE1cKfYNrmZEGmdS5CM7DQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This adds support for the Fitipower fc0011 DVB-t tuner.

Signed-off-by: Michael Buesch <m@bues.ch>

---


Index: linux/drivers/media/common/tuners/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/common/tuners/Kconfig	2012-04-02 15:55:51.1552=
96579 +0200
+++ linux/drivers/media/common/tuners/Kconfig	2012-04-02 16:00:14.464066789=
 +0200
@@ -204,6 +204,13 @@
 	help
 	  NXP TDA18218 silicon tuner driver.
=20
+config MEDIA_TUNER_FC0011
+	tristate "Fitipower FC0011 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  Fitipower FC0011 silicon tuner driver.
+
 config MEDIA_TUNER_TDA18212
 	tristate "NXP TDA18212 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
Index: linux/drivers/media/common/tuners/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/common/tuners/Makefile	2012-04-02 15:55:51.155=
296579 +0200
+++ linux/drivers/media/common/tuners/Makefile	2012-04-02 16:00:14.46406678=
9 +0200
@@ -29,6 +29,7 @@
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) +=3D tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) +=3D tda18212.o
 obj-$(CONFIG_MEDIA_TUNER_TUA9001) +=3D tua9001.o
+obj-$(CONFIG_MEDIA_TUNER_FC0011) +=3D fc0011.o
=20
 ccflags-y +=3D -I$(srctree)/drivers/media/dvb/dvb-core
 ccflags-y +=3D -I$(srctree)/drivers/media/dvb/frontends
Index: linux/drivers/media/common/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/media/common/tuners/fc0011.c	2012-04-02 18:01:25.97847783=
3 +0200
@@ -0,0 +1,524 @@
+/*
+ * Fitipower FC0011 tuner driver
+ *
+ * Copyright (C) 2012 Michael Buesch <m@bues.ch>
+ *
+ * Derived from FC0012 tuner driver:
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
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
+#include "fc0011.h"
+
+
+/* Tuner registers */
+enum {
+	FC11_REG_0,
+	FC11_REG_FA,		/* FA */
+	FC11_REG_FP,		/* FP */
+	FC11_REG_XINHI,		/* XIN high 8 bit */
+	FC11_REG_XINLO,		/* XIN low 8 bit */
+	FC11_REG_VCO,		/* VCO */
+	FC11_REG_VCOSEL,	/* VCO select */
+	FC11_REG_7,		/* Unknown tuner reg 7 */
+	FC11_REG_8,		/* Unknown tuner reg 8 */
+	FC11_REG_9,
+	FC11_REG_10,		/* Unknown tuner reg 10 */
+	FC11_REG_11,		/* Unknown tuner reg 11 */
+	FC11_REG_12,
+	FC11_REG_RCCAL,		/* RC calibrate */
+	FC11_REG_VCOCAL,	/* VCO calibrate */
+	FC11_REG_15,
+	FC11_REG_16,		/* Unknown tuner reg 16 */
+	FC11_REG_17,
+
+	FC11_NR_REGS,		/* Number of registers */
+};
+
+enum FC11_REG_VCOSEL_bits {
+	FC11_VCOSEL_2		=3D 0x08, /* VCO select 2 */
+	FC11_VCOSEL_1		=3D 0x10, /* VCO select 1 */
+	FC11_VCOSEL_CLKOUT	=3D 0x20, /* Fix clock out */
+	FC11_VCOSEL_BW7M	=3D 0x40, /* 7MHz bw */
+	FC11_VCOSEL_BW6M	=3D 0x80, /* 6MHz bw */
+};
+
+enum FC11_REG_RCCAL_bits {
+	FC11_RCCAL_FORCE	=3D 0x10, /* force */
+};
+
+enum FC11_REG_VCOCAL_bits {
+	FC11_VCOCAL_RUN		=3D 0,	/* VCO calibration run */
+	FC11_VCOCAL_VALUEMASK	=3D 0x3F,	/* VCO calibration value mask */
+	FC11_VCOCAL_OK		=3D 0x40,	/* VCO calibration Ok */
+	FC11_VCOCAL_RESET	=3D 0x80, /* VCO calibration reset */
+};
+
+
+struct fc0011_priv {
+	struct i2c_adapter *i2c;
+	u8 addr;
+
+	u32 frequency;
+	u32 bandwidth;
+};
+
+
+static int fc0011_writereg(struct fc0011_priv *priv, u8 reg, u8 val)
+{
+	u8 buf[2] =3D { reg, val };
+	struct i2c_msg msg =3D { .addr =3D priv->addr,
+		.flags =3D 0, .buf =3D buf, .len =3D 2 };
+
+	if (i2c_transfer(priv->i2c, &msg, 1) !=3D 1) {
+		dev_err(&priv->i2c->dev,
+			"I2C write reg failed, reg: %02x, val: %02x\n",
+			reg, val);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int fc0011_readreg(struct fc0011_priv *priv, u8 reg, u8 *val)
+{
+	u8 dummy;
+	struct i2c_msg msg[2] =3D {
+		{ .addr =3D priv->addr,
+		  .flags =3D 0, .buf =3D &reg, .len =3D 1 },
+		{ .addr =3D priv->addr,
+		  .flags =3D I2C_M_RD, .buf =3D val ? : &dummy, .len =3D 1 },
+	};
+
+	if (i2c_transfer(priv->i2c, msg, 2) !=3D 2) {
+		dev_err(&priv->i2c->dev,
+			"I2C read failed, reg: %02x\n", reg);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int fc0011_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv =3D NULL;
+
+	return 0;
+}
+
+static int fc0011_init(struct dvb_frontend *fe)
+{
+	struct fc0011_priv *priv =3D fe->tuner_priv;
+	int err;
+
+	if (WARN_ON(!fe->callback))
+		return -EINVAL;
+
+	err =3D fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+			   FC0011_FE_CALLBACK_POWER, priv->addr);
+	if (err) {
+		dev_err(&priv->i2c->dev, "Power-on callback failed\n");
+		return err;
+	}
+	err =3D fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+			   FC0011_FE_CALLBACK_RESET, priv->addr);
+	if (err) {
+		dev_err(&priv->i2c->dev, "Reset callback failed\n");
+		return err;
+	}
+
+	return 0;
+}
+
+/* Initiate VCO calibration */
+static int fc0011_vcocal_trigger(struct fc0011_priv *priv)
+{
+	int err;
+
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RESET);
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Read VCO calibration value */
+static int fc0011_vcocal_read(struct fc0011_priv *priv, u8 *value)
+{
+	int err;
+
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+	if (err)
+		return err;
+	msleep(10);
+	err =3D fc0011_readreg(priv, FC11_REG_VCOCAL, value);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int fc0011_set_params(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p =3D &fe->dtv_property_cache;
+	struct fc0011_priv *priv =3D fe->tuner_priv;
+	int err;
+	unsigned int i, vco_retries;
+	u32 freq =3D p->frequency / 1000;
+	u32 bandwidth =3D p->bandwidth_hz / 1000;
+	u32 fvco, xin, xdiv, xdivr;
+	u16 frac;
+	u8 fa, fp, vco_sel, vco_cal;
+	u8 regs[FC11_NR_REGS] =3D { };
+
+	regs[FC11_REG_7] =3D 0x0F;
+	regs[FC11_REG_8] =3D 0x3E;
+	regs[FC11_REG_10] =3D 0xB8;
+	regs[FC11_REG_11] =3D 0x80;
+	regs[FC11_REG_RCCAL] =3D 0x04;
+	err =3D fc0011_writereg(priv, FC11_REG_7, regs[FC11_REG_7]);
+	err |=3D fc0011_writereg(priv, FC11_REG_8, regs[FC11_REG_8]);
+	err |=3D fc0011_writereg(priv, FC11_REG_10, regs[FC11_REG_10]);
+	err |=3D fc0011_writereg(priv, FC11_REG_11, regs[FC11_REG_11]);
+	err |=3D fc0011_writereg(priv, FC11_REG_RCCAL, regs[FC11_REG_RCCAL]);
+	if (err)
+		return -EIO;
+
+	/* Set VCO freq and VCO div */
+	if (freq < 54000) {
+		fvco =3D freq * 64;
+		regs[FC11_REG_VCO] =3D 0x82;
+	} else if (freq < 108000) {
+		fvco =3D freq * 32;
+		regs[FC11_REG_VCO] =3D 0x42;
+	} else if (freq < 216000) {
+		fvco =3D freq * 16;
+		regs[FC11_REG_VCO] =3D 0x22;
+	} else if (freq < 432000) {
+		fvco =3D freq * 8;
+		regs[FC11_REG_VCO] =3D 0x12;
+	} else {
+		fvco =3D freq * 4;
+		regs[FC11_REG_VCO] =3D 0x0A;
+	}
+
+	/* Calc XIN. The PLL reference frequency is 18 MHz. */
+	xdiv =3D fvco / 18000;
+	frac =3D fvco - xdiv * 18000;
+	frac =3D (frac << 15) / 18000;
+	if (frac >=3D 16384)
+		frac +=3D 32786;
+	if (!frac)
+		xin =3D 0;
+	else if (frac < 511)
+		xin =3D 512;
+	else if (frac < 65026)
+		xin =3D frac;
+	else
+		xin =3D 65024;
+	regs[FC11_REG_XINHI] =3D xin >> 8;
+	regs[FC11_REG_XINLO] =3D xin;
+
+	/* Calc FP and FA */
+	xdivr =3D xdiv;
+	if (fvco - xdiv * 18000 >=3D 9000)
+		xdivr +=3D 1; /* round */
+	fp =3D xdivr / 8;
+	fa =3D xdivr - fp * 8;
+	if (fa < 2) {
+		fp -=3D 1;
+		fa +=3D 8;
+	}
+	if (fp > 0x1F) {
+		fp &=3D 0x1F;
+		fa &=3D 0xF;
+	}
+	if (fa >=3D fp) {
+		dev_warn(&priv->i2c->dev,
+			 "fa %02X >=3D fp %02X, but trying to continue\n",
+			 (unsigned int)(u8)fa, (unsigned int)(u8)fp);
+	}
+	regs[FC11_REG_FA] =3D fa;
+	regs[FC11_REG_FP] =3D fp;
+
+	/* Select bandwidth */
+	switch (bandwidth) {
+	case 8000:
+		break;
+	case 7000:
+		regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_BW7M;
+		break;
+	default:
+		dev_warn(&priv->i2c->dev, "Unsupported bandwidth %u kHz. "
+			 "Using 6000 kHz.\n",
+			 bandwidth);
+		bandwidth =3D 6000;
+		/* fallthrough */
+	case 6000:
+		regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_BW6M;
+		break;
+	}
+
+	/* Pre VCO select */
+	if (fvco < 2320000) {
+		vco_sel =3D 0;
+		regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+	} else if (fvco < 3080000) {
+		vco_sel =3D 1;
+		regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+		regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_1;
+	} else {
+		vco_sel =3D 2;
+		regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+		regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_2;
+	}
+
+	/* Fix for low freqs */
+	if (freq < 45000) {
+		regs[FC11_REG_FA] =3D 0x6;
+		regs[FC11_REG_FP] =3D 0x11;
+	}
+
+	/* Clock out fix */
+	regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_CLKOUT;
+
+	/* Write the cached registers */
+	for (i =3D FC11_REG_FA; i <=3D FC11_REG_VCOSEL; i++) {
+		err =3D fc0011_writereg(priv, i, regs[i]);
+		if (err)
+			return err;
+	}
+
+	/* VCO calibration */
+	err =3D fc0011_vcocal_trigger(priv);
+	if (err)
+		return err;
+	err =3D fc0011_vcocal_read(priv, &vco_cal);
+	if (err)
+		return err;
+	vco_retries =3D 0;
+	while (!(vco_cal & FC11_VCOCAL_OK) && vco_retries < 6) {
+		/* Reset the tuner and try again */
+		err =3D fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				   FC0011_FE_CALLBACK_RESET, priv->addr);
+		if (err) {
+			dev_err(&priv->i2c->dev, "Failed to reset tuner\n");
+			return err;
+		}
+		/* Reinit tuner config */
+		err =3D 0;
+		for (i =3D FC11_REG_FA; i <=3D FC11_REG_VCOSEL; i++)
+			err |=3D fc0011_writereg(priv, i, regs[i]);
+		err |=3D fc0011_writereg(priv, FC11_REG_7, regs[FC11_REG_7]);
+		err |=3D fc0011_writereg(priv, FC11_REG_8, regs[FC11_REG_8]);
+		err |=3D fc0011_writereg(priv, FC11_REG_10, regs[FC11_REG_10]);
+		err |=3D fc0011_writereg(priv, FC11_REG_11, regs[FC11_REG_11]);
+		err |=3D fc0011_writereg(priv, FC11_REG_RCCAL, regs[FC11_REG_RCCAL]);
+		if (err)
+			return -EIO;
+		/* VCO calibration */
+		err =3D fc0011_vcocal_trigger(priv);
+		if (err)
+			return err;
+		err =3D fc0011_vcocal_read(priv, &vco_cal);
+		if (err)
+			return err;
+		vco_retries++;
+	}
+	if (!(vco_cal & FC11_VCOCAL_OK)) {
+		dev_err(&priv->i2c->dev,
+			"Failed to read VCO calibration value (got %02X)\n",
+			(unsigned int)vco_cal);
+		return -EIO;
+	}
+	vco_cal &=3D FC11_VCOCAL_VALUEMASK;
+
+	switch (vco_sel) {
+	case 0:
+		if (vco_cal < 8) {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_1;
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+			err =3D fc0011_vcocal_trigger(priv);
+			if (err)
+				return err;
+		} else {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+		}
+		break;
+	case 1:
+		if (vco_cal < 5) {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_2;
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+			err =3D fc0011_vcocal_trigger(priv);
+			if (err)
+				return err;
+		} else if (vco_cal <=3D 48) {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_1;
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+		} else {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+			err =3D fc0011_vcocal_trigger(priv);
+			if (err)
+				return err;
+		}
+		break;
+	case 2:
+		if (vco_cal > 53) {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_1;
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+			err =3D fc0011_vcocal_trigger(priv);
+			if (err)
+				return err;
+		} else {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_2;
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			if (err)
+				return err;
+		}
+		break;
+	}
+	err =3D fc0011_vcocal_read(priv, NULL);
+	if (err)
+		return err;
+	msleep(10);
+
+	err =3D fc0011_readreg(priv, FC11_REG_RCCAL, &regs[FC11_REG_RCCAL]);
+	if (err)
+		return err;
+	regs[FC11_REG_RCCAL] |=3D FC11_RCCAL_FORCE;
+	err =3D fc0011_writereg(priv, FC11_REG_RCCAL, regs[FC11_REG_RCCAL]);
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, FC11_REG_16, 0xB);
+	if (err)
+		return err;
+
+	dev_dbg(&priv->i2c->dev, "Tuned to "
+		"fa=3D%02X fp=3D%02X xin=3D%02X%02X vco=3D%02X vcosel=3D%02X "
+		"vcocal=3D%02X(%u) bw=3D%u\n",
+		(unsigned int)regs[FC11_REG_FA],
+		(unsigned int)regs[FC11_REG_FP],
+		(unsigned int)regs[FC11_REG_XINHI],
+		(unsigned int)regs[FC11_REG_XINLO],
+		(unsigned int)regs[FC11_REG_VCO],
+		(unsigned int)regs[FC11_REG_VCOSEL],
+		(unsigned int)vco_cal, vco_retries,
+		(unsigned int)bandwidth);
+
+	priv->frequency =3D p->frequency;
+	priv->bandwidth =3D p->bandwidth_hz;
+
+	return 0;
+}
+
+static int fc0011_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct fc0011_priv *priv =3D fe->tuner_priv;
+
+	*frequency =3D priv->frequency;
+
+	return 0;
+}
+
+static int fc0011_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	*frequency =3D 0;
+
+	return 0;
+}
+
+static int fc0011_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+	struct fc0011_priv *priv =3D fe->tuner_priv;
+
+	*bandwidth =3D priv->bandwidth;
+
+	return 0;
+}
+
+static const struct dvb_tuner_ops fc0011_tuner_ops =3D {
+	.info =3D {
+		.name		=3D "Fitipower FC0011",
+
+		.frequency_min	=3D 45000000,
+		.frequency_max	=3D 1000000000,
+	},
+
+	.release		=3D fc0011_release,
+	.init			=3D fc0011_init,
+
+	.set_params		=3D fc0011_set_params,
+
+	.get_frequency		=3D fc0011_get_frequency,
+	.get_if_frequency	=3D fc0011_get_if_frequency,
+	.get_bandwidth		=3D fc0011_get_bandwidth,
+};
+
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   const struct fc0011_config *config)
+{
+	struct fc0011_priv *priv;
+
+	priv =3D kzalloc(sizeof(struct fc0011_priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->i2c =3D i2c;
+	priv->addr =3D config->i2c_address;
+
+	fe->tuner_priv =3D priv;
+	fe->ops.tuner_ops =3D fc0011_tuner_ops;
+
+	dev_info(&priv->i2c->dev, "Fitipower FC0011 tuner attached\n");
+
+	return fe;
+}
+EXPORT_SYMBOL(fc0011_attach);
+
+MODULE_DESCRIPTION("Fitipower FC0011 silicon tuner driver");
+MODULE_AUTHOR("Michael Buesch <m@bues.ch>");
+MODULE_LICENSE("GPL");
Index: linux/drivers/media/common/tuners/fc0011.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/media/common/tuners/fc0011.h	2012-04-02 16:00:14.48006708=
3 +0200
@@ -0,0 +1,41 @@
+#ifndef LINUX_FC0011_H_
+#define LINUX_FC0011_H_
+
+#include "dvb_frontend.h"
+
+
+/** struct fc0011_config - fc0011 hardware config
+ *
+ * @i2c_address: I2C bus address.
+ */
+struct fc0011_config {
+	u8 i2c_address;
+};
+
+/** enum fc0011_fe_callback_commands - Frontend callbacks
+ *
+ * @FC0011_FE_CALLBACK_POWER: Power on tuner hardware.
+ * @FC0011_FE_CALLBACK_RESET: Request a tuner reset.
+ */
+enum fc0011_fe_callback_commands {
+	FC0011_FE_CALLBACK_POWER,
+	FC0011_FE_CALLBACK_RESET,
+};
+
+#if defined(CONFIG_MEDIA_TUNER_FC0011) ||\
+    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   const struct fc0011_config *config);
+#else
+static inline
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   const struct fc0011_config *config)
+{
+	dev_err(&i2c->dev, "fc0011 driver disabled in Kconfig\n");
+	return NULL;
+}
+#endif
+
+#endif /* LINUX_FC0011_H_ */
Index: linux/MAINTAINERS
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/MAINTAINERS	2012-04-02 15:55:51.155296579 +0200
+++ linux/MAINTAINERS	2012-04-02 16:00:14.500067443 +0200
@@ -2697,6 +2697,13 @@
 F:	Documentation/hwmon/f71805f
 F:	drivers/hwmon/f71805f.c
=20
+FC0011 TUNER DRIVER
+M:	Michael Buesch <m@bues.ch>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/common/tuners/fc0011.h
+F:	drivers/media/common/tuners/fc0011.c
+
 FANOTIFY
 M:	Eric Paris <eparis@redhat.com>
 S:	Maintained


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/upE1cKfYNrmZEGmdS5CM7DQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPedBoAAoJEPUyvh2QjYsOmDwP/2nBbF1LghXOJ8JdmHo1Q+h5
7i03p1l/NwiURyVY6uRTr4UC0hqQFOJ4LU7EU/61dYmqW2keqsvPb/GtptEXIL3e
+Z6yU/QX5O+cevdCkArTWQlXp4En+AcobBZG9HAXOb9nAYkZiE6la9q8uAj70hP/
sxUM3g2UvRTrhwh4NvhyEx1au9sEKkxQVHehwvx3MhX1lFSlW5R0p5n1Q1FwNGqM
GgDdiXlh9RIXdpfa8OTghoRdq66AlA9v8njQF1vITXeEbBDJKn0zwBcr8mQLc6H9
VveHpvRMiAvy34knsTBlS+wJci8V7TPvxqisK15Jt22tt3B2IOpzHlDUkqtFxm2q
Jn/JGk9CAtKUordtYAy507NiRtP6ZBwM6a1IMDPIC/L+ZpFPcVyjx0og2YYVVmNI
/Pds2PeSBCoX570bXWVoXDI/o3PLMx8b8nAuyECtfUTOvNwiHEk2+XAMfcyxyDAK
HnYcNfbACc75LFLSplCfEnFrtcFDfQ3gMDuMJXuzi2D6NNx9Ifl33qqnAtPc7xuT
o5T0+30vVF1X9S8OAQmGS/v0Kx0bFCufWoJLhhk41oh0LljhVrJ0fp5hE2p6aoFn
NGZte7riEGr1TJFSz3CsSIZgPA+nVC3Fn5t3fnPEu+GqByR33pyZbyltMsvs6oDT
0hCIXJ7CG2d6ngbPzbj0
=fA8+
-----END PGP SIGNATURE-----

--Sig_/upE1cKfYNrmZEGmdS5CM7DQ--
