Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47568 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbBCRxP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 12:53:15 -0500
Date: Tue, 3 Feb 2015 15:53:01 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Antti Palosaari <crope@iki.fi>, Mark Brown <broonie@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 21/66] rtl2830: implement own I2C locking
Message-ID: <20150203155301.7ba63776@recife.lan>
In-Reply-To: <20150202203324.GA11486@katana>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
	<1419367799-14263-21-git-send-email-crope@iki.fi>
	<20150202180726.454dc878@recife.lan>
	<54CFDCCC.3030006@iki.fi>
	<20150202203324.GA11486@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/vlc4iJA=hRPVu/H5BVxFEdq"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/vlc4iJA=hRPVu/H5BVxFEdq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Mon, 02 Feb 2015 21:33:24 +0100
Wolfram Sang <wsa@the-dreams.de> escreveu:

>=20
> > >Ok, this may eventually work ok for now, but a further change at the I=
2C
> > >core could easily break it. So, we need to double check about such
> > >patch with the I2C maintainer.
> > >
> > >Jean,
> > >
> > >Are you ok with such patch? If so, please ack.
>=20
> Jean handed over I2C to me in late 2012 :)

Sorry for the mess... I mis-read MAINTAINERS.

> > Basic problem here is that I2C-mux itself is controlled by same I2C dev=
ice
> > which implements I2C adapter for tuner.
> >=20
> > Here is what connections looks like:
> >  ___________         ____________         ____________
> > |  USB IF   |       |   demod    |       |    tuner   |
> > |-----------|       |------------|       |------------|
> > |           |--I2C--|-----/ -----|--I2C--|            |
> > |I2C master |       |  I2C mux   |       | I2C slave  |
> > |___________|       |____________|       |____________|
> >=20
> >=20
> > So when tuner is called via I2C, it needs recursively call same I2C ada=
pter
> > which is already locked. More elegant solution would be indeed nice.
>=20
> So, AFAIU this is the same problem that I2C based mux devices have (like
> drivers/i2c/muxes/i2c-mux-pca954x.c)? They also use the unlocked
> transfers...

If I understood your comment correct, you're ok with this approach,
right? I'll then merge the remaining of this 66-patch series.

If latter a better way to lock the I2C mux appears, we can reverse
this change.

Regards,
Mauro
>=20

--Sig_/vlc4iJA=hRPVu/H5BVxFEdq
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU0QsFAAoJEAhfPr2O5OEVQWoP/3pSoFGkdT+Cq8m9sv0iHul/
V4V+vIn7DVqTRc98oM6Ehtu+BubBR6pAKQiN6XQNQJBg+acB4nVO/nukjbbZmIRh
M335nepmqaMFUAPS1+43vVqgN+w9hqBmlTSUn0SUGw76z2h5jWP2DlMxAlnBayvs
XochsQNkjPAD9dfNRAiU+wE0PysfE5RBAuZC767S69X2+dLUyKuo+UzdIN2ZczyK
E7DJIfyTCEUP9qyuwk3rudLoxVNCVnjnz5gbBZAvHRqlotE1cC4UY5GY13tmKUIp
lnYv1fDjWDtR8w0n00UNnq6fT+xz2ANyPgTbBVxQCIC9Eq5D2237LTPRiFr/Ke1n
hhuH69geST8GxquBOnc3G3lNHES2lj72v+msg6eKcwfTC7S5dPBHcMV6DMvKV+Qw
LzrPfh5bG4cJqz5t8bM80IXjxPJhk2TFihPwBwxmaQ3lGFwozgqvmEs65etiGZJP
6vx16qUK0Goz8kvxTXwa9j5Ea4VuYRPT2Fiz4VDqoPNCiKGw0RBaCy/bKpJXsyKE
ZvShe0E/cSgWHfAKo/NwWV6+RlVTeeg93+9kGlhd641/Jkmy6rW1zKSMb8HRgSho
sn4pIUZ5JYb+GxFgpvzIGvniKTs1e/ZHByRGuXbXMVUxrcvyH3wq0oag2xsQFlOg
0x5HOZGlM9cQTqjyyaHY
=1fer
-----END PGP SIGNATURE-----

--Sig_/vlc4iJA=hRPVu/H5BVxFEdq--
