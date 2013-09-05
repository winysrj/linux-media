Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44450 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab3IECcB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 22:32:01 -0400
Message-ID: <1378348319.27597.16.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2 2/4] [media] lirc_bt829: Fix iomap and PCI device leaks
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 05 Sep 2013 03:31:59 +0100
In-Reply-To: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
References: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DIyw3uy737LanNnFtfwB"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-DIyw3uy737LanNnFtfwB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We must call iounmap() and pci_dev_put() when removed and on
the probe failure path.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index 9c7be55..a61d233 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -82,6 +82,7 @@ static struct pci_dev *do_pci_probe(void)
 		}
 		if (pci_addr_phys =3D=3D 0) {
 			pr_err("no memory resource ?\n");
+			pci_dev_put(my_dev);
 			return NULL;
 		}
 	} else {
@@ -119,13 +120,16 @@ static void atir_set_use_dec(void *data)
 int init_module(void)
 {
 	struct pci_dev *pdev;
+	int rc;
=20
 	pdev =3D do_pci_probe();
 	if (pdev =3D=3D NULL)
 		return -ENODEV;
=20
-	if (!atir_init_start())
-		return -ENODEV;
+	if (!atir_init_start()) {
+		rc =3D -ENODEV;
+		goto err_put_dev;
+	}
=20
 	strcpy(atir_driver.name, "ATIR");
 	atir_driver.minor       =3D -1;
@@ -141,17 +145,28 @@ int init_module(void)
 	atir_minor =3D lirc_register_driver(&atir_driver);
 	if (atir_minor < 0) {
 		pr_err("failed to register driver!\n");
-		return atir_minor;
+		rc =3D atir_minor;
+		goto err_unmap;
 	}
 	dprintk("driver is registered on minor %d\n", atir_minor);
=20
 	return 0;
+
+err_unmap:
+	iounmap(pci_addr_lin);
+err_put_dev:
+	pci_dev_put(pdev);
+	return rc;
 }
=20

 void cleanup_module(void)
 {
+	struct pci_dev *pdev =3D to_pci_dev(atir_driver.dev);
+
 	lirc_unregister_driver(atir_minor);
+	iounmap(pci_addr_lin);
+	pci_dev_put(pdev);
 }
=20




--=-DIyw3uy737LanNnFtfwB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiftH+e/yOyVhhEJAQoAWQ/8CIcRFxJQzR40XnQ69vtBiIcUkzn6mMGH
+3htOc0SOKmrLRItCvPDBiycQLUWdJA9xLOdNjBJ9Anoz3xXhnr5DToYOoReRPTO
Ieb73NBCwo8L8Zd9iaCmc2uzHahKpYW7JPP/nyA22j76qeYsIhBf8dcm0ojOL/Wk
TrU5VkVozfJviCTndtrKvuKtl8avfVu20fX2kz5pWqjb1rmVtKkmoHV5U6OWmR4S
QkU3A3DBkMETrXAezEYUyzaFRiWK2+BLB3IbjnWYsvjNufn3EPXFg8xKGQOL+5ig
JIgqudqjaibH8bVZnb6uJeqxETWWyZSmkwRrKGzWm0uJmZT5Ya10JqVmhRLlZC+9
fzqOqSZ35rzX6I0sd6KzsVU4d8wmLDR11i9P9a8FCxV01+8hikFp+zirbxMkIlyF
bsf0099f02ml/02cajjkzGeBA0GllLTLFTZ0U+1n7mv2M0TUHAc/N0blLKRzXzVi
Ex0wn7DILtdY/+bsV96dtzXC5GQG92VrXCh4y5q9ZG8YUeGKPwRa5B5gEdljsAj7
FWBVcZ2/lumHN38QwfzkPOUUv4qWa1zTETTlFb24tuPVzsEw8MPMXP4r6xUQl9iH
8EcC9BHBmAAGnqFoNGpqtH95eoq69GTLe3582sju7K2OYI9WY1cg2kF/Ou6Z1IU3
eShDolrxkHU=
=iIko
-----END PGP SIGNATURE-----

--=-DIyw3uy737LanNnFtfwB--
