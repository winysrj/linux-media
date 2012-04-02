Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44249 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab2DBQfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 12:35:01 -0400
Date: Mon, 2 Apr 2012 18:34:52 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] af9035: Add Afatech USB PIDs
Message-ID: <20120402183452.68670fb3@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r1BlWWc5M6bF5tTyHT6j5/I"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/r1BlWWc5M6bF5tTyHT6j5/I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Add some generic Afatech USB PIDs used by "Cabstone" sticks and others.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/drivers/media/dvb/dvb-usb/af9035.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/af9035.c	2012-04-02 18:15:46.94695=
2566 +0200
+++ linux/drivers/media/dvb/dvb-usb/af9035.c	2012-04-02 18:27:59.672754125 =
+0200
@@ -738,11 +738,17 @@
=20
 enum af9035_id_entry {
 	AF9035_0CCD_0093,
+	AF9035_15A4_9035,
+	AF9035_15A4_1001,
 };
=20
 static struct usb_device_id af9035_id[] =3D {
 	[AF9035_0CCD_0093] =3D {
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK)},
+	[AF9035_15A4_9035] =3D {
+		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035)},
+	[AF9035_15A4_1001] =3D {
+		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_2)},
 	{},
 };
=20
@@ -785,14 +791,20 @@
=20
 		.i2c_algo =3D &af9035_i2c_algo,
=20
-		.num_device_descs =3D 1,
+		.num_device_descs =3D 2,
 		.devices =3D {
 			{
 				.name =3D "TerraTec Cinergy T Stick",
 				.cold_ids =3D {
 					&af9035_id[AF9035_0CCD_0093],
 				},
-			},
+			}, {
+				.name =3D "Afatech Technologies DVB-T stick",
+				.cold_ids =3D {
+					&af9035_id[AF9035_15A4_9035],
+					&af9035_id[AF9035_15A4_1001],
+				},
+			}
 		}
 	},
 };
Index: linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-04-01 11:41:29.=
094353520 +0200
+++ linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-04-02 18:26:34.38627=
2276 +0200
@@ -76,6 +76,8 @@
 #define USB_PID_AFATECH_AF9005				0x9020
 #define USB_PID_AFATECH_AF9015_9015			0x9015
 #define USB_PID_AFATECH_AF9015_9016			0x9016
+#define USB_PID_AFATECH_AF9035				0x9035
+#define USB_PID_AFATECH_AF9035_2			0x1001
 #define USB_PID_TREKSTOR_DVBT				0x901b
 #define USB_VID_ALINK_DTU				0xf170
 #define USB_PID_ANSONIC_DVBT_USB			0x6000


--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/r1BlWWc5M6bF5tTyHT6j5/I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPedUsAAoJEPUyvh2QjYsOwuYP/0zqAqHBIsbaW8JuMVsCVB2C
FB92fpr5Ziqkjv7ZmduDi4Ti6Oe0Nfr/WbqFvRPjRKm7xU9AsIoF4zh01dvuSsx3
X9/zzHjTnODYBQFpU3qPGrTOs3BioiEpqhVYXA83Wgd5j/efIqBekkxB6YCHRgnQ
SAL3/3sFrThLOgtnbU/xnX/DVeiBnLXzCwkN+Ng+IWMyhyTPClzd3HHh4MayxbBu
FvjZMLsVgmzKeo6QurELarkTWKS6mKchZ2sx5Zfih3lkNSFLALnqMnQuojYp09zG
56qK/gJa+PfgT1TjfnrlcO8rvSkG5/KRSbvGq2h1uMp37XKHBng8htjLIPIA4AGV
GYKMAMkJCDBC2DJtJfB+4FSueTE4RnkKdz5+DR0ywLi+ujTnIwxuoA64U61hIeHQ
LerGij+5a5kdIA2kZfPR846jm0zPcaiwTj4I9bJg8CGfArSe4b7aNqqG3MPb8DVp
XVh37ncsjNgnd75D4K2CfE0CsrhtM9I4+DhkJWgDvc1G36xvWsw6ZIAX9n2H2uqG
4FlNdli+J1d7lzdI/u/txqgiFNGltV5UYFb3zrN5rKyVuiftCxRE05k7W7Ai9gEk
17FzNQMd4cIirrtZdKZaLnhZgQUaq1UgFyZjlyGpUf66LByGyqjTdLB0y4uMh91D
OYcNSAziu6CShMRDuPRy
=CKTz
-----END PGP SIGNATURE-----

--Sig_/r1BlWWc5M6bF5tTyHT6j5/I--
