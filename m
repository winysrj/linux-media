Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45983 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab2DCKHY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 06:07:24 -0400
Date: Tue, 3 Apr 2012 12:07:12 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
Message-ID: <20120403120712.14fea16f@milhouse>
In-Reply-To: <4F7AC9B8.50200@linux.intel.com>
References: <20120403110503.392c8432@milhouse>
	<4F7AC9B8.50200@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ft0KBjuTNYXJ0X1v7Q1LXe6"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Ft0KBjuTNYXJ0X1v7Q1LXe6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Apr 2012 12:58:16 +0300
David Cohen <david.a.cohen@linux.intel.com> wrote:
> > -	while (!(vco_cal&  FC11_VCOCAL_OK)&&  vco_retries<  6) {
> > +	while (!(vco_cal&  FC11_VCOCAL_OK)&&  vco_retries<  3) {
>=20
> Do we need to retry at all?

It is not an i2c retry. It retries the whole device configuration operation
after resetting it.
I shouldn't have mentioned i2c in the commit log, because this really only =
was
a side effect.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/Ft0KBjuTNYXJ0X1v7Q1LXe6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPesvQAAoJEPUyvh2QjYsO+dwP+wYV9zFI96lxn1RqAZrJqxue
4gll5+wj4bJae8nn3AXBZ/40CD52f8bisQw00az/UioSk5eeEtIlWsA/mmWM9LPn
b/zECVvfk3J95SMeP9yM2dB+XoJDpF3y1v+ADQmA0DnxvWROMOBbCQjZdtKb8YiX
dRFtOEpViNmWI5jvVyepFv1i+SBo3cGTB2WbE+tG1iN4cVzEbV6LI2CpIGr4L5dK
apYrqOtijslrxSQuScZhZX3w1Ddcxj5E3C0IjszYFHkuBYYWEJAUj5TBXb5nI8p4
BKkMAwCpTnQXgqCz70V80IWrGXrWoBsBdoPk9jTj1MMLffmossGG+njz19oQyBez
KozVHgWd2AeDWg+/2IUwDWb/y4DyZlS+FKksIRDFVqyv5gQWELVygJ37fVWxOVAn
nBaoeFMd8HbTSiPhbTBa/Hg5aDmHXnVsdRaX0r60ekW5xXzKvWVzjwAcqCJSfKLI
BaJTlltaHoj14omPL7l6S+KUwI/mCWaWBhfR32p2MAh4+p6AVf5JSovqw+mFwEic
qLSeox3IqKxmiQ47puIT3Pvz7jQkxmnUk/g++MBGcJxBGWDKavbrwhXyDj0wzFpg
elRbbykNRdUdjKaSzgCx7iey7xU3BAqFp3D6PFqqBRT2abM6Wj3JS4fD6mw2wXa9
UBZD1EVfAVXkMg2I5xqv
=NITn
-----END PGP SIGNATURE-----

--Sig_/Ft0KBjuTNYXJ0X1v7Q1LXe6--
