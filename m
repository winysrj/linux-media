Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60571 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757685Ab3IBAji (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 20:39:38 -0400
Message-ID: <1378082375.25743.61.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 2/4] [media] lirc_bt829: Fix physical address type
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 02 Sep 2013 01:39:35 +0100
In-Reply-To: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ianetA6kqmwZfYlSXePX"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ianetA6kqmwZfYlSXePX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index c277bf3..8c5ba2a 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -99,7 +99,7 @@ static int atir_pci_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *entry)
 {
 	struct atir_device *atir;
-	unsigned long pci_addr_phys;
+	phys_addr_t pci_addr_phys;
 	int rc;
=20
 	atir =3D kzalloc(sizeof(*atir), GFP_KERNEL);
@@ -115,8 +115,8 @@ static int atir_pci_probe(struct pci_dev *pdev,
 	}
=20
 	pci_addr_phys =3D pdev->resource[0].start;
-	dev_info(&pdev->dev, "memory at 0x%08X\n",
-		 (unsigned int)pci_addr_phys);
+	dev_info(&pdev->dev, "memory at 0x%08llX\n",
+		 (unsigned long long)pci_addr_phys);
=20
 	atir->pci_addr_lin =3D ioremap(pci_addr_phys + DATA_PCI_OFF, 0x400);
 	if (atir->pci_addr_lin =3D=3D 0) {



--=-ianetA6kqmwZfYlSXePX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPeR+e/yOyVhhEJAQrhXhAAvV+LqHC3AzWebTwv0HOaJGXAaObymMDW
GOgXdl31athN3YXGIhD8+bG8YwFQJIvUYorWwEMjUfHQTJIF/xlB0Ae+xo8Q81RX
S7ynHPjhN55e2mhC/qcMuoNfUmAnS/3BNzWEKC5o7dgu74itvGcZXO22t+nmIPu+
jgzLyvwiG55N2S3w8BKxYqvvKpnfC6LFgSbE+WcXm6/t1XWFj/WK9nWmJyKYbrv5
WHurvLTxoo5gDd4XAXTd3gXRpJjAR7Q12c0NLGfaZUtV8lmcRHA6STCeMQ58Rlq7
R71EFQz0GAkDsAEIvVWV0dEkry9/ELr24FYmX03vZvVH+TMN9oqxucmxanZy6nDG
7/PDvb+jXKDBvqlgGjLVDEjGmfPl34IHEqKBGD+Kr7hYrwt6XKrUmj+R9JrjocPB
wUxDF9bNgjqWHCCy5oLu/qn/TwqfAQJTNraLsA3NnmsM6Xx3jeCkzw9HtAk7NgS+
pL//1kyrDrBRDgcqDaUg1cH7uGY0Nli64VM54Eu51f3plmBYxsVg+fL6F2tqQQQo
yEnPLyscSpjPI9Uwf9+m5l1oh/a8gZfgV5hDh7PoJnsr+Q2w7xd9mhpQtUiaBFLt
3jYv4bPa70fThsYEen/sRqKEOmyuONxJHsonSkMidvZqP9YgsZzsxZoavU9fE6YN
4f/vfLWejXw=
=vnIX
-----END PGP SIGNATURE-----

--=-ianetA6kqmwZfYlSXePX--
