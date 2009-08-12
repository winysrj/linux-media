Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42931 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZHLNex (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 09:34:53 -0400
Received: by ewy10 with SMTP id 10so4704ewy.37
        for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 06:34:53 -0700 (PDT)
Subject: Pinnacle PCTV 200e Driver Compilation Error
From: Bernhard =?UTF-8?Q?Vodi=C4=8Dka?= <vodi69@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-13eavgngSE5k1t/ETRtr"
Date: Wed, 12 Aug 2009 15:34:51 +0200
Message-Id: <1250084091.13658.4.camel@vodi-laptop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-13eavgngSE5k1t/ETRtr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Guys!

Today i tried to compile the PCTV 200e Driver from the linuxtv wiki [1]
into my Debian Squeeze/Sid Kernel 2.6.30.

make-kpkg exits with following error:
,---------------------
| drivers/media/dvb/dvb-usb/pctv200e.c:605:5: warning: "LINUX_VERSION_CODE"=
 is not defined
| drivers/media/dvb/dvb-usb/pctv200e.c:605:28: warning: "KERNEL_VERSION" is=
 not defined
| drivers/media/dvb/dvb-usb/pctv200e.c:605:42: error: missing binary operat=
or before token "("
`---------------------

Could you help my to compile it on my Kernel?

bye, Bernhard
--=20
Bernhard Vodi=C4=8Dka=20

Ich kann nicht mehr als schie=C3=9Fen. Au=C3=9Ferdem standen da 40 Leute au=
f der Linie.
		-- Toni Polster (=C3=BCber eine vergebene Torchance)

--=-13eavgngSE5k1t/ETRtr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqCxPUACgkQRsfPIq6hT0RIfgCdEFnMtcPhZyp+ODjIM/N4xT5b
bmAAnRZVdnmuyiNhkCqiTnWAfgQq3Y+t
=ATt7
-----END PGP SIGNATURE-----

--=-13eavgngSE5k1t/ETRtr--

