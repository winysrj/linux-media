Return-path: <linux-media-owner@vger.kernel.org>
Received: from vms173015pub.verizon.net ([206.46.173.15]:62755 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FHSnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 14:43:17 -0400
Received: from [unknown] ([unknown] [129.25.5.251]) by vms173015.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0L3P00FPRLBLA650@vms173015.mailsrvcs.net> for
 linux-media@vger.kernel.org; Tue, 08 Jun 2010 13:42:57 -0500 (CDT)
From: GerbilSoft <gerbilsoft@verizon.net>
To: linux-media@vger.kernel.org
Subject: [em28xx] Non-interlaced composite signal causes lockup
Date: Tue, 08 Jun 2010 14:42:56 -0400
MIME-version: 1.0
Content-type: multipart/signed; boundary=nextPart1512922.ndpNERj78p;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Content-transfer-encoding: 7bit
Message-id: <201006081442.56570.gerbilsoft@verizon.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1512922.ndpNERj78p
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm attempting to use an old video game console on my em28xx-based tuner us=
ing=20
the composite input (WinTV HVR-950). The game console uses a non-standard 2=
62-
line NTSC signal, which works on regular televisions and the same tuner on=
=20
Windows, but on Linux it causes the driver to stall. (This happens in both=
=20
tvtime and mplayer.)

Any ideas on how to fix this so I can use the game console on the composite=
=20
input on my em28xx?

--nextPart1512922.ndpNERj78p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAkwOjzAACgkQFI9sMIk8KDHybwCcDHydajMTsmmjV89zj5mnWiH6
cHQAoKPFOSF7JLXO1YMmWEPKG7fqTQ8C
=3giW
-----END PGP SIGNATURE-----

--nextPart1512922.ndpNERj78p--
