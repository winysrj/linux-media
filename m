Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab2DWDaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 23:30:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SM9yc-0006hy-Rk
	for linux-media@vger.kernel.org; Mon, 23 Apr 2012 05:30:10 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 05:30:10 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 05:30:10 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: HVR-1600 QAM recordings with slight glitches in them
Date: Sun, 22 Apr 2012 23:30:00 -0400
Message-ID: <jn2ibp$pot$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig706BE1306D1AC611D324BBC0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig706BE1306D1AC611D324BBC0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I have an HVR-1600 on a 3GHz dual-core P4 running linux 3.2.0.

Whenever I record from clearqam using this card I frequently get small
"glitches" in playback.  Playing these same files with mplayer yields
things like:

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]Warning MVs not available
[mpeg2video @ 0x893a2e0]concealing 66 DC, 66 AC, 66 MV errors

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.
[mpeg2video @ 0x893a2e0]invalid cbp at 4 12
[mpeg2video @ 0x893a2e0]Warning MVs not available
[mpeg2video @ 0x893a2e0]concealing 198 DC, 198 AC, 198 MV errors
[mpeg2video @ 0x893a2e0]ac-tex damaged at 11 24
[mpeg2video @ 0x893a2e0]Warning MVs not available
[mpeg2video @ 0x893a2e0]concealing 99 DC, 99 AC, 99 MV errors

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.
[mpeg2video @ 0x893a2e0]ac-tex damaged at 27 0
[mpeg2video @ 0x893a2e0]ac-tex damaged at 1 1
[mpeg2video @ 0x893a2e0]ac-tex damaged at 6 2
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]invalid cbp at 15 6
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]ac-tex damaged at 4 8
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 21 10
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]ac-tex damaged at 12 15
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]invalid cbp at 14 18
[mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 12 20
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]ac-tex damaged at 1 22
[mpeg2video @ 0x893a2e0]invalid cbp at 1 23
[mpeg2video @ 0x893a2e0]ac-tex damaged at 20 24
[mpeg2video @ 0x893a2e0]invalid cbp at 1 25
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]ac-tex damaged at 13 29
[mpeg2video @ 0x893a2e0]concealing 990 DC, 990 AC, 990 MV errors

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20

demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.
[mpeg2video @ 0x893a2e0]ac-tex damaged at 14 10
[mpeg2video @ 0x893a2e0]ac-tex damaged at 9 10
[mpeg2video @ 0x893a2e0]invalid mb type in P Frame at 2 11
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]ac-tex damaged at 24 14
[mpeg2video @ 0x893a2e0]ac-tex damaged at 9 14
[mpeg2video @ 0x893a2e0]ac-tex damaged at 3 18
[mpeg2video @ 0x893a2e0]ac-tex damaged at 16 16
[mpeg2video @ 0x893a2e0]ac-tex damaged at 10 17
[mpeg2video @ 0x893a2e0]ac-tex damaged at 10 18
[mpeg2video @ 0x893a2e0]invalid mb type in P Frame at 9 20
[mpeg2video @ 0x893a2e0]ac-tex damaged at 10 20
[mpeg2video @ 0x893a2e0]ac-tex damaged at 11 22
[mpeg2video @ 0x893a2e0]invalid cbp at 1 22
[mpeg2video @ 0x893a2e0]ac-tex damaged at 8 23
[mpeg2video @ 0x893a2e0]ac-tex damaged at 3 24
[mpeg2video @ 0x893a2e0]invalid cbp at 2 26
[mpeg2video @ 0x893a2e0]ac-tex damaged at 9 26
[mpeg2video @ 0x893a2e0]ac-tex damaged at 0 27
[mpeg2video @ 0x893a2e0]ac-tex damaged at 0 28
[mpeg2video @ 0x893a2e0]ac-tex damaged at 0 29
[mpeg2video @ 0x893a2e0]concealing 660 DC, 660 AC, 660 MV errors
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]concealing 297 DC, 297 AC, 297 MV errors
[mpeg2video @ 0x893a2e0]invalid cbp at 1 5
[mpeg2video @ 0x893a2e0]ac-tex damaged at 1 9
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 5 15
[mpeg2video @ 0x893a2e0]invalid cbp at 16 18
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]mb incr damaged
[mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 17 21
[mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 11 22
[mpeg2video @ 0x893a2e0]invalid cbp at 2 23
[mpeg2video @ 0x893a2e0]ac-tex damaged at 9 25
[mpeg2video @ 0x893a2e0]invalid mb type in B Frame at 4 26
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]concealing 891 DC, 891 AC, 891 MV errors

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4] =20
=2E..
demux_mpg: 24000/1001fps progressive NTSC content detected, switching fra=
merate.
[mpeg2video @ 0x893a2e0]slice mismatch
[mpeg2video @ 0x893a2e0]invalid cbp at 15 11
[mpeg2video @ 0x893a2e0]concealing 132 DC, 132 AC, 132 MV errors
[mpeg2video @ 0x893a2e0]concealing 21 DC, 21 AC, 21 MV errors
TS_PARSE: COULDN'T SYNC

I am in particular pointing out the "mpeg2video" errors not the
framerate switching messages.

There are no messages whatsoever in the kernel log when this
happens so whatever is happening the cx18 driver is being silent
about it.

I also can't very easily blame the cable signal as an HVR-950Q
recording from clearqam at the exact same time never has these
sorts of artifacts.

Any thoughts why these only happen on the HVR-1600?

Cheers,
b.


--------------enig706BE1306D1AC611D324BBC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+UzLgACgkQl3EQlGLyuXCGtQCgw1jWIawZ1A/ODUZJcLV1MZNV
4tsAnid98yKn0nZmloXVPOGnea/ifl9n
=UUJY
-----END PGP SIGNATURE-----

--------------enig706BE1306D1AC611D324BBC0--

