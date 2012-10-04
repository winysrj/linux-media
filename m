Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41164 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab2JEBaS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Oct 2012 21:30:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TJwgJ-00007a-1H
	for linux-media@vger.kernel.org; Fri, 05 Oct 2012 03:26:23 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 03:26:22 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 03:26:22 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: hvr-1600 fails frequently on multiple recordings
Date: Wed, 03 Oct 2012 20:44:50 -0400
Message-ID: <k4im62$6tu$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig95C8EA644E0F0192489C4FDD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig95C8EA644E0F0192489C4FDD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a fairly new HVR-1600 which I have seen fail quite a number of
times now when it's asked to record more than one channel on a clearqam
multiplex.  This time it was 3 recordings at once.

There's nothing at all in the kernel ring buffer, just mythtv reports a
failed recording.  Usually one of the files being recorded to will only
be 376 bytes long and the rest will be 0 bytes.

I am running ubuntu's 3.2.0-27-generic kernel with what looks like a
1.5.1 cx18 driver.  The card is either a:

14f1:5b7a Conexant Systems, Inc. CX23418 Single-Chip MPEG-2 Encoder with =
Integrated Analog Video/Broadcast Audio Decoder

or a:

4444:0016 Internext Compression Inc iTVC16 (CX23416) Video Decoder (rev 0=
1)

Sorry.  I don't recall which is which any more.

But I really need to figure this out since failed recordings is causing
all kinds of disappointment around here.  I'm really at the end of my
rope with it.

Tomorrow morning I am going to demote this card to secondary duty and
promote my HVR-950Q to primary duty since I never had this kind of
grief with it.  But even in secondary duty, it could very well be
called upon to record multiple clearqam channels simultaneously so I
would really like to get this figured out.

Any ideas?

Cheers,
b.


--------------enig95C8EA644E0F0192489C4FDD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBs3AMACgkQl3EQlGLyuXD0jgCgsAKhIIWyo60wC7KBJ6iv3f6B
xDkAnA73RMtL9wSGgEwhRGvI8OH3hZjz
=8K+v
-----END PGP SIGNATURE-----

--------------enig95C8EA644E0F0192489C4FDD--

