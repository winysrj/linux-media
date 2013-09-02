Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60582 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757711Ab3IBAkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 20:40:13 -0400
Message-ID: <1378082410.25743.62.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 3/4] [media] lirc_bt829: Fix iomap leak
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 02 Sep 2013 01:40:10 +0100
In-Reply-To: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ui3tg8zGBgAMaN9/vZYg"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Ui3tg8zGBgAMaN9/vZYg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We must call iounmap() when removed from a device.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index 8c5ba2a..76e6cfb 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -140,12 +140,14 @@ static int atir_pci_probe(struct pci_dev *pdev,
 	if (atir->minor < 0) {
 		dev_err(&pdev->dev, "failed to register driver!\n");
 		rc =3D atir->minor;
-		goto err_free;
+		goto err_unmap;
 	}
 	dprintk("driver is registered on minor %d\n", atir->minor);
=20
 	return 0;
=20
+err_unmap:
+	iounmap(atir->pci_addr_lin);
 err_free:
 	pci_set_drvdata(pdev, NULL);
 	kfree(atir);
@@ -158,6 +160,7 @@ static void atir_pci_remove(struct pci_dev *pdev)
 	struct atir_device *atir =3D pci_get_drvdata(pdev);
=20
 	lirc_unregister_driver(atir->minor);
+	iounmap(atir->pci_addr_lin);
 	pci_set_drvdata(pdev, NULL);
 	kfree(atir);
 }



--=-Ui3tg8zGBgAMaN9/vZYg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPeaue/yOyVhhEJAQoL8xAApuw1v9NxvA/fEYfxYzGSBmowhZEpz6/i
jfYD84p+QHSTo15YUFYgwR4tdyvP2aDkRQCWdXmGt/86ETfwR6ttzCzpm6irJOjy
jTaJJFA6g4AfIvdbo5nL8LsEPfIVLwopskLsq9B19cUpEqjlXg0On91l4ldgHNM6
zsGrgKis0QCGhQ/Kze91lxs82+JrfZHuTWb9HV0JE9VqwXHzvcly2NAeXmZ2k9yC
zRyf9HMhF0HVkUxMEsAO9PN0/YDZW1gvWMT0V8qsw1PTlG9kkavAAb8zxPuHFsGE
uhBXyl0RLcwr928vMUT2tSS+AhfYVSDFurrhZP0IKF8kt9odcW5ofpcu8jnDr5Je
oglJ4VP2XL6p4zzAM6c3ukHiKs9jwddprauNqJXlH2twjT/b/l2K7ov6FH7mrul/
26X0GEd5TRkafJHTVoCjx0HEO9udGaiZHK1oskGY63wF1CbhtbPgbSjxfO0ATekz
ECduIbnDSrJSGW4VNnz1FrfbFfapiTdJ5NcvVH9qVelOO1mNIPDx6uriOr6vAiJv
wOfW3o28OtDKAPcmMxSyEoSDQX5xGYeVsoKtsBdAVZqjIiYYDLonpOV9rEquEaSA
ivb6BhuGzJHlr8PkIIkHPjeHBA3gGXdZUIm9Da6ZcLHHkYiAmHM1WTcthUK6g2Oq
ixiK4nhYm7c=
=0cwX
-----END PGP SIGNATURE-----

--=-Ui3tg8zGBgAMaN9/vZYg--
