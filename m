Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46463 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2HSXcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 19:32:43 -0400
Message-ID: <1345419147.22400.78.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2] [media] rc: ite-cir: Initialise ite_dev::rdev earlier
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: YunQiang Su <wzssyqa@gmail.com>, 684441@bugs.debian.org,
	Jarod Wilson <jarod@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Luis Henriques <luis.henriques@canonical.com>
Date: Mon, 20 Aug 2012 00:32:27 +0100
In-Reply-To: <1345411489.22400.76.camel@deadeye.wl.decadent.org.uk>
References: <1345411489.22400.76.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5Lhi4OkxEGFA9/sEqpjU"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-5Lhi4OkxEGFA9/sEqpjU
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
Unlike the previous version, this will apply cleanly to the media
staging/for_v3.6 branch.

Ben.

 drivers/media/rc/ite-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 36fe5a3..24c77a4 100644
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
 		goto failure3;
=20
-	itdev->rdev =3D rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
=20
 	return 0;


--=-5Lhi4OkxEGFA9/sEqpjU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDF3i+e/yOyVhhEJAQrcCQ//SKkjXSAsVvcM+W5ADiuXh0NuiXSCXFgb
8epuLwy0Gka/+neqc5zOHVEpM4PZhDhhRNtQe9Gee4qFJTxGLn0He1z9i+L2e9Dy
9ewfKP1ECHsAcJALxUyHBlhJlOUg+Wp4UDAEapO27Q1yczw5rhXF6EB4mYjxHCMN
KWqwyohohMy6iyfvdUPbV1o1IongPfrCJCGfWAbWe1R2tH1IsefrnsXjg6JEXmpG
FP5b1foDfTe2debBI2v6oyXOIw+okzjxSscWk249wjMBMUWhoeso9VOfOfcsFVId
is7Lbs9AzUJ7Qag0+vps+ZdP6SFK+jyTFrm/BZdFnrnYUIdNhY3ITMsMcdqQG5WE
cSJGVOHoPU6A2+GhBTgascJbGI/yH8eUAmAFa/n26ZpV4yxv1VFBdQtsW1FjWon/
VKu+CIVt7J5uy9Pk9ZqkoGgT8Mq7vjWGi0l2tYcyHV9nyv8Vs09Y9LFcK5BgApHs
hB6o8sSMvQL9vBvCYgY4ofA4t6Wsv6wo28F7mEuIBhVKh9QcrWmH0X9h3e7xRtBD
AYyMfSayvKa8z91OrUn8P05T5t/Lv9BiFw9QPfPx9IHtUf9aWwril76Q2PEYMAqC
36lE6QNqThHBhMMXenY4mc0UTVY9A36bjs/QaaE03ZfziUtdxqqmvufgoAMwH/Rp
XSOPwdlpgtM=
=GeEZ
-----END PGP SIGNATURE-----

--=-5Lhi4OkxEGFA9/sEqpjU--
