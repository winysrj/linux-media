Return-path: <mchehab@pedra>
Received: from smtp204.alice.it ([82.57.200.100]:59627 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab0JFOxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 10:53:46 -0400
Date: Wed, 6 Oct 2010 16:53:37 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-Id: <20101006165337.9c60bb95.ospite@studenti.unina.it>
In-Reply-To: <20101006160441.6ee9583d.ospite@studenti.unina.it>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_16_53_37_+0200_QcrLXZIaupjoYMhs"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Wed__6_Oct_2010_16_53_37_+0200_QcrLXZIaupjoYMhs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Oct 2010 16:04:41 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> On Wed, 6 Oct 2010 13:48:55 +0200
> Jean-Francois Moine <moinejf@free.fr> wrote:
>=20
> > On Wed, 6 Oct 2010 12:33:21 +0200
> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> >=20
> > > with 2.6.36-rc6 I can't use the ov534 gspca subdriver (with PS3 eye)
> > > anymore, when I try to capture video in dmesg I get:
> > > gspca: no transfer endpoint found
> > >=20
> > > If I revert commit 35680ba I can make video capture work again but I
> > > still don't get the audio device in pulseaudio, it shows up in
> > > alsamixer but if I try to select it, on the console I get:
> > > cannot load mixer controls: Invalid argument
> > >=20
[...]
> > About audio stream, I do not see how it can have been broken.
> >
>=20
> PS3 Eye audio is working with linux-2.6.33.7 it is broken in
> linux-2.6.35.7 already, I'll try to further narrow down the interval.
> Ah, alsamixer doesn't work even when the device is OK in pulseaudio...
>=20

I was wrong, the audio part works even in 2.6.36-rc6 but _only_ when
the webcam is plugged in from boot, could this have to do with the order
gspca and snd-usb-audio are loaded?

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__6_Oct_2010_16_53_37_+0200_QcrLXZIaupjoYMhs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkysjXEACgkQ5xr2akVTsAEJCwCgraG+1CVt/Y8NCrnBnldYOnNQ
nf4AniteBSBAGSlEKrqs7hWslJvQumuO
=Rov8
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_16_53_37_+0200_QcrLXZIaupjoYMhs--
