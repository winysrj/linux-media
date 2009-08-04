Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:2460 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZHDJ7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 05:59:04 -0400
Date: Tue, 4 Aug 2009 11:58:35 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: fix recursive locking in .buf_queue()
Message-Id: <20090804115835.10204665.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0908041129340.4627@axis700.grange>
References: <20090804020252.f33f481d.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0908041023450.4627@axis700.grange>
	<20090804111822.b7893079.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0908041129340.4627@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Aug_2009_11_58_35_+0200_epUXCrMkpQP3fvt4"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__4_Aug_2009_11_58_35_+0200_epUXCrMkpQP3fvt4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Aug 2009 11:31:24 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Tue, 4 Aug 2009, Antonio Ospite wrote:
>=20
> > The current patch applies with some fuzzes on vanilla kernels, and it
> > even FAILS to apply for drivers/media/video/sh_mobile_ceu_camera.c in
> > one hunk.
>=20
> Yes, I'll produce one against vanilla for submission.
>=20

Just to make sure you notice: the now unused 'flags' variables can go
away as well.

Thanks,
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

--Signature=_Tue__4_Aug_2009_11_58_35_+0200_epUXCrMkpQP3fvt4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp4BksACgkQ5xr2akVTsAGAcgCdHgCZaFpSZpdibq1bUzMajifc
RScAn3Eh88G06GKL2/GG/L2jmjLqZDzH
=ejyv
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Aug_2009_11_58_35_+0200_epUXCrMkpQP3fvt4--
