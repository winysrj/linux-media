Return-path: <linux-media-owner@vger.kernel.org>
Received: from drsnuggles.stderr.nl ([94.142.244.14]:36603 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2HPIJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 04:09:43 -0400
Date: Thu, 16 Aug 2012 10:09:32 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: (still) NULL pointer crashes with nuvoton_cir driver
Message-ID: <20120816080932.GP21274@login.drsnuggles.stderr.nl>
References: <20120815165153.GJ21274@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kqu4dxz3gYjPH61T"
Content-Disposition: inline
In-Reply-To: <20120815165153.GJ21274@login.drsnuggles.stderr.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Kqu4dxz3gYjPH61T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

> I'm currently compiling a 3.5 kernel with just the rdev initialization
> moved up to see if this will fix my problem at all, but I'd like your
> view on this in the meantime as well.
Ok, this seems to fix my problem:

--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1066,6 +1066,7 @@
        /* tx bits */
        rdev->tx_resolution =3D XYZ;
 #endif
+       nvt->rdev =3D rdev;
=20
        ret =3D -EBUSY;
        /* now claim resources */
@@ -1090,7 +1091,6 @@
                goto failure5;
=20
        device_init_wakeup(&pdev->dev, true);
-       nvt->rdev =3D rdev;
        nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
        if (debug) {
                cir_dump_regs(nvt);


I'm still not sure if the rc_register_device shouldn't also be moved up. It
seems this doesn't trigger a problem right now, but if there is a problem, I
suspect its trigger window is a lot smaller than with the rdev initializati=
on
problem...

Gr.

Matthijs

--Kqu4dxz3gYjPH61T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlAsqrwACgkQz0nQ5oovr7zviACff/cnwoZgLP8Ohniu23KUN6nm
ZMAAoI9onv5l1F8EQALWenmf+XiU6ERA
=7D3v
-----END PGP SIGNATURE-----

--Kqu4dxz3gYjPH61T--
