Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53460 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEGKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 01:10:08 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so9478368pab.7
        for <linux-media@vger.kernel.org>; Tue, 04 Feb 2014 22:10:08 -0800 (PST)
Message-ID: <52F1D497.4010509@gmail.com>
Date: Tue, 04 Feb 2014 22:05:11 -0800
From: Connor Behan <connor.behan@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: au0828 errors and mangled video with Hauppauge 950Q
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xxBBMVrdRCo5VIMCd3PDQo7qGG8hO0eTt"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xxBBMVrdRCo5VIMCd3PDQo7qGG8hO0eTt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ccing Devin. I'm pretty sure the analog side has a problem at the driver
level.

On most days, one cannot pickup an ATSC signal where I am, so I am
trying to capture analog video with a Hauppauge WinTV HVR 950Q. Whether
I use Television, Composite or S-Video, I see the same corrupted video
such as this: http://imgur.com/c398F4v

It is supposed to be a hockey game. When the broadcast cuts to a
commercial, I still see frames of the game for about 5 seconds, then the
fuzzy stuff on the screen contains some images from the game and some
images from the commercial, then it fully switches over to the
commercial. Frames that are supposed to be seen at different times are
being mixed together.

When I enable debugging for all of the media modules, my dmesg is
dominated by au0828 calls to print_err_status:
http://pastebin.ca/2628011 When I enable debugging on all modules except
the au0828, what I see is:

Insert tuner: http://pastebin.ca/2628012
mplayer tv:///2: http://pastebin.ca/2628017

Does this shed light on the problem? I'd be happy to test patches.


--xxBBMVrdRCo5VIMCd3PDQo7qGG8hO0eTt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS8dShAAoJENU6BEW0eg2rH3gH/11uMMtsB59M3dxXcM8pK0r6
jPuJSyk8rPKVQpj+hfTh9wYQ6AuIwtBpn3TU35xs1Rphieo91JZ4tljhBp0q2Jqw
7mMBt1lUGKSufKsxNZ21YCSaIh4dbo0EPlohd4ZnS8X/3S6Tq3xzQ7CasckPUM7e
9tZG0gfHPBmYsYgYb8BHo6q2dvf/xceF+1eC6Ny/VtpK8V3fR0TMYsGCvF4vSQw5
4Rcj4isTVAYK3u70FHBRoxp97x8GSkmRoWv+Bo1YQCQVYAnUv2OZD58hZP7GE3cG
25P5sMLdPrGx6+vVnFuLkinOzrB/RZOEml5qyE2YUrX95KO42vy64z2Vzx15dRE=
=E4DA
-----END PGP SIGNATURE-----

--xxBBMVrdRCo5VIMCd3PDQo7qGG8hO0eTt--
