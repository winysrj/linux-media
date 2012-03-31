Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41431 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab2CaOE4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 10:04:56 -0400
Date: Sat, 31 Mar 2012 16:04:45 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120331160445.71cd1e78@milhouse>
In-Reply-To: <20120331001458.33f12d82@milhouse>
References: <4F75A7FE.8090405@iki.fi>
	<20120330234545.45f4e2e8@milhouse>
	<4F762CF5.9010303@iki.fi>
	<20120331001458.33f12d82@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4Cql_n0.CTxeS2Atsgd9Ae9"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/4Cql_n0.CTxeS2Atsgd9Ae9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 00:14:58 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> On Sat, 31 Mar 2012 01:00:21 +0300
> Antti Palosaari <crope@iki.fi> wrote:
>=20
> > Feel free to do that. Actually, I just tried it about 2 hours ago. But =
I=20
> > failed, since there callbacks given as a param for tuner attach and it=
=20
> > is wrong. There is frontend callback defined just for that. Look exampl=
e=20
> > from some Xceive tuners also hd29l2 demod driver contains one example.=
=20
> > Use git grep DVB_FRONTEND_COMPONENT_ drivers/media/ to see all those=20
> > existing callbacks.
>=20
> Cool. Thanks for the hint. I'll fix this.

Ok, so I cooked something up here.
I'm wondering where to get the firmware file from, so I can test it.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/4Cql_n0.CTxeS2Atsgd9Ae9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPdw79AAoJEPUyvh2QjYsOeZMP/0UQBFSm/kh5Hs2RVFY0lojG
QWgL7KAdWaOO0sBHRyQak1yCSSQIJzfvzbCV73wInv03FRJ6KOsptzVlC9sd9hX7
bEvro2vmgyeOsM4GiSsBKWNsF7RKgV02Wl5Dm/W1kUZg2qS1nsBwdtxCM9KnFAy9
TYjeg0oQMiCKVPqOcZ/Ll2L7NbeuMyIHnn0KTdwpkAiGvQeN9O4QpFbPLmqrGkBV
O1HZFQeQNbb9IGcKbXKpHAH1pHkqTWho4094TSW3uskVOWNX6huDraG6H3HoF+Bt
6UXhJIoXMJ5+flvBUIBNGOXkmlPi05N4Ccc5VxB3/cgCfp9Giik2JoR7d+46PRX7
zeppeemdhO4szQsVVthd2kNXaISJ8TBdIdKSQWbXbzCcCPjTNMjK2OSe5ZTkpB0j
7sXotGfuiptDxZl666njFu24RnGMTFY8nvnViNlf6R2Qqct+Ciu/xIzwfWuUL8iw
uuGWscibMYkfKiB5gN0/a+JIpqSo2DNyORsG94IAkY2Kn7fYPC3xmbtgxz09PbSH
iC4YI4SsxtoS6LFPExaOB2+vfErd1t7/lE0093ajVPUNNUn0bYxKw9K6mj19gy1I
xc3igAA1zBquoeCY3JaeS+7JWisIJ6jsSGlMhAGqopq1UUCJ7VQEjrqj+OlBYoz3
oanHXQoHzoZl3r+iCree
=Vrm6
-----END PGP SIGNATURE-----

--Sig_/4Cql_n0.CTxeS2Atsgd9Ae9--
