Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59089 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbeG3O26 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 10:28:58 -0400
Message-ID: <c2c5b43c4ea426a765297fb390752da87df9c55a.camel@bootlin.com>
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
Date: Mon, 30 Jul 2018 14:54:05 +0200
In-Reply-To: <20180613140714.1686-10-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-10-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qKX9WeEPvbhhbycnfLR7"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-qKX9WeEPvbhhbycnfLR7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> Introduce some basic H264 decoding support in cedrus. So far, only the
> baseline profile videos have been tested, and some more advanced features
> used in higher profiles are not even implemented.

While working on H265 support, I noticed a few things that should apply
to H264 as well.

[...]

> +struct sunxi_cedrus_h264_sram_ref_pic {
> +	__le32	top_field_order_cnt;
> +	__le32	bottom_field_order_cnt;
> +	__le32	frame_info;
> +	__le32	luma_ptr;
> +	__le32	chroma_ptr;
> +	__le32	extra_data_ptr;
> +	__le32	extra_data_end;

These two previous fields represent the top and bottom (field) motion
vector column buffer addresses, so the second field is not the end of
the first one. These fields should be frame-specific and they are called
topmv_coladdr, botmv_coladdr by Allwinner.

> +	__le32	reserved;
> +} __packed;
> +

[...]

> +static void sunxi_cedrus_fill_ref_pic(struct sunxi_cedrus_h264_sram_ref_=
pic *pic,
> +				      struct vb2_buffer *buf,
> +				      dma_addr_t extra_buf,
> +				      size_t extra_buf_len,
> +				      unsigned int top_field_order_cnt,
> +				      unsigned int bottom_field_order_cnt,
> +				      enum sunxi_cedrus_h264_pic_type pic_type)
> +{
> +	pic->top_field_order_cnt =3D top_field_order_cnt;
> +	pic->bottom_field_order_cnt =3D bottom_field_order_cnt;
> +	pic->frame_info =3D pic_type << 8;
> +	pic->luma_ptr =3D vb2_dma_contig_plane_dma_addr(buf, 0) - PHYS_OFFSET;
> +	pic->chroma_ptr =3D vb2_dma_contig_plane_dma_addr(buf, 1) - PHYS_OFFSET=
;
> +	pic->extra_data_ptr =3D extra_buf - PHYS_OFFSET;
> +	pic->extra_data_end =3D (extra_buf - PHYS_OFFSET) + extra_buf_len;
> +}
> +
> +static void sunxi_cedrus_write_frame_list(struct sunxi_cedrus_ctx *ctx,
> +					  struct sunxi_cedrus_run *run)
> +{
> +	struct sunxi_cedrus_h264_sram_ref_pic pic_list[SUNXI_CEDRUS_H264_FRAME_=
NUM];
> +	const struct v4l2_ctrl_h264_decode_param *dec_param =3D run->h264.decod=
e_param;
> +	const struct v4l2_ctrl_h264_slice_param *slice =3D run->h264.slice_para=
m;
> +	const struct v4l2_ctrl_h264_sps *sps =3D run->h264.sps;
> +	struct sunxi_cedrus_buffer *output_buf;
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +	unsigned long used_dpbs =3D 0;
> +	unsigned int position;
> +	unsigned int output =3D 0;
> +	unsigned int i;
> +
> +	memset(pic_list, 0, sizeof(pic_list));
> +
> +	for (i =3D 0; i < ARRAY_SIZE(dec_param->dpb); i++) {
> +		const struct v4l2_h264_dpb_entry *dpb =3D &dec_param->dpb[i];
> +		const struct sunxi_cedrus_buffer *cedrus_buf;
> +		struct vb2_buffer *ref_buf;
> +
> +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> +			continue;
> +
> +		ref_buf =3D ctx->dst_bufs[dpb->buf_index];
> +		cedrus_buf =3D vb2_to_cedrus_buffer(ref_buf);
> +		position =3D cedrus_buf->codec.h264.position;
> +		used_dpbs |=3D BIT(position);
> +	=09
> +		sunxi_cedrus_fill_ref_pic(&pic_list[position], ref_buf,
> +					  ctx->codec.h264.mv_col_buf_dma,
> +					  ctx->codec.h264.mv_col_buf_size,

Following up on my previous comment, this should be specific to each
frame, with 2 buffer chunks per frame (top and bottom fields) as done in
Allwinner's H264MallocBuffer function.=20

[...]

> +static void sunxi_cedrus_set_params(struct sunxi_cedrus_ctx *ctx,
> +				    struct sunxi_cedrus_run *run)
> +{
> +	const struct v4l2_ctrl_h264_slice_param *slice =3D run->h264.slice_para=
m;
> +	const struct v4l2_ctrl_h264_pps *pps =3D run->h264.pps;
> +	const struct v4l2_ctrl_h264_sps *sps =3D run->h264.sps;
> +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> +	dma_addr_t src_buf_addr;
> +	u32 offset =3D slice->header_bit_size;
> +	u32 len =3D (slice->size * 8) - offset;
> +	u32 reg;
> +
> +	sunxi_cedrus_write(dev, ctx->codec.h264.pic_info_buf_dma - PHYS_OFFSET,=
 0x250);
> +	sunxi_cedrus_write(dev, (ctx->codec.h264.pic_info_buf_dma - PHYS_OFFSET=
) + 0x48000, 0x254);
> +
> +	sunxi_cedrus_write(dev, len, VE_H264_VLD_LEN);
> +	sunxi_cedrus_write(dev, offset, VE_H264_VLD_OFFSET);
> +
> +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
> +	src_buf_addr -=3D PHYS_OFFSET;
> +	sunxi_cedrus_write(dev, VE_H264_VLD_ADDR_VAL(src_buf_addr) |
> +			   VE_H264_VLD_ADDR_FIRST | VE_H264_VLD_ADDR_VALID | VE_H264_VLD_ADDR=
_LAST,
> +			   VE_H264_VLD_ADDR);
> +	sunxi_cedrus_write(dev, src_buf_addr + VBV_SIZE - 1, VE_H264_VLD_END);
> +
> +	sunxi_cedrus_write(dev, VE_H264_TRIGGER_TYPE_INIT_SWDEC,
> +			   VE_H264_TRIGGER_TYPE);

It seems that this trigger type is only useful when trying
to subsequently access the bitstream data from the VPU (for easier
parsing, as done in libvdpau-sunxi), but it should not be required when
all the parsing was done already and no such access is necessary.

I haven't tested without it so far, but I have a hunch we can spare this
call.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-qKX9WeEPvbhhbycnfLR7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltfCm0ACgkQ3cLmz3+f
v9Ffywf/RGeHXXe5Y7+Nd3BhBbU5tyVE87jhcUTuMPA6Hv5455gGaB4mYl8SgUDU
U0RWpRnZv/hpTrFCTfMzQPZzrPqQNd0SKK4vHvis4/hmaQCLK4LC6hSHp/mBdHhi
zHZB55cwA3PyC+CCWahXFbRqHE/7q9OVMM9bsYfpXcMx+6p1eBNP+YFdQmGrYU1L
9eDVhdQK3Nia42f5sx3k2vqyWaqk90K87hxI589AS/8oW6FYdNc9osspbDihTCzM
2WEdzd8U5bHY5qBYAhbZF0Ijf1pSfO+/VvVLFK4Jj6yrA4DJUkO3nn2pDZIUuY6o
+wB/yqao497tYvyoLgtRtsnmPXal3A==
=IEbq
-----END PGP SIGNATURE-----

--=-qKX9WeEPvbhhbycnfLR7--
