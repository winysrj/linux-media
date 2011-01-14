Return-path: <mchehab@pedra>
Received: from smtp207.alice.it ([82.57.200.103]:44052 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1ANPFv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 10:05:51 -0500
Date: Fri, 14 Jan 2011 16:05:42 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-Id: <20110114160542.f7e8b034.ospite@studenti.unina.it>
In-Reply-To: <20110113173021.1f8a7b8b@tele>
References: <20110113115953.4636c392@tele>
	<20110113123804.d391b10e.ospite@studenti.unina.it>
	<20110113173021.1f8a7b8b@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Jan_2011_16_05_42_+0100_=t6wA48dpq6PUUNY"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Fri__14_Jan_2011_16_05_42_+0100_=t6wA48dpq6PUUNY
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Jan 2011 17:30:21 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Thu, 13 Jan 2011 12:38:04 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > > Jean-Fran=E7ois Moine (9): =20
> > [...]
> > >       gspca - ov534: Use the new video control mechanism =20
> >=20
> > In this commit, is there a reason why you didn't rename also
> > sd_setagc() into setagc() like for the other functions?
> >=20
> > I am going to test the changes and report back if there's anything
> > more, I like the cleanup tho.
>=20
> Hi Antonio,
>=20
> With the new video control mechanism, the '.set_control' function is
> called only when capture is active. Otherwise, the '.set' function is
> called in any case, and here, it activates/inactivates the auto white
> balance control... Oh, I forgot to disable the awb when the agc is
> disabled!
>

So the convention you used for function names is:
 .set =3D sd_setFOO;
and
 .set_control =3D setBAR;

right?

Tested with guvcview, when toggling the Autoexposure control I get this
message:
  control id: 0x009a0901 failed to set (error -1)
  control id: 0x009a0901 failed to get value (error -1)

Similar error with qv4l2:
  Error Auto Exposure (1): Invalid argument

And because of that the manual Exposure control does not work either.

However I verified these errors are also in 2.6.35, so I think your
conversion is fine, there must be something else going on; maybe I
should open another thread, as there is also the pending issue of
changing framerates "live", unrelated to the control changes as well.

I hope to be able to look at these issues soon, if nobody else does
before.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__14_Jan_2011_16_05_42_+0100_=t6wA48dpq6PUUNY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0wZkYACgkQ5xr2akVTsAESAwCdF8H5GJltdG4T1PG5a6Nq0NWL
rHYAnigW06gSy7or7sUDIN9sNsOsrsuV
=ENfj
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Jan_2011_16_05_42_+0100_=t6wA48dpq6PUUNY--
