Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.tu-cottbus.de ([141.43.99.248]:41835 "EHLO
	smtp2.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0CQPFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 11:05:49 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp2.tu-cottbus.de (Postfix) with ESMTP id 0D7DF690170
	for <linux-media@vger.kernel.org>; Wed, 17 Mar 2010 15:59:08 +0100 (CET)
Received: from loki (cd1.cd.tu-cottbus.de [141.43.159.77])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: meshciev)
	by smtp2.tu-cottbus.de (Postfix) with ESMTPSA id 604CF69013B
	for <linux-media@vger.kernel.org>; Wed, 17 Mar 2010 15:59:01 +0100 (CET)
Date: Wed, 17 Mar 2010 15:59:00 +0100
From: Eugeniy Meshcheryakov <eugen@debian.org>
To: linux-media@vger.kernel.org
Subject: Problem with em28xx card, PAL and teletext
Message-ID: <20100317145900.GA7875@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I have a Pinnacle Hybrid Pro Stick (in kernel source "Pinnacle Hybrid
Pro (2)", driver em28xx). Several kernel releases ago it started to have
problem displaying analog tv correctly. The picture is shifted and
there is green line on the bottom (see http://people.debian.org/~eugen/tv.png).
Also part of the picture is shifted from the right edge to the left
(several columns). TV norm is PAL-BG. I noticed that teletext is also
not correct. I can see some full words, but text itself is not readable.
Picture is correct if i load em28xx with disable_vbi=1.

Please CC me in replies.

Regards,
Eugeniy Meshcheryakov

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkug7jQACgkQKaC6+zmozOKJDgCfdHH7so4VPOjo8Rwcv97nGQms
6K4An3JndP2Wfyn41tsokbnKDVSCSbwV
=KZUc
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
