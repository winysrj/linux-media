Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:54290 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbcBQHpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 02:45:25 -0500
Message-ID: <1455695088.1893.11.camel@winder.org.uk>
Subject: Looking for a bit of help with DVB-T(2) and GStreamer
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Wed, 17 Feb 2016 07:44:48 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iYQoPmefJDSem7RMw0wW"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-iYQoPmefJDSem7RMw0wW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I feel I have exhausted Google, Stack Overflow, and the manuals, so I
am asking here as there might be people here with experience and
knowledge. So as to avoid cluttering up this list with what might be
seen as OT material please feel free to email me directly. I can then
summarize to the list later.


With dvbv5-zap I can tune DVB-T and DVB-T2 devices and then use mplayer
to play the MPEG stream from the appropriate dvr0 file.

Using the dvbv5-zap and dvbv5-tune C code as reference, I have some C++
code (it's on GitHub if anyone wants to take a look and have a giggle
:-) that can scan using and tune the DVB-T(2) devices. I can use
mplayer to prove the dvr0 stream is as it should be and I can even get
some playing directly using VLC (though it has problems but this may be
my set up of VLC).

The core problem I am having is that I cannot get a GStreamer pipeline
either in C++ code nor using gst-launch-1.0 to play a properly set up
dvr0 file. In all case I end up with:

Setting pipeline to PAUSED ...
Pipeline is PREROLLING ...

and no actual activity. Has anyone ever managed to get GStreamer to
play a valid MPEG stream from a properly (and provable with mplayer)
set up dvr0 file? I have no problem playing MPEG-4 or MPEG-2 files with
GStreamer, just no success with the dvr0 file.


--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-iYQoPmefJDSem7RMw0wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlbEJPEACgkQ+ooS3F10Be/29QCbB4cls6udQpaGz10Usm6B9WUN
QWkAoPvys9OcIv7eEHTM4SL7SXjwq+99
=1cqm
-----END PGP SIGNATURE-----

--=-iYQoPmefJDSem7RMw0wW--

