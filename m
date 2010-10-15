Return-path: <mchehab@pedra>
Received: from smtp204.alice.it ([82.57.200.100]:42755 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0JOHl5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 03:41:57 -0400
Date: Fri, 15 Oct 2010 09:41:48 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.36] gspca for_2.6.36
Message-Id: <20101015094148.95fd205b.ospite@studenti.unina.it>
In-Reply-To: <20101010132447.0c7f9a22@tele>
References: <20101010132447.0c7f9a22@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Oct_2010_09_41_48_+0200_Vwi0Z93usEMfQ95C"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Fri__15_Oct_2010_09_41_48_+0200_Vwi0Z93usEMfQ95C
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Oct 2010 13:24:47 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> The following changes since commit
> d65728875a85ac7c8b7d6eb8d51425bacc188980:
>=20
>   V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call (2010-09-30 0=
7:35:12 -0300)
>=20
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_2.6.36
>=20
> Jean-Fran=E7ois Moine (1):
>       gspca - main: Fix a regression with the PS3 Eye webcam
>=20

Hi, this is not in 2.6.36-rc8, any chance we can make it for 2.6.36?

Thanks,
   Antonio

>  drivers/media/video/gspca/gspca.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> --=20
> Ken ar c'henta=F1	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__15_Oct_2010_09_41_48_+0200_Vwi0Z93usEMfQ95C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAky4BbwACgkQ5xr2akVTsAEEkgCgg0COV8b6Im8K5uHT2at60DWR
j90AoKzrtCBC1g8qMde6GC/i7foYNv/f
=eEM9
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Oct_2010_09_41_48_+0200_Vwi0Z93usEMfQ95C--
