Return-path: <mchehab@gaivota>
Received: from smtp204.alice.it ([82.57.200.100]:55061 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0L1LiF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 06:38:05 -0500
Date: Tue, 28 Dec 2010 12:37:56 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	openkinect@googlegroups.com, Steven Toth <stoth@kernellabs.com>
Subject: Re: [RFC, PATCH] Add 10 bit packed greyscale format.
Message-Id: <20101228123756.e95dc546.ospite@studenti.unina.it>
In-Reply-To: <1292498984-9198-1-git-send-email-ospite@studenti.unina.it>
References: <1292498984-9198-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_12_37_56_+0100_B.NWfmUIJ/L/_MKG"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--Signature=_Tue__28_Dec_2010_12_37_56_+0100_B.NWfmUIJ/L/_MKG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Dec 2010 12:29:44 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> A 10 bits per pixel greyscale format in a packed array representation is
> supplied for instance by Kinect sensor device.
>=20
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>

Ping.

> Hi,
>=20
> This is the first attempt to add v4l support for the 10bpp packed array f=
ormat
> used by the Kinect sensor device for depth data and for IR mode (in this =
mode
> the device streams the image as seen by the monochrome sensor).
>=20
> This version is mainly to start the discussion about the format and how it
> should be seen by v4l, the doubts I still have are about:
>=20
>   1. The name of the format: is Y10P OK? Moreover, "packed" here is used =
in a
>      _stronger_ meaning compared to the other packed formats, and I also =
saw the
>      name "compact array" used somewhere for these kind of objects.
>=20
>   2. The actual order of the bits, please check the documentation below t=
o see
>      if I got it right.
>      And maybe I should not mention the unpacked version of the data as t=
his
>      depends on the unpacking algorithm, what do you think?
>

Ok, I checked that the order of the bits in the packed representation
used on the kinect is the natural one (most significant bits come
first from the left). And about the unpacking, well, if we called this
format Y10P, are we implying that the unpacked format is Y10, hence
with little-endian order? Or should we consider the two formats
independent even if the names are so similar?

>   3. The way to illustrate the packed array concept in the documentation:=
 I
>      used a bit-field syntax like in hardware registers docs, does this l=
ook
>      meaningful to you? Or should I find a way to clearly show the differ=
ence
>      between _byte_alignment_ and _element_alignment_.
>

Now that I've checked the actual data format I am dealing with, I think
I can improve the illustration as well.

> If you could point to some literature about packed array representations =
I'd be
> happy to take a look at it.
>=20
> After these issues are addressed, I am going to submit changes to libv4l =
as
> well.
>=20
> Thanks,
>   Antonio Ospite
>   http://ao2.it
>=20
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

--Signature=_Tue__28_Dec_2010_12_37_56_+0100_B.NWfmUIJ/L/_MKG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0ZzBQACgkQ5xr2akVTsAFfJgCfXtcGKrw3M5/Na/KMS3+1mKEh
xPoAoJLB5lZjKU4MqbcqAdVlG2hjmzYz
=IDNK
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_12_37_56_+0100_B.NWfmUIJ/L/_MKG--
