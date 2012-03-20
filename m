Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50248 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab2CTVoz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 17:44:55 -0400
Date: Tue, 20 Mar 2012 22:44:38 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hans-Frieder Vogt <hfvogt@gmx.net>
Cc: gennarone@gmail.com, linux-media@vger.kernel.org,
	Benjamin Larsson <benjamin@southpole.se>
Subject: Add fc0011 tuner support (was: [PATCH 2/3] Basic AF9035/AF9033
 driver)
Message-ID: <20120320224438.73ac5d5c@milhouse>
In-Reply-To: <20120320183250.504fcced@milhouse>
References: <201202222321.43972.hfvogt@gmx.net>
 <4F67CF24.8050601@redhat.com>
 <20120320140411.58b5808b@milhouse>
 <4F68B001.1050809@gmail.com>
 <20120320173724.4d3f2f0f@milhouse>
 <4F68B52F.4040405@gmail.com>
 <20120320183250.504fcced@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3GhXkwshnKAmLi7jsiZXfhK"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/3GhXkwshnKAmLi7jsiZXfhK
Content-Type: multipart/mixed; boundary="MP_/TtmkonfdO.afpSLqDIRN3lA"

--MP_/TtmkonfdO.afpSLqDIRN3lA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Okay, here we go. These patches apply on top of the latest
af903x by Hans-Frieder Vogt. This adds support for the fc0011
tuner, which is used on a "cabstone" stick. (Its USB-id is already
in af903x's list).

I did some _very_ basic testing on this stuff and it basically seems to
work more or less.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Two patches for review and testing follow (inline for commenting and attach=
ed).
(Yes, the '#if 0' sections are going to be removed. I'm currently
testing on a 3.2 kernel, so I need them for now.)

---

Index: linux-source-3.2/drivers/media/common/tuners/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/common/tuners/Kconfig	2012-03-20 20=
:34:00.938801738 +0100
+++ linux-source-3.2/drivers/media/common/tuners/Kconfig	2012-03-20 20:34:0=
0.986802601 +0100
@@ -204,6 +204,13 @@
 	help
 	  NXP TDA18212 silicon tuner driver.
=20
+config MEDIA_TUNER_FC0011
+	tristate "Fitipower FC0011 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  Fitipower FC0011 silicon tuner driver.
+
 config MEDIA_TUNER_FC0012
 	tristate "Fitipower FC0012 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
Index: linux-source-3.2/drivers/media/common/tuners/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/common/tuners/Makefile	2012-03-20 2=
0:34:00.942801805 +0100
+++ linux-source-3.2/drivers/media/common/tuners/Makefile	2012-03-20 20:34:=
00.986802601 +0100
@@ -27,6 +27,7 @@
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) +=3D max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) +=3D tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) +=3D tda18212.o
+obj-$(CONFIG_MEDIA_TUNER_FC0011) +=3D fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) +=3D fc0012.o
=20
 ccflags-y +=3D -Idrivers/media/dvb/dvb-core
