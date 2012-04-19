Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49768 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab2DSMIb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 08:08:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SKqA2-00046H-NR
	for linux-media@vger.kernel.org; Thu, 19 Apr 2012 14:08:30 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2012 14:08:30 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2012 14:08:30 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: can't rmmod au0828; modprobe au0828 and have a working device
Date: Thu, 19 Apr 2012 08:08:18 -0400
Message-ID: <jmov7j$hrc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5803467D6FB412107E6868A1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5803467D6FB412107E6868A1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have an HVR-950Q:

[44847.234403] tveeprom 0-0050: Hauppauge model 72001, rev B3F0, serial# =
*******
[44847.294643] tveeprom 0-0050: MAC address is **:**:**:**:**:**
[44847.343417] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, ty=
pe 76)
[44847.402873] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (ee=
prom 0x88)
[44847.465471] tveeprom 0-0050: audio processor is AU8522 (idx 44)
[44847.515481] tveeprom 0-0050: decoder processor is AU8522 (idx 42)
[44847.567162] tveeprom 0-0050: has no radio, has IR receiver, has no IR =
transmitter
[44847.630272] hauppauge_eeprom: hauppauge eeprom: model=3D72001

I cannot seem to get it to work after removing the au0828 xc5000 au8522
modules and then modprobing the au0828 module.

If I physically remove the device and plug it back in, it will work
fine, however using rmmod/modprobe it seems to fail on trying to read
from it.  For example:

$ gnutv -adapter 0 -out stdout -channels chans 100-3

just yields a:

Using frontend "Auvitek AU8522 QAM/8VSB Frontend", type ATSC
status       | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |=20

where the value to the right of the signal and snr toggles between
0000 and 0118 but no output is ever emitted.

Why would I need to use rmmod and modprobe to remove and reinstall
the driver you might ask?  To be honest I'd prefer not to have to
but with these drivers loaded suspend-to-ram hangs.  This never used
to be the case on previous (2.6.32ish) kernels but now with the 3.2
kernels that I have been using it is the case.

So in fact, if the hanging-on-suspend problem could be fixed, this
other issue with a failing device after rmmod/modprobe would be moot.

Any ideas on either problem?

Cheers,
b.


--------------enig5803467D6FB412107E6868A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+QADIACgkQl3EQlGLyuXAFgwCdFF301pA7PQYMp7Djoy1z/2KN
Db0AoMgh4atf5b4952Wj1GUdXEMFquyK
=8ga3
-----END PGP SIGNATURE-----

--------------enig5803467D6FB412107E6868A1--

