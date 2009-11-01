Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60562 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757872AbZKACOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 22:14:34 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KhJvdVQ9DY5Z47jmv/Hb"
Date: Sun, 01 Nov 2009 02:14:35 +0000
Message-Id: <1257041675.3136.310.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] V4L/DVB: lgs8gxx: remove firmware for lgs8g75
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KhJvdVQ9DY5Z47jmv/Hb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The recently added support for lgs8g75 included some 8051 machine code
without accompanying source code.  Replace this with use of the
firmware loader.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This firmware can be added to linux-firmware.git instead, and I will be
requesting that very shortly.

Ben.

 drivers/media/dvb/frontends/Kconfig   |    1 +
 drivers/media/dvb/frontends/lgs8gxx.c |   50 ++++++-----------------------=
---
 2 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/fronte=
nds/Kconfig
index d7c4837..26b00ab 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -553,6 +553,7 @@ config DVB_LGS8GL5
 config DVB_LGS8GXX
 	tristate "Legend Silicon LGS8913/LGS8GL5/LGS8GXX DMB-TH demodulator"
 	depends on DVB_CORE && I2C
+	select FW_LOADER
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A DMB-TH tuner module. Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/fron=
tends/lgs8gxx.c
index eabcadc..1bfcf85 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -24,6 +24,7 @@
  */
=20
 #include <asm/div64.h>
+#include <linux/firmware.h>
=20
 #include "dvb_frontend.h"
=20
@@ -46,42 +47,6 @@ module_param(fake_signal_str, int, 0644);
 MODULE_PARM_DESC(fake_signal_str, "fake signal strength for LGS8913."
 "Signal strength calculation is slow.(default:on).");
=20
-static const u8 lgs8g75_initdat[] =3D {
-	0x01, 0x30, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
-	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
-	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
-	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
-	0x00, 0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
-	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
-	0xE4, 0xF5, 0xA8, 0xF5, 0xB8, 0xF5, 0x88, 0xF5,
-	0x89, 0xF5, 0x87, 0x75, 0xD0, 0x00, 0x11, 0x50,
-	0x11, 0x50, 0xF4, 0xF5, 0x80, 0xF5, 0x90, 0xF5,
-	0xA0, 0xF5, 0xB0, 0x75, 0x81, 0x30, 0x80, 0x01,
-	0x32, 0x90, 0x80, 0x12, 0x74, 0xFF, 0xF0, 0x90,
-	0x80, 0x13, 0x74, 0x1F, 0xF0, 0x90, 0x80, 0x23,
-	0x74, 0x01, 0xF0, 0x90, 0x80, 0x22, 0xF0, 0x90,
-	0x00, 0x48, 0x74, 0x00, 0xF0, 0x90, 0x80, 0x4D,
-	0x74, 0x05, 0xF0, 0x90, 0x80, 0x09, 0xE0, 0x60,
-	0x21, 0x12, 0x00, 0xDD, 0x14, 0x60, 0x1B, 0x12,
-	0x00, 0xDD, 0x14, 0x60, 0x15, 0x12, 0x00, 0xDD,
-	0x14, 0x60, 0x0F, 0x12, 0x00, 0xDD, 0x14, 0x60,
-	0x09, 0x12, 0x00, 0xDD, 0x14, 0x60, 0x03, 0x12,
-	0x00, 0xDD, 0x90, 0x80, 0x42, 0xE0, 0x60, 0x0B,
-	0x14, 0x60, 0x0C, 0x14, 0x60, 0x0D, 0x14, 0x60,
-	0x0E, 0x01, 0xB3, 0x74, 0x04, 0x01, 0xB9, 0x74,
-	0x05, 0x01, 0xB9, 0x74, 0x07, 0x01, 0xB9, 0x74,
-	0x0A, 0xC0, 0xE0, 0x74, 0xC8, 0x12, 0x00, 0xE2,
-	0xD0, 0xE0, 0x14, 0x70, 0xF4, 0x90, 0x80, 0x09,
-	0xE0, 0x70, 0xAE, 0x12, 0x00, 0xF6, 0x12, 0x00,
-	0xFE, 0x90, 0x00, 0x48, 0xE0, 0x04, 0xF0, 0x90,
-	0x80, 0x4E, 0xF0, 0x01, 0x73, 0x90, 0x80, 0x08,
-	0xF0, 0x22, 0xF8, 0x7A, 0x0C, 0x79, 0xFD, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD9,
-	0xF6, 0xDA, 0xF2, 0xD8, 0xEE, 0x22, 0x90, 0x80,
-	0x65, 0xE0, 0x54, 0xFD, 0xF0, 0x22, 0x90, 0x80,
-	0x65, 0xE0, 0x44, 0xC2, 0xF0, 0x22
-};
-
 /* LGS8GXX internal helper functions */