Index: linux-source-3.2/drivers/media/common/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-source-3.2/drivers/media/common/tuners/fc0011.c	2012-03-20 22:28:=
54.132458133 +0100
@@ -0,0 +1,386 @@
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
+struct fc0011_priv {
+        struct i2c_adapter *i2c;
+	u8 addr;
+
+        u32 frequency;
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
+#if 0 //TODO 3.3
+static int fc0011_set_params(struct dvb_frontend *fe)
+#else
+static int fc0011_set_params(struct dvb_frontend *fe,
+        struct dvb_frontend_parameters *params)
+#endif
+{
+        struct fc0011_priv *priv =3D fe->tuner_priv;
+	int err;
+	unsigned int i;
+#if 0 //TODO 3.3
+	struct dtv_frontend_properties *p =3D &fe->dtv_property_cache;
+	u32 freq =3D p->frequency / 1000;
+	u32 delsys =3D p->delivery_system;
+	u32 bandwidth =3D p->bandwidth_hz / 1000;
+#else
+	u32 freq =3D params->frequency / 1000;
+	u32 bandwidth =3D params->u.ofdm.bandwidth / 1000;
+#endif
+	u32 fvco, xin, xdiv, xdivr, fa;
+	u16 frac;
+	u8 fp, vco_sel, vco_cal;
+	u8 regs[14] =3D { };
+
+	err =3D fc0011_writereg(priv, 7, 0x0F);
+	err |=3D fc0011_writereg(priv, 8, 0x3E);
+	err |=3D fc0011_writereg(priv, 10, 0xB8);
+	err |=3D fc0011_writereg(priv, 11, 0x80);
+	err |=3D fc0011_writereg(priv, 13, 0x04);
+	if (err)
+		return -EIO;
+
+	/* Set VCO freq and VCO div */
+	if (freq < 54000) {
+		fvco =3D freq * 64;
+		regs[5] =3D 0x82;
+	} else if (freq < 108000) {
+		fvco =3D freq * 32;
+		regs[5] =3D 0x42;
+	} else if (freq < 216000) {
+		fvco =3D freq * 16;
+		regs[5] =3D 0x22;
+	} else if (freq < 432000) {
+		fvco =3D freq * 8;
+		regs[5] =3D 0x12;
+	} else {
+		fvco =3D freq * 4;
+		regs[5] =3D 0x0A;
+	}
+
+	/* Calc XIN */
+	xdiv =3D fvco / 18000;
+	frac =3D fvco - xdiv * 18000;
+	frac =3D (frac << 15) / 18000;
+	if (frac >=3D 16384)
+		frac +=3D 32786;
+	if (!frac)
+		xin =3D 0;
+	else if (frac < 511)
+		xin =3D 0x200;
+	else if (frac < 65025)
+		xin =3D frac;
+	else
+		xin =3D 0xFE00;
+	regs[3] =3D xin >> 8;
+	regs[4] =3D xin;
+	err =3D fc0011_writereg(priv, 3, regs[3]);
+	err |=3D fc0011_writereg(priv, 4, regs[4]);
+	if (err)
+		return -EIO;
+
+	/* Calc FP and FA */
+	xdivr =3D xdiv;
+	if (fvco - xdiv * 18000 >=3D 9000)
+		xdivr =3D xdiv + 1;
+	fp =3D xdivr / 8;
+	fa =3D xdivr - fp * 8;
+	if (fa < 2) {
+		fp -=3D 1;
+		fa +=3D 8;
+	}
+	regs[1] =3D fa;
+	regs[2] =3D fp;
+	err =3D fc0011_writereg(priv, 1, regs[1]);
+	err |=3D fc0011_writereg(priv, 2, regs[2]);
+	if (err)
+		return -EIO;
+
+	/* Select bandwidth */
+	switch (bandwidth) {
+	default:
+	case 8000:
+		regs[6] =3D 0;
+		break;
+	case 7000:
+		regs[6] =3D 0x40;
+		break;
+	case 6000:
+		regs[6] =3D 0x80;
+		break;
+	}
+
+	/* Pre VCO select */
+	if (fvco < 2320000) {
+		vco_sel =3D 0;
+		regs[6] &=3D 0xE7;
+	} else if (fvco < 3080000) {
+		vco_sel =3D 1;
+		regs[6] |=3D 0x10;
+	} else {
+		vco_sel =3D 2;//FIXME?
+		regs[6] |=3D 0x8;
+	}
+
+	/* Fix for low freqs */
+	if (freq < 45000) {
+		regs[1] =3D 0x6;
+		regs[2] =3D 0x11;
+	}
+
+	/* Clock out fix */
+	regs[6] |=3D 0x20;
+
+	/* Write the cached registers */
+	for (i =3D 1; i < 7; i++) {
+		err =3D fc0011_writereg(priv, i, regs[i]);
+		if (err)
+			return err;
+	}
+
+	/* VCO calibration */
+	err =3D fc0011_writereg(priv, 14, 0x80); /* reset */
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, 14, 0); /* run */
+	if (err)
+		return err;
+	/* Read calib val */
+	err =3D fc0011_writereg(priv, 14, 0);
+	if (err)
+		return err;
+	msleep(10);
+	err =3D fc0011_readreg(priv, 14, &vco_cal);
+	if (err)
+		return err;
+	vco_cal &=3D 0x3F;
+
+	switch (vco_sel) {
+	case 0:
+		if (vco_cal < 8) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x10 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			err |=3D fc0011_writereg(priv, 14, 0x80);
+			err |=3D fc0011_writereg(priv, 14, 0);
+			if (err)
+				return -EIO;
+		} else {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		}
+		break;
+	case 1:
+		if (vco_cal < 5) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x8 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		} else if (vco_cal < 48) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x10 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		} else {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			err |=3D fc0011_writereg(priv, 14, 0x80);
+			err |=3D fc0011_writereg(priv, 14, 0);
+			if (err)
+				return -EIO;
+		}
+		break;
+	case 2:
+		if (vco_cal > 53) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x10 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			err |=3D fc0011_writereg(priv, 14, 0x80);
+			err |=3D fc0011_writereg(priv, 14, 0);
+			if (err)
+				return -EIO;
+		} else {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x8 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		}
+		break;
+	}
+	msleep(10);
+
+	err =3D fc0011_readreg(priv, 13, &regs[13]);
+	if (err)
+		return err;
+	regs[13] |=3D 0x10;
+	err =3D fc0011_writereg(priv, 13, regs[13]);
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, 16, 0xB);
+	if (err)
+		return err;
+
+	priv->frequency =3D freq * 1000;
+	priv->bandwidth =3D bandwidth * 1000;
+
+	return 0;
+}
+
+static int fc0011_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+        struct fc0011_priv *priv =3D fe->tuner_priv;
+
+        *frequency =3D priv->frequency;
+
+        return 0;
+}
+
+static int fc0011_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+        *frequency =3D 0;
+        return 0;
+}
+
+static int fc0011_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+        struct fc0011_priv *priv =3D fe->tuner_priv;
+
+        *bandwidth =3D priv->bandwidth;
+
+        return 0;
+}
+
+static const struct dvb_tuner_ops fc0011_tuner_ops =3D {
+	.info =3D {
+		.name		=3D "Fitipower FC0011",
+
+		.frequency_min	=3D 170000000, //FIXME?
+		.frequency_max	=3D 860000000, //FIXME?
+		.frequency_step	=3D 0,
+        },
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
+struct dvb_frontend * fc0011_attach(struct dvb_frontend *fe,
+				    struct i2c_adapter *i2c,
+				    u8 i2c_address)
+{
+        struct fc0011_priv *priv =3D NULL;
+
+	priv =3D kzalloc(sizeof(struct fc0011_priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->i2c =3D i2c;
+	priv->addr =3D i2c_address;
+
+	dev_info(&priv->i2c->dev, "Fitipower FC0011 attached\n");
+
+	fe->tuner_priv =3D priv;
+
+	memcpy(&fe->ops.tuner_ops, &fc0011_tuner_ops,
+	       sizeof(struct dvb_tuner_ops));
+
+	return fe;
+}
+EXPORT_SYMBOL(fc0011_attach);
+
+MODULE_DESCRIPTION("Fitipower FC0011 silicon tuner driver");
+MODULE_AUTHOR("Michael Buesch <m@bues.ch>");
+MODULE_LICENSE("GPL");
Index: linux-source-3.2/drivers/media/common/tuners/fc0011.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-source-3.2/drivers/media/common/tuners/fc0011.h	2012-03-20 20:34:=
00.990802668 +0100
@@ -0,0 +1,22 @@
+#ifndef LINUX_FC0011_H_
+#define LINUX_FC0011_H_
+
+#include "dvb_frontend.h"
+
+#if defined(CONFIG_MEDIA_TUNER_FC0011) ||\
+    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   u8 i2c_address);
+#else
+static inline
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   u8 i2c_address)
+{
+	dev_err(&i2c->dev, "Driver disabled in Kconfig\n");
+	return NULL;
+}
+#endif
+
+#endif /* LINUX_FC0011_H_ */




Index: linux-source-3.2/drivers/media/dvb/dvb-usb/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/Kconfig	2012-03-20 22:2=
7:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/Kconfig	2012-03-20 22:29:13.=
124801711 +0100
@@ -342,6 +342,7 @@
 config DVB_USB_AF903X
 	tristate "Afatech AF903X DVB-T USB2.0 support"
 	depends on DVB_USB && EXPERIMENTAL
+	select MEDIA_TUNER_FC0011   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_FC0012   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
 	help
Index: linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-devices.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-0=
3-20 22:27:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-03-20 =
22:29:13.128801781 +0100
@@ -260,6 +260,7 @@
 }
