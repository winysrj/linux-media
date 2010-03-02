Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:4530 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0CBPju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 10:39:50 -0500
Date: Tue, 2 Mar 2010 16:39:37 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: "M.Ebrahimi" <m.ebrahimi@ieee.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-Id: <20100302163937.70a15c19.ospite@studenti.unina.it>
In-Reply-To: <1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele>
	<20100228201850.81f7904a.ospite@studenti.unina.it>
	<20100228205528.54d1ba69@tele>
	<1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Mar_2010_16_39_37_+0100_=vpuLo+V25xI1.XB"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__2_Mar_2010_16_39_37_+0100_=vpuLo+V25xI1.XB
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Mar 2010 11:26:15 +0000
"M.Ebrahimi" <m.ebrahimi@ieee.org> wrote:

> On 28 February 2010 19:55, Jean-Francois Moine <moinejf@free.fr> wrote:
> > On Sun, 28 Feb 2010 20:18:50 +0100
> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> >
> >> Maybe we could just use
> >> =A0 =A0 =A0 V4L2_CID_POWER_LINE_FREQUENCY_DISABLED =A0=3D 0,
> >> =A0 =A0 =A0 V4L2_CID_POWER_LINE_FREQUENCY_50HZ =A0 =A0 =A0=3D 1,
> >>
> >> It looks like the code matches the DISABLED state (writing 0 to the
> >> register). Mosalam?
> >
> > I don't know the ov772x sensor. I think it should look like the ov7670
> > where there are 3 registers to control the light frequency: one
> > register tells if light frequency filter must be used, and which
> > frequency 50Hz or 60Hz; the two other ones give the filter values for
> > each frequency.
> >
>=20
> I think it's safe to go with disabled/50hz. Perhaps later if needed
> can patch it to control the filter values. Since it seems there is no
> flickering in the 60hz regions at available frame rates, and this
> register almost perfectly removes light flickers in the 50hz regions
> (by modifying exposure/frame rate).
>
> Mosalam
>

Mosalam did you spot the register from a PS3 usb dump or by looking at
the sensor datasheet?

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

--Signature=_Tue__2_Mar_2010_16_39_37_+0100_=vpuLo+V25xI1.XB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuNMTkACgkQ5xr2akVTsAE7cQCePP0E6261pO93hvwgH5wjTddQ
qQQAoJyJ9eFdqETlto/MtEXyEKp52w9o
=zQFi
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Mar_2010_16_39_37_+0100_=vpuLo+V25xI1.XB--
