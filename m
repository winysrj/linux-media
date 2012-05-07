Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53339 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab2EGLP4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 07:15:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SRLv0-0005Rl-Px
	for linux-media@vger.kernel.org; Mon, 07 May 2012 13:15:54 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 13:15:54 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 13:15:54 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: [PATCH 1/1] gnutv: exit on EPIPE/SIGPIPE
Date: Mon, 07 May 2012 07:15:43 -0400
Message-ID: <jo8at0$tm4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB65DFBCE5DE6CA18EEFD4550"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB65DFBCE5DE6CA18EEFD4550
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

When using gnutv with "-out stdout" it doesn't exit when it's reader
quits (i.e. and it gets an EPIPE/SIGPIPE).

Signed-off-by: Brian J. Murrell <brian@interlinx.bc.ca>
---
--- linuxtv-dvb-apps-1.1.1+rev1273~/util/gnutv/gnutv_data.c	2011-11-28 09=
:10:33.010407011 -0500
+++ linuxtv-dvb-apps-1.1.1+rev1273/util/gnutv/gnutv_data.c	2011-11-28 09:=
10:26.446258282 -0500
@@ -265,7 +265,10 @@
 		while(written < size) {
 			int tmp =3D write(outfd, buf + written, size - written);
 			if (tmp =3D=3D -1) {
-				if (errno !=3D EINTR) {
+				if (errno =3D=3D EPIPE) {
+					fprintf(stderr, "processing EPIPE\n");
+					return 0;
+				} else if (errno !=3D EINTR) {
 					fprintf(stderr, "Write error: %m\n");
 					break;
 				}
--- linuxtv-dvb-apps-1.1.1+rev1273~/util/gnutv/gnutv.c	2011-11-28 10:13:1=
3.294445131 -0500
+++ linuxtv-dvb-apps-1.1.1+rev1273/util/gnutv/gnutv.c.new	2011-11-28 10:1=
3:10.510492321 -0500
@@ -262,7 +262,7 @@
=20
 	// setup any signals
 	signal(SIGINT, signal_handler);
-	signal(SIGPIPE, SIG_IGN);
+	signal(SIGPIPE, signal_handler);
=20
 	// start the CA stuff
 	gnutv_ca_params.adapter_id =3D adapter_id;


--------------enigB65DFBCE5DE6CA18EEFD4550
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+nrt8ACgkQl3EQlGLyuXDz0QCg0Ct9JtmVOpw29S8lK+79f0h/
ZJ4AoOz6+YSZwocV7e6/SjNXU7ZdiwBb
=lgQ7
-----END PGP SIGNATURE-----

--------------enigB65DFBCE5DE6CA18EEFD4550--

