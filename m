Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:62929 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaFVFe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jun 2014 01:34:29 -0400
Received: by mail-yk0-f181.google.com with SMTP id 9so3846699ykp.12
        for <linux-media@vger.kernel.org>; Sat, 21 Jun 2014 22:34:28 -0700 (PDT)
Date: Sun, 22 Jun 2014 02:33:59 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: Anthony DeStefano <adx@fastmail.fm>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] staging: solo6x10: fix for sparse warning message
Message-ID: <20140622023359.3c4b5d10@pirotess.bf.iodev.co.uk>
In-Reply-To: <20140620015302.GA1543@pluto-arch.home>
References: <20140620015302.GA1543@pluto-arch.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Rq7WnQWd_y2UYHqRLy6WVCZ"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Rq7WnQWd_y2UYHqRLy6WVCZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jun 2014 21:53:21 -0400
Anthony DeStefano <adx@fastmail.fm> wrote:
> Define jpeg_dqt as static.
>=20
> Signed-off-by: Anthony DeStefano <adx@fastmail.fm>
> ---
>  drivers/staging/media/solo6x10/solo6x10-jpeg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h
> b/drivers/staging/media/solo6x10/solo6x10-jpeg.h index
> c5218ce..9e41185 100644 ---
> a/drivers/staging/media/solo6x10/solo6x10-jpeg.h +++
> b/drivers/staging/media/solo6x10/solo6x10-jpeg.h @@ -110,7 +110,7 @@
> static const unsigned char jpeg_header[] =3D { /* This is the byte
> marker for the start of the DQT */ #define DQT_START	17
>  #define DQT_LEN		138
> -const unsigned char jpeg_dqt[4][DQT_LEN] =3D {
> +static const unsigned char jpeg_dqt[4][DQT_LEN] =3D {
>  	{
>  		0xff, 0xdb, 0x00, 0x43, 0x00,
>  		0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

--Sig_/Rq7WnQWd_y2UYHqRLy6WVCZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTpmrIAAoJEBrCLcBAAV+Gd0oH/js2uOu0mUF+2t0yHejM+okZ
2CBF76qdSCeN60su+zcLsljk9R0h0QuJ80wCynwAcjuMaQDrhGAzPUVE3SZRLfdO
MD3aUGQkpSsxzIgVYzm03nEw/e9FIY8dU+lFU/Ilsivbi9q0ugE/e3/GsWeaAgy8
F0s+W7aaMfXZlitD1HcyPzfWacci8RaOEEN7W32DinqTaTdyHHdxsGIpSKwCuvCU
uHmEviRh46hxFLQgmxtVmh4cjhnrTt7xudd9F04qxhc6P8MF235k/zf2rKm9cxxj
w9jWh1iXi1gsSFEJ2vyNyWNpgEFibjYQUqFKZ81zxxEZ4SYg5zsZxMoPPyTuXJ8=
=DlE/
-----END PGP SIGNATURE-----

--Sig_/Rq7WnQWd_y2UYHqRLy6WVCZ--
