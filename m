Return-path: <mchehab@pedra>
Received: from smtp205.alice.it ([82.57.200.101]:46560 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0JJKC7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 06:02:59 -0400
Date: Sun, 10 Oct 2010 12:02:50 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-Id: <20101010120250.4739ce08.ospite@studenti.unina.it>
In-Reply-To: <20101006203553.22edfeb7@tele>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
	<20101006203553.22edfeb7@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_Oct_2010_12_02_50_+0200_9t5GbswhQOoiD.OJ"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Sun__10_Oct_2010_12_02_50_+0200_9t5GbswhQOoiD.OJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Oct 2010 20:35:53 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 6 Oct 2010 16:04:41 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > Thanks, the following change fixes it, was this what you had in mind?
> >=20
> > diff --git a/drivers/media/video/gspca/gspca.c
[...]
>=20
> Yes, but, after thought, as there is only one alternate setting, the
> tests could be:
> 	if (gspca_dev->audio && i < gspca_dev->nbalt - 1)
> and
> 	if (gspca_dev->audio && i > 0)
>=20
> This should work also for isochronous transfers.

JF this change as is does not work for me, if I change the second check
to=20
	if (gspca_dev->audio && i > 1)

it does, but I don't know if this breaks anything else.

In my case I have:

get_ep: gspca_dev->cam.reverse_alts: 0
get_ep: gspca_dev->alt: 1
get_ep: gspca_dev->nbalt: 1
get_ep: gspca_dev->audio: 1
get_ep: gspca_dev->cam.bulk: 1

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sun__10_Oct_2010_12_02_50_+0200_9t5GbswhQOoiD.OJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyxj0oACgkQ5xr2akVTsAG0AgCgox/nSeU8eqiqXcqKflpj7eIR
7KkAoKdb7TMg7juk++uR35EKlRjWIbmj
=vMrh
-----END PGP SIGNATURE-----

--Signature=_Sun__10_Oct_2010_12_02_50_+0200_9t5GbswhQOoiD.OJ--
