Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:35132 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab2C2ABs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 20:01:48 -0400
Date: Thu, 29 Mar 2012 02:01:34 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH] Add Fitipower fc0011 tuner driver
Message-ID: <20120329020134.1a18e39e@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HJg5fncX8tjtEOiNQ5+7vvN"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/HJg5fncX8tjtEOiNQ5+7vvN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This adds a driver for the Fitipower fc0011 DVB-t tuner.

Signed-off-by: Michael Buesch <m@bues.ch>

---

The driver is tested with the af903x driver.

Mauro Carvalho Chehab, I'm actually aiming on getting this driver
merged into the media-tree now.

Hans-Frieder Vogt, what are your plans on getting af903x merged?
As the driver does actually work, we should focus on merging it ASAP.
That would help further development a _lot_.


Index: linux/drivers/media/common/tuners/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/common/tuners/Kconfig	2012-02-28 14:26:19.0000=
00000 +0100
+++ linux/drivers/media/common/tuners/Kconfig	2012-03-28 23:53:55.942050978=
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
--- linux.orig/drivers/media/common/tuners/Makefile	2012-03-28 23:51:43.000=
000000 +0200
+++ linux/drivers/media/common/tuners/Makefile	2012-03-28 23:55:08.83831520=
2 +0200
@@ -28,6 +28,7 @@
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) +=3D max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) +=3D tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) +=3D tda18212.o
+obj-$(CONFIG_MEDIA_TUNER_FC0011) +=3D fc0011.o
=20
 ccflags-y +=3D -I$(srctree)/drivers/media/dvb/dvb-core
 ccflags-y +=3D -I$(srctree)/drivers/media/dvb/frontends