=20
 extern struct tuner_desc tuner_af9007;
+extern struct tuner_desc tuner_fc0011;
 extern struct tuner_desc tuner_fc0012;
 extern struct tuner_desc tuner_mxl5007t;
=20
@@ -273,6 +274,9 @@
 	case TUNER_AF9007:
 		ctx->tuner_desc =3D &tuner_af9007;
 		break;
+	case TUNER_FC0011:
+		ctx->tuner_desc =3D &tuner_fc0011;
+		break;
 	case TUNER_FC0012:
 		ctx->tuner_desc =3D &tuner_fc0012;
 		break;
Index: linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-fe.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-20 =
22:27:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-20 22:29=
:13.132801864 +0100
@@ -28,6 +28,7 @@
 #include "af903x-fe.h"
 #include "af903x-fe-priv.h"
 #include "dvb_frontend.h"
+#include "fc0011.h"
 #include "fc0012.h"
 #include "mxl5007t.h"
=20
@@ -1990,6 +1991,12 @@
 	switch(ctx->tuner_desc->tunerId) {
 	case TUNER_AF9007:
 		break;
+	case TUNER_FC0011:
+		ret =3D dvb_attach(fc0011_attach, frontend, i2c_adap,
+			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
+			ctx->tuner_desc->tuner_addr + 1)
+			=3D=3D NULL ?  -ENODEV : 0;
+		break;
 	case TUNER_FC0012:
 		ret =3D dvb_attach(fc0012_attach, frontend, i2c_adap,
 			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
Index: linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-tuners.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03=
-20 22:27:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03-20 2=
2:29:13.136801932 +0100
@@ -189,6 +189,69 @@
 	{0xf1e6, 0x00},
 };
=20
+static u16 fc0011_script_sets[] =3D {
+	0x38,
+};
+
+static struct af903x_val_set fc0011_scripts[] =3D {
+	{0x0046, 0x28}, /* TUNER_ID */
+	{0x0057, 0x00},
+	{0x0058, 0x01},
+	{0x005f, 0x00},
+	{0x0060, 0x00},
+	{0x0068, 0xa5},
+	{0x006e, 0x01},
+	{0x0071, 0x0A},
+	{0x0072, 0x02},
+	{0x0074, 0x01},
+	{0x0079, 0x01},
+	{0x0093, 0x00},
+	{0x0094, 0x00},
+	{0x0095, 0x00},
+	{0x0096, 0x00},
+	{0x009b, 0x2D},
+	{0x009c, 0x60},
+	{0x009d, 0x23},
+	{0x00a4, 0x50},
+	{0x00ad, 0x50},
+	{0x00b3, 0x01},
+	{0x00b7, 0x88},
+	{0x00b8, 0xa6},
+	{0x00c3, 0x01},
+	{0x00c4, 0x01},
+	{0x00c7, 0x69},
+	{0xF007, 0x00},
+	{0xF00A, 0x1B},
+	{0xF00B, 0x1B},
+	{0xF00C, 0x1B},
+	{0xF00D, 0x1B},
+	{0xF00E, 0xFF},
+	{0xF00F, 0x01},
+	{0xF010, 0x00},
+	{0xF011, 0x02},
+	{0xF012, 0xFF},
+	{0xF013, 0x01},
+	{0xF014, 0x00},
+	{0xF015, 0x02},
+	{0xF01B, 0xEF},
+	{0xF01C, 0x01},
+	{0xF01D, 0x0f},
+	{0xF01E, 0x02},
+	{0xF01F, 0x6E},
+	{0xF020, 0x00},
+	{0xF025, 0xDE},
+	{0xF026, 0x00},
+	{0xF027, 0x0A},
+	{0xF028, 0x03},
+	{0xF029, 0x6E},
+	{0xF02A, 0x00},
+	{0xF047, 0x00},
+	{0xF054, 0x0},
+	{0xF055, 0x0},
+	{0xF077, 0x01},
+	{0xF1E6, 0x00},
+};
+
 static int af903x_fc0012_init(struct af903x_dev_ctx *ctx, int chip)
 {
 	int ret;
@@ -338,6 +401,19 @@
 	TUNER_FC0012,
 };
=20
+struct tuner_desc tuner_fc0011 =3D {
+	af903x_fc0012_init,
+	af903x_fc0012_sleep,
+	af903x_fc0012_set,
+	fc0011_scripts,
+	fc0011_script_sets,
+	0xc0,
+	1,
+	0,
+	true,
+	TUNER_FC0011,
+};
+
 static u16 mxl5007t_script_sets[] =3D {
 	0x1e
 };


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--MP_/TtmkonfdO.afpSLqDIRN3lA
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=fc0011-tuner.patch

Index: linux-source-3.2/drivers/media/common/tuners/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/common/tuners/Kconfig	2012-03-20 20=
:34:00.938801738 +0100
+++ linux-source-3.2/drivers/media/common/tuners/Kconfig	2012-03-20 20:34:0=
0.986802601 +0100
@@ -204,6 +204,13 @@
 	help
 	  NXP TDA18212 silicon tuner driver.
=20
+config MEDIA_TUNER_FC0011
+	tristate "Fitipower FC0011 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  Fitipower FC0011 silicon tuner driver.
+
 config MEDIA_TUNER_FC0012
 	tristate "Fitipower FC0012 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
Index: linux-source-3.2/drivers/media/common/tuners/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/common/tuners/Makefile	2012-03-20 2=
0:34:00.942801805 +0100
+++ linux-source-3.2/drivers/media/common/tuners/Makefile	2012-03-20 20:34:=
00.986802601 +0100
@@ -27,6 +27,7 @@
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) +=3D max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) +=3D tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) +=3D tda18212.o
+obj-$(CONFIG_MEDIA_TUNER_FC0011) +=3D fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) +=3D fc0012.o
=20
 ccflags-y +=3D -Idrivers/media/dvb/dvb-core
