Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56065 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbZCYXsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 19:48:18 -0400
Date: Thu, 26 Mar 2009 00:09:32 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: darron@kewl.org, v4l-dvb-maintainer@linuxtv.org,
	linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: Hauppauge/IR breakage with 2.6.28/2.6.29
Message-ID: <20090326000932.6aa1a456@laptop.hypervisor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O6LBErVZ3_8wUDQolMDHF6_";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/O6LBErVZ3_8wUDQolMDHF6_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

The following patch
http://kerneltrap.org/mailarchive/git-commits-head/2008/10/13/3643574
that was added between 2.6.27 and 2.6.28 has resulted in my Hauppauge
WinTV IR remote not working anymore. I've tracked down the breakage to:

if (dev!=3D0x1e && dev!=3D0x1f)=20
  return 0;

in drivers/media/video/ir-kbd-i2c.c

My remote sends with dev=3D0x0 and is the following model:
http://www.phphuoc.com/reviews/tvtuner_hauppauge_wintv_theater/index_files/=
image001.jpg

Removing the check results in the remote working again. Is there a way to
convince the remote to send a different dev? Otherwise I guess the check
should be relaxed.

Cheers,

	- Udo

--Sig_/O6LBErVZ3_8wUDQolMDHF6_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknKua0ACgkQnhRzXSM7nSk+3wCeOm9FCv4Fa02X0xYEozh+qfxy
6ewAn3IX/sw+awHI+fQ63m2MJZEOszua
=X6FX
-----END PGP SIGNATURE-----

--Sig_/O6LBErVZ3_8wUDQolMDHF6_--
