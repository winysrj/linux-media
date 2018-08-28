Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51174 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbeH1S7P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 14:59:15 -0400
Date: Tue, 28 Aug 2018 17:06:57 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 2/2] media: cedrus: Add HEVC/H.265 decoding support
Message-ID: <20180828150657.dxwevt3oaac3lgx5@flea>
References: <20180828080240.10982-1-paul.kocialkowski@bootlin.com>
 <20180828080240.10982-3-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gw3paeaxa6sllcdg"
Content-Disposition: inline
In-Reply-To: <20180828080240.10982-3-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gw3paeaxa6sllcdg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 28, 2018 at 10:02:40AM +0200, Paul Kocialkowski wrote:
> @@ -165,7 +182,8 @@ static inline void cedrus_write(struct cedrus_dev *de=
v, u32 reg, u32 val)
> =20
>  static inline u32 cedrus_read(struct cedrus_dev *dev, u32 reg)
>  {
> -	return readl(dev->base + reg);
> +	u32 val =3D readl(dev->base + reg);
> +	return val;

I'm not sure that's needed :)

> +static void cedrus_h265_frame_info_write_dpb(struct cedrus_ctx *ctx,
> +					     const struct v4l2_hevc_dpb_entry *dpb,
> +					     u8 num_active_dpb_entries)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	dma_addr_t dst_luma_addr, dst_chroma_addr;
> +	dma_addr_t mv_col_buf_addr[2];
> +	u32 pic_order_cnt[2];
> +	unsigned int i;
> +
> +	for (i =3D 0; i < num_active_dpb_entries; i++) {
> +		dst_luma_addr =3D cedrus_dst_buf_addr(ctx, dpb[i].buffer_index,
> +						    0); // FIXME - PHYS_OFFSET ?
> +		dst_chroma_addr =3D cedrus_dst_buf_addr(ctx, dpb[i].buffer_index,
> +						      1); // FIXME - PHYS_OFFSET ?
> +		mv_col_buf_addr[0] =3D cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> +			dpb[i].buffer_index, 0);
> +		pic_order_cnt[0] =3D dpb[i].pic_order_cnt[0];
> +
> +		if (dpb[i].field_pic) {
> +			mv_col_buf_addr[1] =3D
> +				cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> +				dpb[i].buffer_index, 1);
> +			pic_order_cnt[1] =3D dpb[i].pic_order_cnt[1];
> +		}
> +
> +		cedrus_h265_frame_info_write_single(dev, i, dpb[i].field_pic,
> +						    pic_order_cnt,
> +						    mv_col_buf_addr,
> +						    dst_luma_addr,
> +						    dst_chroma_addr);
> +	}
> +}

You have this a number of times, but you can reduce the range of most
of the variables (basically all of them but dev and i) to the loop
itself. Declaring them for the whole function like you did suggests
that you're going to use the value from one iteration to the other,
which isn't the case here.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--gw3paeaxa6sllcdg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluFZRAACgkQ0rTAlCFN
r3Q5nRAAjSrGzEpYPIXufGp4rmaoLMpcFv9aqDDqOcI7OLsGKo+RkkoePsyUyhHJ
V3PErk6MM2D6p3VO0+1wLwUF+ZlCd1awhSgubHzELHLTUmXF1TTwpS2G93oy95B8
l3qWo+1SOOR3NB9L5qAw5W2GXBukaWEVY1jw5A+JGCwfG8AiIV8UiXUUrsPkui49
vxhIGkkd7fPdkna38QcoLvzVNuPdU/u+90NldWISoJbtc7vHqZQMNjoGYf8ITh2U
cBbeU6xKF2B0kqRQhpgsJKujpheuBYWitirVSXtn7WKp+32VY8iLgZT+mpbwJLfl
bJL+O4QH1w5ov9/pAnNp4IIFbQRS5E/RER/poTOydGYghl6npVmlRatHbqR4nU80
JRnryaB/ukxD5tZMoKYdox6qyVNVW+sZLnkgZayeXVEAlyGHoB9o9TP+mnMymUc5
B0++kmLwO50STdKcgwKu+usvAsCjJSiYnmJHFe7NPhAArdx5Me9+BlI+tuJSKxeT
C5IkpN1Pn7I9vg9y0S5vOKmZvYZ9+CYbo841Wry0r2vXRtJ0q96Ab+tEPyABpFQF
K0XtBI0NQK8bA1N4jvN5/LJ5rEh8cr4BtjqbjfTr9T7IzEciuoHGZnJkHe9M+jhW
Aiexqh9idx2RJIzPhHMA35WXlxA9jw6ok1AZhht1xLudWVMqC/U=
=aJvz
-----END PGP SIGNATURE-----

--gw3paeaxa6sllcdg--
