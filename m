Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:2565 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbZHDJSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 05:18:55 -0400
Date: Tue, 4 Aug 2009 11:18:22 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: fix recursive locking in .buf_queue()
Message-Id: <20090804111822.b7893079.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0908041023450.4627@axis700.grange>
References: <20090804020252.f33f481d.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0908041023450.4627@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Aug_2009_11_18_23_+0200_.k=71J_TQYEP4V9j"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__4_Aug_2009_11_18_23_+0200_.k=71J_TQYEP4V9j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Aug 2009 10:30:47 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Tue, 4 Aug 2009, Antonio Ospite wrote:
>
> > verified to be present in linux-2.6.31-rc5, here's some info dumped
> > from RAM, since the machine hangs, sorry if it is not complete but I
> > couldn't get anything better for now, nothing is printed on
> > the screen.
>=20
> You're right, thanks for the report. Does the patch below fix the problem=
?=20
> It only gets a bit tricky in mx3_camera.c, will have to test.
>

Yes, the patch fixes the problem. Many thanks.

The current patch applies with some fuzzes on vanilla kernels, and it
even FAILS to apply for drivers/media/video/sh_mobile_ceu_camera.c in
one hunk.

I hope that this one and also http://patchwork.kernel.org/patch/33960/
will hit mainline soon.

Ciao,
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

--Signature=_Tue__4_Aug_2009_11_18_23_+0200_.k=71J_TQYEP4V9j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp3/N8ACgkQ5xr2akVTsAH3ggCfeoLpy7FWeO93f5h8nsIjX7OD
4zwAoKQcaywqsckabafaufnY+5yGnxBD
=wmGZ
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Aug_2009_11_18_23_+0200_.k=71J_TQYEP4V9j--
