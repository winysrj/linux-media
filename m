Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:33121 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2EMPLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 11:11:55 -0400
Message-ID: <1336921909.9715.3.camel@anglides.winder.org.uk>
Subject: Re: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs
 updating for London transmitters
From: Russel Winder <russel@winder.org.uk>
To: Andy Furniss <andyqos@ukfsn.org>
Cc: Mark Purcell <mark@purcell.id.au>, linux-media@vger.kernel.org,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
Date: Sun, 13 May 2012 16:11:49 +0100
In-Reply-To: <4FAFC3CA.7070008@ukfsn.org>
References: <201205132005.47858.mark@purcell.id.au>
	  <4FAF89DB.9020004@ukfsn.org>
	 <1336906328.19220.277.camel@launcelot.winder.org.uk>
	 <4FAFC3CA.7070008@ukfsn.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8Id4RejDv0xDO1atr5dQ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8Id4RejDv0xDO1atr5dQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-13 at 15:23 +0100, Andy Furniss wrote:
[...]
> > Should that be 545833000 instead of 545833330, and 529833000 instead of=
 529833330?
> >
> Possibly - I think if you calculate by hand from channel number and add=
=20
> or take the offset if it it <channel>+ or - then you do get the extra 33.

If I remember correctly the OfCom documentation states the +/- offset is
0.166.  Certainly that is what I used for my manual calculation.

> I don't live in London, but using a slightly newer w_scan for my=20
> transmitter gave different output from that, with the 330 -> 000.

Where did you get this w_scan command from, I don't seem to have one.

[...]
> T2 0 16417 802000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO     # East=
=20

I wonder if the 0 and 16417 can be ascertained from OfCom documents?

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

--=-8Id4RejDv0xDO1atr5dQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+vzzUACgkQ+ooS3F10Be8ZIACfQKyrLuwks3VrZ5OOZgVmM7li
SpcAnjU5HxutI9yMnYDxOBPRC5t+9sCD
=W2Tl
-----END PGP SIGNATURE-----

--=-8Id4RejDv0xDO1atr5dQ--

