Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45652 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2DCGhB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 02:37:01 -0400
Date: Tue, 3 Apr 2012 08:36:48 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH] Add fc0011 tuner driver
Message-ID: <20120403083648.258257cd@milhouse>
In-Reply-To: <4F7A1F88.1060109@iki.fi>
References: <20120402181432.74e8bd50@milhouse>
	<4F79DA52.2050907@iki.fi>
	<20120402192011.4edc82ff@milhouse>
	<4F79E49D.1020802@iki.fi>
	<20120402195125.771b2c72@milhouse>
	<4F7A1F88.1060109@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t_azOEX/Fp4iKxNQD3qsxWu"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/t_azOEX/Fp4iKxNQD3qsxWu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Apr 2012 00:52:08 +0300
Antti Palosaari <crope@iki.fi> wrote:

> > Well the fc0011 tuner driver still works worse on this af9035 driver
> > than on Hans' driver. I have absolutely no idea why this is the case.
> > I'm almost certain that it is not a timing issue of some sort. I tried
> > a zillion of delays and such.
>=20
> And after taking sniffs and comparing those I found the reason. It is=20
> I2C adapter code. It writes one byte too much =3D> as a FC0011 is=20
> auto-increment (as almost every I2C client) registers it means it writes=
=20
> next register too. Fixing that gives normal tuner sensitivity. I will=20
> try to make patch for that soon.

Awesome! Thanks a lot!

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/t_azOEX/Fp4iKxNQD3qsxWu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJPepqAAAoJEPUyvh2QjYsOzz0P+OC2NhvHl9G4Hqu769vMC1FH
rFTAXpT9NKdFB0lx1SDeTWizHOxO4R0KIc6k5RtHiMw1wfMiqhgfdGxKcxqFOqGm
q1qKx9/x6u6B7fXRxsbhihP+PXVb2GW8qJqdBXDMhHIHrd/WKg3hPWriKnFJh6pN
HBEKQXaTXctO9q3NkVk+ENOuAVL9Wj596QvQ2OThSaRH6WwmpKwOaXQSvjgghHD6
aBj2iNyiZFzTxWQD1a5Z82U9HS0KFoV4FTwA9kHPSWVKDH566KMxTI/siQg0/5Lz
fDpxXIj/xdbuKTeJayJUCvtnok3KupP/jMuN+em1hjdFNN5W9S7Hy8qBeO4J+x12
eutAznFT1YUYDElwkiYi8gqvjaBc0gI/J65cMV8sx8YyX8OVPfX62iinuERTCPiU
l/SZAHEyNRjK9OZeQn4rXN2Uzk0lZ4c+xB7D8r1JLsjnzgzN9F7YOEF/Kq0UP8vI
rcwsXK96oQUDFZZGm4OHX6iMe5Wtf6u9KT7W/16nEeRrkA9qdRWzMeYALFem+LcZ
d7cQQxuyxNrRsEf07srXr8+qyVyF3EWRKxUCuh7V7eI5QL4Hxvh0ebvrIV1tyKN2
pvzP3mSBkwzlB4orE/X4IyAEI5zbubXIeT0YixnWPU3UTPaO/E3LF7khci29Vt7l
ak88uByGMnvjxOPueTI=
=7bAw
-----END PGP SIGNATURE-----

--Sig_/t_azOEX/Fp4iKxNQD3qsxWu--
