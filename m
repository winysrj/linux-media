Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59031 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbbF2Tpk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 15:45:40 -0400
Date: Mon, 29 Jun 2015 14:45:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Benoit Parrot <bparrot@ti.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] media: am437x-vpfe: Fix a race condition during
 release
Message-ID: <20150629194537.GF1019@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1435606913-2279-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/NRh952CO+2tg14"
Content-Disposition: inline
In-Reply-To: <1435606913-2279-1-git-send-email-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--K/NRh952CO+2tg14
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2015 at 02:41:53PM -0500, Benoit Parrot wrote:
> There was a race condition where during cleanup/release operation
> on-going streaming would cause a kernel panic because the hardware
> module was disabled prematurely with IRQ still pending.
>=20
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

should this go to stable too ?

> ---
>  drivers/media/platform/am437x/am437x-vpfe.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/=
platform/am437x/am437x-vpfe.c
> index a30cc2f..eb25c43 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -1185,14 +1185,21 @@ static int vpfe_initialize_device(struct vpfe_dev=
ice *vpfe)
>  static int vpfe_release(struct file *file)
>  {
>  	struct vpfe_device *vpfe =3D video_drvdata(file);
> +	bool fh_singular =3D v4l2_fh_is_singular_file(file);
>  	int ret;
> =20
>  	mutex_lock(&vpfe->lock);
> =20
> -	if (v4l2_fh_is_singular_file(file))
> -		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +	/* the release helper will cleanup any on-going streaming */
>  	ret =3D _vb2_fop_release(file, NULL);
> =20
> +	/*
> +	 * If this was the last open file.
> +	 * Then de-initialize hw module.
> +	 */
> +	if (fh_singular)
> +		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +
>  	mutex_unlock(&vpfe->lock);
> =20
>  	return ret;
> --=20
> 1.8.5.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--K/NRh952CO+2tg14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVkaBhAAoJEIaOsuA1yqREVhMP/2oIGuKT/VWvY6Zq9T3PDvmC
Wrg4CS1CXXMUiHPMMYBsG/I60Onr4+KPXRhf4Go4iBBskCZw+sDxFHlsofzTDunz
qYYA4pr3LTR8axFLhDAe46IzzzpEkIsU1LHjHPOYTsU8LocuIOAhBwGDZuea+ufW
psZ4j5VkC0A1zPvj7ZAqEGKYfsH9i/6VuprojuAbJfqzr2E/YdboSN/W3JNg1qzl
7AXjudFikNMvkQmwP24SDt6x4Ulhg5JgSrp7VixQ2lby8dGCfPu6A4YIyrDMobD8
TbxGNuuQ/gzQQfk1riXgSX2EkTl7p2Z8tV07PvbS+4k3xme5k8qoVbTcpfgcBbFj
edw1k29pETiTKIjd7UFPaethVv1zPnLzWSR4xpLlEuwC+BlD2em7qG0aKHybc+At
8pQ6IBF+gQj0O2WM3dVLkRhh97HjntD4EmMoi09+uQy4iFinyHr56y/jl6Z2KjLK
o3H0ZQl3G6qx54RcHaWe1U5pKmiRCXitInf8oGynS0i/YsiNaDyy/YpmqiDHYxVq
N75q5flOBxmx3YSS2DeXyE5k4BHmt4gwuaCzaKnw1tHS49QX+menp4paQHICX7xc
UsvSVWmQBoX0jtPHGGArognx9WS1Bn1E/Eyoj3itkcBW9YRNIQauEAS/szWeMGSv
H243838roXZH0SzBCor0
=TMQy
-----END PGP SIGNATURE-----

--K/NRh952CO+2tg14--
