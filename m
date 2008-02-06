Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m16G4aeV019968
	for <video4linux-list@redhat.com>; Wed, 6 Feb 2008 11:04:36 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.170])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m16G3vWY031442
	for <video4linux-list@redhat.com>; Wed, 6 Feb 2008 11:03:58 -0500
Received: by ug-out-1314.google.com with SMTP id t39so458743ugd.6
	for <video4linux-list@redhat.com>; Wed, 06 Feb 2008 08:03:57 -0800 (PST)
From: Francisco Javier Cabello <fjcabello@visual-tools.com>
To: video4linux-list@redhat.com
Date: Wed, 6 Feb 2008 17:03:57 +0100
MIME-Version: 1.0
Message-Id: <200802061704.00367.fjcabello@visual-tools.com>
Subject: saa7130. how many buffers?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0878321185=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0878321185==
Content-Type: multipart/signed; boundary="nextPart1775526.QnCSMlNWI6";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1775526.QnCSMlNWI6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,
I am working with a saa7130 based capture board. It has four saa7134 grabbi=
ng=20
video from four different cameras.
I want to grab 25 fps from each camera. I have realized that saa7130 driver=
=20
uses four video buffers, although you can set more buffers per device.

How many buffers should I use? are four buffers enough? Is there any way ch=
eck=20
if driver is lacking buffers during capture process?

Thanks in advance.

Paco
=2D-=20
One of my most productive days was throwing away 1000 lines of code (Ken=20
Thompson)
=2D----------------
PGP fingerprint: AF69 62B4 97EB F5BB 2C60  B802 568A E122 BBBE 5820
PGP Key available at http://pgp.mit.edu
=2D----------------


--nextPart1775526.QnCSMlNWI6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHqdpwVorhIru+WCARAiCOAJ9RH41iDi3ULnqWweCVqvnxf5FxPwCfa+H6
Aw1RhVr2b00B21Wxm9yOL3U=
=Ycf2
-----END PGP SIGNATURE-----

--nextPart1775526.QnCSMlNWI6--


--===============0878321185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0878321185==--
