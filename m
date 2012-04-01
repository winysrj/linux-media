Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42321 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab2DANMF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 09:12:05 -0400
Date: Sun, 1 Apr 2012 15:11:53 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Daniel =?UTF-8?B?R2zDtmNrbmVy?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401151153.637d2393@milhouse>
In-Reply-To: <4F784A13.5000704@iki.fi>
References: <4F75A7FE.8090405@iki.fi>
	<20120330234545.45f4e2e8@milhouse>
	<4F762CF5.9010303@iki.fi>
	<20120331001458.33f12d82@milhouse>
	<20120331160445.71cd1e78@milhouse>
	<4F771496.8080305@iki.fi>
	<20120331182925.3b85d2bc@milhouse>
	<4F77320F.8050009@iki.fi>
	<4F773562.6010008@iki.fi>
	<20120331185217.2c82c4ad@milhouse>
	<4F77DED5.2040103@iki.fi>
	<20120401103315.1149d6bf@milhouse>
	<20120401141940.04e5220c@milhouse>
	<4F784A13.5000704@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OYtCTzW5qJNqHL8KQyD=6N6"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/OYtCTzW5qJNqHL8KQyD=6N6
Content-Type: multipart/mixed; boundary="MP_/wSxREMjY.xjszLiBumu.Xqv"

--MP_/wSxREMjY.xjszLiBumu.Xqv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, 01 Apr 2012 15:29:07 +0300
Antti Palosaari <crope@iki.fi> wrote:
> buf[1] =3D msg[0].addr << 1;
> Maybe you have given I2C address as a "8bit" format?

Uhh, the address is leftshifted by one.
So I changed the i2c address from 0xC0 to 0x60.

The i2c write seems to work now. At least it doesn't complain anymore
and it sorta seems to tune to the right frequency.
But i2c read may be broken.
I had to enable the commented read code, but it still fails to read
the VCO calibration value:

[ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)

It doesn't run into this check on the other af903x driver.
So I suspect an i2c read issue here.

Attached: The patches.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--MP_/wSxREMjY.xjszLiBumu.Xqv
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=fc0011-tuner.patch

Index: linux/drivers/media/common/tuners/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/common/tuners/Kconfig	2012-04-01 11:42:36.5395=
32984 +0200
+++ linux/drivers/media/common/tuners/Kconfig	2012-04-01 11:42:38.803572117=
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
--- linux.orig/drivers/media/common/tuners/Makefile	2012-04-01 11:42:36.539=
532984 +0200
+++ linux/drivers/media/common/tuners/Makefile	2012-04-01 11:42:38.80357211=
7 +0200
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
+++ linux/drivers/media/common/tuners/fc0011.c	2012-04-01 14:49:08.04638266=
1 +0200
@@ -0,0 +1,491 @@
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
+	struct fc0011_priv *priv =3D fe->tuner_priv;
+	int err;
+
+	if (WARN_ON(!fe->callback))
+		return -EINVAL;
+	err =3D fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+			   FC0011_FE_CALLBACK_POWER, 0);
+	if (err) {
+		dev_err(&priv->i2c->dev, "power-on callback failed\n");
+		return err;
+	}
+
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
+		err =3D fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
+				   FC0011_FE_CALLBACK_RESET, 0);
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
+		dev_err(&priv->i2c->dev,
+			"Failed to read VCO calibration value (got %02X)\n",
+			(unsigned int)(u8)vco_cal);
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
+++ linux/drivers/media/common/tuners/fc0011.h	2012-04-01 11:42:38.80757218=
5 +0200
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
--- linux.orig/MAINTAINERS	2012-04-01 11:42:36.539532984 +0200
+++ linux/MAINTAINERS	2012-04-01 11:42:38.819572398 +0200
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

--MP_/wSxREMjY.xjszLiBumu.Xqv
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=af9035-add-fc0011-tuner.patch

Index: linux/drivers/media/dvb/dvb-usb/af9035.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 11:42:38.86757=
3221 +0200
+++ linux/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 14:44:20.848955668 =
+0200
@@ -22,6 +22,7 @@
 #include "af9035.h"
 #include "af9033.h"
 #include "tua9001.h"
