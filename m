Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40649 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab2K1DYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 22:24:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TdYGm-0006Gl-Sf
	for linux-media@vger.kernel.org; Wed, 28 Nov 2012 04:25:04 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 04:25:04 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 04:25:04 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: ivtv driver inputs randomly "block"
Date: Tue, 27 Nov 2012 22:20:37 -0500
Message-ID: <k93vu3$ffi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA47949618D1771B68945022"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA47949618D1771B68945022
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a machine with a PVR-150 and a PVR-500 in it on a
3.2.0-33-generic (Ubuntu kernel, based on 3.2.1 IIUC) kernel.

I am having problems where at random times random /dev/video[0,1,2]
inputs will just block on read.  It's not the same input every time and
it's not even the same card every time.  This is all hardware which has
worked without any such problems before.

To remedy the hanging input I simply have to rmmod ivtv && modprobe ivtv
and all is back to normal again, until it happens again.

Any ideas?

b.


--------------enigBA47949618D1771B68945022
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC1gwUACgkQl3EQlGLyuXBIHQCfQwnqN/ptzSjMZyRhnnpsYtE9
zy0AoK3Ep1jydxff4f7BlOgDBxZ7W5Xf
=SU2L
-----END PGP SIGNATURE-----

--------------enigBA47949618D1771B68945022--

