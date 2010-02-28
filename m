Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:1142 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0B1SzH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 13:55:07 -0500
Date: Sun, 28 Feb 2010 19:54:25 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 05/11] ov534: Fix setting manual exposure
Message-Id: <20100228195425.0be36259.ospite@studenti.unina.it>
In-Reply-To: <20100228193814.34f6755f@tele>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-6-git-send-email-ospite@studenti.unina.it>
	<20100228193814.34f6755f@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_19_54_26_+0100_zW0uUlxVyHczl/Ji"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sun__28_Feb_2010_19_54_26_+0100_zW0uUlxVyHczl/Ji
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Feb 2010 19:38:14 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Sat, 27 Feb 2010 21:20:22 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > Exposure is now a u16 value, both MSB and LSB are set, but values in
> > the v4l2 control are limited to the interval [0,506] as 0x01fa (506)
> > is the maximum observed value with AEC enabled.
> 	[snip]
> >  	    .type    =3D V4L2_CTRL_TYPE_INTEGER,
> >  	    .name    =3D "Exposure",
> >  	    .minimum =3D 0,
> > -	    .maximum =3D 255,
> > +	    .maximum =3D 506,
> >  	    .step    =3D 1,
> >  #define EXPO_DEF 120
> >  	    .default_value =3D EXPO_DEF,
>=20
> Hi Antonio,
>=20
> Do we need a so high precision for the exposure? Just setting the
> maximum value to 253 should solve the problem.
>

JF, the intent here is to cover all the range of values available in
Auto Exposure mode too, doesn't this make sense to you?

I could set .maximum to 253 to limit the "UI" control precision but then
I should use 2*value when setting the registers in order to cover the
actual max value, this looks a little unclean.

Anyhow, let me know what you prefer, I have no strong feelings on that.
If you want to save a byte, I'll agree.

Regards,
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

--Signature=_Sun__28_Feb_2010_19_54_26_+0100_zW0uUlxVyHczl/Ji
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuKu+IACgkQ5xr2akVTsAG1dgCgqoPzyjXvebWKh6/pl8mjtkps
IGUAn1FRuZSwiNHSHE9zJnZ2Ejh/9BuA
=xB2Y
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_19_54_26_+0100_zW0uUlxVyHczl/Ji--
