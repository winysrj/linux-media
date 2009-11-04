Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:3048 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZKDJOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 04:14:34 -0500
Date: Wed, 4 Nov 2009 10:14:29 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX
 phones
Message-Id: <20091104101429.23338a42.ospite@studenti.unina.it>
In-Reply-To: <f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Nov_2009_10_14_29_+0100_Dd9EfKLSVewWptbc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__4_Nov_2009_10_14_29_+0100_Dd9EfKLSVewWptbc
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Nov 2009 14:38:40 +0800
Eric Miao <eric.y.miao@gmail.com> wrote:

> Hi Antonio,
>=20
> Patch looks generally OK except for the MFP/GPIO usage, check my
> comments below, thanks.
>

Ok, will resend ASAP. Some questions inlined below after your comments.

> > +/* camera */
> > +static int a780_pxacamera_init(struct device *dev)
> > +{
> > + =A0 =A0 =A0 int err;
> > +
> > + =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0* GPIO50_GPIO is CAM_EN: active low
> > + =A0 =A0 =A0 =A0* GPIO19_GPIO is CAM_RST: active high
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 err =3D gpio_request(MFP_PIN_GPIO50, "nCAM_EN");
>=20
> Mmm... MFP !=3D GPIO, so this probably should be written simply as:
>=20
> #define GPIO_nCAM_EN	(50)
>

If the use of parentheses here is recommended, should I send another
patch to add them to current defines for GPIOs in ezx.c, for style
consistency?

> or (which tends to be more accurate but not necessary)
>=20
> #define GPIO_nCAM_EN	mfp_to_gpio(MFP_PIN_GPIO50)
>

For me it is the same, just tell me if you really prefer this one.

> > +
> > +static int a780_pxacamera_power(struct device *dev, int on)
> > +{
> > + =A0 =A0 =A0 gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);
>=20
> 	gpio_set_value(GPIO_nCAM_EN, on ? 0 : 1);
>=20
> > +
> > +#if 0
> > + =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0* This is reported to resolve the "vertical line in vi=
ew finder"
> > + =A0 =A0 =A0 =A0* issue (LIBff11930), in the original source code rele=
ased by
> > + =A0 =A0 =A0 =A0* Motorola, but we never experienced the problem, so w=
e don't use
> > + =A0 =A0 =A0 =A0* this for now.
> > + =A0 =A0 =A0 =A0*
> > + =A0 =A0 =A0 =A0* AP Kernel camera driver: set TC_MM_EN to low when ca=
mera is running
> > + =A0 =A0 =A0 =A0* and TC_MM_EN to high when camera stops.
> > + =A0 =A0 =A0 =A0*
> > + =A0 =A0 =A0 =A0* BP Software: if TC_MM_EN is low, BP do not shut off =
26M clock, but
> > + =A0 =A0 =A0 =A0* BP can sleep itself.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 gpio_set_value(MFP_PIN_GPIO99, on ? 0 : 1);
> > +#endif
>=20
> This is a little bit confusing - can we remove this for this stage?
>

Ok, I am removing it for now. I might put this note in again in
future, hopefully with a better description.

[...]

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

--Signature=_Wed__4_Nov_2009_10_14_29_+0100_Dd9EfKLSVewWptbc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrxRfUACgkQ5xr2akVTsAGVYgCfWgY97O/HW1fcxTGqZpLsRsPd
WxcAoJAmum6MubGw0EKzRPQZ1am4FsHu
=sDh8
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Nov_2009_10_14_29_+0100_Dd9EfKLSVewWptbc--
