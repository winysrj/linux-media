Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:35396 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab3BKU7i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 15:59:38 -0500
Date: Mon, 11 Feb 2013 21:59:19 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: Re: [git:v4l-dvb/for_v3.9] [media] fc0011: Return early, if the
 frequency is already tuned
Message-ID: <20130211215919.344d30ee@milhouse>
In-Reply-To: <E1U3tzD-0007O1-4M@www.linuxtv.org>
References: <E1U3tzD-0007O1-4M@www.linuxtv.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Hg=JqvqIVp=qJby.7Nec=kO"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Hg=JqvqIVp=qJby.7Nec=kO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Can you please revert this one again? It might cause issues if the dvb devi=
ce
is reset/reinitialized.


On Fri, 08 Feb 2013 20:51:36 +0100
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> This is an automatic generated email to let you know that the following p=
atch were queued at the=20
> http://git.linuxtv.org/media_tree.git tree:
>=20
> Subject: [media] fc0011: Return early, if the frequency is already tuned
> Author:  Michael B=C3=83=C2=BCsch <m@bues.ch>
> Date:    Thu Feb 7 12:21:06 2013 -0300
>=20
> Return early, if we already tuned to a frequency.
>=20
> Signed-off-by: Michael Buesch <m@bues.ch>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>=20
>  drivers/media/tuners/fc0011.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> ---
>=20
> http://git.linuxtv.org/media_tree.git?a=3Dcommitdiff;h=3Da92591a7112042f9=
2b609be42bc332d989776e9b
>=20
> diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
> index 3932aa8..18caab1 100644
> --- a/drivers/media/tuners/fc0011.c
> +++ b/drivers/media/tuners/fc0011.c
> @@ -187,6 +187,9 @@ static int fc0011_set_params(struct dvb_frontend *fe)
>  	u8 fa, fp, vco_sel, vco_cal;
>  	u8 regs[FC11_NR_REGS] =3D { };
> =20
> +	if (priv->frequency =3D=3D p->frequency)
> +		return 0;
> +
>  	regs[FC11_REG_7] =3D 0x0F;
>  	regs[FC11_REG_8] =3D 0x3E;
>  	regs[FC11_REG_10] =3D 0xB8;
>=20



--=20
Greetings, Michael.

PGP: 908D8B0E

--Sig_/Hg=JqvqIVp=qJby.7Nec=kO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGVunAAoJEPUyvh2QjYsO4QIP/3/ZUiZsaRJGE6rOfpJVhhS2
aPbQwj2cvXRADb3D9XuTO87MOQ7jdfb0Jr6600r8Ht7okt8s58jh9bTjf4r7X18d
0t53i68wbo4r3LuPLNkh6i9Wk21oVgA9FW7IOigkWauAQCOUrGk8Oz/EepFGd/id
GpDyDyjaHoLQnSKnAfmZ88f48JcIGooBu1TcjomyTN8281sflCek20Afj5LiHGek
N7jimb6T2Npi0hUjoXbj1xKA7SxWV3DKP6ldb5BM+sj1aHO0o7Trv9Q5ApRFqCtS
fK5fn+KK3qZdj2CLfXJRwKWYua49TFpgnEIHdt6BdCPUCuyQX9pA0LUClkGAvBdD
8PGn2MowHtUiuftVx/BzXnAeLLPjeURAtMMtCfnACEvd4W99mnzdw3X6NHhO4ARm
va36dD3yl0AkGc3gaMymcinXRyQPymn6trFKTywnZo6KmV/NpdJGgxBPbI5ythNo
6894gTboSGt79GoPqse9Kai65ycNyMEo7aWDi0uUtVtqj1LrhXg2dm1trX2+TkuF
tldzK5Hpz/5oci3cUyVUnI6S4sBAImIDwdqNpFQSVJdEwa6FN10ECZVa8+u24yxY
A7cLuuk+w9xwfjOaSa8jIFt2oR4wsMaGMbq0WPmZSfWaFQgmjjYEeE6ejc4iyArm
lPnvbgTZfYRRmns9J9N6
=MV8D
-----END PGP SIGNATURE-----

--Sig_/Hg=JqvqIVp=qJby.7Nec=kO--
