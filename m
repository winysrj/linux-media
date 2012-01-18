Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.interlinx.bc.ca ([66.11.173.224]:34648 "EHLO
	linux.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab2ARO3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 09:29:23 -0500
Received: from [10.75.22.1] (pc.ilinx [10.75.22.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by linux.interlinx.bc.ca (Postfix) with ESMTPSA id 047E475994
	for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 09:22:54 -0500 (EST)
Message-ID: <4F16D5BD.6060609@interlinx.bc.ca>
Date: Wed, 18 Jan 2012 09:22:53 -0500
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx18-0: Could not find buf 90 for stream TS
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0300E3123248F62A1F5F1C26"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0300E3123248F62A1F5F1C26
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[ Apologies if this ends up as a duplicate post but my first posting
  (via gmane) a couple of hours ago is still not on the list ]

I have an HVR-1600 on a 2.6.32[-33 Ubuntu] kernel (modinfo says the
cx18 driver is version 1.2.0 with srcversion "DBC252062593953C879E266")
which I have MythTV driving.  Last night a number of recordings from
the analog tuner failed.  The first failure correlates to the following
in the kernel log:

Jan 17 20:30:34 pvr kernel: [565436.263521] cx18-0: Could not find buf 90=
 for stream TS
Jan 17 20:30:34 pvr kernel: [565436.610052] cx18-0: Skipped TS, buffer 83=
, 19 times - it must have dropped out of rotation
Jan 17 20:30:35 pvr kernel: [565437.360282] cx18-0: Could not find buf 50=
 for stream encoder MPEG
Jan 17 20:30:35 pvr kernel: [565438.072959] cx18-0: Skipped encoder MPEG,=
 buffer 33, 61 times - it must have dropped out of rotation
Jan 17 20:30:36 pvr kernel: [565438.537061] cx18-0: Skipped TS, buffer 67=
, 19 times - it must have dropped out of rotation
Jan 17 20:30:36 pvr kernel: [565438.590691] cx18-0: Skipped encoder MPEG,=
 buffer 49, 55 times - it must have dropped out of rotation
Jan 17 20:30:38 pvr kernel: [565440.265314] cx18-0: Could not find buf 81=
 for stream encoder MPEG
Jan 17 20:30:38 pvr kernel: [565440.780971] cx18-0: Skipped TS, buffer 68=
, 19 times - it must have dropped out of rotation
Jan 17 20:30:39 pvr kernel: [565441.705943] cx18-0: Skipped encoder MPEG,=
 buffer 41, 42 times - it must have dropped out of rotation
Jan 17 20:32:01 pvr kernel: [565523.657123] cx18-0: Skipped encoder MPEG,=
 buffer 6, 62 times - it must have dropped out of rotation
Jan 17 20:32:18 pvr kernel: [565540.248743] cx18-0: Skipped encoder MPEG,=
 buffer 62, 62 times - it must have dropped out of rotation
Jan 17 20:32:19 pvr kernel: [565541.337101] cx18-0: Could not find buf 35=
 for stream encoder MPEG
Jan 17 20:32:19 pvr kernel: [565541.862825] cx18-0: Skipped TS, buffer 73=
, 19 times - it must have dropped out of rotation
Jan 17 20:32:19 pvr kernel: [565541.975030] cx18-0: Skipped TS, buffer 82=
, 16 times - it must have dropped out of rotation
Jan 17 20:32:20 pvr kernel: [565543.105033] cx18-0: Unable to find blank =
work order form to schedule incoming mailbox command processing
Jan 17 20:32:21 pvr kernel: [565543.595668] cx18-0: Skipped encoder MPEG,=
 buffer 34, 44 times - it must have dropped out of rotation
Jan 17 20:32:24 pvr kernel: [565546.512745] cx18-0: ignoring gop_end: not=
 (yet?) supported by the firmware

At the same time as the analog recording a digital recording stopped
(very) short of completing with only having captured 36MB.

Beyond that, MythTV reports:

2012-01-17 21:00:06.286397 W [2451/3732] RecThread mpegrecorder.cpp:1358 =
(StartEncoding) - MPEGRec(/dev/video1): StartEncoding failed
                        eno: Input/output error (5)
=2E..
2012-01-17 22:00:05.774512 W [2451/4335] RecThread mpegrecorder.cpp:1358 =
(StartEncoding) - MPEGRec(/dev/video1): StartEncoding failed
                        eno: Input/output error (5)

But ultimately all further recordings (both analog and digital) from
that card failed.

Any ideas what happened?  I can leave this machine as is for a few
hours in case anyone wants any information from it before I reboot it.

Cheers,
b.




--------------enig0300E3123248F62A1F5F1C26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8W1b0ACgkQl3EQlGLyuXAPZwCg4PTNflyj5lh9gRe47n6NH5X6
rF4AoOh0J3zWJsdPoBGuArhG/537Tz97
=e5rO
-----END PGP SIGNATURE-----

--------------enig0300E3123248F62A1F5F1C26--
