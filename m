Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:4400 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZEFOPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 10:15:38 -0400
Date: Wed, 6 May 2009 16:15:42 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-uvc-devel@lists.berlios.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: UVC gadget driver for linux.
Message-Id: <20090506161542.98a2507a.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_May_2009_16_15_42_+0200_BZyCMJrT/HS=+PVA"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__6_May_2009_16_15_42_+0200_BZyCMJrT/HS=+PVA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(I am not subscribed to linux-uvc-devel, so please CC me on reply)

I found this UVC gadget driver for linux developed by Motorola for the
EzX platform, it should be the very same driver which makes the Motorola
ROCKR E6[1,1a] show up as a UVC webcam. It's for linux-2.4, I haven't
looked at it very deeply and I can't comment on its status, but I just
thought to report about it because someone might want to port it to 2.6
and v4l2.

The original tarball is at opensource.motorola.com[2].

You can find a browsable copy of it at git.openezx.org[3].

the relevant filenames are:
  ./drivers/media/video/camera4uvc.c
  ./drivers/media/video/camera4uvc.h
  ./drivers/usbd/UVC_fd
  ./drivers/usbd/UVC_fd/uvc.c
  ./drivers/usbd/UVC_fd/uvc.h

Regards,
   Antonio Ospite

[1]
http://www.motorola.com/motoinfo/product/details.jsp?globalObjectId=3D175

[1a]
http://lists.berlios.de/pipermail/linux-uvc-devel/2007-October/002305.html

[2]
https://opensource.motorola.com/sf/frs/do/downloadFile/projects.a1200/frs.a=
1200e_latam.r541l7_g_11_10_11r/frs6837?dl=3D1

[3]
http://git.openezx.org/?p=3Dmotorola-2.4.git;a=3Dtree;h=3D1627c6705140336fd=
d043af3141b57e752fbbdd2;hb=3D53e66c3b1448c5679cb34d64e18cca65830a25b3

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__6_May_2009_16_15_42_+0200_BZyCMJrT/HS=+PVA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoBm44ACgkQ5xr2akVTsAHXWgCgl6roSUPT4rpNn1b373sDI0Es
y1IAoKbNYYbLE0kMtY7W7mGHIOgYQVg4
=2Msx
-----END PGP SIGNATURE-----

--Signature=_Wed__6_May_2009_16_15_42_+0200_BZyCMJrT/HS=+PVA--
