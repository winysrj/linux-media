Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:3632 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbZGCVm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 17:42:27 -0400
Date: Fri, 3 Jul 2009 23:41:48 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, rsc@pengutronix.de
Subject: Re: pxa_camera: Oops in pxa_camera_probe.
Message-Id: <20090703234148.b5aad4da.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0907032200420.25247@axis700.grange>
References: <20090701204325.2a277884.ospite@studenti.unina.it>
	<20090703161140.845950e8.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0907032200420.25247@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Jul_2009_23_41_49_+0200_fb_dv0LL+EYjBxb0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__3_Jul_2009_23_41_49_+0200_fb_dv0LL+EYjBxb0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Jul 2009 22:03:27 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Fri, 3 Jul 2009, Antonio Ospite wrote:
>=20
> > > Linux video capture interface: v2.00
> > > Unable to handle kernel NULL pointer dereference at virtual address 0=
0000060
> > > pgd =3D c0004000
> > > [00000060] *pgd=3D00000000
> > > Internal error: Oops: f5 [#1] PREEMPT
> > > Modules linked in:
> > > CPU: 0    Tainted: G        W   (2.6.31-rc1-ezxdev #1)
> > > PC is at dev_driver_string+0x0/0x38
> > > LR is at pxa_camera_probe+0x144/0x428
> >=20
> > The offending dev_driver_str() here is the one in the dev_warn() call in
> > mclk_get_divisor().
> >=20
> > This is what is happening: in struct pxacamera_platform_data I have:
> > 	.mclk_10khz =3D 5000,
> >=20
> > which makes the > test in mclk_get_divisor() succeed calling dev_warn
> > to report that the clock has been limited, but pcdev->soc_host.dev is
> > still uninitialized at this time.
> >=20
> > I could lower the value in my platform data and avoid the bug, but it
> > would be good to have this fixed ASAP anyway.
> >=20
> > The attached rough patch fixes the problem, but you will surely come
> > out with a better one :)
>=20
> Why should I? Your patch seems correct to me so far, thanks. I'll push it=
=20
> for 2.6.31. Please, next time inline your patch as described in=20
> Documentation/SubmittingPatches.
>

Well, it should be correct, I just thought it could be considered
unpretty with the pcdev->soc_host initializations scattered here and
there, that's what I was referring to.
But, if this is ok to you, it's ok to me too :)

Ciao,
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

--Signature=_Fri__3_Jul_2009_23_41_49_+0200_fb_dv0LL+EYjBxb0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpOex0ACgkQ5xr2akVTsAFMJgCfcPCHgdhV9cYkR0RTrPBKn6/v
fR0AoIM9cor2y+7u+CId8e8jcqHV4E5D
=FAyx
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Jul_2009_23_41_49_+0200_fb_dv0LL+EYjBxb0--
