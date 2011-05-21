Return-path: <mchehab@pedra>
Received: from smtp209.alice.it ([82.57.200.105]:40241 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1EUJ1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 05:27:21 -0400
Date: Sat, 21 May 2011 11:27:12 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
Message-Id: <20110521112712.74ed3710.ospite@studenti.unina.it>
In-Reply-To: <20110521085933.485f77aa@tele>
References: <20110521085933.485f77aa@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__21_May_2011_11_27_12_+0200_ee..d+b3vV4kk6u3"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Sat__21_May_2011_11_27_12_+0200_ee..d+b3vV4kk6u3
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 21 May 2011 08:59:33 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> The following changes since commit
> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
>=20
>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 =
05:47:20 +0200)
>=20
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_v2.6.40
>=20
> Jean-Fran=E7ois Moine (9):
[...]
>       gspca - main: Remove USB traces

OK, now I got it, thanks a lot :)

BTW there are still a lot of messages using D_USBI and D_USBO in gspca
subdrivers which are now muted unconditionally  by that change, however
I notice that they are mostly about telling what registers and values
are being set and got, we could call that "device specific" messages and
they are kind of independent form the USB transport indeed; do you
think it is worth to have a new debug level to replace D_USB{I,O} in
order to keep those messages? I am not sure about the name tho: D_COMM,
D_DEV, D_REGS, D_IC, D_HW?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sat__21_May_2011_11_27_12_+0200_ee..d+b3vV4kk6u3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3XhXAACgkQ5xr2akVTsAF8xACeM4vDsQFG5vMdf0WMhy/h64Xv
4JMAoLCaZ3poSbu+00EPObnf35hKvIPu
=pWAP
-----END PGP SIGNATURE-----

--Signature=_Sat__21_May_2011_11_27_12_+0200_ee..d+b3vV4kk6u3--
