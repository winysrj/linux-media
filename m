Return-path: <mchehab@pedra>
Received: from smtp204.alice.it ([82.57.200.100]:34828 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0JJJpr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 05:45:47 -0400
Date: Sun, 10 Oct 2010 11:45:36 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-Id: <20101010114536.1ecbaf29.ospite@studenti.unina.it>
In-Reply-To: <20101007194401.4a327081@tele>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
	<20101006165337.9c60bb95.ospite@studenti.unina.it>
	<20101007194401.4a327081@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_Oct_2010_11_45_36_+0200_=1poc6VNMzCaSh8B"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Sun__10_Oct_2010_11_45_36_+0200_=1poc6VNMzCaSh8B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Oct 2010 19:44:01 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 6 Oct 2010 16:53:37 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > > PS3 Eye audio is working with linux-2.6.33.7 it is broken in
> > > linux-2.6.35.7 already, I'll try to further narrow down the
> > > interval. Ah, alsamixer doesn't work even when the device is OK in
> > > pulseaudio...=20
> >=20
> > I was wrong, the audio part works even in 2.6.36-rc6 but _only_ when
> > the webcam is plugged in from boot, could this have to do with the
> > order gspca and snd-usb-audio are loaded?
>=20
> Hi Antonio,
>=20
> If you still have a kernel 2.6.33, may you try my test version (tarball
> in my web page)? As it contain only the gspca stuff, this may tell if
> the problem is in gspca or elsewhere in the kernel.
>=20

JF I suspect the device not showing up in pulseaudio has nothing to do
with gspca at all. I can actually record audio using alsa even if
pulseaudio does not see the device, so it must be a pulseaudio issue.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sun__10_Oct_2010_11_45_36_+0200_=1poc6VNMzCaSh8B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyxi0AACgkQ5xr2akVTsAERWwCfXALCDsc7fTtQ6QAYxOf0HYlW
hlAAmgLNMRSawLI+gSoDy8ZDdN2fajKN
=7SFf
-----END PGP SIGNATURE-----

--Signature=_Sun__10_Oct_2010_11_45_36_+0200_=1poc6VNMzCaSh8B--
