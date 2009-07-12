Return-path: <linux-media-owner@vger.kernel.org>
Received: from t3rror.net ([213.133.102.34]:59580 "EHLO mail.t3rror.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZGLOBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 10:01:22 -0400
Received: from boris64.localnet (p4FC6920C.dip0.t-ipconnect.de [79.198.146.12])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mail.t3rror.net (Postfix) with ESMTPSA id D51612FAA11
	for <linux-media@vger.kernel.org>; Sun, 12 Jul 2009 15:51:01 +0200 (CEST)
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
From: Boris Cuber <me@boris64.net>
Reply-To: me@boris64.net
Date: Sun, 12 Jul 2009 15:50:36 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1730524.ANSHKdQQ30";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907121550.36679.me@boris64.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1730524.ANSHKdQQ30
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi kernel folks!

Problem:
Since kernel-2.6.31-rc* my dvb-s adapter (Technisat SkyStar2 DVB card)
refuses to work (worked fine in every kernel up to 2.6.30.1).
So anything pulled into the new kernel seems to have broken=20
something (at least for me :/).

I opened a detailed bug report here:
http://bugzilla.kernel.org/show_bug.cgi?id=3D13709
Please let me know if i can help in finding a solution
or testing a patch /whatever.

Thank you for your attention ;)

PS: As i'm not subscribed to this mailing list, please
answer to my address or cc me.

=2D-=20
http://boris64.net 20xx ;)

--nextPart1730524.ANSHKdQQ30
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJKWeosAAoJEONrv02ePEYNj2cQAMliFfiNyjEAe9/TNI7bc9B/
PfFgtS9fGMVmZmu4PUZwRqPLtciq58GlqPBnFL+DBw/A0/WsAozuyxj1us0gxqyo
H/A3kxkxB97qEskxr9U5X63Zc0xlIYj5+rRd08Ue4X5fOcfcKYjh5HcXF59OOrpV
C5Ib4KNrbEcwoLTv4AB22kHh9mR5RfWQhhqGBsRCIOCUAss+IeHtAFBBawEWTadS
Z1tsBTIkh2ORuFJ4IsK0d1fL/3CS5Rn4I3HPgH+L5avzRys9i0tukIUEpRhqKx/g
0Yu45kFavW9+mRCcI0R58P1ZLFn3z3UrCngW6V9yaYWL6iWD/qz2SpRq8/rKcU2c
qArtcnW52XmHN8uJkK372INmZbEihJGp5553nSEwL9hHgNpWZURRmXb/Ag3ekCGi
ztUStTJrBQjV8f5p6pd+qDAKBb1AbMfecsyrQq+ZZHGtHmisfhSC0DQY6itiHENU
4Ws/GXGwHqo20e6Fl3lbIlnV/J3ctvrkpbjEgfNQiGVmQGZvaDWhSsVFaBF3nmpX
j71/Tt++wa7eAecM2puOeRrisoAE5QPaiHtmZrpjZ298wb1hXNE3VsCegYlF/wzC
zA3ePzPPc4/k2/zxiz1yRrcb+4Y7xWx4FleZx47znpYfivUOFCGLSOhqqwnpwf0u
KbnVI9PjJFS5V7bYhMSz
=VyGh
-----END PGP SIGNATURE-----

--nextPart1730524.ANSHKdQQ30--