+#include "fc0011.h"
=20
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static DEFINE_MUTEX(af9035_usb_mutex);
@@ -209,12 +210,6 @@
 					msg[1].len);
 		} else {
 			/* I2C */
-#if 0
-			/*
-			 * FIXME: Keep that code. It should work but as it is
-			 * not tested I left it disabled and return -EOPNOTSUPP
-			 * for the sure.
-			 */
 			u8 buf[4 + msg[0].len];
 			struct usb_req req =3D { CMD_I2C_RD, 0, sizeof(buf),
 					buf, msg[1].len, msg[1].buf };
@@ -224,9 +219,6 @@
 			buf[3] =3D 0x00;
 			memcpy(&buf[4], msg[0].buf, msg[0].len);
 			ret =3D af9035_ctrl_msg(d->udev, &req);
-#endif
-			pr_debug("%s: I2C operation not supported\n", __func__);
-			ret =3D -EOPNOTSUPP;
 		}
 	} else if (num =3D=3D 1 && !(msg[0].flags & I2C_M_RD)) {
 		if (msg[0].len > 40) {
@@ -480,6 +472,7 @@
=20
 		switch (tmp) {
 		case AF9033_TUNER_TUA9001:
+		case AF9033_TUNER_FC0011:
 			af9035_af9033_config[i].spec_inv =3D 1;
 			break;
 		default:
@@ -524,6 +517,83 @@
 	return ret;
 }
=20
+static int af9035_fc0011_tuner_callback(struct dvb_usb_device *d,
+					int cmd, int arg)
+{
+	int err;
+
+	switch (cmd) {
+	case FC0011_FE_CALLBACK_POWER:
+		/* Tuner enable */
+		err =3D af9035_wr_reg_mask(d, 0xd8eb, 1, 1);
+		if (err)
+			return err;
+		err =3D af9035_wr_reg_mask(d, 0xd8ec, 1, 1);
+		if (err)
+			return err;
+		err =3D af9035_wr_reg_mask(d, 0xd8ed, 1, 1);
+		if (err)
+			return err;
+		/* LED */
+		err =3D af9035_wr_reg_mask(d, 0xd8d0, 1, 1);
+		if (err)
+			return err;
+		err =3D af9035_wr_reg_mask(d, 0xd8d1, 1, 1);
+		if (err)
+			return err;
+		msleep(10);
+		break;
+	case FC0011_FE_CALLBACK_RESET:
+		err =3D af9035_wr_reg(d, 0xd8e9, 1);
+		if (err)
+			return err;
+		err =3D af9035_wr_reg(d, 0xd8e8, 1);
+		if (err)
+			return err;
+		err =3D af9035_wr_reg(d, 0xd8e7, 1);
+		if (err)
+			return err;
+		msleep(10);
+		err =3D af9035_wr_reg(d, 0xd8e7, 0);
+		if (err)
+			return err;
+		msleep(10);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int af9035_tuner_callback(struct dvb_usb_device *d, int cmd, int ar=
g)
+{
+	switch (af9035_af9033_config[0].tuner) {
+	case AF9033_TUNER_FC0011:
+		return af9035_fc0011_tuner_callback(d, cmd, arg);
+	default:
+		break;
+	}
+
+	return -ENODEV;
+}
+
+static int af9035_frontend_callback(void *adapter_priv, int component,
+				    int cmd, int arg)
+{
+	struct i2c_adapter *adap =3D adapter_priv;
+	struct dvb_usb_device *d =3D i2c_get_adapdata(adap);
+
+	switch (component) {
+	case DVB_FRONTEND_COMPONENT_TUNER:
+		return af9035_tuner_callback(d, cmd, arg);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -552,6 +622,7 @@
 		ret =3D -ENODEV;
 		goto err;
 	}
+	adap->fe_adap[0].fe->callback =3D af9035_frontend_callback;
=20
 	return 0;
=20
@@ -565,6 +636,10 @@
 	.i2c_addr =3D 0x60,
 };
=20
+static const struct fc0011_config af9035_fc0011_config =3D {
+	.i2c_address =3D 0x60,
+};
+
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -613,6 +688,10 @@
 		fe =3D dvb_attach(tua9001_attach, adap->fe_adap[0].fe,
 				&adap->dev->i2c_adap, &af9035_tua9001_config);
 		break;
+	case AF9033_TUNER_FC0011:
+		fe =3D dvb_attach(fc0011_attach, adap->fe_adap[0].fe,
+				&adap->dev->i2c_adap, &af9035_fc0011_config);
+		break;
 	default:
 		fe =3D NULL;
 	}
Index: linux/drivers/media/dvb/frontends/af9033.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/frontends/af9033.c	2012-04-01 11:42:36.147=
526208 +0200
+++ linux/drivers/media/dvb/frontends/af9033.c	2012-04-01 11:42:38.91957412=
0 +0200
@@ -297,6 +297,10 @@
 		len =3D ARRAY_SIZE(tuner_init_tua9001);
 		init =3D tuner_init_tua9001;
 		break;
+	case AF9033_TUNER_FC0011:
+		len =3D ARRAY_SIZE(tuner_init_fc0011);
+		init =3D tuner_init_fc0011;
+		break;
 	default:
 		pr_debug("%s: unsupported tuner ID=3D%d\n", __func__,
 				state->cfg.tuner);
Index: linux/drivers/media/dvb/frontends/af9033_priv.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/frontends/af9033_priv.h	2012-04-01 11:42:3=
6.147526208 +0200
+++ linux/drivers/media/dvb/frontends/af9033_priv.h	2012-04-01 11:42:38.919=
574120 +0200
@@ -238,5 +238,66 @@
 	{ 0x80f1e6, 0x00 },
 };
=20
+/* Fitipower fc0011 tuner init
+   AF9033_TUNER_FC0011    =3D 0x28 */
+static const struct reg_val tuner_init_fc0011[] =3D {
+	{ 0x800046, AF9033_TUNER_FC0011 },
+	{ 0x800057, 0x00 },
+	{ 0x800058, 0x01 },
+	{ 0x80005f, 0x00 },
+	{ 0x800060, 0x00 },
+	{ 0x800068, 0xa5 },
+	{ 0x80006e, 0x01 },
+	{ 0x800071, 0x0A },
+	{ 0x800072, 0x02 },
+	{ 0x800074, 0x01 },
+	{ 0x800079, 0x01 },
+	{ 0x800093, 0x00 },
+	{ 0x800094, 0x00 },
+	{ 0x800095, 0x00 },
+	{ 0x800096, 0x00 },
+	{ 0x80009b, 0x2D },
+	{ 0x80009c, 0x60 },
+	{ 0x80009d, 0x23 },
+	{ 0x8000a4, 0x50 },
+	{ 0x8000ad, 0x50 },
+	{ 0x8000b3, 0x01 },
+	{ 0x8000b7, 0x88 },
+	{ 0x8000b8, 0xa6 },
+	{ 0x8000c3, 0x01 },
+	{ 0x8000c4, 0x01 },
+	{ 0x8000c7, 0x69 },
+	{ 0x80F007, 0x00 },
+	{ 0x80F00A, 0x1B },
+	{ 0x80F00B, 0x1B },
+	{ 0x80F00C, 0x1B },
+	{ 0x80F00D, 0x1B },
+	{ 0x80F00E, 0xFF },
+	{ 0x80F00F, 0x01 },
+	{ 0x80F010, 0x00 },
+	{ 0x80F011, 0x02 },
+	{ 0x80F012, 0xFF },
+	{ 0x80F013, 0x01 },
+	{ 0x80F014, 0x00 },
+	{ 0x80F015, 0x02 },
+	{ 0x80F01B, 0xEF },
+	{ 0x80F01C, 0x01 },
+	{ 0x80F01D, 0x0f },
+	{ 0x80F01E, 0x02 },
+	{ 0x80F01F, 0x6E },
+	{ 0x80F020, 0x00 },
+	{ 0x80F025, 0xDE },
+	{ 0x80F026, 0x00 },
+	{ 0x80F027, 0x0A },
+	{ 0x80F028, 0x03 },
+	{ 0x80F029, 0x6E },
+	{ 0x80F02A, 0x00 },
+	{ 0x80F047, 0x00 },
+	{ 0x80F054, 0x00 },
+	{ 0x80F055, 0x00 },
+	{ 0x80F077, 0x01 },
+	{ 0x80F1E6, 0x00 },
+};
+
 #endif /* AF9033_PRIV_H */
=20

--MP_/wSxREMjY.xjszLiBumu.Xqv--

--Sig_/OYtCTzW5qJNqHL8KQyD=6N6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeFQZAAoJEPUyvh2QjYsOuVsQALV+avcOSEvbgqEoPSYj8Ao7
xFfBquXelak+rlxuHoDRJu+QA/in5qAJ+azKLPSmZjRQSX65lM2/CKz2fMat3mdm
w/+cTskCWcOY+4NCsEPm75ZCDMh4K0YxOPYap5ftONAraiRN9lOLaYQ/wVxkU6O8
SqRGacnhvQm26YEHRfCVs7XrofG6axvSOIRrBqV650159GPnDemj3tUFFxYkXXOr
AWXZ6R14TubNR3yb/1IaPoeSENvpxmP9+IVJiXIEhp3PnatQ9ZCvwHGpTPTN5QVP
THmqHKZBOPrRXlKFJWUEiylvF398T/eDDYR3Daq1uwzAT3jMR/17jTYtQR4J5kzW
02TPEKaut7FHmRqctVtb1BOs3OGsuEhGLvJQGzismbn4ci8vD+xn3gQYRJNUW79r
UnHwRzhUbVMsFVTsA4X0EUVDUjqpEfnAHHtvtRSoJdN6rTR6wmDw9zEobSU7/SAu
IpfTtHwtEVz2pwcsaoj5ZyS1QOveij7ORJYiyIYCSvgnx8TSSlOX4oLpox3LJV5v
w2YWJbrRK23m1h9FU1uwqNG2tTZKA8eFL3SSHr3lRspzi/7n2KGS3U72er8TPqzR
XIOJAY9iCkmvjLVOqpS0PqfLz+b3QZh8JPKPSTWowRaoa3ZPOmDGIDwABFM853tB
DYxp6I96X3DL5zaH6vcv
=+6xU
-----END PGP SIGNATURE-----

--Sig_/OYtCTzW5qJNqHL8KQyD=6N6--
