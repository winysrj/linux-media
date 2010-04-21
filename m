Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out01.alice.it ([85.33.2.12]:4067 "EHLO
	smtp-out01.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0DUKTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 06:19:04 -0400
Date: Wed, 21 Apr 2010 12:06:56 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	jic23@cam.ac.uk
Subject: Re: [PATCH] pxa_camera: move fifo reset direct before dma start
Message-Id: <20100421120656.0fcc2cea.ospite@studenti.unina.it>
In-Reply-To: <87ljciyqk2.fsf@free.fr>
References: <1271746289-14849-1-git-send-email-hbmeier@hni.uni-paderborn.de>
	<Pine.LNX.4.64.1004200905250.5292@axis700.grange>
	<87ljciyqk2.fsf@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_Apr_2010_12_06_56_+0200_CsmxqotlIPS9b_Di"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__21_Apr_2010_12_06_56_+0200_CsmxqotlIPS9b_Di
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Apr 2010 19:36:13 +0200
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>=20
> > Robert, what do you think? Are you still working with PXA camera?
> Hi Guennadi,
>=20
> Yes, I'm still working with pxa_camera :)
>=20
> About the patch, I have a very good feeling about it. I have not tested i=
t, but
> it looks good to me. I'll assume Stefan has tested it, and if you want it,
> please take my :
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
>

FWIW,
Tested-by: Antonio Ospite <ospite@studenti.unina.it>

It works on Motorola A780: pxa_camera + mt9m111
The first picture is now ok.

Thanks Stefan.

Ciao ciao,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Wed__21_Apr_2010_12_06_56_+0200_CsmxqotlIPS9b_Di
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvOzkAACgkQ5xr2akVTsAHzYQCfavgmf8DTfXHPJe4C/RnlCNXs
KdwAnj5BfUVqOCWXqcjtKIs9Veh5Kspf
=ROmA
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Apr_2010_12_06_56_+0200_CsmxqotlIPS9b_Di--
