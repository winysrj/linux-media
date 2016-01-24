Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:53830 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcAXMup (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 07:50:45 -0500
Message-ID: <1453639842.2497.69.camel@winder.org.uk>
Subject: Re: SV: PCTV 292e support
From: Russel Winder <russel@winder.org.uk>
To: Andy Furniss <adf.lists@gmail.com>,
	Peter =?ISO-8859-1?Q?F=E4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sun, 24 Jan 2016 12:50:42 +0000
In-Reply-To: <56A4A262.1090708@gmail.com>
References: <1453613292.2497.26.camel@winder.org.uk>
	 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
	 <1453615078.2497.29.camel@winder.org.uk>
	 <1453618564.2497.51.camel@winder.org.uk>
	 <1453625202.2497.54.camel@winder.org.uk> <56A4A262.1090708@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0pPsvRBorOdyFhE5wIO4"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-0pPsvRBorOdyFhE5wIO4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-01-24 at 10:07 +0000, Andy Furniss wrote:

>=20
> Maybe your uk-CrystalPalace is old.

It's the one distributed with Debian Sid, I would hope it is up to
date. We haven't had a physical channel revamp here in quite a while.
=46rom what I can tell it correctly describes what should be there.

> There's something called w_scan which really does scan.

It finds all the physical channels, quite happily describes all the
virtual channels in the T1 channels, fails to find anything in one of
the T2 channels and finds unnamed channels in the other T2 channel. The
device itself is fine, as it gets all T1 and T2 channels on Windows.
This implies something awry with it in a Linux context.

> Try distro install or searching for it.

Debian Sid packages it, but I have some source code to compile as well.

> I don't use and haven't updated the dvb5 tools for ages. Looking back
> at
> experiments it seems I have T rather than T2 in my tuning files.
> Maybe
> that's something to keep in mind, also IIRC for T2 channels you do
> need
> each frequency (unlike the Ts whose details are found by tuning to
> any
> channel).
>=20
> I don't know your setup or requirements, but using players to
> tune/record will avoid the "-p" issue. I run headless and use
> tvheadend.
> If I had an HTPC setup I would probably use kodi (xbmc).
>=20

The whole point of my activity is to rewrite Me TV. This is intended as
a very lightweight DVB player. The idea is not to have MythTV, Kodi,
etc. which are intended to be media centres. I just want a television
window with EPG. Original Me TV was GTK+2, Xine, DVBv3 with direct
access to the kernel API. I am rewriting for libdvbv5, GStreamer,
GTK+3.=C2=A0

I am starting with scan and tune codes so as to set up dvr0 as the
input source for the rendering. dvbv5-zap -p is an experimental tool to
plug into a gst-launcher-1.0 script just to trial things. My code has
the same problems dvbv5-zap has, describing my problem in terms of
dvbv5-zap behaviour just means it isn't my code that is wrong, there is
an issue somewhere in the libdvbv5 code or the device driver.
=C2=A0=C2=A0
--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-0pPsvRBorOdyFhE5wIO4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlakyKIACgkQ+ooS3F10Be/OOACcDu03NwUK4QFUKXg3O+V1BRtN
298AoJ+mU9Q0Q3+5Kc/IJ+kWjcUvxCWw
=mPxQ
-----END PGP SIGNATURE-----

--=-0pPsvRBorOdyFhE5wIO4--

