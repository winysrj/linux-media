Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45615 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab2HSVZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 17:25:12 -0400
Message-ID: <1345411489.22400.76.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] [media] rc: ite-cir: Initialise ite_dev::rdev earlier
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: YunQiang Su <wzssyqa@gmail.com>, 684441@bugs.debian.org,
	Jarod Wilson <jarod@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Luis Henriques <luis.henriques@canonical.com>
Date: Sun, 19 Aug 2012 22:24:49 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-q4+KuiOpLt1AvsOwceik"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-q4+KuiOpLt1AvsOwceik
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ite_dev::rdev is currently initialised in ite_probe() after
rc_register_device() returns.  If a newly registered device is opened
quickly enough, we may enable interrupts and try to use ite_dev::rdev
before it has been initialised.  Move it up to the earliest point we
can, right after calling rc_allocate_device().

References: http://bugs.debian.org/684441
Reported-and-tested-by: YunQiang Su <wzssyqa@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
 drivers/media/rc/ite-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 0e49c99..c06992e 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1473,6 +1473,7 @@ static int ite_probe(struct pnp_dev *pdev, const stru=
ct pnp_device_id
 	rdev =3D rc_allocate_device();
 	if (!rdev)
 		goto failure;
+	itdev->rdev =3D rdev;
=20
 	ret =3D -ENODEV;
=20
@@ -1604,7 +1605,6 @@ static int ite_probe(struct pnp_dev *pdev, const stru=
ct pnp_device_id
 	if (ret)
 		goto failure;
=20
-	itdev->rdev =3D rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
=20
 	return 0;


--=-q4+KuiOpLt1AvsOwceik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDFZoee/yOyVhhEJAQobpg//dXxyhLOgDEwbQwz6qhcGspFpu4qf4IoM
ih6Ra1+JJzAXgY34TiNOLy/7KU2mguVVADJr7fXwNaOeI7bzkiXl24/Zp7CimPf+
LqB/RMHL5qXdXduis1Ytt37777IcJMFJSfntFJ9Da10zjfRA8MkTnQQeZ+oB9rVV
G1SWoxjvjsrCqLS20kokRom0AbzJRzw95n0GVoIf+4TMvAQIOZzubFMFB7OZca3K
RxfCxlmGFVr8mU8yZE1Nguhln413DuyqLw2hxPYzGKF3LUZjcCWfki6+Gl96QIXK
SFeYZZTaq6/jo0FI/veNZafEQJwykXXdacg7s+3WO6wD9K0FQTRtWVP7z1mEeDt7
DzSdHx78Wc18Zg+rNeb2Y58jtqrveuncx6H9IajJJmypR5RzOtg9a9xtrs+ys34R
tfR2vCvryIXvIHNi98BSwQFWT9xy6OVxVUA/3H1wzefHjkgDfczIeSTZJQybLEql
k/aWPjBYL/xh9CfzACnENLNneVmYes6pnid8NON9Q7ygizAmG8njLJEtalt0ebWK
T4+6es6rFJzEvJmKOhLIf4Zo0RVzmqcLXF89YA4XtSNYtbV1uoGQr3Isxag+XGBc
OvNmNozfa+LHwlccCvcJCEH3vSEgvNGv+zwWNXRZyyifcslzAetRio2PvIi/utNy
BdJQWfQoQ5k=
=RnRc
-----END PGP SIGNATURE-----

--=-q4+KuiOpLt1AvsOwceik--
