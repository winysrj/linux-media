Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44445 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab3IECbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 22:31:18 -0400
Message-ID: <1378348275.27597.15.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2 1/4] [media] lirc_bt829: Fix physical address type
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Fabio Estevam <festevam@gmail.com>
Date: Thu, 05 Sep 2013 03:31:15 +0100
In-Reply-To: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
References: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8hLRTVJ+K880ILx95sXy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8hLRTVJ+K880ILx95sXy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Use phys_addr_t and log format %pa.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index fa31ee7..9c7be55 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -63,7 +63,7 @@ static bool debug;
 	} while (0)
=20
 static int atir_minor;
-static unsigned long pci_addr_phys;
+static phys_addr_t pci_addr_phys;
 static unsigned char *pci_addr_lin;
=20
 static struct lirc_driver atir_driver;
@@ -78,8 +78,7 @@ static struct pci_dev *do_pci_probe(void)
 		pci_addr_phys =3D 0;
 		if (my_dev->resource[0].flags & IORESOURCE_MEM) {
 			pci_addr_phys =3D my_dev->resource[0].start;
-			pr_info("memory at 0x%08X\n",
-			       (unsigned int)pci_addr_phys);
+			pr_info("memory at %pa\n", &pci_addr_phys);
 		}
 		if (pci_addr_phys =3D=3D 0) {
 			pr_err("no memory resource ?\n");



--=-8hLRTVJ+K880ILx95sXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUifs8+e/yOyVhhEJAQr2iBAAqutCcVj4OOyPeju58YVy/7+1l5w9L0iV
q6uLruMM4j3mjzqp41NN2yS41ipFX+KkSMafDkPQI9Or7V0DnOEC91zKbd65ZkVx
rs11DFF9cBDI71M4vRGPsuG4kK6HFaIKiqmrVV/SRDAHDGchbHwzgzK/mNNk9FvP
2TzdH4pmUzN7YxNK2A71ykRCUPkHVUUEfHJcnebvFxVErd4oNPmwrQ9TlUtmhF2g
dn1UwROhKa/UKlkZAfPyZiORXVipdrA7aeueU4XKMzGG5in5MbZvlGhakUnCuy+j
0dUCdXrHaBD5j4NLu2PQsHlv+N0CQgNmOXFrn3493eX++3a1EXZ96aROeJRGSkOJ
jRdNRD64MI1cxECY/2wGbHrfAKpdF0fPKb4oqwIPjNRcXXPGghMuu807m7C3g1FX
nRuZiZP032J1VPr6ORzbwg4eW08PMkLVXtdbFHfTB5BooYAZ1DXimxddYmGNgIiE
MCZN1oEk70rD8R+M3/nx2yL3cYr3Xsc77AgZbxDKl1MsDFmSt9VWgTcTt19c0vAV
lIyoh1iwkAUBQIBEAy5d7MrSazrLHgHdp1C52uS+eUxCoHY/sCPXkJ2ulfRwFaSk
+XTqUbicOBicziJVyNMsk4e2O/rzduafItTmlVlWQ7fzXDAnm2WCK+clbucMr1Oh
fQ298sTXX+0=
=Apy0
-----END PGP SIGNATURE-----

--=-8hLRTVJ+K880ILx95sXy--
