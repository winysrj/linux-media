Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:55269 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab2EEI00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 04:26:26 -0400
Date: Sat, 5 May 2012 10:26:14 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 0/3] gspca - ov534: saturation and hue (using
 fixp-arith.h)
Message-Id: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
In-Reply-To: <20120430155101.29b34c2776fb8c0f8aebacca@studenti.unina.it>
References: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
	<20120423141625.0138bbeb@lwn.net>
	<20120430155101.29b34c2776fb8c0f8aebacca@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_May_2012_10_26_14_+0200_vSnFeLHKjCgN4=uQ"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sat__5_May_2012_10_26_14_+0200_vSnFeLHKjCgN4=uQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 15:51:01 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> On Mon, 23 Apr 2012 14:16:25 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
>=20
> > On Mon, 23 Apr 2012 15:21:04 +0200
> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> >=20
> > > Jonathan, maybe fixp_sin() and fixp_cos() can be used in
> > > drivers/media/video/ov7670.c too where currently ov7670_sine() and
> > > ov7670_cosine() are defined, but I didn't want to send a patch I could
> > > not test.
> >=20
> > Seems like a good idea.  No reason to have multiple such hacks in the
> > kernel; I'll look at dumping the ov7670 version when I get a chance.  T=
hat
> > may not be all that soon, though; life is a bit challenging at the mome=
nt.
> >=20
> > One concern is that if we're going to add users to fixp-arith.h, some of
> > it should maybe go to a C file.  Otherwise we'll create duplicated copi=
es
> > of the cos_table array for each user.  I'm not sure the functions need =
to
> > be inline either; nobody expects cos() to be blindingly fast.
> >=20
>=20
> Jonathan, does lib/fixp-arith.c sound OK to you? I'll put that on my
> TODO, unless Johann wans to do some more rework; in any case I think we
> can still merge this patchset like it is right now.
>=20
> Jean-Francois will you take care of that?
>=20

Or wait :)

I'll send a v2, I think I should merge the current COLORS control used
for SENSOR_OV767x and the SATURATION one I added for SENSOR_OV772x as
they both are V4L2_CID_SATURATION.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sat__5_May_2012_10_26_14_+0200_vSnFeLHKjCgN4=uQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+k5CYACgkQ5xr2akVTsAHLtwCghBPVP5JUL7on8cU7WHf73YYV
Z4wAoJCBfY+WpCsc8VwYjjWPrcb17IqM
=h6oW
-----END PGP SIGNATURE-----

--Signature=_Sat__5_May_2012_10_26_14_+0200_vSnFeLHKjCgN4=uQ--
