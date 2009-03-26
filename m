Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:51827 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZCZCfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 22:35:16 -0400
Date: Thu, 26 Mar 2009 03:34:53 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: mchehab@redhat.com, Darron Broad <darron@kewl.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
Subject: [PATCH] Allow the user to restrict the RC5 address
Message-ID: <20090326033453.7d90236d@laptop.hypervisor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/slHZp==pRt5W8_3zebw_urY";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/slHZp==pRt5W8_3zebw_urY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Mauro,

This patch allows users with multiple remotes to specify an RC5 address for=
 a
remote from which key codes will be accepted. If no address is specified, t=
he
default value of 0 accepts key codes from any remote. This replaces the cur=
rent
hard-coded address checks, which are too restrictive.


Signed-off-by: Udo Steinberg <udo@hypervisor.org>


--- linux-2.6.29/drivers/media/video/ir-kbd-i2c.c	2009-03-24 00:12:14.00000=
0000 +0100
+++ linux-2.6.29/drivers/media/video/ir-kbd-i2c.new	2009-03-26 03:12:11.000=
000000 +0100
@@ -58,6 +58,9 @@
 module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
 MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=3Dblack, 1=3Dgrey=
 (defaults to 0)");
=20
+static unsigned int device;
+module_param(device, uint, 0644);    /* RC5 device address */
+MODULE_PARM_DESC(device, "Specify device address: 0=3Dany (defaults to 0)"=
);
=20
 #define DEVNAME "ir-kbd-i2c"
 #define dprintk(level, fmt, arg...)	if (debug >=3D level) \
@@ -104,8 +107,8 @@
 		/* invalid key press */
 		return 0;
=20
-	if (dev!=3D0x1e && dev!=3D0x1f)
-		/* not a hauppauge remote */
+	if (device && device !=3D dev)
+		/* not an acceptable remote */
 		return 0;
=20
 	if (!range)

--Sig_/slHZp==pRt5W8_3zebw_urY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknK6c0ACgkQnhRzXSM7nSkeUgCcCB6fe0qZiqLCQCBWgU0XxyxK
BP0AmwY/oYEPVaB6O73PRCo5/DWVNrpU
=2nhn
-----END PGP SIGNATURE-----

--Sig_/slHZp==pRt5W8_3zebw_urY--
