Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.interlinx.bc.ca ([216.58.37.5]:49056 "EHLO
	linux.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab2JDMNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 08:13:30 -0400
Received: from [IPv6:2001:4978:161:0:214:d1ff:fe13:45ac] (pc.interlinx.bc.ca [IPv6:2001:4978:161:0:214:d1ff:fe13:45ac])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by linux.interlinx.bc.ca (Postfix) with ESMTPSA id 73BAC86D0
	for <linux-media@vger.kernel.org>; Thu,  4 Oct 2012 07:58:23 -0400 (EDT)
Message-ID: <506D79DE.3040403@interlinx.bc.ca>
Date: Thu, 04 Oct 2012 07:58:22 -0400
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: hvr-1600 fails frequently on multiple recordings
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90FB4153559E3B6EF794FE21"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90FB4153559E3B6EF794FE21
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

14f1:5b7a Conexant Systems, Inc. CX23418 Single-Chip MPEG-2 Encoder with
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




--------------enig90FB4153559E3B6EF794FE21
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBted4ACgkQl3EQlGLyuXD0xwCgn3v/q6jATL8zqdZVsU9RfZ0Z
f60AoIZf2GUGtEHl1Z/51gGJlHAF8T/J
=e3bd
-----END PGP SIGNATURE-----

--------------enig90FB4153559E3B6EF794FE21--
