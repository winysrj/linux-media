Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:55316 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab0JFKjI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 06:39:08 -0400
Date: Wed, 6 Oct 2010 12:33:21 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>,
	Jim Paris <jim@jtan.com>, Max Thrun <bear24rw@gmail.com>
Subject: gspca, audio and ov534: regression.
Message-Id: <20101006123321.baade0a4.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_12_33_21_+0200_f_RETOOkhwsC.2MO"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Wed__6_Oct_2010_12_33_21_+0200_f_RETOOkhwsC.2MO
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

with 2.6.36-rc6 I can't use the ov534 gspca subdriver (with PS3 eye)
anymore, when I try to capture video in dmesg I get:
gspca: no transfer endpoint found

If I revert commit 35680ba I can make video capture work again but I
still don't get the audio device in pulseaudio, it shows up in alsamixer
but if I try to select it, on the console I get:
cannot load mixer controls: Invalid argument

I'll test with latest Jean-Fran=E7ois tree, and if it still fails I'll try
to find a solution, but I wanted to report it quickly first, I hope we
fix this before 2.6.36.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__6_Oct_2010_12_33_21_+0200_f_RETOOkhwsC.2MO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkysUHEACgkQ5xr2akVTsAE/+QCcDkViYbv9x1BCdl44HC/hJMPn
rMsAn2gWwJrY50hfypYkf8H4iuQT8HB1
=kGVN
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_12_33_21_+0200_f_RETOOkhwsC.2MO--
