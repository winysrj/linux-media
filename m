Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:42168 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2EMK6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 06:58:48 -0400
Message-ID: <1336906328.19220.277.camel@launcelot.winder.org.uk>
Subject: Re: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs
 updating for London transmitters
From: Russel Winder <russel@winder.org.uk>
To: Andy Furniss <andyqos@ukfsn.org>
Cc: Mark Purcell <mark@purcell.id.au>, linux-media@vger.kernel.org,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
Date: Sun, 13 May 2012 11:52:08 +0100
In-Reply-To: <4FAF89DB.9020004@ukfsn.org>
References: <201205132005.47858.mark@purcell.id.au>
	 <4FAF89DB.9020004@ukfsn.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-s0cXo8u3PvrintUbYjkn"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-s0cXo8u3PvrintUbYjkn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-13 at 11:15 +0100, Andy Furniss wrote:
[...]
> Transmission mode changed from 2k to 8k in the uk after analogue switch o=
ff.

Of course. I just failed to make that change in my files. With that
changed I got some response from gnome-dvb-setup but it only analysed
one multiplex.

> Chris Rankin already posted UK, Crystal Palace on here.
[...]
> T 490000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE # London .
> T 514000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE # London .
> T 545833330 8MHz 2/3 NONE QAM256 AUTO AUTO AUTO # London .
> T 482000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # London .
> T 506000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # London .
> T 529833330 8MHz 3/4 NONE QAM64 8k 1/32 NONE # London .

Should that be 545833000 instead of 545833330, and 529833000 instead of 529=
833330?

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

--=-s0cXo8u3PvrintUbYjkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+vklgACgkQ+ooS3F10Be813wCePgw7j+XMCU/T7Pib/FosNal+
7ZEAoKCqgYlZKJmkYf5AddJegxt1ODhM
=dFs5
-----END PGP SIGNATURE-----

--=-s0cXo8u3PvrintUbYjkn--

