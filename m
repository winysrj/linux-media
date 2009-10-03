Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:2694 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbZJCONd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 10:13:33 -0400
Date: Sat, 3 Oct 2009 16:13:28 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  Failed to configure for format 50323234
Message-Id: <20091003161328.36419315.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0910030116270.12093@axis700.grange>
References: <20091002213530.104a5009.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0910030116270.12093@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_Oct_2009_16_13_28_+0200_djC8Imc1UFSCZZx6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sat__3_Oct_2009_16_13_28_+0200_djC8Imc1UFSCZZx6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Oct 2009 01:27:04 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Fri, 2 Oct 2009, Antonio Ospite wrote:
>=20
> > Hi,
> >=20
> > after updating to 2.6.32-rc2 I can't capture anymore with the setup in =
the
> > subject.
>=20
> Indeed:-( Please, verify, that this patch fixes your problem (completely=
=20
> untested), if it does, I'll push it for 2.6.32:
>=20
> pxa_camera: fix camera pixel format configuration
>=20
> A typo prevents correct picel format negotiation with client drivers.
>

typo in the log message too :) s/picel/pixel/
=20
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_c=
amera.c
> index 6952e96..aa831d5 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -1432,7 +1432,9 @@ static int pxa_camera_set_fmt(struct soc_camera_dev=
ice *icd,
>  		icd->sense =3D &sense;
> =20
>  	cam_f.fmt.pix.pixelformat =3D cam_fmt->fourcc;
> -	ret =3D v4l2_subdev_call(sd, video, s_fmt, f);
> +	ret =3D v4l2_subdev_call(sd, video, s_fmt, &cam_f);
> +	cam_f.fmt.pix.pixelformat =3D pix->pixelformat;
> +	*pix =3D cam_f.fmt.pix;
> =20
>  	icd->sense =3D NULL;

Ok, I can capture again even by only fixing the typo: s/f/&cam_f/
but I don't know if this is complete.

Anyways your patch works, but the picture is now shifted, see:
http://people.openezx.org/ao2/a780-pxa-camera-mt9m111-shifted.jpg

Is this because of the new cropping code?

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

--Signature=_Sat__3_Oct_2009_16_13_28_+0200_djC8Imc1UFSCZZx6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrHXAgACgkQ5xr2akVTsAF+5wCgjrzA724Fz2dppJzM8wIvZEX2
UrwAmQGUcPsjPzzfq/tGlMxhcjIS1ysl
=xMTm
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Oct_2009_16_13_28_+0200_djC8Imc1UFSCZZx6--
