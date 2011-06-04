Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57584 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1FDSD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 14:03:59 -0400
Received: by pzk9 with SMTP id 9so1260869pzk.19
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2011 11:03:59 -0700 (PDT)
Subject: Re: AverMedia A306 (cx23385, xc3028, af9013) (A577 too ?)
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: wallak@free.fr
Cc: linux-media@vger.kernel.org
In-Reply-To: <1307201853.4dea513d52e5d@imp.free.fr>
References: <S932606Ab1ESVJJ/20110519210909Z+86@vger.kernel.org>
	 <1305839612.4dd587fc20a03@imp.free.fr> <1307119353.15402.5.camel@chimera>
	 <1307201853.4dea513d52e5d@imp.free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OzkgJy1GPj5dGIdQpu3v"
Date: Sat, 04 Jun 2011 11:03:52 -0700
Message-ID: <1307210632.15402.29.camel@chimera>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--=-OzkgJy1GPj5dGIdQpu3v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-06-04 at 17:37 +0200, wallak@free.fr wrote:
> A307 may be close to the A306 board. I've found the following chips: cx23=
385,
> xc[34]?, lg3303). The demodulator is not the same, and follows the ATSC s=
tandard
> (The A306 is DVB-T compatible).
> Coordinating our works may be helpful, for example for the initialization=
 and
> the proper reset of the I2C chips. By email that will be OK.
>=20
> Wallak.

We can take this discussion off-list whenever you are ready. The card is
in the machine on which I am typing this, so I cannot remove it and look
on the underside at this time, but IIRC there indeed is an LG chip
there. The markings on the tuner chip are covered by a thermal compound,
so I cannot read them at all, but my best guess based on the card's
specs is that it is an XC5000. I would like there to be some way to
identify the tuner programmatically, though. However, before beginning
work on the card, I would strongly prefer to verify the functionality of
its baseband inputs, and I lack the cable to attach to the baseband
connector on the card. Can you by any chance determine the pinout, so
that I could have such a cable made? Thank you.

--=-OzkgJy1GPj5dGIdQpu3v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk3qc3wACgkQO/Dos2Fb9DQyfQCeLT7p0CbVk8nPYYNXz5gbjV92
6tUAn3radkeDj7mYsxFdWthCBeHc6PcI
=E+ss
-----END PGP SIGNATURE-----

--=-OzkgJy1GPj5dGIdQpu3v--

