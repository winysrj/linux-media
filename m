Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60586 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553Ab3IBAkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 20:40:46 -0400
Message-ID: <1378082443.25743.63.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 4/4] [media] lirc_bt829: Enable and disable memory BAR
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 02 Sep 2013 01:40:43 +0100
In-Reply-To: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AQT1iDXpB2yQ5i/71rj2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-AQT1iDXpB2yQ5i/71rj2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We must not assume that the PCI device is already enabled.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index 76e6cfb..b386628 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -118,11 +118,15 @@ static int atir_pci_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "memory at 0x%08llX\n",
 		 (unsigned long long)pci_addr_phys);
=20
+	rc =3D pci_enable_device_mem(pdev);
+	if (rc)
+		goto err_free;
+
 	atir->pci_addr_lin =3D ioremap(pci_addr_phys + DATA_PCI_OFF, 0x400);
 	if (atir->pci_addr_lin =3D=3D 0) {
 		dev_err(&pdev->dev, "pci mem must be mapped\n");
 		rc =3D -ENODEV;
-		goto err_free;
+		goto err_disable;
 	}
=20
 	strcpy(atir->driver.name, "ATIR");
@@ -148,6 +152,8 @@ static int atir_pci_probe(struct pci_dev *pdev,
=20
 err_unmap:
 	iounmap(atir->pci_addr_lin);
+err_disable:
+	pci_disable_device(pdev);
 err_free:
 	pci_set_drvdata(pdev, NULL);
 	kfree(atir);
@@ -161,6 +167,7 @@ static void atir_pci_remove(struct pci_dev *pdev)
=20
 	lirc_unregister_driver(atir->minor);
 	iounmap(atir->pci_addr_lin);
+	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	kfree(atir);
 }


--=-AQT1iDXpB2yQ5i/71rj2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPei+e/yOyVhhEJAQpq7A//ZnRwkBAKEo7+8cPpdsSgDHQvopW48cSC
YnPK5qz2gCpJ07wNM198QavPk/PMV6J9hjGXaiTWngbZ4cJ042AX49+2YBtiZBrh
FgQHUb8xoMW8PDozzsQJzJtW3JqJA00eP0ARt0CBJ6z4qEdfySBI3XtjCd6oE9cH
yFMs8aFjWJ+TSbVeNDxvn3/ZGYfBZIFkUDTJl6/GCPmFsXy7yncR56I65k56LZYw
kf/CkAUV85+23mwAfo6JBTPZByHogGzcWQHUYhJhb0zyrYcI7mSmmb+mIHhjoben
rNWQP2CIIb2OEksIzTXyB1WxgiyT1DViILNgyV+DFIQKxHOxStkGG1iBvQVzz3YT
/8T0+RnLCjRH3T7W02MYvPcIXia2Vbc4xH+epTlP7Hc4tVyYyBEIQpo4ef5iyIF7
BblgbJQbQusnVOYDZBHTzUcCbUzg4ww3k+2VsPl5wQvUHqoFZlAL69Juwo/1xZqZ
UJdrRLJpIzV3KFtHiYRv7EV3JtoSwGSl87f5j1hpSl5lqScAGhE9pj2Zr74Hl+Kr
IdxMn28UsEK8tpd3y0gsHJx/73jgDUd3MYHxYqSGbtB70S/Yuapia5UsYGdCMSRo
3l783Tre7vu1LenGOl3LbBokJuJ4wIJJ6R+Wsg56h8FFUTSRm6IMsgGit4E7oSeN
co3CdmFh0cc=
=zIFF
-----END PGP SIGNATURE-----

--=-AQT1iDXpB2yQ5i/71rj2--
