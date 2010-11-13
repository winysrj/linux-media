Return-path: <mchehab@pedra>
Received: from smtp204.alice.it ([82.57.200.100]:34165 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0KMPpv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 10:45:51 -0500
Date: Sat, 13 Nov 2010 16:45:37 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>
Subject: Re: gspca_ov534: Changing framerates, different behaviour in 2.6.36
Message-Id: <20101113164537.79124037.ospite@studenti.unina.it>
In-Reply-To: <20101113161205.b94cb748.ospite@studenti.unina.it>
References: <20101113161205.b94cb748.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__13_Nov_2010_16_45_37_+0100_an46.12omKG19u2N"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Sat__13_Nov_2010_16_45_37_+0100_an46.12omKG19u2N
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Nov 2010 16:12:05 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> guvcview:
>=20
> If I:
>  1. Go to the "Video & Files Tab"
>  2. Change the "Frame Rate" value from the drop down menu
>=20
[...]
>=20
> since 2.6.36 + the regression fix in [1] (please apply it):
>  3a. dmesg shows the message: ov534: frame_rate: xx
>  3b. guvcviews gives some errors and the preview image halts:
>        VIDIOC_QBUF - Unable to queue buffer: Invalid argument
>        Could not grab image (select timeout):
>                   Resource temporarily unavailable
>=20
[...]
> I am trying to spot what caused this, I guess it is something in
> gspca_main, hopefully Jean-Fran=E7ois has some idea that can help me
> narrowing down the search.
>=20

Reverting f7059eaa285c0460569ffd26c43ae07e3f03cd6c brings the old
behaviour back. So something there is not happy with changing frame
rate on the fly.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sat__13_Nov_2010_16_45_37_+0100_an46.12omKG19u2N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzesqEACgkQ5xr2akVTsAGJDgCgnD6dfzV2ULuZH8cWlR8p9wXN
ukwAoI+/isvVIYwbmQr9n03MY/hg5kzP
=mfDj
-----END PGP SIGNATURE-----

--Signature=_Sat__13_Nov_2010_16_45_37_+0100_an46.12omKG19u2N--
