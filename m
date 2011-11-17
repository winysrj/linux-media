Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50370 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab1KQVz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 16:55:28 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RR9vY-0007SL-Gd
	for linux-media@vger.kernel.org; Thu, 17 Nov 2011 22:55:24 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 22:55:24 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 22:55:24 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: "scan" returns channels with no VID
Date: Thu, 17 Nov 2011 16:55:06 -0500
Message-ID: <ja3vrr$27b$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A58C0B7A6555FD003550678"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A58C0B7A6555FD003550678
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi.

Using dvb-apps 1.1.1+rev1355-1ubuntu1 on Ubuntu, I'm scanning my qam
channels with "scan" on both an Hauppage HVR-950q and HVR-1600 and the
resulting output contains channels which I know are both audio and video
yet the VID field of the output is 0.  i.e.

120:585000000:QAM_256:0:5842:11
121:585000000:QAM_256:0:5846:77
122:585000000:QAM_256:0:5848:936
123:585000000:QAM_256:0:5850:958

These are all viewable "channels".  Any ideas why the VID is empty?

At the same time, other "channels" have a VID but are not actually
viewable/tunable:

108:555000000:QAM_256:3691:3692:726
109:555000000:QAM_256:3695:3696:728
110:555000000:QAM_256:3693:3694:727

Any ideas?

Cheers,
b.


--------------enig2A58C0B7A6555FD003550678
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7FgrsACgkQl3EQlGLyuXCrWgCeJlKPxbiveeEmrPVQHBob4GU8
4tYAoLueMNRhK292Ho47X+IClXhDRAWH
=SkdJ
-----END PGP SIGNATURE-----

--------------enig2A58C0B7A6555FD003550678--