Index: linux/drivers/media/common/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/media/common/tuners/fc0011.c	2012-03-28 23:53:42.66200481=
2 +0200
@@ -0,0 +1,495 @@
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
+	FC11_REG_7,		/* Unknown tune reg 7 */
+	FC11_REG_8,		/* Unknown tune reg 8 */
+	FC11_REG_9,
+	FC11_REG_10,		/* Unknown tune reg 10 */
+	FC11_REG_11,		/* Unknown tune reg 11 */
+	FC11_REG_12,
+	FC11_REG_RCCAL,		/* RC calibrate */
+	FC11_REG_VCOCAL,	/* VCO calibrate */
+	FC11_REG_15,
+	FC11_REG_16,		/* Unknown tune reg 16 */
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
+
+	int (*tuner_reset)(unsigned long, unsigned long);
+	unsigned long tuner_reset_arg0;
+	unsigned long tuner_reset_arg1;
+};
+
+
+static int fc0011_writereg(struct fc0011_priv *priv, u8 reg, u8 val)
+{
+	u8 buf[2] =3D { reg, val };
+	struct i2c_msg msg =3D { .addr =3D priv->addr,
+		.flags =3D 0, .buf =3D buf, .len =3D 2 };
+
+	msleep(1);
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
+	struct i2c_msg msg[2] =3D {
+		{ .addr =3D priv->addr,
+		  .flags =3D 0, .buf =3D &reg, .len =3D 1 },
+		{ .addr =3D priv->addr,
+		  .flags =3D I2C_M_RD, .buf =3D val, .len =3D 1 },
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
+	/* nothing to do here */
+	return 0;
+}
+
+static int fc0011_sleep(struct dvb_frontend *fe)
+{
+	/* nothing to do here */
+	return 0;
+}
+
+static int fc0011_set_params(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p =3D &fe->dtv_property_cache;
+	struct fc0011_priv *priv =3D fe->tuner_priv;
+	int err;
+	unsigned int i;
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
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RESET);
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+	if (err)
+		return err;
+	/* Read calib val */
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+	if (err)
+		return err;
+	msleep(10);
+	err =3D fc0011_readreg(priv, FC11_REG_VCOCAL, &vco_cal);
+	if (err)
+		return err;
+	if (!(vco_cal & FC11_VCOCAL_OK)) {
+		/* Reset the tuner and try again */
+		err =3D priv->tuner_reset(priv->tuner_reset_arg0,
+					priv->tuner_reset_arg1);
+		if (err)
+			return -EIO;
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
+		err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RESET);
+		if (err)
+			return err;
+		err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+		if (err)
+			return err;
+		/* Read calib val */
+		err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+		if (err)
+			return err;
+		msleep(10);
+		err =3D fc0011_readreg(priv, FC11_REG_VCOCAL, &vco_cal);
+		if (err)
+			return err;
+	}
+	if (!(vco_cal & FC11_VCOCAL_OK)) {
+		dev_err(&priv->i2c->dev, "Failed to read VCO calibration value\n");
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
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RESET);
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RUN);
+			if (err)
+				return -EIO;
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
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RESET);
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RUN);
+			if (err)
+				return -EIO;
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
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RESET);
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RUN);
+			if (err)
+				return -EIO;
+		}
+		break;
+	case 2:
+		if (vco_cal > 53) {
+			regs[FC11_REG_VCOSEL] &=3D ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
+			regs[FC11_REG_VCOSEL] |=3D FC11_VCOSEL_1;
+			err =3D fc0011_writereg(priv, FC11_REG_VCOSEL,
+					      regs[FC11_REG_VCOSEL]);
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RESET);
+			err |=3D fc0011_writereg(priv, FC11_REG_VCOCAL,
+					       FC11_VCOCAL_RUN);
+			if (err)
+				return -EIO;
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
+	err =3D fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
+	if (err)
+		return err;
+	msleep(10);
+	err =3D fc0011_readreg(priv, FC11_REG_VCOCAL, &vco_cal);
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
+
+	.init			=3D fc0011_init,
+	.sleep			=3D fc0011_sleep,
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
+				   u8 i2c_address,
+				   int (*tuner_reset)(unsigned long, unsigned long),
+				   unsigned long tuner_reset_arg0,
+				   unsigned long tuner_reset_arg1)
+{
+	struct fc0011_priv *priv;
+
+	priv =3D kzalloc(sizeof(struct fc0011_priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->i2c =3D i2c;
+	priv->addr =3D i2c_address;
+	priv->tuner_reset =3D tuner_reset;
+	priv->tuner_reset_arg0 =3D tuner_reset_arg0;
+	priv->tuner_reset_arg1 =3D tuner_reset_arg1;
+	WARN_ON(!tuner_reset);
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
+++ linux/drivers/media/common/tuners/fc0011.h	2012-03-28 23:53:42.66600483=
0 +0200
@@ -0,0 +1,28 @@
+#ifndef LINUX_FC0011_H_
+#define LINUX_FC0011_H_
+
+#include "dvb_frontend.h"
+
+#if defined(CONFIG_MEDIA_TUNER_FC0011) ||\
+    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   u8 i2c_address,
+				   int (*tuner_reset)(unsigned long, unsigned long),
+				   unsigned long tuner_reset_arg0,
+				   unsigned long tuner_reset_arg1);
+#else
+static inline
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   u8 i2c_address,
+				   int (*tuner_reset)(unsigned long, unsigned long),
+				   unsigned long tuner_reset_arg0,
+				   unsigned long tuner_reset_arg1)
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
--- linux.orig/MAINTAINERS	2012-03-28 23:52:44.000000000 +0200
+++ linux/MAINTAINERS	2012-03-28 23:53:42.670004864 +0200
@@ -2692,6 +2692,13 @@
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

--Sig_/HJg5fncX8tjtEOiNQ5+7vvN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPc6ZeAAoJEPUyvh2QjYsO3SkP/3dOCXk6f+V687xsMMrmmbHM
6b/qUHt16yteMW1lUMOvkzcG4mMWL1HAn8pnFDU93Y4vnaTtCnv9qmihXJMF8M13
4yhS4LSlkbZEWLe/7JnqTiQP1sepL9EMzNPPjwipB2FVKnVhouGBPCCEGEQ6+RX/
JGLyDdWSDlrETj2NMacZUTSop9m3z1RGtmQBq0m7RzVGLHTyVOsRhVJR2NNs526u
Z2OO+btheCjBjJAqiXOdGQ8C0XsMsQULaMC6bGtWaQI7f6M8pqJfqYmwL8EJa8nR
LnHiz5wPuNkTmqwzQL68+Al9V+AkJdeTHRN7U+iViJh9FkXUmbpMvALHtJSoh99x
RYKTpeVsPqP0K6R6KFLavbewMvsOVHnd9CcK9tkJL96nM0TEpI+p2OVjsoAZoiJZ
Sn0FM2ifmR0w3xeev+Ktr6M04K2x1ODjsU0+T9z6MOqfqb+7JAdk2zrX/CfKSBBt
tISQ5XZn3TH++AZ39LS7vs9eJsVcuS0Zljj9fbVMU/wlxAJUH5F5m6dncz7Ka5nN
P6NDW1CBzWJw23IvasrkXAUBMm6CjWoPrrE5PZ4RphJ6m2ltq1EqebjJp1oofgmA
vL2Z+1zocyomsCGkBFrxMH8qQAWBBRQCgHCVOPdURW+5ED6Map/GTIIfX/o99PSO
wiJvLdOUbF0eq6Uc3naj
=/wAU
-----END PGP SIGNATURE-----

--Sig_/HJg5fncX8tjtEOiNQ5+7vvN--
