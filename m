Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nADJYDwO015592
	for <video4linux-list@redhat.com>; Fri, 13 Nov 2009 14:34:13 -0500
Received: from mail-gx0-f216.google.com (mail-gx0-f216.google.com
	[209.85.217.216])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nADJYC20012579
	for <video4linux-list@redhat.com>; Fri, 13 Nov 2009 14:34:13 -0500
Received: by gxk8 with SMTP id 8so3679861gxk.11
	for <video4linux-list@redhat.com>; Fri, 13 Nov 2009 11:34:12 -0800 (PST)
Date: Fri, 13 Nov 2009 17:34:05 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20091113193405.GA9499@pathfinder.pcs.usp.br>
MIME-Version: 1.0
Subject: new sensor for a t613 camera
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1516374691=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============1516374691==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

I bought me a new webcam. lsusb said me it was a 17a1:0128 device, for
which the gspca_t613 module is available. But it did not recognize the
sensor number, 0x0802.

I fiddled with the driver source code, and just made it recognize it
as a 0x0803 sensor, called "others" in the code, and I did get images
=66rom the camera. But the colors are extremely wrong, like the contrast
was set to a very high number. It's probably some soft of color
encoding gone wrong...

How can I start hacking this driver to try to make my camera work
under Linux?

Thanks,
  ++nicolau



--=20
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr9tK0ACgkQ0rVki0eJAyeHIwCfXRAkTzirALNp/+F2TGlu6E8+
jycAnA4IIh30NnZFxDB/M0da0OiSLmFI
=OfDV
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--


--===============1516374691==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1516374691==--