=20
 static int lgs8gxx_write_reg(struct lgs8gxx_state *priv, u8 reg, u8 data)
@@ -627,9 +592,14 @@ static int lgs8913_init(struct lgs8gxx_state *priv)
=20
 static int lgs8g75_init_data(struct lgs8gxx_state *priv)
 {
-	const u8 *p =3D lgs8g75_initdat;
+	const struct firmware *fw;
+	int rc;
 	int i;
=20
+	rc =3D request_firmware(&fw, "lgs8g75.fw", &priv->i2c->dev);
+	if (rc)
+		return rc;
+
 	lgs8gxx_write_reg(priv, 0xC6, 0x40);
=20
 	lgs8gxx_write_reg(priv, 0x3D, 0x04);
@@ -640,16 +610,16 @@ static int lgs8g75_init_data(struct lgs8gxx_state *pr=
iv)
 	lgs8gxx_write_reg(priv, 0x3B, 0x00);
 	lgs8gxx_write_reg(priv, 0x38, 0x00);
=20
-	for (i =3D 0; i < sizeof(lgs8g75_initdat); i++) {
+	for (i =3D 0; i < fw->size; i++) {
 		lgs8gxx_write_reg(priv, 0x38, 0x00);
 		lgs8gxx_write_reg(priv, 0x3A, (u8)(i&0xff));
 		lgs8gxx_write_reg(priv, 0x3B, (u8)(i>>8));
-		lgs8gxx_write_reg(priv, 0x3C, *p);
-		p++;
+		lgs8gxx_write_reg(priv, 0x3C, fw->data[i]);
 	}
=20
 	lgs8gxx_write_reg(priv, 0x38, 0x00);
=20
+	release_firmware(fw);
 	return 0;
 }
=20
--=20
1.6.5.2



--=-KhJvdVQ9DY5Z47jmv/Hb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASuzvBue/yOyVhhEJAQIkshAAmr/0jYpIysznvhz69PD/jTfmUHyGOXa8
CQb4LB2/xtyuFsn/wghoScm+rC7RR8FO0Mt5xkKlic17ySDcgu8s7mwVrKhQIZAf
GRiZkPDOyklLpQF8teXjv1qbDnvxgWd9llsS2tAbZo8GTHPtIF8/XwFaH4Yi2oFw
nfmLHl1SoqiWN/MzULunuGYPaOWIVBLP7d1RjMLKGGw56nd0l/U2z5YxCF4s2C0C
qlNui0LRFJsQR1RFGlaH2hcNn/3i85AWvzRylns/hDRWl9LWWxGQIF6zT0RPl67X
gCEdS4Y6AhNFD63dWMn4QUP0RpPDbPoWAiT4jFp1cZTfcJNPCi4cKOLVbzxOn4Jl
jsaioNWjkl+RrjCyblRdT/e3D2VvRhqiIk/FxM47Om4pDAa4NHfBjZAmcuufDAJq
7opgpxbkSrrp1XQBLGu0Gq1Rjr0lLkuiNAb8pnoLqGH3XbOlLvHomAA8gz+MbEbw
un82CG8HojZ6GdSxk7aPMS74wu6cm5+jqHdZPLmVHp8FDl5iuz9TOcdPv/6U9n7n
UbD4JrAtQZn/+11kUUEvz3vdF4C14ywKBU6bWMV8U8FVNoIIDzgLgAfpXYOm+0XA
a+FYwOgrymAACNBweMieuQlYRq52xuvM/sZsTt0coM7peLnFvap7vQyqG3VmrcVz
s7KNigLY3LU=
=BDy/
-----END PGP SIGNATURE-----

--=-KhJvdVQ9DY5Z47jmv/Hb--
