Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:3282 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZJDPUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 11:20:14 -0400
Date: Sun, 4 Oct 2009 17:19:24 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  Failed to configure for format 50323234
Message-Id: <20091004171924.7579b589.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0910040024070.5857@axis700.grange>
References: <20091002213530.104a5009.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0910030116270.12093@axis700.grange>
	<20091003161328.36419315.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0910040024070.5857@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__4_Oct_2009_17_19_24_+0200_nUU8zvrdQCA5+iQD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sun__4_Oct_2009_17_19_24_+0200_nUU8zvrdQCA5+iQD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Oct 2009 00:31:24 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Sat, 3 Oct 2009, Antonio Ospite wrote:
>=20
[...]
> > Anyways your patch works, but the picture is now shifted, see:
> > http://people.openezx.org/ao2/a780-pxa-camera-mt9m111-shifted.jpg
> >=20
> > Is this because of the new cropping code?
>=20
> Hm, it shouldn't be. Does it look always like this - reproducible? What=20
> program are you using? What about other geometry configurations? Have you=
=20
> ever seen this with previous kernel versions? New cropping - neither=20
> mplayer nor gstreamer use cropping normally. This seems more like a HSYNC=
=20
> problem to me. Double-check platform data? Is it mioa701 or some custom=20
> board?
>

It seemed to be reproducible yesterday, but I can't get it today, maybe
it happens in low battery conditions. I am using capture-example.c from
v4l2-apps. Never seen before. I am testing this on a Motorola A780,
the soc-camera platform code is not in mainline yet.

I'll bug you when I hit the problem again. Thanks for your patience.

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

Ciao ciao,
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

--Signature=_Sun__4_Oct_2009_17_19_24_+0200_nUU8zvrdQCA5+iQD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrIvPwACgkQ5xr2akVTsAElmgCfdrssRZ25IUyTi4eidGz5iQJW
WDEAnRrLa85zLiI4B6jzME3VhMDeL2lX
=xjxw
-----END PGP SIGNATURE-----

--Signature=_Sun__4_Oct_2009_17_19_24_+0200_nUU8zvrdQCA5+iQD--
