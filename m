Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42414 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2DAO4L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 10:56:11 -0400
Date: Sun, 1 Apr 2012 16:56:01 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Hans-Frieder Vogt" <hfvogt@gmx.net>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401165601.17a76a03@milhouse>
In-Reply-To: <201204011642.35087.hfvogt@gmx.net>
References: <4F75A7FE.8090405@iki.fi>
	<4F784A13.5000704@iki.fi>
	<20120401151153.637d2393@milhouse>
	<201204011642.35087.hfvogt@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EFG2Nfzz.s.mRJSh6sudC9h"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/EFG2Nfzz.s.mRJSh6sudC9h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 16:42:34 +0200
"Hans-Frieder Vogt" <hfvogt@gmx.net> wrote:
> > [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)
> >=20
> > It doesn't run into this check on the other af903x driver.
> > So I suspect an i2c read issue here.
>=20
> I would first uncomment the i2c read functionality in Antti's driver!

I did this.

> > Attached: The patches.

See the patches.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/EFG2Nfzz.s.mRJSh6sudC9h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeGyBAAoJEPUyvh2QjYsOdnQQAKGvvAIJpxNtyzl3S42Y1CHn
giqlYZdzYwaWU2kZPpGJKvYmONkpacIrDJeMtsXtiu7rYLuv8zBpVTXJ0ruHSDmk
nmCYfULz/3TRRrjMu8jNEqwdjornw8q7X6d4n8PVQGcAVGQPWXPsHW9LPIMge4KU
3fqre+NmuW93DDKmfvJX+n5/encYBz+a53usBRGkUQeZaB7IrwjkTNqWCYgFWtmp
bKhkgGi5PHGMq74+C7HB20iY4YYb/wO+mGHY6HPa4TUwkdwr2HuJ1G6oLSXoYlQd
6u3Tc8XTH6Dgf0kKSwPp0mz3Iq5hwtTWORz4JkZD/ctSol9O35tJyAZHWzB6bhV5
jfBExo1ZJAlVDr3HLP6Wh+Onw/EI1pHukMChtSXmemuOyr5aXX1IbUcUjC9Rlb1P
lPQr96VyJTBkyx0qkX63td5YexwCLRCAzwj/x8e63eRVWkNK4NMjwrlGVIkckCTQ
1Ql+C57DJFnvCCOmQoGbTQgFVAT9JG0BDFoFwEsWxND/OB/gU4y8P/hOjM+GhH1C
DFHu8QNj+XD9OBYkA9+We6SN8Sg+RdgmYhXMHyCXqGgRKGXn3BX1MQJ8q1AQPind
GfXly7Bt3URXgZdJ4HFHCVUo7a8ZgWhuesx4kavj0zjXYS/ZQoStlA1KTmDloIAT
wtukzE01601rFgFP1bGW
=JyxL
-----END PGP SIGNATURE-----

--Sig_/EFG2Nfzz.s.mRJSh6sudC9h--
