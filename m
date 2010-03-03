Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:1925 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0CCIAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 03:00:18 -0500
Date: Wed, 3 Mar 2010 09:00:08 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: "M.Ebrahimi" <m.ebrahimi@ieee.org>
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org, Jim Paris <jim@jtan.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-Id: <20100303090008.f94e7789.ospite@studenti.unina.it>
In-Reply-To: <1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele>
	<20100228201850.81f7904a.ospite@studenti.unina.it>
	<20100228205528.54d1ba69@tele>
	<1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
	<20100302163937.70a15c19.ospite@studenti.unina.it>
	<7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
	<1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_09_00_08_+0100_bSe3=UsS9ueaH_bR"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__3_Mar_2010_09_00_08_+0100_bSe3=UsS9ueaH_bR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Mar 2010 02:27:38 +0000
"M.Ebrahimi" <m.ebrahimi@ieee.org> wrote:

> On 2 March 2010 16:06, Max Thrun <bear24rw@gmail.com> wrote:
> >
> >
> > On Tue, Mar 2, 2010 at 10:39 AM, Antonio Ospite <ospite@studenti.unina.=
it>
> > wrote:
[...]
> >> Mosalam did you spot the register from a PS3 usb dump or by looking at
> >> the sensor datasheet?
>=20
> None, I got that register from sniffing a Windows driver for another
> camera that turned out to be using ov7620 or something similar, though
> I thought it has the same sensor. I double checked, this register is
> for frame rate adjustment (decreasing frame rate / increasing
> exposure) . And this has been used in some other drivers (e.g.
> gspca_sonixb) to remove light flicker as well.
>=20

I see. It would be interesting to see how Powerline Frequency filtering
is done on PS3. I added Jim Paris on CC.

> >
> > I'd also like to know where you got the 2b register from, cause someone=
 else
> > also said 2b was filtering but the datasheet says it LSB of dummy pixel=
...
> >
> >- Max Thrun
>=20
> Definitely it is adjusting the frame rate (see the ov7620 DS for the
> description how the register value is used, for instance). I have no
> idea why the ov7720 datasheet says otherwise.
>=20
> Since this patch does not use the banding filter registers mentioned
> in the datasheet maybe should be discarded. I am working on 75 FPS at
> VGA, when I get that working well I can get back to this again.
>=20
> Thanks for the comments.
> Mosalam
>=20

Ok, so Jean-Francois can you apply the patches except 10/11, please?
We are keeping this one for another round.

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

--Signature=_Wed__3_Mar_2010_09_00_08_+0100_bSe3=UsS9ueaH_bR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuOFwgACgkQ5xr2akVTsAFw+QCgjK73zACAAt2I5pVFmZ32LA2P
UOkAniql8Y9ba2u+4dEBELDfv/V3CPGA
=wFhf
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_09_00_08_+0100_bSe3=UsS9ueaH_bR--
