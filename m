Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59134 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbeH0LdC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 07:33:02 -0400
Message-ID: <3a92082b201776bfed0f68facc30577cb7d2a5c1.camel@bootlin.com>
Subject: Re: [PATCH v3 6/7] media: Add controls for JPEG quantization tables
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Mon, 27 Aug 2018 09:47:20 +0200
In-Reply-To: <20180822165937.8700-7-ezequiel@collabora.com>
References: <20180822165937.8700-1-ezequiel@collabora.com>
         <20180822165937.8700-7-ezequiel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GpuEdeyWmAmNo17ngG7e"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GpuEdeyWmAmNo17ngG7e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-08-22 at 13:59 -0300, Ezequiel Garcia wrote:
> From: Shunqian Zheng <zhengsq@rock-chips.com>
>=20
> Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
> configure the JPEG quantization tables.

How about having a single control for quantization?

In MPEG-2/H.264/H.265, we have a single control exposed as a structure,
which contains the tables for both luma and chroma. In the case of JPEG,
it's not that big a deal, but for advanced video formats, it would be
too much hassle to have one control per table.

In order to keep the interface consistent, I think it'd be best to merge
both matrices into a single control.

What do you think?

Paul

> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  Documentation/media/uapi/v4l/extended-controls.rst | 13 +++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c               | 13 +++++++++++++
>  include/uapi/linux/v4l2-controls.h                 |  3 +++
>  3 files changed, 29 insertions(+)
>=20
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documen=
tation/media/uapi/v4l/extended-controls.rst
> index 9f7312bf3365..1189750a022c 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -3354,6 +3354,19 @@ JPEG Control IDs
>      Specify which JPEG markers are included in compressed stream. This
>      control is valid only for encoders.
> =20
> +.. _jpeg-quant-tables-control:
> +
> +``V4L2_CID_JPEG_LUMA_QUANTIZATION (__u8 matrix)``
> +    Sets the luma quantization table to be used for encoding
> +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
> +    a 8x8-byte matrix, and it's expected to be in JPEG zigzag order,
> +    as per the JPEG specification.
> +
> +``V4L2_CID_JPEG_CHROMA_QUANTIZATION (__u8 matrix)``
> +    Sets the chroma quantization table to be used for encoding
> +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
> +    a 8x8-byte matrix, and it's expected to be in JPEG zigzag order,
> +    as per the JPEG specification.
> =20
> =20
>  .. flat-table::
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-co=
re/v4l2-ctrls.c
> index 6ab15f4a0fea..677af8069bfc 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -999,6 +999,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
>  	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
>  	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
> +	case V4L2_CID_JPEG_LUMA_QUANTIZATION:	return "Luminance Quantization Ma=
trix";
> +	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:	return "Chrominance Quantizatio=
n Matrix";
> =20
>  	/* Image source controls */
>  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
> @@ -1286,6 +1288,17 @@ void v4l2_ctrl_fill(u32 id, const char **name, enu=
m v4l2_ctrl_type *type,
>  	case V4L2_CID_DETECT_MD_REGION_GRID:
>  		*type =3D V4L2_CTRL_TYPE_U8;
>  		break;
> +	case V4L2_CID_JPEG_LUMA_QUANTIZATION:
> +	case V4L2_CID_JPEG_CHROMA_QUANTIZATION:
> +		*min =3D *def =3D 0;
> +		*max =3D 0xff;
> +		*step =3D 1;
> +		*type =3D V4L2_CTRL_TYPE_U8;
> +		if (dims) {
> +			memset(dims, 0, V4L2_CTRL_MAX_DIMS * sizeof(dims[0]));
> +			dims[0] =3D dims[1] =3D 8;
> +		}
> +		break;
>  	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
>  		*type =3D V4L2_CTRL_TYPE_U16;
>  		break;
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2=
-controls.h
> index e4ee10ee917d..a466acf40625 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -987,6 +987,9 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
>  #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
> =20
> +#define V4L2_CID_JPEG_LUMA_QUANTIZATION		(V4L2_CID_JPEG_CLASS_BASE + 5)
> +#define V4L2_CID_JPEG_CHROMA_QUANTIZATION	(V4L2_CID_JPEG_CLASS_BASE + 6)
> +
> =20
>  /* Image source controls */
>  #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE |=
 0x900)
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-GpuEdeyWmAmNo17ngG7e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAluDrIgACgkQ3cLmz3+f
v9ETbgf/X18xMo1n0INupgyS6rOQFAJVuW3iWLgUBPrX74l8RMv+4xGId0CQPAMi
7c6lwK7BB0NrdLEIdZ8wjrWei+ApO8thq7nRzbAxw7Yf8gV8YsJTNZWwmOxYuAPn
gXnUOJGWXYSgU9EtE1aoVQHboPIe1LpuXl18DCkKk99EDe1y6Snh9YnJYlwofLC1
rbVQzHNd9Ud8/GK8NSe/cqSkqz4xxEhErR0/Khiai2pfhl9tD9myrgRPx2fmNClC
74zZRyg5TRK9TTqEkWHMCMDcJpUVKgQWrADbxQxyWMH6N9AfVUzgMnUTpI6Nrp8s
INWeuIWPN7+pZodw8FWyHZps4moHEA==
=o3yq
-----END PGP SIGNATURE-----

--=-GpuEdeyWmAmNo17ngG7e--
