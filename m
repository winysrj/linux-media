Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43856 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2KWNYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:24:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TbtFP-0001Mk-Np
	for linux-media@vger.kernel.org; Fri, 23 Nov 2012 14:24:47 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 14:24:47 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 14:24:47 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: one tuner of a PVR-500 not returning any data
Date: Fri, 23 Nov 2012 08:24:26 -0500
Message-ID: <k8nte9$sj1$1@ger.gmane.org>
References: <k8l63b$1bd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8EFCA0D40B19250257A15A14"
In-Reply-To: <k8l63b$1bd$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8EFCA0D40B19250257A15A14
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-11-22 07:33 AM, Brian J. Murrell wrote:
> I have a PVR-500 in a machine here where one of the /dev/video* devices=

> can successfully be opened and return data while the other can be
> opened but returns to data to a read(2).  i.e.:
>=20
> open("/dev/video3", O_RDONLY|O_LARGEFILE) =3D 3
> dup3(3, 0, 0)                           =3D 0
> close(3)                                =3D 0
> fstat64(0, {st_mode=3DS_IFCHR|0660, st_rdev=3Dmakedev(81, 11), ...}) =3D=
 0
> ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfc7f568) =3D -1 EINVAL (Inva=
lid argument)
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb7423000
> read(0,=20
>=20
> and the process blocks there.

FWIW, simply rmoving and inserting the ivtv module seems to have fixed th=
is.

But really odd (to me at least) that it's just one tuner of a dual-tuner
card.  So like 1 piece of hardware, with only 1 submodule not working.

b.




--------------enig8EFCA0D40B19250257A15A14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlCveQoACgkQl3EQlGLyuXBccwCfc91b9j2z+15tekk1J7rh37YT
TLwAmgMGA75rvyECYnfhvzVIRIlKhcmt
=TM7N
-----END PGP SIGNATURE-----

--------------enig8EFCA0D40B19250257A15A14--

