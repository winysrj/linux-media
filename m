Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42638 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2DAQop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 12:44:45 -0400
Date: Sun, 1 Apr 2012 18:44:38 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Daniel =?UTF-8?B?R2zDtmNrbmVy?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401184438.2d2299a2@milhouse>
In-Reply-To: <4F7884DC.2070501@iki.fi>
References: <4F75A7FE.8090405@iki.fi>
	<20120330234545.45f4e2e8@milhouse>
	<4F762CF5.9010303@iki.fi>
	<20120331001458.33f12d82@milhouse>
	<20120331160445.71cd1e78@milhouse>
	<4F771496.8080305@iki.fi>
	<20120331182925.3b85d2bc@milhouse>
	<4F77320F.8050009@iki.fi>
	<4F773562.6010008@iki.fi>
	<20120331185217.2c82c4ad@milhouse>
	<4F77DED5.2040103@iki.fi>
	<20120401103315.1149d6bf@milhouse>
	<20120401141940.04e5220c@milhouse>
	<4F784A13.5000704@iki.fi>
	<20120401151153.637d2393@milhouse>
	<20120401181502.7f5604c3@milhouse>
	<4F788045.40208@iki.fi>
	<20120401183220.3e411278@milhouse>
	<4F7884DC.2070501@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wQQGX.fQ7aoBp1HReevcArU"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/wQQGX.fQ7aoBp1HReevcArU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 01 Apr 2012 19:39:56 +0300
Antti Palosaari <crope@iki.fi> wrote:

> > Well I didn't retry at that level, but at the fc0011 driver level.
> > It does already retry once in fc0011 (with complete tuner reset).
> > I increased it to 6 times (3 was not enough).
>=20
> Maybe some delay is needed in order to wait tuner wakes up after the=20
> reset. Reason it does not occur the other driver is likely there is some=
=20
> delay somewhere...

Yep, I suspect that, too. However, I already tried lots of things that didn=
't
really work. Such as adding 100ms delay before and after all i2c reads
and writes inside of the fc0011 driver.
I'll investigate further...

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/wQQGX.fQ7aoBp1HReevcArU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeIX2AAoJEPUyvh2QjYsOtBoP/ivfMBqMJu6pHYYkFDWZzAEA
+tUT+tYM0bRu4Z/i3s0xQFai+pc1xYXzKC+A6LaO2hCUgq4DjMIwZqSL9RKTznYd
pyDnNGakoKi7WzSmXoFVOKsn7TxGexwchfQUAXUaCiLjaIUxTHi5XmVpTA4hmz7f
gpDfdZ+LH0+BIOGZA1Dwg0jampCMLDk6Bm0cLG3fB0hKTne0HPvF2EofxvSIEWX+
1zTGDN/ZVddj8wyd7VaTs4VhKL91+SReScyK9Y1cWWrXwvCPC0M64EZNS6I5XNst
t/D5748X1sFRboSIGG362qXPsGTW/+AmZa0V3KI7PjYyskLYW+hZUgviacdoGT8p
7vxjQTNk7V5w5b6Ve5iei4RJUspGsiwxXsu5gso/dNc0NnIOPjrUVcfmLIrvdX+X
CLUULIAQQPNYDVjJAJ4du/iGYlANCIoKAvsiG2leLEratdH0bJEiubRZhBoP+UPY
54rbVNQhN9IUmQS8VF1nmg/5LzhGMhErPxdjfhP1bLo2o27aBi0m287Rd2Uu6wFq
Hz6x9vl+LVHh0VKAFb0R2aEfI6pyO2mDBwv+1OkLIaCJzT9ry0KkaDZZKIWi2f2x
Vems3X88AaDowNsToHIv58CbO5lExQl3IUwQ8YwwRN+lUT9PszqkRHN8oXRJUqt8
m4UPOvqbXBFsKMLZGA5k
=Lgaq
-----END PGP SIGNATURE-----

--Sig_/wQQGX.fQ7aoBp1HReevcArU--
