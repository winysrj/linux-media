Return-path: <linux-media-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:53139 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZJWQEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 12:04:55 -0400
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost1.zedat.fu-berlin.de (Exim 4.69)
          for linux-media@vger.kernel.org with esmtp
          (envelope-from <benpicco@zedat.fu-berlin.de>)
          id <1N1MK7-0003Zp-6M>; Fri, 23 Oct 2009 17:45:03 +0200
Received: from i577b4d86.versanet.de ([87.123.77.134] helo=rechenknecht2k7)
          by inpost2.zedat.fu-berlin.de (Exim 4.69)
          for linux-media@vger.kernel.org with esmtpsa
          (envelope-from <benpicco@zedat.fu-berlin.de>)
          id <1N1MK7-0008CH-2E>; Fri, 23 Oct 2009 17:45:03 +0200
Date: Fri, 23 Oct 2009 17:45:02 +0200
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: linux-media@vger.kernel.org
Subject: pinnacle pctv 7010ix and saa716x
Message-ID: <20091023174502.0608cd4e@rechenknecht2k7>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=9OUvLYVlnFRI8d0ilwqQke"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/=9OUvLYVlnFRI8d0ilwqQke
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,
I have a Pinnacle pctv 7010ix that is oddly recognized as a Pinnacle
PCTV 3010iX [1].
I found that the SAA7162 chip used in that device is supported while
the device itself is not. I was a bit confused wich of the various
repositories I encountered reflects the latest version of development,
however, none of the linux/drivers/media/video/saa7164/saa7164-cards.c
contained a string referring to said pinnacle card.
It seems like the only obstacle that keeps the card from working is the
missing configuration for the board - how does one figure out that?
I would like to get some hints on how to determine necessary
configuration or test some.

regards
Benjamin


[1] lspci -vv: http://paste.pocoo.org/show/146589/
[2] http://mercurial.intuxication.org/hg/s2-liplianin
[3] http://jusst.de/hg/saa716x/summary
[4] http://kernellabs.com/hg/~mkrufky/saa7164/

--Sig_/=9OUvLYVlnFRI8d0ilwqQke
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrhz34ACgkQg4D7JNscH9rt5wCfWzwzX4GkU7vsfh2xXi7Y6+wZ
Gs8Anj8Fqz92xt4cWG48qkXudaRe+W6P
=Weh0
-----END PGP SIGNATURE-----

--Sig_/=9OUvLYVlnFRI8d0ilwqQke--
