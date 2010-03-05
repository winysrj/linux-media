Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:3887 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0CEQSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Mar 2010 11:18:41 -0500
Date: Fri, 5 Mar 2010 17:18:29 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jim Paris <jim@jtan.com>
Cc: "M.Ebrahimi" <m.ebrahimi@ieee.org>, Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-Id: <20100305171829.03d32cbc.ospite@studenti.unina.it>
In-Reply-To: <20100304201445.GA21194@psychosis.jim.sh>
References: <20100228194951.1c1e26ce@tele>
	<20100228201850.81f7904a.ospite@studenti.unina.it>
	<20100228205528.54d1ba69@tele>
	<1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
	<20100302163937.70a15c19.ospite@studenti.unina.it>
	<7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
	<1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
	<20100303090008.f94e7789.ospite@studenti.unina.it>
	<20100304045533.GA17821@psychosis.jim.sh>
	<20100304100346.79818884.ospite@studenti.unina.it>
	<20100304201445.GA21194@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Mar_2010_17_18_29_+0100_3O0H9gpYoJTNmti."
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__5_Mar_2010_17_18_29_+0100_3O0H9gpYoJTNmti.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Mar 2010 15:14:45 -0500
Jim Paris <jim@jtan.com> wrote:

> > On Wed, 3 Mar 2010 23:55:33 -0500
> > Jim Paris <jim@jtan.com> wrote:
> >=20
> > > Antonio Ospite wrote:
[...]
> > > > It would be interesting to see how Powerline Frequency filtering
> > > > is done on PS3. I added Jim Paris on CC.
> > >=20
> > > I can open up the camera and sniff the I2C bus instead.  It'll take
> > > a little longer.
> > >
[...]
> Looks like Mosalam's patch is correct:
>=20
> --- i2c-60hz.log	2010-03-04 15:09:23.000000000 -0500
> +++ i2c-50hz.log	2010-03-04 15:09:27.000000000 -0500
> @@ -69,7 +69,7 @@
>  ov_write_verify 8C E8
>  ov_write_verify 8D 20
>  ov_write_verify 0C 90
> -ov_write_verify 2B 00
> +ov_write_verify 2B 9E
>  ov_write_verify 22 7F
>  ov_write_verify 23 03
>  ov_write_verify 11 01
>=20

OK, thanks.
I am sending a v2 for patch 10/11 as well, using DISABLED/50Hz as
choices.

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

--Signature=_Fri__5_Mar_2010_17_18_29_+0100_3O0H9gpYoJTNmti.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuRLtUACgkQ5xr2akVTsAHf8wCeIACFJrpFaRVu7wW0GF4TM73K
9wgAn1cvXeYjBcKfsPLyXfPuRAHyIAy9
=b9L0
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Mar_2010_17_18_29_+0100_3O0H9gpYoJTNmti.--
