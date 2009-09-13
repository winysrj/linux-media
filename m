Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.km20937-01.keymachine.de ([84.19.184.169]:42090 "EHLO
	mail.mojo.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZIMNXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 09:23:32 -0400
Received: from maistor.s-und-s.home (eko [84.112.117.162])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.mojo.cc (Postfix) with ESMTP id 7A6FA316016E
	for <linux-media@vger.kernel.org>; Sun, 13 Sep 2009 14:57:06 +0200 (CEST)
From: Emanoil Kotsev <emanoil.kotsev@sicherundsicher.at>
Reply-To: Emanoil Kotsev <emanoil.kotsev@sicherundsicher.de>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Terratec T USB XXS 0ccd:00ab device
Date: Sun, 13 Sep 2009 14:56:56 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2128103.7FnOJ9NWir";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909131457.05286.emanoil.kotsev@sicherundsicher.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2128103.7FnOJ9NWir
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello, I've just subscribed this list. I'm normally using knode to read new=
s,=20
but somehow I can not pull the groups etc from the vger server.

I also tried to post to linux-dvb mailing list, but found out that it moved=
=20
here. If you think I need to know something explicitly about participating =
to=20
the list, please let me know.

The issue I'm facing is that my old TV card (HVR900) stopped working, so I=
=20
googled around and decided to buy Terratec T USB XXS, reading it was=20
supported in dvb_usb_dib0700

However after installing the card (usb-stick) it was not recognized (my one=
=20
has product id 0x00ab and not 0x0078), so I googled again and found a hint =
to=20
change the device id in dvb_usb_ids.h which was working for other Terratec=
=20
card.

I pulled the latest v4l-dvb code and did it (perhaps I could have done it i=
n=20
the kernel 2.6.31), compiled, installed and it started working.

However I can not handle udev to get the remote control links created=20
correctly. Can someone help me with it? How can I provide useful output to=
=20
developers to solve the issues with ir? I read and saw that ir control keys=
=20
are coded in the driver, so if the ir part of the 0x00ab card is different,=
=20
how can I get a useful information that can be coded for this card? Who is=
=20
doing the work at linux-dvb?

I read there are other people, returning the cards to the seller, because i=
t's=20
not working/supported by linux, which does not seem to be really true.

Luckilly I have a bit kernel experience and good C knowledge and could do=20
testing if somebody can have a look at the issues - the code is completely=
=20
new to me so that I prefer to be an alpha tester for the device.

thanks for patience in advance and kind regards


=2D-=20
pub   1024D/648C084C 2008-06-06 Emanoil Kotsev=20
<emanoil.kotsev@sicherundsicher.at>
 Primary key fingerprint: 002C AF99 232A 5A44 EF9E  6D7D 0D65 4160 648C 084C

--nextPart2128103.7FnOJ9NWir
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqs7BoACgkQDWVBYGSMCEwH6ACfSJsg3Amiwoe4hGCz4l4KU8V0
T2YAmwU6tcmz9ZtVNOyd5NtyJghgCiGn
=u27O
-----END PGP SIGNATURE-----

--nextPart2128103.7FnOJ9NWir--
