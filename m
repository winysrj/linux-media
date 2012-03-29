Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:35147 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab2C2ARc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 20:17:32 -0400
Date: Thu, 29 Mar 2012 02:17:21 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: Re: [PATCH] Add Fitipower fc0011 tuner driver
Message-ID: <20120329021721.6f0ba357@milhouse>
In-Reply-To: <20120329020134.1a18e39e@milhouse>
References: <20120329020134.1a18e39e@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H10OFVK91Nl5Kh1ViL+9S5a"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/H10OFVK91Nl5Kh1ViL+9S5a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Mar 2012 02:01:34 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> The driver is tested with the af903x driver.

For reference, here goes the af903x/fc0011 glue:

Signed-off-by: Michael Buesch <m@bues.ch>

Index: linux-3.3/drivers/media/dvb/dvb-usb/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-3.3.orig/drivers/media/dvb/dvb-usb/Kconfig	2012-03-28 23:47:04.09=
1901520 +0200
+++ linux-3.3/drivers/media/dvb/dvb-usb/Kconfig	2012-03-28 23:47:07.6959650=
33 +0200
@@ -342,6 +342,7 @@
 config DVB_USB_AF903X
 	tristate "Afatech AF903X DVB-T USB2.0 support"
 	depends on DVB_USB && EXPERIMENTAL
+	select MEDIA_TUNER_FC0011   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_FC0012   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
 	help
Index: linux-3.3/drivers/media/dvb/dvb-usb/af903x-devices.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-3.3.orig/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-03-28 23=
:47:04.091901520 +0200
+++ linux-3.3/drivers/media/dvb/dvb-usb/af903x-devices.c	2012-03-28 23:47:0=
7.699965103 +0200
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
Index: linux-3.3/drivers/media/dvb/dvb-usb/af903x-fe.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-3.3.orig/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-28 23:47:0=
4.091901520 +0200
+++ linux-3.3/drivers/media/dvb/dvb-usb/af903x-fe.c	2012-03-28 23:47:07.699=
965103 +0200
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
+extern int af903x_fc0011_reset(unsigned long arg0, unsigned long arg1);
+
 static struct dvb_frontend_ops af903x_ops;
 struct dvb_frontend *af903x_fe_attach(struct i2c_adapter *i2c_adap, int id,
 	struct af903x_dev_ctx *ctx)
@@ -1990,6 +1993,14 @@
 	switch(ctx->tuner_desc->tunerId) {
 	case TUNER_AF9007:
 		break;
+	case TUNER_FC0011:
+		ret =3D dvb_attach(fc0011_attach, frontend, i2c_adap,
+			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
+			ctx->tuner_desc->tuner_addr + 1,
+			af903x_fc0011_reset,
+			(unsigned long)ctx, (unsigned long)id)
+			=3D=3D NULL ?  -ENODEV : 0;
+		break;
 	case TUNER_FC0012:
 		ret =3D dvb_attach(fc0012_attach, frontend, i2c_adap,
 			id =3D=3D 0 ? ctx->tuner_desc->tuner_addr :
Index: linux-3.3/drivers/media/dvb/dvb-usb/af903x-tuners.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-3.3.orig/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03-28 23:=
47:04.091901520 +0200
+++ linux-3.3/drivers/media/dvb/dvb-usb/af903x-tuners.c	2012-03-28 23:47:07=
.699965103 +0200
@@ -189,6 +189,69 @@
 	{0xf1e6, 0x00},
 };
=20
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
+static u16 fc0011_script_sets[] =3D {
+	ARRAY_SIZE(fc0011_scripts),
+};
+
 static int af903x_fc0012_init(struct af903x_dev_ctx *ctx, int chip)
 {
 	int ret;
@@ -338,6 +401,44 @@
 	TUNER_FC0012,
 };
=20
+int af903x_fc0011_reset(unsigned long arg0, unsigned long arg1)
+{
+	struct af903x_dev_ctx *ctx =3D (struct af903x_dev_ctx *)arg0;
+	int chip =3D arg1;
+	struct usb_device *udev =3D ctx->udev;
+	int ret;
+
+	ret =3D af9035_wr_reg(udev, chip, PRO_LINK, GPIOT3_ON, 1);
+	if (ret < 0)
+		return ret;
+	ret =3D af9035_wr_reg(udev, chip, PRO_LINK, GPIOT3_EN, 1);
+	if (ret < 0)
+		return ret;
+	ret =3D af9035_wr_reg(udev, chip, PRO_LINK, GPIOT3_O, 1);
+	if (ret < 0)
+		return ret;
+	msleep(10);
+	ret =3D af9035_wr_reg(udev, chip, PRO_LINK, GPIOT3_O, 0);
+	if (ret < 0)
+		return ret;
+	msleep(10);
+
+	return 0;
+}
+
+struct tuner_desc tuner_fc0011 =3D {
+	.open_tuner		=3D af903x_fc0012_init,
+	.close_tuner		=3D af903x_fc0012_sleep,
+	.set_tuner		=3D af903x_fc0012_set,
+	.tuner_scripts		=3D fc0011_scripts,
+	.tuner_script_sets	=3D fc0011_script_sets,
+	.tuner_addr		=3D 0xc0,
+	.reg_addr_len		=3D 1,
+	.if_freq		=3D 0,
+	.inversion		=3D true,
+	.tunerId		=3D TUNER_FC0011,
+};
+
 static u16 mxl5007t_script_sets[] =3D {
 	0x1e
 };


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/H10OFVK91Nl5Kh1ViL+9S5a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPc6oRAAoJEPUyvh2QjYsOtuEP/0X0zr5VXJoBWzLzBnSx4RWQ
7eREP3L//+SbKe6rl57/JU6bpH3iNIyWT+FFtNKDM5S+zVzFSdutOyEMjJaclABu
7QxXHsySnq1fPo+PMqCMkakPcoaDvQ71grM/tU+2ErBUmF7b+sM97GwaqXao9P/l
5lE72JwzhMT455exqpgFkm2iET1Zk/KPmM8EAen0zAD2otm+d/1yd9vHRuKGsuTO
giDJfcfP54UHiD+1Tk2Lrf78GEOIlRUexUDhs6S227eYmedjPP0z7bUgK2Dk99YK
T04B1TYIvmhCRjHi74qPK9ru2m+Yb8lsYpW0Y70g5t26eJDatdb1raDb3zbniEZu
ugB/BfeTNrAo2pnh75m3lSbN+ni4FEZ1Y0dd+9nwEfgBsJOYkmsYYcPm8S60XvaM
qKewgiS7BLXttZRgRjrCo1+KytQ6LCS4AaON9TEliOke17csODfWoNFpq2XBT8dh
BNCRwNUz74sj2MInlCfyeIvwVHzH88vEHHYUqA+zKK+uvnha1SIRAoDx597LtycL
J56GCIufzWqM0PLHpUlxxS1Z4PY5wcxxBhkav49iKGoRD8RDXSeqJmXOzfhwP3vJ
QrVreHQ9dCwhrulM5Qc5iBJv/IqgOnR4Y56jGnTQ8qwOUe2gUFJsRTns7qtOpWnV
jwxVLzgQdUJvigZcXpbl
=Rzay
-----END PGP SIGNATURE-----

--Sig_/H10OFVK91Nl5Kh1ViL+9S5a--
