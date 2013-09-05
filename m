Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44455 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538Ab3IECcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 22:32:22 -0400
Message-ID: <1378348339.27597.17.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2 3/4] [media] lirc_bt829: Enable and disable device
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 05 Sep 2013 03:32:19 +0100
In-Reply-To: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
References: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MvfIKG3ZMZ6WxehwhKoF"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-MvfIKG3ZMZ6WxehwhKoF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We must not assume that the PCI device is already enabled.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index a61d233..623f10e 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -126,9 +126,13 @@ int init_module(void)
 	if (pdev =3D=3D NULL)
 		return -ENODEV;
=20
+	rc =3D pci_enable_device(pdev);
+	if (rc)
+		goto err_put_dev;
+
 	if (!atir_init_start()) {
 		rc =3D -ENODEV;
-		goto err_put_dev;
+		goto err_disable;
 	}
=20
 	strcpy(atir_driver.name, "ATIR");
@@ -154,6 +158,8 @@ int init_module(void)
=20
 err_unmap:
 	iounmap(pci_addr_lin);
+err_disable:
+	pci_disable_device(pdev);
 err_put_dev:
 	pci_dev_put(pdev);
 	return rc;
@@ -166,6 +172,7 @@ void cleanup_module(void)
=20
 	lirc_unregister_driver(atir_minor);
 	iounmap(pci_addr_lin);
+	pci_disable_device(pdev);
 	pci_dev_put(pdev);
 }
=20



--=-MvfIKG3ZMZ6WxehwhKoF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiftM+e/yOyVhhEJAQoq3w/7BsjwjGbVkE9tUcfjlI4htqnSySESam8F
d+1Jhs/+6v7Es8SBeyEDorgEnZam0Fp32sJVHuGdz4Dt/0AWh+fjjdRR1SRJvAqS
wwZnpVbY6HpTv/QFBA9tziAtsRmRCVJqfcMg8ak5ZLgf+V5CbCifpqWdHegDpn6G
lj1MjcXBGb7UKcjcABBLctZFQcC3gYJWOTrH1i9IRUKf708qIZ8r2rHyfrbq0T+9
aBe3Ce0Mc6uY9QkDPs4MZIx2RhFkhLU51nFpwXb9/OCWyXqzxskUb/HPmlplxnC0
sm8840ytCwlKI1eB3AiPWKQNVHaxXj6mxJgWNiFUkY6brrcrq2LfVh7sj3IAARny
zo8ClXw+U7fXENqiK5rFKHboLnkBwUHN0x3zer6vcbmqQ9oyw0e4sKOn70TWNCl5
E/PU4WzDYC/p8jvtZ5wOnKYfFUO1cAZkezyOVfbIse6Q1R1HLS19wKnSKru+38hS
m6umwR2DWyiNNd5dkwuSfRxhSpK4QVWRLL6+Ot75dOs1jpIgCD0xbOoNIfIpxGD3
PXQDDOMWRRl+yMOayzY+H5itN98+Xy9zKTdKg2wdchhWd6vOxDwHDr2hHn4sC21K
zQrpm87UVzl4PCde/xsSiGqsgNdLuX1AvLXJhW4nk23ekuaSwuOIWdttDMDC0Kcq
Hj9KK2Tb3PE=
=HI7y
-----END PGP SIGNATURE-----

--=-MvfIKG3ZMZ6WxehwhKoF--
