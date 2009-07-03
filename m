Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:2932 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZGCOMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 10:12:45 -0400
Date: Fri, 3 Jul 2009 16:11:40 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <kernel@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera: Oops in pxa_camera_probe.
Message-Id: <20090703161140.845950e8.ospite@studenti.unina.it>
In-Reply-To: <20090701204325.2a277884.ospite@studenti.unina.it>
References: <20090701204325.2a277884.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Jul_2009_16_11_40_+0200_V6crx/DzZYRXOhpK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__3_Jul_2009_16_11_40_+0200_V6crx/DzZYRXOhpK
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__3_Jul_2009_16_11_40_+0200_z4dLFUsGeECIz8fX"


--Multipart=_Fri__3_Jul_2009_16_11_40_+0200_z4dLFUsGeECIz8fX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Jul 2009 20:43:25 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,
>=20
> I get this with pxa-camera in mainline linux (from today).
> I haven't touched my board code which used to work in 2.6.30
>

I think I've tracked down the cause. The board code is triggering a
bug in pxa_camera. The same should apply to mioa701 as well.

> Linux video capture interface: v2.00
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
060
> pgd =3D c0004000
> [00000060] *pgd=3D00000000
> Internal error: Oops: f5 [#1] PREEMPT
> Modules linked in:
> CPU: 0    Tainted: G        W   (2.6.31-rc1-ezxdev #1)
> PC is at dev_driver_string+0x0/0x38
> LR is at pxa_camera_probe+0x144/0x428

The offending dev_driver_str() here is the one in the dev_warn() call in
mclk_get_divisor().

This is what is happening: in struct pxacamera_platform_data I have:
	.mclk_10khz =3D 5000,

which makes the > test in mclk_get_divisor() succeed calling dev_warn
to report that the clock has been limited, but pcdev->soc_host.dev is
still uninitialized at this time.

I could lower the value in my platform data and avoid the bug, but it
would be good to have this fixed ASAP anyway.

The attached rough patch fixes the problem, but you will surely come
out with a better one :)

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Multipart=_Fri__3_Jul_2009_16_11_40_+0200_z4dLFUsGeECIz8fX
Content-Type: text/x-diff;
 name="pxa_camera_oops_in_mclk_get_divisor_dev_driver_string.patch"
Content-Disposition: attachment;
 filename="pxa_camera_oops_in_mclk_get_divisor_dev_driver_string.patch"
Content-Transfer-Encoding: quoted-printable

mclk_get_divisor uses pcdev->soc_host.dev, make sure it is initialized.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_cam=
era.c
index 46e0d8a..e048d25 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1579,6 +1579,7 @@ static int __devinit pxa_camera_probe(struct platform=
_device *pdev)
 		pcdev->mclk =3D 20000000;
 	}
=20
+	pcdev->soc_host.dev =3D &pdev->dev;
 	pcdev->mclk_divisor =3D mclk_get_divisor(pcdev);
=20
 	INIT_LIST_HEAD(&pcdev->capture);
@@ -1644,7 +1645,6 @@ static int __devinit pxa_camera_probe(struct platform=
_device *pdev)
 	pcdev->soc_host.drv_name	=3D PXA_CAM_DRV_NAME;
 	pcdev->soc_host.ops		=3D &pxa_soc_camera_host_ops;
 	pcdev->soc_host.priv		=3D pcdev;
-	pcdev->soc_host.dev		=3D &pdev->dev;
 	pcdev->soc_host.nr		=3D pdev->id;
=20
 	err =3D soc_camera_host_register(&pcdev->soc_host);

--Multipart=_Fri__3_Jul_2009_16_11_40_+0200_z4dLFUsGeECIz8fX--

--Signature=_Fri__3_Jul_2009_16_11_40_+0200_V6crx/DzZYRXOhpK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpOEZwACgkQ5xr2akVTsAF95ACfQiffbNxWS1D97BnaPcbxco+N
HQMAnjPG0kgK88NYEebbUvIegKZsf6gQ
=S8bE
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Jul_2009_16_11_40_+0200_V6crx/DzZYRXOhpK--
