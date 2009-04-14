Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:3362 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZDNOFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 10:05:07 -0400
Date: Tue, 14 Apr 2009 16:04:50 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW] v4l2 loopback
Message-Id: <20090414160450.4ac1a498.ospite@studenti.unina.it>
In-Reply-To: <36c518800904140553m41fcbd34rb265e0993dd76689@mail.gmail.com>
References: <200903262049.10425.vasily@scopicsoftware.com>
	<200904131317.01731.hverkuil@xs4all.nl>
	<36c518800904131808m67482f2ex54307dfab91ccdf0@mail.gmail.com>
	<20090414091233.3ea2f6e4@pedra.chehab.org>
	<36c518800904140553m41fcbd34rb265e0993dd76689@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Apr_2009_16_04_50_+0200_oKmCmq3oIqJPmD7b"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__14_Apr_2009_16_04_50_+0200_oKmCmq3oIqJPmD7b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Apr 2009 15:53:00 +0300
vasaka@gmail.com wrote:

> On Tue, Apr 14, 2009 at 3:12 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>
> > The issue I see is that the V4L drivers are meant to support real devic=
es. This
> > driver that is a loopback for some userspace driver. I don't discuss it=
s value
> > for testing purposes or other random usage, but I can't see why this sh=
ould be
> > at upstream kernel.
> >
> > So, I'm considering to add it at v4l-dvb tree, but as an out-of-tree dr=
iver
> > only. For this to happen, probably, we'll need a few adjustments at v4l=
 build.
> >
> > Cheers,
> > Mauro
> >
>=20
> Mauro,
>=20
> ok, let it be out-of -tree driver, this is also good as I do not have
> to adapt the driver to each new kernel, but I want to argue alittle
> about Inclusion of the driver into upstream kernel.
>=20
>  Main reason for inclusion to the kernel is ease of use, as I
> understand installing the out-of-tree driver for some kernel needs
> downloading of the whole v4l-dvb tree(am I right?).
>=20
>  Loopback gives one opportunities to do many fun things with video
> streams and when it needs just one step to begin using it chances that
> someone will do something useful with the driver are higher.
>

I, as a target user of vloopback, agree that having it in mainline
would be really handy. Think that with a stable vloopback solution,
with device detection and parameter setting, we can really make PTP
digicams as webcams[1] useful, right now this is tricky and very
uncomfortable on kernel update.

>  Awareness that there is such thing as loopback is also. If the driver
> is in upstream tree - more people will see it and more chances that
> more people will participate in loopback getiing better.
>=20
>  vivi is an upstream driver :-)
>

Even vivi can be seen as a particular case of a vloopback device, can't
it?

Regards,
   Antonio

[1]
http://shell.studenti.unina.it/~ospite/section/it/dev/canoncam.html#English

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Tue__14_Apr_2009_16_04_50_+0200_oKmCmq3oIqJPmD7b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknkmAIACgkQ5xr2akVTsAGWZgCeJX8rLeGLhk/undtVYUo0z2n5
HNIAniwTnqoz7jv8SOU/SO5ieVrDIQGJ
=rrm2
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Apr_2009_16_04_50_+0200_oKmCmq3oIqJPmD7b--
