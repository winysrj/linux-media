Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42602 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2DAQca (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 12:32:30 -0400
Date: Sun, 1 Apr 2012 18:32:20 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Daniel =?UTF-8?B?R2zDtmNrbmVy?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401183220.3e411278@milhouse>
In-Reply-To: <4F788045.40208@iki.fi>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Wd7lCS1SNHEPz_78rwp8cH"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/=Wd7lCS1SNHEPz_78rwp8cH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 01 Apr 2012 19:20:21 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 01.04.2012 19:15, Michael B=C3=BCsch wrote:
> > On Sun, 1 Apr 2012 15:11:53 +0200
> > Michael B=C3=BCsch<m@bues.ch>  wrote:
> >
> >> [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)
> >
> > Ok, it turns out that it doesn't fail all the time, but only sporadical=
ly.
> > So increasing the number of retries fixes (or at least works around) it.
>=20
> OK, feel free to add ~3 retries inside af9035_ctrl_msg() i think.

Well I didn't retry at that level, but at the fc0011 driver level.
It does already retry once in fc0011 (with complete tuner reset).
I increased it to 6 times (3 was not enough).

I think we can't retry at af9035_ctrl_msg() level, because the
actual i2c/usb transfer does not fail. The received packet checksum even
is ok (although we currently don't check it. I'll send a patch for that lat=
er).

> You didn't mention if error is coming from af9035 firmware or from USB=20
> stack. Just for the interest...

I don't know how much the firmware is involved in this, but _maybe_ this
glitch is caused by it.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/=Wd7lCS1SNHEPz_78rwp8cH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeIMUAAoJEPUyvh2QjYsOr7UQAJH15iSMpYh9jAkm/IW5JcZC
6SxgyypwPwKPQJXrHrptmTwVMO5h0udcVT7MQjgwwaVC3E1r63ixQjW9UoP5cZ7a
Me5Cw4Ba+UBz1P5MPK9bHYBKQKrWGXk9WMT76K0D8+XuhTlc7udag1qVOx2EOtRH
j+FcuLc/WKZ4JlBHm20Y86z3WAhFnpE3bc509DuVBi+xyd79DoPBeCQqgF+zHtzz
M/8wGpzkFJCNGYRSdtAqAmzJ2X09ePp9xDM2qkxsq87EYoEsKI8wTUdL7Ta2ElPl
JsiyWSpM1lOSPBd5wwWzNJc04Q2C+CKcdD2n2gpgHFER6xyxOL5HKOXvtriItZVu
eweoFbJkyXm3k1QyC6YSL8Y4k/AW/M+MYFmDmWevtGWMumkLIt6ceRni6KQhrsW1
klBU6V+7B1fD/VIeVv6jWhbiwVLfu5OTM0qokdfwSZXZsH4aFPnoc2t1LdAN5SxF
BxMYtnDWtZ5pSx6o6b+5Z+UXdH1FobVuIK9aMjXNkORGNFUHSsFX5uaepT5jIjsi
b9i4+g5nYdXHh0jaD0Kl/SmCFOPB7ARTjadsxkObWRWZLWYdQZ8Aj3rlgZ8/dcSM
58CjMUSFT0votQLi02jRvNqKQHhsHefYONtwfxrZq0kcOd+XntHSLLw5VS4d9ezx
LnZQMHXpx8nzUtf3gH26
=zNzn
-----END PGP SIGNATURE-----

--Sig_/=Wd7lCS1SNHEPz_78rwp8cH--
