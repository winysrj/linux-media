Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:1971 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbZKDLfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 06:35:43 -0500
Date: Wed, 4 Nov 2009 12:35:36 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX
 phones
Message-Id: <20091104123536.9b95d161.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0911040907400.4837@axis700.grange>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
	<Pine.LNX.4.64.0911040907400.4837@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Nov_2009_12_35_37_+0100_LZaZQyl_4if/pVXy"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__4_Nov_2009_12_35_37_+0100_LZaZQyl_4if/pVXy
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Nov 2009 09:13:16 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Wed, 4 Nov 2009, Eric Miao wrote:
>=20
> > Hi Antonio,
> >=20
> > Patch looks generally OK except for the MFP/GPIO usage, check my
> > comments below, thanks.
> >=20
> > > +/* camera */
> > > +static int a780_pxacamera_init(struct device *dev)
> > > +{
> > > + =A0 =A0 =A0 int err;
> > > +
> > > + =A0 =A0 =A0 /*
> > > + =A0 =A0 =A0 =A0* GPIO50_GPIO is CAM_EN: active low
> > > + =A0 =A0 =A0 =A0* GPIO19_GPIO is CAM_RST: active high
> > > + =A0 =A0 =A0 =A0*/
> > > + =A0 =A0 =A0 err =3D gpio_request(MFP_PIN_GPIO50, "nCAM_EN");
> >=20
> > Mmm... MFP !=3D GPIO, so this probably should be written simply as:
> >=20
> > #define GPIO_nCAM_EN	(50)
>=20
> ...but without parenthesis, please:
>=20
> #define GPIO_nCAM_EN	50
>=20
> same everywhere below
>

OK.

BTW, Guennadi, shouldn't the pxa_camera platform_data expose also an
exit() method for symmetry with the init() one, where we can free the
requested resources?

If you want I think I can add it.

[...]
> > > +
> > > +static int a780_pxacamera_power(struct device *dev, int on)
> > > +{
> > > + =A0 =A0 =A0 gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);
> >=20
> > 	gpio_set_value(GPIO_nCAM_EN, on ? 0 : 1);
>=20
> IMHO better yet
>=20
> 	gpio_set_value(GPIO_nCAM_EN, !on);
>=20
> Also throughout the patch below.
>=20
> I'm still to look at it miself and maybe provide a couple more comments,=
=20
> if any.
>=20

Ok, thanks,
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

--Signature=_Wed__4_Nov_2009_12_35_37_+0100_LZaZQyl_4if/pVXy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrxZwkACgkQ5xr2akVTsAFBtQCghtCBFpkQ6MtGhSdBFMq3Mxqa
3wIAn3E5aeD/Km+S/st3w9vCZvqRnz7W
=n2xF
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Nov_2009_12_35_37_+0100_LZaZQyl_4if/pVXy--
