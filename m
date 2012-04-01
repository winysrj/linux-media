Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42575 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2DAQPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 12:15:11 -0400
Date: Sun, 1 Apr 2012 18:15:02 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Daniel =?UTF-8?B?R2zDtmNrbmVy?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401181502.7f5604c3@milhouse>
In-Reply-To: <20120401151153.637d2393@milhouse>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UCV6rWX7Qr_hRox4GXH0X_d"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/UCV6rWX7Qr_hRox4GXH0X_d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 15:11:53 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)

Ok, it turns out that it doesn't fail all the time, but only sporadically.
So increasing the number of retries fixes (or at least works around) it.

No idea why this behaves differently from fc0011 on Hans' driver, though.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/UCV6rWX7Qr_hRox4GXH0X_d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeH8GAAoJEPUyvh2QjYsOUKEP/1BP0BJkiIf2KXeq7OCH6Yc+
gQQ5n4QKQY5Zx9nh9X6Y63IKEAiobl7bsRJYkKun4B7ILO9eTQU+kuaoUrU52Ayv
KE9oFrtSbrRHgGcbLsOdUDzAIcK12CiG9kIZdTS/tAKxb9/lQqPRCzFRKWv377Kf
kX6XVBBxQbeP7+wDOdosn2S0jUHLjM/OR93P/6j5HlK/o5zJHneMHsvZshjmWSLI
i6a7vQRCJi5aEmcIgjPnYWmS1KZCXiWazBvSP8GCAqqO4rvrW7OS6oEwa6q40qvx
XkKxmkFZvZmEyBLXqu9pKjIJKLLDRSUfszHJ22Y2bDAjF593H37M96QimNf414MX
iGj0iK85deY5dC70nBnT5G8l0Y5d0jcIPG9bSy6CVU1XvjXcqukILKiYN/pTf8mE
moHDh7vXVUAd1jSMsV/abAp4J7d/aKZzoRnY/h7v/YjWl6wp8aRZSeP3R0uWnMRs
YS3rBUV5KauoRhF5PvZfBk9fx9HYmrX8MEVS8RrgZYpwVkgKTz7NldqKSMxd5C8/
z/VepGg92PdcrnG/FzVAPNw2k6/NFkPA+B/aRQndnqO3tEO+KfcFjGCY2Q6rqfR2
R3WyvSn20I7H2sCszQQtfy1d0nMNEKAZrZLa1R07wfMXRS+WaGjQ/l20kTJSK0dn
KDKlQOJikD/JwQjzHfLo
=Hb5G
-----END PGP SIGNATURE-----

--Sig_/UCV6rWX7Qr_hRox4GXH0X_d--
