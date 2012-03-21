Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51834 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab2CUP5E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 11:57:04 -0400
Date: Wed, 21 Mar 2012 16:56:59 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hans-Frieder Vogt <hfvogt@gmx.net>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] Integrate Fitipower fc0011 into af903x
Message-ID: <20120321165659.4bc10e78@milhouse>
In-Reply-To: <20120321160237.02193470@milhouse>
References: <20120321160237.02193470@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2DRC21AB_OnNnuKWK=3eOkP"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/2DRC21AB_OnNnuKWK=3eOkP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This adds fc0011 support to the af903x driver.

Signed-off-by: Michael Buesch <m@bues.ch>

---


Index: linux-source-3.2/drivers/media/dvb/dvb-usb/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-source-3.2.orig/drivers/media/dvb/dvb-usb/Kconfig	2012-03-20 22:4=
8:14.025859279 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/Kconfig	2012-03-21 15:31:43.=
266801632 +0100
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
3-20 22:48:14.025859279 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-03-21 =
15:31:43.270801692 +0100
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
22:48:14.025859279 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-21 15:37=
:04.968319280 +0100
@@ -28,6 +28,7 @@
 #include "af903x-fe.h"
 #include "af903x-fe-priv.h"
 #include "dvb_frontend.h"
+#include "fc0011.h"
 #include "fc0012.h"
 #include "mxl5007t.h"
=20
@@ -1967,6 +1968,8 @@
 	}
 };
=20
+extern int af903x_fc0011_reset(void *_ctx);
+
 static struct dvb_frontend_ops af903x_ops;
 struct dvb_frontend *af903x_fe_attach(struct i2c_adapter *i2c_adap, int id,
 	struct af903x_dev_ctx *ctx)
@@ -1990,6 +1993,13 @@
 	switch(ctx->tuner_desc->tunerId) {
 	case TUNER_AF9007:
 		break;
+	case TUNER_FC0011:
+		ret =3D dvb_attach(fc0011_attach, frontend, i2c_adap,
+			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
+			ctx->tuner_desc->tuner_addr + 1,
+			af903x_fc0011_reset, ctx)
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
-20 22:48:14.025859279 +0100
+++ linux-source-3.2/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03-21 1=
5:42:42.214115654 +0100
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
@@ -338,6 +401,43 @@
 	TUNER_FC0012,
 };
=20
+int af903x_fc0011_reset(void *_ctx)
+{
+	struct af903x_dev_ctx *ctx =3D _ctx;
+	struct usb_device *udev =3D ctx->udev;
+	int ret;
+
+	ret =3D af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_ON, 1);
+	if (ret < 0)
+		return ret;
+	ret =3D af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_EN, 1);
+	if (ret < 0)
+		return ret;
+	ret =3D af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_O, 1);
+	if (ret < 0)
+		return ret;
+	msleep(10);
+	ret =3D af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_O, 0);
+	if (ret < 0)
+		return ret;
+	msleep(10);
+
+	return 0;
+}
+
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

--Sig_/2DRC21AB_OnNnuKWK=3eOkP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPafpLAAoJEPUyvh2QjYsOzjYP/1/MtrPi9maaCK9ruyieMG+E
5OqcvM1rMu843PyfxhAAfgp00Gn7pQzV3Pt4ETqcOme//EbCpqj31fWjieQ0kYGE
tw4GGG/9EifkoChMbYzEfnsN5NJGTA1kWHw7pUN7GL4pRvoQKc/ysIac+ICoEpTj
RmSwDWfWshT6AyoUHD4QMmeiLzVBdGmL0DBhFEPRejK2J/mkx6PFWaVQfn45m05w
GNbCtS4YNuKiLYwig6DV5GvDdhxu1RGI4C+zk47fqti7b2lq/aIbYzlcxgwhwqK8
zA/DY7nLLnblZChebdTXv/mKVYYGG25BjaO5lds1D0Lz5vKadlCjok6iUgiHU21A
p0/3Nbqy4dcbGO+ZLMjAjw4TqA4IaSOWY+7VHm200vIR3yO0kTq341SxBrBn/7F2
9OUTKP81vNOLRjRWabwPUb0BO2yy6W53PvDYnK2URkerjZLu0qR45D7H9IcmzlfG
9lcNaKHrNsk5VGBcM2QjX9rqi00yUx/VMAEc4QAKvr8P27WwKUK5tEnF9ym4gk2v
TJmVJzBHzuHmQApUkiBxu/3P4BXGWrdzNcI9cPukICIP6XgqwIBkRfqVfnEGs66O
epHGE/L1JDGCMvzpWpjuqVzOqY8V3aiP/tHHop2GvohLBHoR6qn76NFFsdplw+XJ
VzD/29k3u7s3/UnN28wp
=h8PO
-----END PGP SIGNATURE-----

--Sig_/2DRC21AB_OnNnuKWK=3eOkP--
