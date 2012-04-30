Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:52578 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2D3NvJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 09:51:09 -0400
Date: Mon, 30 Apr 2012 15:51:01 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Johann Deneux <johann.deneux@gmail.com>,
	Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: [PATCH 0/3] gspca - ov534: saturation and hue (using
 fixp-arith.h)
Message-Id: <20120430155101.29b34c2776fb8c0f8aebacca@studenti.unina.it>
In-Reply-To: <20120423141625.0138bbeb@lwn.net>
References: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
	<20120423141625.0138bbeb@lwn.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Apr_2012_15_51_01_+0200_x9fMF1+1utxtX_pw"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Mon__30_Apr_2012_15_51_01_+0200_x9fMF1+1utxtX_pw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 14:16:25 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> On Mon, 23 Apr 2012 15:21:04 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > Jonathan, maybe fixp_sin() and fixp_cos() can be used in
> > drivers/media/video/ov7670.c too where currently ov7670_sine() and
> > ov7670_cosine() are defined, but I didn't want to send a patch I could
> > not test.
>=20
> Seems like a good idea.  No reason to have multiple such hacks in the
> kernel; I'll look at dumping the ov7670 version when I get a chance.  That
> may not be all that soon, though; life is a bit challenging at the moment.
>=20
> One concern is that if we're going to add users to fixp-arith.h, some of
> it should maybe go to a C file.  Otherwise we'll create duplicated copies
> of the cos_table array for each user.  I'm not sure the functions need to
> be inline either; nobody expects cos() to be blindingly fast.
>=20

Jonathan, does lib/fixp-arith.c sound OK to you? I'll put that on my
TODO, unless Johann wans to do some more rework; in any case I think we
can still merge this patchset like it is right now.

Jean-Francois will you take care of that?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Mon__30_Apr_2012_15_51_01_+0200_x9fMF1+1utxtX_pw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+emMUACgkQ5xr2akVTsAHvJgCfdgYccXZzD2ykIsez70D+OidQ
lfcAnj4i7ZoD9c+hkWhzNC3MlAZolCdS
=BFEx
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Apr_2012_15_51_01_+0200_x9fMF1+1utxtX_pw--
