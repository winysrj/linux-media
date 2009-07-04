Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:2030 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZGDUH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jul 2009 16:07:27 -0400
Date: Sat, 4 Jul 2009 22:07:19 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	rsc@pengutronix.de
Subject: Re: pxa_camera: Oops in pxa_camera_probe.
Message-Id: <20090704220719.fe1850bb.ospite@studenti.unina.it>
In-Reply-To: <87skhcfdhh.fsf@free.fr>
References: <20090701204325.2a277884.ospite@studenti.unina.it>
	<20090703161140.845950e8.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0907032200420.25247@axis700.grange>
	<20090703234148.b5aad4da.ospite@studenti.unina.it>
	<87skhcfdhh.fsf@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__4_Jul_2009_22_07_19_+0200_Dr6Q.y2W09UTuNcC"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sat__4_Jul_2009_22_07_19_+0200_Dr6Q.y2W09UTuNcC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 04 Jul 2009 21:35:22 +0200
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> >> > The offending dev_driver_str() here is the one in the dev_warn() cal=
l in
> >> > mclk_get_divisor().
> >> >=20
> >> > This is what is happening: in struct pxacamera_platform_data I have:
> >> > 	.mclk_10khz =3D 5000,
> >> >=20
> >> > which makes the > test in mclk_get_divisor() succeed calling dev_warn
> >> > to report that the clock has been limited, but pcdev->soc_host.dev is
> >> > still uninitialized at this time.
>
> Antonio,
>=20
> Would you check [1] and see if your stack does correspond to the one I re=
ported
> some time ago ? As this is fresh in your memory, you'll be far quicker th=
at me.
>
...
> [1] http://osdir.com/ml/linux-media/2009-04/msg00874.html

Yes, I think that is it. The offsets are different of course but the
call stack is pretty much the same.

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

--Signature=_Sat__4_Jul_2009_22_07_19_+0200_Dr6Q.y2W09UTuNcC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpPtncACgkQ5xr2akVTsAEhIgCgghy4EgcOS+hfOFopcDlrlUP+
gToAnR2iK8pCN4qF+n6qzCCQ5EQtrLMA
=Nt88
-----END PGP SIGNATURE-----

--Signature=_Sat__4_Jul_2009_22_07_19_+0200_Dr6Q.y2W09UTuNcC--
