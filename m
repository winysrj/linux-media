Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound-queue-2.mail.thdo.gradwell.net ([212.11.70.35]:37188
	"EHLO outbound-queue-2.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605Ab1JFUMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 16:12:16 -0400
Received: from outbound-edge-2.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-2.mail.thdo.gradwell.net (Postfix) with ESMTP id 5DDC92250B
	for <linux-media@vger.kernel.org>; Thu,  6 Oct 2011 21:06:42 +0100 (BST)
Message-ID: <kQmOmyBaqgjOFweZ@echelon.upsilon.org.uk>
Date: Thu, 6 Oct 2011 21:07:54 +0100
To: linux-media@vger.kernel.org
From: dave cunningham <ml@upsilon.org.uk>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
 <4e8b8099.95d1e30a.4bee.0501@mx.google.com>
 <CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
 <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
 <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
 <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
In-Reply-To: <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;boundary="=_Turnpike_iwFPeqBUqgjO57uG=";
 protocol="application/pgp-signature";micalg=pgp-sha1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a PGP signed message sent according to RFC3156 [PGP/MIME]

--=_Turnpike_iwFPeqBUqgjO57uG=
Content-Type: text/plain;charset=us-ascii;format=flowed
Content-Transfer-Encoding: quoted-printable

In message=20
<CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>,=20
Josu Lazkano wrote

<snip>
>
>I get this I2C messages:
>
># tail -f /var/log/messages
>Oct  5 20:16:44 htpc kernel: [  534.168957] af9013: I2C read failed reg:d3=
30
>Oct  5 20:16:49 htpc kernel: [  538.626152] af9013: I2C read failed reg:d3=
30
>Oct  5 21:22:15 htpc kernel: [ 4464.930734] af9013: I2C write failed
>reg:d2e2 len:1
>Oct  5 21:40:46 htpc kernel: [ 5576.241897] af9013: I2C read failed reg:d2=
e6
>Oct  5 23:07:33 htpc kernel: [10782.852522] af9013: I2C read failed reg:d2=
e6
>Oct  5 23:20:11 htpc kernel: [11540.824515] af9013: I2C read failed reg:d0=
7c
>Oct  6 00:11:41 htpc kernel: [14631.122384] af9013: I2C read failed reg:d2=
e6
>Oct  6 00:26:13 htpc kernel: [15502.900549] af9013: I2C read failed reg:d2=
e6
>Oct  6 00:39:58 htpc kernel: [16328.273015] af9013: I2C read failed reg:d3=
30
>

I have two af9013 sticks in my mythtv backend. One is a KWorld 399U, the=20
other a single tuner Tevion stick.

When I originally setup this system I had major problems with these=20
sticks and also a pair of Freecom WT-220U (which worked perfectly in an=20
older system - I've since disposed of these).

I was seeing I2C read fails similar to the above.

The system in question has an AMD760G southbridge.

After a lot of googling I came across a post somewhere which said that=20
the USB host controller on the 760G is problematic and suggested getting=20
a NEC or VIA hub and using this between the DVB sticks and the root hub.

I bought a cheap hub with an NEC chip on and since then (6 months maybe)=20
I've had no problems with the system. Having said this I probably don't=20
use all three frontends that often (I also have a DVB-S card and this=20
takes precedence) though I certainly have on occasion and don't recall=20
any problems.

--=20
Dave Cunningham                                  PGP KEY ID: 0xA78636DC

--=_Turnpike_iwFPeqBUqgjO57uG=
Content-Type: application/pgp-signature
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: PGPsdk 2.1.1

iQA/AwUATo4KlCuVAX6nhjbcEQKyBACginLeBiHz/o33zY/3IBBIlUo3ouUAoM4v
ZaE6HQdL7mI4HUdEvdNH4nTz
=h8DZ
-----END PGP SIGNATURE-----

--=_Turnpike_iwFPeqBUqgjO57uG=--