Index: linux-source-3.2/drivers/media/common/tuners/fc0011.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-source-3.2/drivers/media/common/tuners/fc0011.c	2012-03-20 22:28:=
54.132458133 +0100
@@ -0,0 +1,386 @@
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
+struct fc0011_priv {
+        struct i2c_adapter *i2c;
+	u8 addr;
+
+        u32 frequency;
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
+#if 0 //TODO 3.3
+static int fc0011_set_params(struct dvb_frontend *fe)
+#else
+static int fc0011_set_params(struct dvb_frontend *fe,
+        struct dvb_frontend_parameters *params)
+#endif
+{
+        struct fc0011_priv *priv =3D fe->tuner_priv;
+	int err;
+	unsigned int i;
+#if 0 //TODO 3.3
+	struct dtv_frontend_properties *p =3D &fe->dtv_property_cache;
+	u32 freq =3D p->frequency / 1000;
+	u32 delsys =3D p->delivery_system;
+	u32 bandwidth =3D p->bandwidth_hz / 1000;
+#else
+	u32 freq =3D params->frequency / 1000;
+	u32 bandwidth =3D params->u.ofdm.bandwidth / 1000;
+#endif
+	u32 fvco, xin, xdiv, xdivr, fa;
+	u16 frac;
+	u8 fp, vco_sel, vco_cal;
+	u8 regs[14] =3D { };
+
+	err =3D fc0011_writereg(priv, 7, 0x0F);
+	err |=3D fc0011_writereg(priv, 8, 0x3E);
+	err |=3D fc0011_writereg(priv, 10, 0xB8);
+	err |=3D fc0011_writereg(priv, 11, 0x80);
+	err |=3D fc0011_writereg(priv, 13, 0x04);
+	if (err)
+		return -EIO;
+
+	/* Set VCO freq and VCO div */
+	if (freq < 54000) {
+		fvco =3D freq * 64;
+		regs[5] =3D 0x82;
+	} else if (freq < 108000) {
+		fvco =3D freq * 32;
+		regs[5] =3D 0x42;
+	} else if (freq < 216000) {
+		fvco =3D freq * 16;
+		regs[5] =3D 0x22;
+	} else if (freq < 432000) {
+		fvco =3D freq * 8;
+		regs[5] =3D 0x12;
+	} else {
+		fvco =3D freq * 4;
+		regs[5] =3D 0x0A;
+	}
+
+	/* Calc XIN */
+	xdiv =3D fvco / 18000;
+	frac =3D fvco - xdiv * 18000;
+	frac =3D (frac << 15) / 18000;
+	if (frac >=3D 16384)
+		frac +=3D 32786;
+	if (!frac)
+		xin =3D 0;
+	else if (frac < 511)
+		xin =3D 0x200;
+	else if (frac < 65025)
+		xin =3D frac;
+	else
+		xin =3D 0xFE00;
+	regs[3] =3D xin >> 8;
+	regs[4] =3D xin;
+	err =3D fc0011_writereg(priv, 3, regs[3]);
+	err |=3D fc0011_writereg(priv, 4, regs[4]);
+	if (err)
+		return -EIO;
+
+	/* Calc FP and FA */
+	xdivr =3D xdiv;
+	if (fvco - xdiv * 18000 >=3D 9000)
+		xdivr =3D xdiv + 1;
+	fp =3D xdivr / 8;
+	fa =3D xdivr - fp * 8;
+	if (fa < 2) {
+		fp -=3D 1;
+		fa +=3D 8;
+	}
+	regs[1] =3D fa;
+	regs[2] =3D fp;
+	err =3D fc0011_writereg(priv, 1, regs[1]);
+	err |=3D fc0011_writereg(priv, 2, regs[2]);
+	if (err)
+		return -EIO;
+
+	/* Select bandwidth */
+	switch (bandwidth) {
+	default:
+	case 8000:
+		regs[6] =3D 0;
+		break;
+	case 7000:
+		regs[6] =3D 0x40;
+		break;
+	case 6000:
+		regs[6] =3D 0x80;
+		break;
+	}
+
+	/* Pre VCO select */
+	if (fvco < 2320000) {
+		vco_sel =3D 0;
+		regs[6] &=3D 0xE7;
+	} else if (fvco < 3080000) {
+		vco_sel =3D 1;
+		regs[6] |=3D 0x10;
+	} else {
+		vco_sel =3D 2;//FIXME?
+		regs[6] |=3D 0x8;
+	}
+
+	/* Fix for low freqs */
+	if (freq < 45000) {
+		regs[1] =3D 0x6;
+		regs[2] =3D 0x11;
+	}
+
+	/* Clock out fix */
+	regs[6] |=3D 0x20;
+
+	/* Write the cached registers */
+	for (i =3D 1; i < 7; i++) {
+		err =3D fc0011_writereg(priv, i, regs[i]);
+		if (err)
+			return err;
+	}
+
+	/* VCO calibration */
+	err =3D fc0011_writereg(priv, 14, 0x80); /* reset */
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, 14, 0); /* run */
+	if (err)
+		return err;
+	/* Read calib val */
+	err =3D fc0011_writereg(priv, 14, 0);
+	if (err)
+		return err;
+	msleep(10);
+	err =3D fc0011_readreg(priv, 14, &vco_cal);
+	if (err)
+		return err;
+	vco_cal &=3D 0x3F;
+
+	switch (vco_sel) {
+	case 0:
+		if (vco_cal < 8) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x10 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			err |=3D fc0011_writereg(priv, 14, 0x80);
+			err |=3D fc0011_writereg(priv, 14, 0);
+			if (err)
+				return -EIO;
+		} else {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		}
+		break;
+	case 1:
+		if (vco_cal < 5) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x8 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		} else if (vco_cal < 48) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x10 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		} else {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			err |=3D fc0011_writereg(priv, 14, 0x80);
+			err |=3D fc0011_writereg(priv, 14, 0);
+			if (err)
+				return -EIO;
+		}
+		break;
+	case 2:
+		if (vco_cal > 53) {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x10 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			err |=3D fc0011_writereg(priv, 14, 0x80);
+			err |=3D fc0011_writereg(priv, 14, 0);
+			if (err)
+				return -EIO;
+		} else {
+			regs[6] &=3D 0xE7;
+			regs[6] |=3D 0x8 | 0x20;
+			err =3D fc0011_writereg(priv, 6, regs[6]);
+			if (err)
+				return err;
+		}
+		break;
+	}
+	msleep(10);
+
+	err =3D fc0011_readreg(priv, 13, &regs[13]);
+	if (err)
+		return err;
+	regs[13] |=3D 0x10;
+	err =3D fc0011_writereg(priv, 13, regs[13]);
+	if (err)
+		return err;
+	err =3D fc0011_writereg(priv, 16, 0xB);
+	if (err)
+		return err;
+
+	priv->frequency =3D freq * 1000;
+	priv->bandwidth =3D bandwidth * 1000;
+
+	return 0;
+}
+
+static int fc0011_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+        struct fc0011_priv *priv =3D fe->tuner_priv;
+
+        *frequency =3D priv->frequency;
+
+        return 0;
+}
+
+static int fc0011_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+        *frequency =3D 0;
+        return 0;
+}
+
+static int fc0011_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+        struct fc0011_priv *priv =3D fe->tuner_priv;
+
+        *bandwidth =3D priv->bandwidth;
+
+        return 0;
+}
+
+static const struct dvb_tuner_ops fc0011_tuner_ops =3D {
+	.info =3D {
+		.name		=3D "Fitipower FC0011",
+
+		.frequency_min	=3D 170000000, //FIXME?
+		.frequency_max	=3D 860000000, //FIXME?
+		.frequency_step	=3D 0,
+        },
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
+struct dvb_frontend * fc0011_attach(struct dvb_frontend *fe,
+				    struct i2c_adapter *i2c,
+				    u8 i2c_address)
+{
+        struct fc0011_priv *priv =3D NULL;
+
+	priv =3D kzalloc(sizeof(struct fc0011_priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->i2c =3D i2c;
+	priv->addr =3D i2c_address;
+
+	dev_info(&priv->i2c->dev, "Fitipower FC0011 attached\n");
+
+	fe->tuner_priv =3D priv;
+
+	memcpy(&fe->ops.tuner_ops, &fc0011_tuner_ops,
+	       sizeof(struct dvb_tuner_ops));
+
+	return fe;
+}
+EXPORT_SYMBOL(fc0011_attach);
+
+MODULE_DESCRIPTION("Fitipower FC0011 silicon tuner driver");
+MODULE_AUTHOR("Michael Buesch <m@bues.ch>");
+MODULE_LICENSE("GPL");
Index: linux-source-3.2/drivers/media/common/tuners/fc0011.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-source-3.2/drivers/media/common/tuners/fc0011.h	2012-03-20 20:34:=
00.990802668 +0100
@@ -0,0 +1,22 @@
+#ifndef LINUX_FC0011_H_
+#define LINUX_FC0011_H_
+
+#include "dvb_frontend.h"
+
+#if defined(CONFIG_MEDIA_TUNER_FC0011) ||\
+    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   u8 i2c_address);
+#else
+static inline
+struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
+				   struct i2c_adapter *i2c,
+				   u8 i2c_address)
+{
+	dev_err(&i2c->dev, "Driver disabled in Kconfig\n");
+	return NULL;
+}
+#endif
+
+#endif /* LINUX_FC0011_H_ */

--MP_/TtmkonfdO.afpSLqDIRN3lA
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=af903x-add-fc0011.patch

Index: linux-source-3.2/drivers/media/dvb/dvb-usb/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/Kconfig	2012-03-20 22:2=
7:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/Kconfig	2012-03-20 22:29:13.=
124801711 +0100
@@ -342,6 +342,7 @@
 config DVB_USB_AF903X
 	tristate "Afatech AF903X DVB-T USB2.0 support"
 	depends on DVB_USB && EXPERIMENTAL
+	select MEDIA_TUNER_FC0011   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_FC0012   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
 	help
Index: linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-devices.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-0=
3-20 22:27:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-03-20 =
22:29:13.128801781 +0100
@@ -260,6 +260,7 @@
 }
