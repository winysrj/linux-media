Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40174 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2KVTTd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:19:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TbVyq-00032g-6q
	for linux-media@vger.kernel.org; Thu, 22 Nov 2012 13:34:08 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 13:34:08 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 13:34:08 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: one tuner of a PVR-500 not returning any data
Date: Thu, 22 Nov 2012 07:33:47 -0500
Message-ID: <k8l63b$1bd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig125CD5FF34985089AEF45069"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig125CD5FF34985089AEF45069
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a PVR-500 in a machine here where one of the /dev/video* devices
can successfully be opened and return data while the other can be
opened but returns to data to a read(2).  i.e.:

open("/dev/video3", O_RDONLY|O_LARGEFILE) =3D 3
dup3(3, 0, 0)                           =3D 0
close(3)                                =3D 0
fstat64(0, {st_mode=3DS_IFCHR|0660, st_rdev=3Dmakedev(81, 11), ...}) =3D =
0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfc7f568) =3D -1 EINVAL (Invali=
d argument)
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0xb7423000
read(0,=20

and the process blocks there.

Any idea why this might be happening?  Kernel is 3.2.0-33-generic which
I believe is 3.2.1 based.

b.


--------------enig125CD5FF34985089AEF45069
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlCuG6wACgkQl3EQlGLyuXAQGgCg1ZFkPaAjQnbI7Y2HyK/8qZJc
AuEAn0bJ4Pjmfraqch0WbtIzRI3y8t9c
=UQhq
-----END PGP SIGNATURE-----

--------------enig125CD5FF34985089AEF45069--

