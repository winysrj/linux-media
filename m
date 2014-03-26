Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34923 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbaCZWiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 18:38:51 -0400
Message-ID: <1395873527.32312.27.camel@nicolas-tpx230>
Subject: Re: [PATCH 3/5] s5p-fimc: Align imagesize to row size for tiled
 formats
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: s.nawrocki@samsung.com
Date: Wed, 26 Mar 2014 18:38:47 -0400
In-Reply-To: <1395780682.11851.18.camel@nicolas-tpx230>
References: <1395780301.11851.14.camel@nicolas-tpx230>
	 <1395780682.11851.18.camel@nicolas-tpx230>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QNZ2go3qOmjjJlj7RitX"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-QNZ2go3qOmjjJlj7RitX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 25 mars 2014 =C3=A0 16:51 -0400, Nicolas Dufresne a =C3=A9crit :
> For tiled format, we need to allocated a multiple of the row size. A
> good example is for 1280x720, wich get adjusted to 1280x736. In tiles,
> this mean Y plane is 20x23 and UV plane 20x12. Because of the rounding,
> the previous code would only have enough space to fit half of the last
> row.
>=20
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-core.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/medi=
a/platform/exynos4-is/fimc-core.c
> index 2e70fab..0e94412 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -736,6 +736,7 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, =
u32 width, u32 height,
>  	for (i =3D 0; i < pix->num_planes; ++i) {
>  		struct v4l2_plane_pix_format *plane_fmt =3D &pix->plane_fmt[i];
>  		u32 bpl =3D plane_fmt->bytesperline;
> +		u32 sizeimage;
> =20
>  		if (fmt->colplanes > 1 && (bpl =3D=3D 0 || bpl < pix->width))
>  			bpl =3D pix->width; /* Planar */
> @@ -755,8 +756,16 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt,=
 u32 width, u32 height,
>  			bytesperline /=3D 2;
> =20
>  		plane_fmt->bytesperline =3D bytesperline;
> -		plane_fmt->sizeimage =3D max((pix->width * pix->height *
> -				   fmt->depth[i]) / 8, plane_fmt->sizeimage);
> +		sizeimage =3D pix->width * pix->height * fmt->depth[i] / 8;
> +
> +		/* Ensure full last row for tiled formats */
> +		if (tiled_fmt(fmt)) {
> +			/* 64 * 32 * plane_fmt->bytesperline / 64 */
> +			u32 row_size =3D plane_fmt->bytesperline * 32;
> +			sizeimage =3D ALIGN(sizeimage, row_size);

I made a mistake here, and it seems I've badly tested it too (was
setting the size from the test application). ALIGN won't work as
row_size is not a power of two. Sorry for that, will send an update.
roundup(sizeimage, row_size) would be the way to go. Will resubmit.

> +		}
> +
> +		plane_fmt->sizeimage =3D max(sizeimage, plane_fmt->sizeimage);
>  	}
>  }
> =20


--=-QNZ2go3qOmjjJlj7RitX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMzVvcACgkQcVMCLawGqBza1gCeP+BctxFwTxRm6W+1//cN/+Hv
Du4AoKuV78IVfsfFzDxiGEfyojUKth1z
=5bKH
-----END PGP SIGNATURE-----

--=-QNZ2go3qOmjjJlj7RitX--

