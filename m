Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out28.alice.it ([85.33.2.28]:1738 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZH2Pfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 11:35:50 -0400
Date: Sat, 29 Aug 2009 17:35:27 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-media@vger.kernel.org, moinejf@free.fr
Subject: Re: [Fwd: How to debug problem with Playstation Eye webcam?]
Message-Id: <20090829173527.5cb7fb76.ospite@studenti.unina.it>
In-Reply-To: <1251508203.3200.34.camel@palomino.walls.org>
References: <1251508203.3200.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__29_Aug_2009_17_35_28_+0200_6J9Kw3w=qp=DXy3u"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sat__29_Aug_2009_17_35_28_+0200_6J9Kw3w=qp=DXy3u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> -------- Forwarded Message --------
> From: Tim Bird <tim.bird@am.sony.com>

> I'm trying to get a Playstation Eye webcam working under a new install of
> Fedora 11 and not having much luck.
>=20
> I'm running a stock Fedora kernel (2.6.29.4).
>

Hi Tim,

before doing any further investigation about code in 2.6.29.4, forgive
the silly question: is using a more recent kernel/driver an option for
you?
I've just tried latest code from v4l-dvb and it "just works" with the
applications I use. You can get the mercurial repository here
http://linuxtv.org/hg/v4l-dvb

I know that there was a regression in 2.6.30 (not sure about 2.6.29.4)
and a patch has been sent by Jim Paris to fix it, I don't know if it is
already in a 2.6.30.x release, tho. The change is this one:
http://patchwork.kernel.org/patch/42114/

> When I plug in the device, /dev/video0 is created, and the modules
> gspca_main and gspca_ov534 are loaded into the kernel.
>=20
> The device responds to QUERYCAP and other interrogation commands
> from user space, but when my test program actually tries to read
> the device, I get a multi-second delay, and an eventual
> errno of EIO.
>

I tested the driver with "mplayer" and "luvcview" during development,
and I am now using it with "cheese", I've never run v4l-test.

> I ran v4l-test version 0.19, and some tests succeeded and others failed.
> Results are shown below.  Note that I had to disable the test
> "VIDIOC_G_CTRL with NULL parameter", because that resulted in a hang
> of v4l-test when run against the 'Eye' webcam.
>

I confirm this happens also with the "just working" latest version.

> A logitech web camera has mixed results from v4l-test as well
> (succeeding and failing in different places from the Playstation Eye).
> But the logitech works fine with my test program and a variety of
> other programs.
>=20
> I'm not sure where to look next to continue debugging this.
> I assume that the general relationship of components is:
> test program ->linux kernel -> gspca main driver ->
> 	USB and ov534 driver -> USB and camera hardware
>=20
> Any tips for how to figure out where the problem might be,
> reports of previous experience with this webcam, or additional
> diagnostic tools or techniques would be much appreciated.
>

I'd give a run to _latest_ code to see if the problem has been
solved already, and if you really can't use it, then you isolate the fix
and apply it to the code you have to use.
Captain Obvious to the rescue :)

> Thanks,
>  -- Tim
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> Tim Bird
> Architecture Group Chair, CE Linux Forum
> Senior Staff Engineer, Sony Corporation of America
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>

Regards,
   Antonio Ospite

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Sat__29_Aug_2009_17_35_28_+0200_6J9Kw3w=qp=DXy3u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqZSsAACgkQ5xr2akVTsAHCtgCdGJdjKLAAzo2sbBaK7QL/v+5N
w6IAn0AaaOAZwhzDg7gUG4Pdlay2W9Qa
=XJuB
-----END PGP SIGNATURE-----

--Signature=_Sat__29_Aug_2009_17_35_28_+0200_6J9Kw3w=qp=DXy3u--
