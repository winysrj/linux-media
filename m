Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35155 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbcJWUkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 16:40:03 -0400
Date: Sun, 23 Oct 2016 22:40:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161023204001.GD6391@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thanks, this answered half of my questions already. ;-)
>=20
> Do all the modes work for you currently btw.?

Aha, went through my notes. This is what it does in 5MP mode, even on
v4.9:

pavel@n900:/my/fcam-dev$ ./camera.py
['-r']
['-l', '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]']
['-l', '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]']
['-l', '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]']
['-l', '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]']
['-V', '"et8ek8 3-003e":0 [SGRBG10 2592x1968]']
['-V', '"OMAP3 ISP CCP2":0 [SGRBG10 2592x1968]']
['-V', '"OMAP3 ISP CCP2":1 [SGRBG10 2592x1968]']
['-V', '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1968]']
['-V', '"OMAP3 ISP CCDC":2 [SGRBG10 2592x1968]']
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture (without
mplanes) device.
Video format set: SGRBG10 (30314142) 2592x1968 (stride 5184) field
none buffer size 10202112
Video format: SGRBG10 (30314142) 2592x1968 (stride 5184) field none
buffer size 10202112
4 buffers requested.
length: 10202112 offset: 0 timestamp type/source: mono/EoF
Buffer 0/0 mapped at address 0xb63a0000.
length: 10202112 offset: 10203136 timestamp type/source: mono/EoF
Buffer 1/0 mapped at address 0xb59e5000.
length: 10202112 offset: 20406272 timestamp type/source: mono/EoF
Buffer 2/0 mapped at address 0xb502a000.
length: 10202112 offset: 30609408 timestamp type/source: mono/EoF
Buffer 3/0 mapped at address 0xb466f000.
0 (0) [E] any 0 10202112 B 0.000000 2792.366987 0.001 fps ts mono/EoF
Unable to queue buffer: Input/output error (5).
Unable to requeue buffer: Input/output error (5).
Unable to release buffers: Device or resource busy (16).
pavel@n900:/my/fcam-dev$

(gitlab.com fcam-dev branch good)

Kernel will say

[ 2689.598358] stream on success
[ 2702.426635] Streamon
[ 2702.426727] check_format checking px 808534338 808534338, h 984
984, w 1296 1296, bpline 2592 2592, size 2550528 2550528 field 1 1
[ 2702.426818] configuring for 1296(2592)x984
[ 2702.434722] stream on success
[ 2792.276184] Streamon
[ 2792.276306] check_format checking px 808534338 808534338, h 1968
1968, w 2592 2592, bpline 5184 5184, size 10202112 10202112 field 1 1
[ 2792.276367] configuring for 2592(5184)x1968
[ 2792.284240] stream on success
[ 2792.368164] omap3isp 480bc000.isp: CCDC won't become idle!
[ 2793.901550] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP CCDC
pavel@n900:/my/fcam-dev$

in this case.

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgNICEACgkQMOfwapXb+vJ2pwCfTkAVrkevAyeDLIAquu1ta2PX
M+wAnj6fqiFFrpAUaVvtaWEgv/qtTebD
=/izl
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
