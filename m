Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56708 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaA3IRM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 03:17:12 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so2736576pde.14
        for <linux-media@vger.kernel.org>; Thu, 30 Jan 2014 00:17:11 -0800 (PST)
Received: from [128.189.167.159] (host159-167.resnet.ubc.ca. [128.189.167.159])
        by mx.google.com with ESMTPSA id kk1sm14658335pbd.22.2014.01.30.00.17.09
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 00:17:10 -0800 (PST)
Message-ID: <52EA0964.1020409@gmail.com>
Date: Thu, 30 Jan 2014 00:12:20 -0800
From: Connor Behan <connor.behan@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Hauppauge 950Q corrupted analog video
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UQjvXxOhwKxiIi0KIXOqHLaB07wLVjj5R"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UQjvXxOhwKxiIi0KIXOqHLaB07wLVjj5R
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I am trying to use a Hauppauge WinTV 950Q tuner to capture a signal from
a basic cable package. Most problems I've seen people having with this
card concern audio. I can't even get video to work so I'm only asking
for help with that right now.

The card works in Windows, but when I try it on Linux (3.12.6 and I
tried an older 3.x recently) the video changes rapidly, only fills half
the screen and has blocks in the wrong place. I thought this was an
issue with tuning to the wrong frequency but I see this even with the
composite input.

When I hooked up my PS2 this is a screenshot I got from "mplayer
tv:///1": http://imgur.com/ExuKOWA and 1/30 of a second later, it will
flicker to a very different but equally bad looking frame. I see the
same by running "tvtime" and trying to change various options. None of
these actions show any errors in dmesg. When I plug in the card, I get
http://pastebin.ca/2601413 and when I try to view the signal I only see:

[40375.270946] xc5000: firmware read 12401 bytes.
[40375.270962] xc5000: firmware uploading...
[40378.326038] xc5000: firmware upload complete...

Does this issue look familiar? I've tried everything I can think of, so
I'd really like some ideas for module parameters or lines of code to
change. Thanks.


--UQjvXxOhwKxiIi0KIXOqHLaB07wLVjj5R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS6glrAAoJENU6BEW0eg2rnl4H/jTolwFc/MWHKMbrBXbwa2po
XfDfwbia7euCHlJCYWTxemu7qTTuFejdOVl3JNoYA1oHLChhEN1sDE1mr8vreuqR
GxNs1m1yPHwV9FcsGu57tSG9SGH4W8au6mciwFEaCg5l/rOzMWln/367c93p1XeT
jkocuwSYwDsTTlnXnGF3d2OkZuHOAT+d3NMvf2LRIHMC/ORAjx8jPIazvqhKBBAO
ZQElMcRwfCLuWWDhF9n51fzkFvU9BZ5hHv4M0o52geBFgPgmh0LjqM6S3ga1wglT
1r7ppSfK7NIDJeN0FSTJQmG/VYONOYzhYE7f9dZEJeLFN1nW+8y3OFOtEDxnkNY=
=S7HT
-----END PGP SIGNATURE-----

--UQjvXxOhwKxiIi0KIXOqHLaB07wLVjj5R--
