Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50855 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812Ab2F2FKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 01:10:15 -0400
Message-ID: <1340946601.4852.12.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [git:v4l-dvb/for_v3.6] [media] gspca-core: Fix buffers staying
 in queued state after a stream_off
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org,
	Antonio Ospite <ospite@studenti.unina.it>,
	Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Date: Fri, 29 Jun 2012 06:10:01 +0100
In-Reply-To: <E1Sjr0a-0006XB-Lg@www.linuxtv.org>
References: <E1Sjr0a-0006XB-Lg@www.linuxtv.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-l7MgOXjfgQC9RkTOOxEy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-l7MgOXjfgQC9RkTOOxEy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-11 at 21:06 +0200, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following p=
atch were queued at the=20
> http://git.linuxtv.org/media_tree.git tree:
>=20
> Subject: [media] gspca-core: Fix buffers staying in queued state after a =
stream_off
> Author:  Hans de Goede <hdegoede@redhat.com>
> Date:    Tue May 22 11:24:05 2012 -0300
>=20
> This fixes a regression introduced by commit f7059ea and should be
> backported to all supported stable kernels which have this commit.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Antonio Ospite <ospite@studenti.unina.it>
> CC: stable@vger.kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[...]

This surely can't both be so important that it should go into stable
updates, yet so unimportant that it can wait for 3.6.

Ben.

--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-l7MgOXjfgQC9RkTOOxEy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+04qee/yOyVhhEJAQqXfBAAw32+o7+lzRHKfjah0BAsmRJtKiR8z26Z
BO1WHA+02wWl14Gpmy1PiBlswAuka5TRVs0UlZDl9MA8hKpEVEladd5kwXRf76kh
1NEGRk7SzbLoOiQeuQl9knunWddXwShajjWlFs/oXEw59sH265AmebFxMN8gPBSR
WmjoVwnJUc91kj6ydXzdzYvUE08it0HqZvpTij7W+PGAhhQpeBpM/P2LerG6RvMY
G4iMegYlW7XlLIe1XKdnodPuv30KGyO014JqFi/35jAf3/r+Bj7nkJTmLEEL2PrL
MdQxmYfkTkjwpFISKGNAJ0qH/ytlVqiEPZPmWqqoqn3eW1Y8joum2aKXFzKzqYpC
ZY3Zrdd9uDwS4e4LlTJ00P/IWSAGORoqM6VLt/T8mNEX6+o4H7oWECNd9ClJkYt+
ebDki/SIkHadfVqmYdLsTB2fsxvrPovGa/e9MokQb8uM/NIeG0UB39wdQccP1fSh
LSCbEy6/vAI6D8lqdHQELkT2hLza7uRy4Y9/AXeN+80juLfoQzo+0gELkLr5+iMl
0PnWLdYfxEfaQjf8l9Ruwp7sQDDbWz9+cHrLcOTLS4wd+a4hX08yB44joinxPeGE
Pk80oJyg8NnPrdLUcs+5HzvgQ1sNQlw9Y54XsB6UowLXVsIyBWyVx0SjQX7x3lin
EVbEZwiX1Co=
=cvDf
-----END PGP SIGNATURE-----

--=-l7MgOXjfgQC9RkTOOxEy--
