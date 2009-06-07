Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv2.rent-a-guru.de ([212.86.204.162]:26536 "EHLO
	mx02.rent-a-guru.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZFGU2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 16:28:07 -0400
Date: Sun, 7 Jun 2009 22:27:48 +0200
From: Michael Stapelberg <michael+lm@stapelberg.de>
To: linux-media@vger.kernel.org
Cc: dl6jv@chaoswelle.de
Subject: [PATCH] bt8xx: Add support for the Conexant Fusion 878a / Twinhan
	VP 1025 DVB-S
Message-ID: <20090607202748.GM10731@mx01>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--H8ygTp4AXg6deix2
Content-Type: multipart/mixed; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Add fefe:0001 to the list of identifiers for the bt8xx driver. The chip is
named Conexant Fusion 878a, the card is a Twinhan VP 1025 DVB-S PCI.

Please commit the attached patch.

Thanks and best regards,
Michael

--Pd0ReVV5GZGQvF3a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="fusion.patch"
Content-Transfer-Encoding: quoted-printable

--- bt878.orig.c	2009-06-07 22:23:33.000000000 +0200
+++ bt878.c	2009-06-07 22:23:27.000000000 +0200
@@ -405,6 +405,7 @@
 	BROOKTREE_878_DEVICE(0x18ac, 0xd500, "DViCO FusionHDTV 5 Lite"),
 	BROOKTREE_878_DEVICE(0x7063, 0x2000, "pcHDTV HD-2000 TV"),
 	BROOKTREE_878_DEVICE(0x1822, 0x0026, "DNTV Live! Mini"),
+	BROOKTREE_878_DEVICE(0xfefe, 0x0001, "Conexant Fusion / Twinhan VP 1025 D=
VB-S"),
 	{ }
 };
=20

--Pd0ReVV5GZGQvF3a--

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKLCLEAAoJEE5xYO1KyO4da9EQAIh86rO/ZPZYOiICUwTYMSgw
5pM/5ZZFkf+6e+Dt/G9uoc6q1uUCmw4WIH993/gUHY5WqRPedYAVRqGFg1UmJiae
Uv7iJkt6I1MUbyvJXOTO83KHBXRM42EJHC/bAoJWDj7iwu+rdSUJZRViSF61/AAg
L/TshLa6ylp085JKn1iL05qRlwG42/nSopDuF6r384gYK02OtSlBZ5rzDt4EuG7x
aIth3wFphka3pN6gQmKjDTurCTNdk60UjxGIUFtUBQQJeV3GlxCYO4eiFqU9J2MS
HrWk9YLA7hqAsf4Q6V6JK4g2m9f7Z84m2LkYn314Kgd3bZ8ZCoCB9vzScqLRvpNi
F01kSg22tymAyzvfGl1Q5CXq5iK0vDlMNAXmfA007WLD9C/0A/uC/TH3g7yvsCrL
WWdugBpob+0Bt0AWdV36RK7Wb/7rjQkhK0R0N/D/p0gSbhEFtdQSs9gGzGzo09qB
Ykz+SVKTJiFQh+AfeY+3xWqdrUI8+GYBpFv1zRzKu6jI+6W1/zy9s+gqYf3MYhLO
pdT0S8N8WSMx7hodguSyU+fTMAexCWIhNQx+jDPAvr5Qs3uFy05A5Ean5MOOmQIP
Y8mS/hGvPcrcD7j1kNSXrZ/XCraoCuSvLNWiWnTEiZKcw4GLusV8mvVI9mo2Etuc
mxCiwirBs3Lljxyio4Ry
=0Bhz
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
