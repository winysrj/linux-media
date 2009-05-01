Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42643 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZEAIra (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 04:47:30 -0400
Date: Fri, 1 May 2009 10:47:29 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: linux-media@vger.kernel.org
Subject: Re: Donating a mr97310 based elta-media 8212dc (0x093a:0x010e)
Message-ID: <20090501084729.GB6941@pengutronix.de>
References: <20090430022847.GA15183@pengutronix.de> <alpine.LNX.2.00.0904300953330.21567@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0904300953330.21567@banach.math.auburn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

> know where he lives) then perhaps to Thomas Kaiser, who lives a bit=20
> closer to you. I think that all three of us are equally interested but as=
=20

Well, looks like I will send it to Thomas then. I'm glad that it can still =
be
useful.

> Judging from the Vendor:Product number which you report, it is one of the=
=20
> small MR97310 cameras for which the OEM driver was called the "CIF" =20
> driver. Indeed, these cameras are not supported right now, so the matter =
=20
> is interesting.

I tried simply adding the usb-id to the list in mr97310a.c, but as that did=
n't
produce anything useful (green screen), I thought I'll leave it to the pros=
 :)

> the SOF marker -- and this with the OEM driver software, too. But you say=
=20
> that yours actually worked.

Yup, just downloaded some driver from the net (can look up the URL if neede=
d).

> Finally, I would ask one question:
>
> In the libgphoto2 driver for these cameras, I have a listing for
>
> {"Elta Medi@ digi-cam", GP_DRIVER_STATUS_EXPERIMENTAL, 0x093a, 0x010e},
>
> Do you think this is the same camera, or a different one? Yours has a =20

I am pretty sure this is the same camera. "elta medi@ digi-cam" is printed =
on
the front-side. The model number "8212DC" is just on a glued label on the
down-side which may not be present on all charges or may have been removed =
or
got lost somehow. I could make pictures of the cam if this helps.

> Also might you be interested to try it out as a still camera, with =20
> libgphoto2, before surrendering it to someone else?

I am not at home this weekend, so I don't have access to my Linux-machines.=
 I
have the camera with me as I tested it on a Windows machine here; I could
send it like tomorrow. Thomas, is it okay for you, if I leave this to you?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn6tyEACgkQD27XaX1/VRuXJwCcDw6A7bwVf4X4xwWH+5rTtmLH
5wQAoKqwlqA1Kuag0lRnlidHxop6GGfE
=7RIg
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
