Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA2JcU3g002308
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 14:38:30 -0500
Received: from ptaff.ca (ptaff.ca [82.165.148.111])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA2JbcHY013631
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 14:37:39 -0500
Received: from localhost (unknown [127.0.0.1])
	by ptaff.ca (Postfix) with ESMTP id A3DA8301843
	for <video4linux-list@redhat.com>; Sun,  2 Nov 2008 14:50:28 -0500 (EST)
Received: from ptaff.ca ([127.0.0.1])
	by localhost (ptaff.ca [82.165.148.111]) (amavisd-new, port 10024)
	with LMTP id RItB6tOm+TSf for <video4linux-list@redhat.com>;
	Sun,  2 Nov 2008 14:50:27 -0500 (EST)
Received: from nestor.ptaff.ca (modemcable059.95-56-74.mc.videotron.ca
	[74.56.95.59]) by ptaff.ca (Postfix) with ESMTP id 20688301842
	for <video4linux-list@redhat.com>; Sun,  2 Nov 2008 14:50:27 -0500 (EST)
Date: Sun, 2 Nov 2008 14:37:35 -0500
From: Patrice Levesque <video2linux.wayne@ptaff.ca>
To: video4linux-list@redhat.com
Message-ID: <20081102193735.GA24731@ptaff.ca>
MIME-Version: 1.0
Subject: cx88/cx88-cards.c patch for ATI TV Wonder Pro autodetection
Reply-To: Patrice Levesque <video2linux.wayne@ptaff.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2118521981=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============2118521981==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline


--ftEhullJWpWg/VHq
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi.

There's a second PCI identifier for the ATI TV WONDER PRO card
(0x1002:0x00f9).

Attached is a patch to kernel 2.6.27 that adds autodetection for this
version.



--=20
 --=3D=3D=3D=3D|=3D=3D=3D=3D--
    --------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------
        Patrice Levesque
         http://ptaff.ca/
        video2linux.wayne@ptaff.ca
    --------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------
 --=3D=3D=3D=3D|=3D=3D=3D=3D--
--

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cx88-cards.c.patch"

--- cx88/cx88-cards.c.orig	2008-11-02 14:02:41.000000000 -0500
+++ cx88/cx88-cards.c	2008-11-02 14:01:47.000000000 -0500
@@ -1691,6 +1691,10 @@
 		.subdevice = 0x00f8,
 		.card      = CX88_BOARD_ATI_WONDER_PRO,
 	},{
+		.subvendor = PCI_VENDOR_ID_ATI,
+		.subdevice = 0x00f9,
+		.card      = CX88_BOARD_ATI_WONDER_PRO,
+	},{
 		.subvendor = 0x107d,
 		.subdevice = 0x6611,
 		.card      = CX88_BOARD_WINFAST2000XP_EXPERT,

--KsGdsel6WgEHnImy--

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkOAX8ACgkQGV7PdpISpDLYCQCeMAxShM4/luAOKLWBg1SfQQ2P
VssAnjP8V7tptUKy/AtpwtXytx6h7yJo
=E1ZC
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--


--===============2118521981==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============2118521981==--
