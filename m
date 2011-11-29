Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33599 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab1K2OWU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 09:22:20 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RVOZf-0001EU-5r
	for linux-media@vger.kernel.org; Tue, 29 Nov 2011 15:22:19 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 29 Nov 2011 15:22:19 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 29 Nov 2011 15:22:19 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: gnutv should not ignore SIGPIPE
Date: Tue, 29 Nov 2011 09:22:05 -0500
Message-ID: <jb2pqe$h8d$1@dough.gmane.org>
References: <jao3r9$i9e$1@dough.gmane.org> <201111251534.05480.remi@remlab.net> <jao5l8$v03$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD4E057360ADAED0BDF53929B"
In-Reply-To: <jao5l8$v03$1@dough.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4E057360ADAED0BDF53929B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 11-11-25 08:36 AM, Brian J. Murrell wrote:
>=20
> Yes, that is the other way to skin that cat I suppose.

I couldn't figure out what the right thing for writer thread to do to
terminate the application so I used SIGPIPE instead.  Here's the patch:

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


--------------enigD4E057360ADAED0BDF53929B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7U6o0ACgkQl3EQlGLyuXAftQCg0+d9mqVC9fu7EaXxOqSEuj+9
1gQAoL2Fzr13QvL9hXr/486007CG5351
=zpWy
-----END PGP SIGNATURE-----

--------------enigD4E057360ADAED0BDF53929B--