=20
 extern struct tuner_desc tuner_af9007;
+extern struct tuner_desc tuner_fc0011;
 extern struct tuner_desc tuner_fc0012;
 extern struct tuner_desc tuner_mxl5007t;
=20
@@ -273,6 +274,9 @@
 	case TUNER_AF9007:
 		ctx->tuner_desc =3D &tuner_af9007;
 		break;
+	case TUNER_FC0011:
+		ctx->tuner_desc =3D &tuner_fc0011;
+		break;
 	case TUNER_FC0012:
 		ctx->tuner_desc =3D &tuner_fc0012;
 		break;
Index: linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-fe.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-20 =
22:27:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-20 22:29=
:13.132801864 +0100
@@ -28,6 +28,7 @@
 #include "af903x-fe.h"
 #include "af903x-fe-priv.h"
 #include "dvb_frontend.h"
+#include "fc0011.h"
 #include "fc0012.h"
 #include "mxl5007t.h"
=20
@@ -1990,6 +1991,12 @@
 	switch(ctx->tuner_desc->tunerId) {
 	case TUNER_AF9007:
 		break;
+	case TUNER_FC0011:
+		ret =3D dvb_attach(fc0011_attach, frontend, i2c_adap,
+			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
+			ctx->tuner_desc->tuner_addr + 1)
+			=3D=3D NULL ?  -ENODEV : 0;
+		break;
 	case TUNER_FC0012:
 		ret =3D dvb_attach(fc0012_attach, frontend, i2c_adap,
 			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
Index: linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-tuners.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03=
-20 22:27:53.823367115 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03-20 2=
2:29:13.136801932 +0100
@@ -189,6 +189,69 @@
 	{0xf1e6, 0x00},
 };
=20
+static u16 fc0011_script_sets[] =3D {
+	0x38,
+};
+
+static struct af903x_val_set fc0011_scripts[] =3D {
+	{0x0046, 0x28}, /* TUNER_ID */
+	{0x0057, 0x00},
+	{0x0058, 0x01},
+	{0x005f, 0x00},
+	{0x0060, 0x00},
+	{0x0068, 0xa5},
+	{0x006e, 0x01},
+	{0x0071, 0x0A},
+	{0x0072, 0x02},
+	{0x0074, 0x01},
+	{0x0079, 0x01},
+	{0x0093, 0x00},
+	{0x0094, 0x00},
+	{0x0095, 0x00},
+	{0x0096, 0x00},
+	{0x009b, 0x2D},
+	{0x009c, 0x60},
+	{0x009d, 0x23},
+	{0x00a4, 0x50},
+	{0x00ad, 0x50},
+	{0x00b3, 0x01},
+	{0x00b7, 0x88},
+	{0x00b8, 0xa6},
+	{0x00c3, 0x01},
+	{0x00c4, 0x01},
+	{0x00c7, 0x69},
+	{0xF007, 0x00},
+	{0xF00A, 0x1B},
+	{0xF00B, 0x1B},
+	{0xF00C, 0x1B},
+	{0xF00D, 0x1B},
+	{0xF00E, 0xFF},
+	{0xF00F, 0x01},
+	{0xF010, 0x00},
+	{0xF011, 0x02},
+	{0xF012, 0xFF},
+	{0xF013, 0x01},
+	{0xF014, 0x00},
+	{0xF015, 0x02},
+	{0xF01B, 0xEF},
+	{0xF01C, 0x01},
+	{0xF01D, 0x0f},
+	{0xF01E, 0x02},
+	{0xF01F, 0x6E},
+	{0xF020, 0x00},
+	{0xF025, 0xDE},
+	{0xF026, 0x00},
+	{0xF027, 0x0A},
+	{0xF028, 0x03},
+	{0xF029, 0x6E},
+	{0xF02A, 0x00},
+	{0xF047, 0x00},
+	{0xF054, 0x0},
+	{0xF055, 0x0},
+	{0xF077, 0x01},
+	{0xF1E6, 0x00},
+};
+
 static int af903x_fc0012_init(struct af903x_dev_ctx *ctx, int chip)
 {
 	int ret;
@@ -338,6 +401,19 @@
 	TUNER_FC0012,
 };
=20
+struct tuner_desc tuner_fc0011 =3D {
+	af903x_fc0012_init,
+	af903x_fc0012_sleep,
+	af903x_fc0012_set,
+	fc0011_scripts,
+	fc0011_script_sets,
+	0xc0,
+	1,
+	0,
+	true,
+	TUNER_FC0011,
+};
+
 static u16 mxl5007t_script_sets[] =3D {
 	0x1e
 };

--MP_/TtmkonfdO.afpSLqDIRN3lA--

--Sig_/3GhXkwshnKAmLi7jsiZXfhK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPaPpGAAoJEPUyvh2QjYsOseoQAJFVU6SPnYlHc8a5yQc24Y3s
dZhli5b5WnVsxm2Rv0WoSS97IhA7uRIbb27XFwiZomIuAoBuuEws4kkw4tCukIJy
+GNJr/Nx0PrclAAqny/uTA4s6Rs3mSmiQCaB6Aaavfz+DzKgoBke/GHriNGvaGAV
q968FbIk01if1xZerkJpBXqUxSU7iLx7u0i+9UrAUY6AIHZ+HDKN2TM3rhwEY/tw
7epGINMHIY4Og44djf3YMz4RRlRS3gfV2EbMgZQrwox7r3eELMapmopW+7gW14Z2
tQd1+2gehpJkiti6tll7jxuVQ+cBafqmK6/NPVQ5VeGkv0WhUahqYMTllXT/0NOk
4RIJ5rB+ggqUQVzQlfCHxitfcWwT860AOruR7PeUI5HkVJRsB60uEEqjL2Fldxwq
QT0HC5WU0Jchd+ma+ch41LDLqazwf+aJh90zeac/r3VZlkZeoITQcQgi4vjjwfpr
QjS6fU41/k2Z7ERY9wde71rO6i9AMAC0RBJn5d5DPu8x46zVSpH0M50AjTOI4WhL
fyk0+gzxh94o2H8Xjwjxgpfb69m5vws/RsB41CeVrb0ZppHvP+cjkx8ancnsF9eS
k51Ve2vgeEd5MGwGQrDAMerg2wvlDgflONLG3z04RxMYXUa2ED4jGIQdF8cFjQ9x
raLOvr3u6IRgyeRwrCbn
=6gkh
-----END PGP SIGNATURE-----

--Sig_/3GhXkwshnKAmLi7jsiZXfhK--
