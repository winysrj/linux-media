Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39166 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2DVQD2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 12:03:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SLzG1-0002AV-8J
	for linux-media@vger.kernel.org; Sun, 22 Apr 2012 18:03:25 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2012 18:03:25 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2012 18:03:25 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: HVR-1600: Skipped encoder MPEG, MDL 63, 62 times - it must have dropped
 out of rotation
Date: Sun, 22 Apr 2012 12:03:14 -0400
Message-ID: <jn1a43$vlj$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig500B52F6747773509B013FE9"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig500B52F6747773509B013FE9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I've got an HVR-1600 in a fairly fast machine (P4 3GHz, two cores) on a
3.2.0 kernel and seem to be getting lots of this sort of thing:

Apr 19 20:09:10 pvr kernel: [34651.015170] cx18-0: Skipped encoder MPEG, =
MDL 63, 62 times - it must have dropped out of rotation
Apr 19 20:10:05 pvr kernel: [34705.375793] cx18-0: Skipped encoder IDX, M=
DL 415, 2 times - it must have dropped out of rotation
Apr 19 20:12:45 pvr kernel: [34865.535784] cx18-0: Skipped encoder IDX, M=
DL 426, 2 times - it must have dropped out of rotation
Apr 19 20:12:45 pvr kernel: [34865.609900] cx18-0: Skipped encoder IDX, M=
DL 430, 1 times - it must have dropped out of rotation
Apr 19 20:12:45 pvr kernel: [34865.684180] cx18-0: Could not find MDL 426=
 for stream encoder IDX
Apr 19 20:12:58 pvr kernel: [34878.912976] cx18-0: Could not find MDL 430=
 for stream encoder IDX
Apr 19 20:13:00 pvr kernel: [34880.850172] cx18-0: Skipped encoder MPEG, =
MDL 53, 62 times - it must have dropped out of rotation
Apr 19 20:15:25 pvr kernel: [35025.696747] cx18-0: Skipped encoder IDX, M=
DL 435, 2 times - it must have dropped out of rotation
Apr 19 20:15:25 pvr kernel: [35025.771765] cx18-0: Skipped encoder IDX, M=
DL 439, 1 times - it must have dropped out of rotation
Apr 19 20:15:25 pvr kernel: [35025.847732] cx18-0: Could not find MDL 435=
 for stream encoder IDX
Apr 19 20:15:25 pvr kernel: [35025.901315] cx18-0: Skipped TS, MDL 82, 16=
 times - it must have dropped out of rotation
Apr 19 20:15:32 pvr kernel: [35032.370364] cx18-0: Skipped encoder IDX, M=
DL 435, 2 times - it must have dropped out of rotation
Apr 19 20:15:38 pvr kernel: [35039.074592] cx18-0: Could not find MDL 439=
 for stream encoder IDX
Apr 19 20:15:40 pvr kernel: [35040.938552] cx18-0: Skipped encoder MPEG, =
MDL 29, 62 times - it must have dropped out of rotation
Apr 19 20:18:05 pvr kernel: [35185.859652] cx18-0: Skipped encoder IDX, M=
DL 445, 2 times - it must have dropped out of rotation
Apr 19 20:18:05 pvr kernel: [35185.933816] cx18-0: Skipped encoder IDX, M=
DL 449, 1 times - it must have dropped out of rotation
Apr 19 20:18:05 pvr kernel: [35186.008176] cx18-0: Could not find MDL 445=
 for stream encoder IDX
Apr 19 20:18:19 pvr kernel: [35199.237035] cx18-0: Could not find MDL 449=
 for stream encoder IDX
Apr 19 20:18:19 pvr kernel: [35199.289870] cx18-0: Could not find MDL 49 =
for stream encoder MPEG
Apr 19 20:18:25 pvr kernel: [35205.879310] cx18-0: Skipped encoder IDX, M=
DL 450, 2 times - it must have dropped out of rotation
Apr 19 20:23:26 pvr kernel: [35506.147134] cx18-0: Skipped encoder IDX, M=
DL 402, 2 times - it must have dropped out of rotation
Apr 19 20:24:19 pvr kernel: [35559.705155] cx18-0: Skipped encoder MPEG, =
MDL 16, 62 times - it must have dropped out of rotation

IIRC I was told previously that it was due to interrupts not being
serviced quickly enough.  Am I recalling correctly?

Could that really be a problem even with a dual core 3GHz P4?

Also, are those messages related to the clearqam path or the
MPEG2 hardware encoder path?  i.e. are those digital recording
messages or analog recording messages?

Cheers,
b.


--------------enig500B52F6747773509B013FE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+UK8MACgkQl3EQlGLyuXBAfwCfWcErXJQJFTFz3CgduBjCiXBr
g68AoMX4in1jw4fnEA8TFHfn4dBin/N6
=u/vM
-----END PGP SIGNATURE-----

--------------enig500B52F6747773509B013FE9--

