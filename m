Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44217 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2DBQSm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 12:18:42 -0400
Date: Mon, 2 Apr 2012 18:18:36 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] af9035: Add fc0011 tuner support
Message-ID: <20120402181836.0018c6ad@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eDQgw.zR=DAAZm90GEVLPNM"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/eDQgw.zR=DAAZm90GEVLPNM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This adds Fitipower fc0011 tuner support to the af9035 driver.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/dvb/dvb-usb/af9035.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/af9035.c	2012-04-02 18:11:09.97560=
5484 +0200
+++ linux/drivers/media/dvb/dvb-usb/af9035.c	2012-04-02 18:15:46.946952566 =
+0200
@@ -22,6 +22,7 @@
 #include "af9035.h"
 #include "af9033.h"
 #include "tua9001.h"
+#include "fc0011.h"
=20
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static DEFINE_MUTEX(af9035_usb_mutex);
@@ -498,6 +499,7 @@
=20
 		switch (tmp) {
 		case AF9033_TUNER_TUA9001:
+		case AF9033_TUNER_FC0011:
 			af9035_af9033_config[i].spec_inv =3D 1;
 			break;
 		default:
@@ -542,6 +544,83 @@
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
@@ -570,6 +649,7 @@
 		ret =3D -ENODEV;
 		goto err;
 	}
+	adap->fe_adap[0].fe->callback =3D af9035_frontend_callback;
=20
 	return 0;
=20
@@ -583,6 +663,10 @@
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
@@ -631,6 +715,10 @@
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
--- linux.orig/drivers/media/dvb/frontends/af9033.c	2012-04-02 18:11:08.551=
563486 +0200
+++ linux/drivers/media/dvb/frontends/af9033.c	2012-04-02 18:11:18.82786544=
4 +0200
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
--- linux.orig/drivers/media/dvb/frontends/af9033_priv.h	2012-04-02 18:11:0=
8.551563486 +0200
+++ linux/drivers/media/dvb/frontends/af9033_priv.h	2012-04-02 18:11:18.827=
865444 +0200
@@ -336,5 +336,66 @@
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
Index: linux/drivers/media/dvb/dvb-usb/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/Kconfig	2012-04-01 11:41:29.090353=
449 +0200
+++ linux/drivers/media/dvb/dvb-usb/Kconfig	2012-04-02 18:16:32.460019436 +=
0200
@@ -428,6 +428,7 @@
 	depends on DVB_USB
 	select DVB_AF9033
 	select MEDIA_TUNER_TUA9001 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_FC0011 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Afatech AF9035 based DVB USB receiver.
=20


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/eDQgw.zR=DAAZm90GEVLPNM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPedFdAAoJEPUyvh2QjYsOl4sQAMTndhMMBWAM7Vz/l/MgGaiC
0WWcBDAgHd/QnQ6CD1W/y4zf1svsYtBBb2u+gTTMQSHf8vjFHk63YDCdx+YKS6cl
k7HLBSTkDWxlbcIDeBygICAWOpkIDFNM3aSiQa78pCSTOZ1VlUEDTUfEpx1T8XVQ
p8I+4pfixoDZuThQoMsIUIPGXgBEiMycsSXfpFnvLLRiES5unvya+9Yawpc8dVV7
sLnHswxLzHctKjHVmE6933fUjwQieGaTqHLkw7RasGmLKm2ZywPydkFr3TBH58rz
oNBCnWx9dfBRSQnNnswwKwpegb6KWKK0Fap/Hp5OcKqRl8+gt6tAHXTVoKFLyL/q
F1wYBPBKnf7a8Z6cj4DJfYUrqIowmA90r9U3IdSp1KJWJEqXtyMAb1IyFFLJOQ3+
lM6bp8q+ZCAYB7nkxpyddXAn5VcQr1GG2NzVYx8o/RnbEt9z/185mKhGIl8xV/z2
m+ADrI1po72rBy5oTNx/mFRyYs+vHGMJ09xO/+jnE2ZMxk6TEyvluBm7eOerlfEk
o20YIZGspOOpBR4LWNLATld2M9yOBXBLATSVnUDARyr2XX/MnIby5BSm1jv5LEiw
c0Lheyt50Ngqc0yKLUsmqCV+X5GR56rYk9WXKIwtQiROnF1VItBHFk56DdyE/b14
6DEVN5D4ot45m5Kk58MZ
=lxbW
-----END PGP SIGNATURE-----

--Sig_/eDQgw.zR=DAAZm90GEVLPNM--
