Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:41687 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0DMPLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 11:11:08 -0400
Received: from tyldum.com (unknown [192.168.168.50])
	by ns1.tyldum.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Tue, 13 Apr 2010 17:01:54 +0200 (CEST)
Date: Tue, 13 Apr 2010 17:01:53 +0200
From: Vidar Tyldum Hansen <vidar@tyldum.com>
To: linux-media@vger.kernel.org
Subject: mantis crashes
Message-ID: <20100413150153.GB11631@mail.tyldum.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello list,

I am having issues with my TerraTec Cinergy C DVB-C, described in detail
here: https://bugzilla.kernel.org/show_bug.cgi?id=3D15750

The essence is that machine would reboot or hang at random intervals if
the card is actively used (mythtv or tvheadend running for instance).
Just loading the mantis module and let the card idle does not trigger
anything.


I am trying to figure out if this is a driver or hardware issue, and by
enabling more verbose logging on the mantis module I ended up with the
syslog output attached to the bug report. It shows binary garbage and
function calls for parts of the kernel not in use by the machine in
question right before the crash occurred.

I have not been able to find a different card to test with yet.

So, based on this, is it possible to conclude whom to blame for the
crash?

--=20
       Vidar Tyldum Hansen
                                 vidar@tyldum.com               PGP: 0x3110=
AA98

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvEh2EACgkQsJJnSzEQqpjDvgCfeZDM+NgX+mnXt7c0/cdzM5to
2FAAmQGTjDS36VP/CkQNPKzYzOWF1yQ8
=I4ME
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
