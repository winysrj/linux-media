Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55552 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab1KYNGA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 08:06:00 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RTvTa-0004Xd-TH
	for linux-media@vger.kernel.org; Fri, 25 Nov 2011 14:05:58 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 14:05:58 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 14:05:58 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: gnutv should not ignore SIGPIPE
Date: Fri, 25 Nov 2011 08:05:44 -0500
Message-ID: <jao3r9$i9e$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0ABD2552F8854DB88CF24F83"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0ABD2552F8854DB88CF24F83
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Currently, (at least in rev. 1355) gnutv is ignoring SIGPIPE:

	signal(SIGPIPE, SIG_IGN);

This means though that if it is used as such:

gnutv -out stdout -channels /home/mythtv/channels.conf.found 91-472 |
mplayer -

It will not terminate as it should when/if it's consumer (mplayer in
the above example) is killed.

Is there a good reason I am not seeing why gnutv should be ignoring
SIGPIPE?

Cheers,
b.




--------------enig0ABD2552F8854DB88CF24F83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7PkqgACgkQl3EQlGLyuXCWGQCfeDYgY6GiYNSwr+HaYHMMVJQ0
RkgAoN5ps6iAf8au49DtZZdFlHdMbLAG
=Cekq
-----END PGP SIGNATURE-----

--------------enig0ABD2552F8854DB88CF24F83--

