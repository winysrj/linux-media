Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38774 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab2DYCqT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 22:46:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SMsFG-0004A3-IP
	for linux-media@vger.kernel.org; Wed, 25 Apr 2012 04:46:18 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 04:46:18 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 04:46:18 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: udev rules for persistent symlinks for adapter?/frontend0 devices
Date: Tue, 24 Apr 2012 22:46:08 -0400
Message-ID: <jn7ohg$k5q$1@dough.gmane.org>
References: <jn6n2e$gu1$1@dough.gmane.org> <1335309978.8218.22.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE3E5D636D17FE48340F35D38"
In-Reply-To: <1335309978.8218.22.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE3E5D636D17FE48340F35D38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-04-24 07:26 PM, Andy Walls wrote:
>=20
> Maybe by using matches on DEVPATH and/or DEVNAME along with the other
> attributes you already check?
>=20
=2E..
> KERNEL[1335308536.258048] add      /devices/pci0000:00/0000:00:14.4/000=
0:03:00.0/dvb/dvb0.frontend0 (dvb)
> UDEV_LOG=3D3
> ACTION=3Dadd
> DEVPATH=3D/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.fronte=
nd0

Perhaps this is the ultimate in persistence, but unfortunately is also
highly dependent on physical location in the machine (i.e. which PCI
slot even).

> SUBSYSTEM=3Ddvb
> DEVNAME=3Ddvb/adapter0/frontend0

AFAIU, the "adapter0" is not representative of physical device
persistence but is rather dependent on probing order.  IOW,
"dvb/adapter0/frontend0" will always be the first DVB device found but
won't be a guarantee of which physical device it is.  This is what I
currently have with /dev/dvb/adapter{0.1} which is unfortunately
unsuitable since it's so predictable.

I might end up having to bite the bullet and using DEVNAME.  :-(

Thanks for the info though, much appreciated,
b.


--------------enigE3E5D636D17FE48340F35D38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+XZXAACgkQl3EQlGLyuXCR+wCgs6kDkun5JKEENuNnTRC4XWuG
GuwAoMBH6zXS8m+46Qq9o3Y6xQwO89y6
=AoKQ
-----END PGP SIGNATURE-----

--------------enigE3E5D636D17FE48340F35D38--

