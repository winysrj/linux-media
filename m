Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:57042 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbcFSLPz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 07:15:55 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	mchehab@osg.samsung.com, Martin Kaltenbrunner <modin@yuri.at>
From: Florian Echtler <floe@butterbrot.org>
Subject: sur40: DMA-SG and performance question
Message-ID: <57667EE2.10501@butterbrot.org>
Date: Sun, 19 Jun 2016 13:15:46 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="K0PAKXIFuhNUmucqLHNWsTD2Ifa3J8dXK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K0PAKXIFuhNUmucqLHNWsTD2Ifa3J8dXK
Content-Type: multipart/mixed; boundary="ckOvgvKEdIubxHT4hVo6fp5x87c2vuigK"
From: Florian Echtler <floe@butterbrot.org>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 mchehab@osg.samsung.com, Martin Kaltenbrunner <modin@yuri.at>
Message-ID: <57667EE2.10501@butterbrot.org>
Subject: sur40: DMA-SG and performance question

--ckOvgvKEdIubxHT4hVo6fp5x87c2vuigK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I've been doing some latency testing on my sur40 driver, and I've
measured over 160 ms of round-trip delay (with an external high-speed
camera, delay between lighting up an LED and seeing the on-screen
response in the video stream).

I'm aware that this value has to factor in screen refresh rates etc.,
but it still seems to me that at least 100 ms have to be accounted for
purely by image acquisition and delivery.

My question now is: can any of this latency be caused by my usage of
DMA-SG (see [1] ff.), or is this a zero-copy operation, i.e. the data is
delivered directly to the V4L2 buffer from the USB host controller?

Thanks & best regards, Florian

[1]
https://git.kernel.org/cgit/linux/kernel/git/mchehab/linux-media.git/tree=
/drivers/input/touchscreen/sur40.c#n431
--=20
SENT FROM MY DEC VT50 TERMINAL


--ckOvgvKEdIubxHT4hVo6fp5x87c2vuigK--

--K0PAKXIFuhNUmucqLHNWsTD2Ifa3J8dXK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAldmfucACgkQ7CzyshGvatiXYACg4bQlctlnvuafJniI8kiDADhu
htkAoJ57k+4G6K6jFPnzyHoZGGoPN8Aw
=pc0j
-----END PGP SIGNATURE-----

--K0PAKXIFuhNUmucqLHNWsTD2Ifa3J8dXK--
