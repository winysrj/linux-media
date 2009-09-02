Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:46421 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZIBOQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 10:16:27 -0400
Received: from [131.159.10.70] (lapnavab35.informatik.tu-muenchen.de [131.159.10.70])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTP id 68AEDA4F4
	for <linux-media@vger.kernel.org>; Wed,  2 Sep 2009 16:06:46 +0200 (CEST)
Subject: gspca_vc032x: Sensor MI1320 in Samsung Q1 Ultra not working
From: Florian Echtler <echtler@in.tum.de>
To: linux-media@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G/GE3HcNg353ae7CacUz"
Date: Wed, 02 Sep 2009 16:06:41 +0200
Message-Id: <1251900401.29777.0.camel@pancake>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-G/GE3HcNg353ae7CacUz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I've installed the latest & greatest v4l drivers from
http://linuxtv.org/hg/~jfrancois/gspca/ and tried to use the camera on a
Samsung Q1 Ultra with them. The camera reports as=20

Bus 001 Device 005: ID 0ac8:c301 Z-Star Microelectronics Corp.

and the gspca_vc032x driver recognizes it - dmesg shows:

[  703.298585] Linux video capture interface: v2.00
[  703.313857] gspca: main v2.7.0 registered
[  703.321625] gspca: probing 0ac8:c301
[  703.322554] vc032x: check sensor header 20
[  703.509321] vc032x: Sensor ID 148c (14)
[  703.509334] vc032x: Find Sensor MI1320_SOC
[  703.511699] gspca: probe ok
[  703.511764] usbcore: registered new interface driver vc032x
[  703.511775] vc032x: registered

However, no video tool works. cheese always reports "libv4l2: error
dequeuing buf: Input/output error" and the svv tool from the linuxtv
website just shows a green screen, nothing else. At one point, I've also
seen an error message in the log along the lines of "frame overflow
616416 > 614400".

Does anybody have a hint for me how to fix this?

Thanks, Yours, Florian
--=20
0666 - Filemode of the Beast


--=-G/GE3HcNg353ae7CacUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqee/EACgkQ7CzyshGvatj8gQCgtPUzfdcrGOU98mDQ4ivSny4x
7aIAoOUGO+zVrvhKxG5atpEK3OIGu+AN
=CEeq
-----END PGP SIGNATURE-----

--=-G/GE3HcNg353ae7CacUz--

