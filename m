Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63272 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaDWUfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 16:35:10 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so1153660eek.22
        for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 13:35:09 -0700 (PDT)
Message-ID: <535823E6.8020802@dragonslave.de>
Date: Wed, 23 Apr 2014 22:34:46 +0200
From: Daniel Exner <dex@dragonslave.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: dex@dragonslave.de
Subject: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2ujJqcxpm8NFTKuxu490qJJrHBHM7jOjh"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2ujJqcxpm8NFTKuxu490qJJrHBHM7jOjh
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

(Please keep me in CC as I'm currently not subscribed to this Mailinglist=
)

I happened to inherit one of those DVB-T Sticks

> ID 0ccd:0043 TerraTec Electronic GmbH Cinergy T XS

and of course it isn't working as exspected.

So far I extracted the firmware the tuner_xc2028 module was telling me
(xc3028-v27.fw) and the module loaded.
But no dvb device nodes where created.

I tried connecting directly to it using xawtv and that gave me a load of
"Incorrect readback of firmware version." messages.

Then I tried loading the module with debug=3D1 and now I see:

> Device is Xceive 34584 version 8.7, firmware version 1.8

So I guess the driver is trying to use the wrong firmware file.

I extracted some file named merlinC.rom from the Terratec Windows
Drivers that I suspect to contain the firmware.

Now I need some help how to verify that and create a usable fw File for
the driver.

Greetings
Daniel
--=20
Daniel Exner
Public-Key: https://www.dragonslave.de/pub_key.asc


--2ujJqcxpm8NFTKuxu490qJJrHBHM7jOjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTWCPnAAoJEJzUMd6kHcEp+/sP/12XB83MocmlucH/mLEwfNY6
DKEdPd6TnkIM1s90/bHWfMftHAS1/iZvPFTSZc8ZZReUnd2teaJBp7pEm90m4MsP
5EYpWBbSb4OMhklOo6pO355GhJ6ELVmvxIQTLwrzbqGy+koorHSgyrfbXJTyTld+
Xyn/KmH5IvpfGpx/2s9vreKYyM6TIomdogAvijvL68lGzeEQ8Jzlx0nGx6fmSBXB
zKJ75FeTczYtshMaf2aRhAdSIHXVBiIwXZRhTZTJjqtPWsm52jYuEZlKBx+HqobN
sDaMbTu0pk2wLhpqsaKX+6tWQ6Uf8XORmVzKXOAGsgZ/LB+C/Uuv9Su5r3bS3RW7
LdZOjCjDXAQxUd6OEHvS2lHQZl+zxA5Q6AXoeEek2+Boa7P8jWZ00I8uurmMNKEJ
OnNd/l56vRvdRsOXOT1uHwIhqGMw18qApi92EqrfvWZYYohH3UfVr6tjOQewsf8h
RqdM8Z5fQlgTCfh6FYQtLIFSSPG/3K+Soj+1HtFaiUxqbcfIc7YEXfcq9sFnZnSM
DRBVrcJUg6PlSM4FNzOf+mLpWSH6Df9Qhz4PGltGPONnEKKEBrfIewCLhAiU76IL
nhICpdhJegAbDDoxMiYayO0d7jqLHcU1vF5QzPhUmH3ftGG2hQ+qprTaW6XJYHKx
8ZHBysjXJtf+AWbtvhOA
=C2s7
-----END PGP SIGNATURE-----

--2ujJqcxpm8NFTKuxu490qJJrHBHM7jOjh--
