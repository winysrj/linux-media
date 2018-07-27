Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37992 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbeG0PTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 11:19:02 -0400
Message-ID: <8c0b2fbec0302a15292d3629570ab1268fd306b8.camel@bootlin.com>
Subject: Re: [PATCH 9/9] media: cedrus: Add H264 decoding support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Fri, 27 Jul 2018 15:56:45 +0200
In-Reply-To: <20180613140714.1686-10-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-10-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-029qBFRxMV8wtDZl6vh5"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-029qBFRxMV8wtDZl6vh5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> Introduce some basic H264 decoding support in cedrus. So far, only the
> baseline profile videos have been tested, and some more advanced features
> used in higher profiles are not even implemented.

Here are two specific comments about things I noticed when going through
the h264 code.

[...]

> @@ -88,12 +101,37 @@ struct sunxi_cedrus_ctx {
>  	struct work_struct run_work;
>  	struct list_head src_list;
>  	struct list_head dst_list;
> +
> +	union {
> +		struct {
> +			void		*mv_col_buf;
> +			dma_addr_t	mv_col_buf_dma;
> +			ssize_t		mv_col_buf_size;
> +			void		*neighbor_info_buf;
> +			dma_addr_t	neighbor_info_buf_dma;

Should be "neighbour" instead of "neighbor" and the same applies to most
variables related to this, as well as the register description.

[...]

> +static int sunxi_cedrus_h264_start(struct sunxi_cedrus_ctx *ctx)
> +{
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +	int ret;
> +
> +	ctx->codec.h264.pic_info_buf =3D
> +		dma_alloc_coherent(dev->dev, SUNXI_CEDRUS_PIC_INFO_BUF_SIZE,
> +				   &ctx->codec.h264.pic_info_buf_dma,
> +				   GFP_KERNEL);
> +	if (!ctx->codec.h264.pic_info_buf)
> +		return -ENOMEM;
> +
> +	ctx->codec.h264.neighbor_info_buf =3D
> +		dma_alloc_coherent(dev->dev, SUNXI_CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
> +				   &ctx->codec.h264.neighbor_info_buf_dma,
> +				   GFP_KERNEL);
> +	if (!ctx->codec.h264.neighbor_info_buf) {
> +		ret =3D -ENOMEM;
> +		goto err_pic_buf;
> +	}

Although this buffer is allocated here, the resulting address is
apparently never written to the appropriate VPU register (0x54).

Perhaps a write to the aforementioned register was lost along the
development process?

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-029qBFRxMV8wtDZl6vh5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltbJJ4ACgkQ3cLmz3+f
v9FPTQf5Afysfwywy00aVNkiI4TExiY02o8+LLqffUgPJMpLuI7q0Bia2cy7rnnK
nEAmTBdNtCRAnKjkmr6o1lzsA4wrxbvq7SlZZebc8eBXDqU2/dR3p4CiNeCvAzy+
WmtwN1PiG6AhfwQMLoq56vmE7CCdwiRmjl7uWmsQz0Tj/ZERIt46c3MVj7OMlgmW
aCO1Mcc7v9vaSlryWU8o5MPppWr8sQ3YfXtzTMTLcvE/iKmaPeJbs3KTZO3qs0w2
gCw4/bnK9FErjRgvB3ztsjwTOACcfhzaKAd/CdFVvTf7gEBVMFw7VzZb6lJuu/WR
dzbhuPxMsVgwpgHcTtWs+Hs4w5LGPA==
=SAHH
-----END PGP SIGNATURE-----

--=-029qBFRxMV8wtDZl6vh5--
