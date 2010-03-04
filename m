Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:3618 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab0CDJEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 04:04:01 -0500
Date: Thu, 4 Mar 2010 10:03:46 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jim Paris <jim@jtan.com>
Cc: "M.Ebrahimi" <m.ebrahimi@ieee.org>, Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-Id: <20100304100346.79818884.ospite@studenti.unina.it>
In-Reply-To: <20100304045533.GA17821@psychosis.jim.sh>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele>
	<20100228201850.81f7904a.ospite@studenti.unina.it>
	<20100228205528.54d1ba69@tele>
	<1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
	<20100302163937.70a15c19.ospite@studenti.unina.it>
	<7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
	<1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
	<20100303090008.f94e7789.ospite@studenti.unina.it>
	<20100304045533.GA17821@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Mar_2010_10_03_47_+0100_Y.f9+g_//Nd.jA=3"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Thu__4_Mar_2010_10_03_47_+0100_Y.f9+g_//Nd.jA=3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Mar 2010 23:55:33 -0500
Jim Paris <jim@jtan.com> wrote:

> Antonio Ospite wrote:
[...]
> >=20
> > I see. It would be interesting to see how Powerline Frequency filtering
> > is done on PS3. I added Jim Paris on CC.
>=20
> Hi Antonio and Mosalam,
>=20
> I tried, but I can't capture that.  My USB logger only does USB 1.1,
> which is too slow for the camera to run normally, but good enough to
> see the initialization sequence.  However, the 50/60Hz option only
> appears later, once the PS3 is receiving good frame data.
>=20
> I can open up the camera and sniff the I2C bus instead.  It'll take
> a little longer.
>

Thanks for your time Jim.

> Interesting side note, the only change in the initialization sequence
> between PS3 firmware 1.93 and 3.15 is 0x0C bit 6 -- horizontal flip :)
> So they haven't made any improvements that we can borrow.
>
> -jim
>=20

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

--Signature=_Thu__4_Mar_2010_10_03_47_+0100_Y.f9+g_//Nd.jA=3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuPd3MACgkQ5xr2akVTsAFzmgCffo8EQiAzFZi7xw/TJoMhGNCQ
UMoAoJSnC6M6hZHvWA7Nev7XE+EmyP43
=WCLK
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Mar_2010_10_03_47_+0100_Y.f9+g_//Nd.jA=3--
