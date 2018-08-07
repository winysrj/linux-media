Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57056 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbeHGOWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 10:22:05 -0400
Message-ID: <3b093c7c5f8503869a94d4065e215439bc5c71ec.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v6 4/8] media: platform: Add Cedrus VPU
 decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Tue, 07 Aug 2018 14:07:49 +0200
In-Reply-To: <1703875.6APCh3GEgq@jernej-laptop>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
         <1703875.6APCh3GEgq@jernej-laptop>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wYvpBtmUXvfZqdKDv/NV"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wYvpBtmUXvfZqdKDv/NV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2018-07-29 at 09:58 +0200, Jernej =C5=A0krabec wrote:
> Hi!
>=20
> Dne sreda, 25. julij 2018 ob 12:02:52 CEST je Paul Kocialkowski napisal(a=
):
> > This introduces the Cedrus VPU driver that supports the VPU found in
> > Allwinner SoCs, also known as Video Engine. It is implemented through
> > a v4l2 m2m decoder device and a media device (used for media requests).
> > So far, it only supports MPEG2 decoding.
> >=20
> > Since this VPU is stateless, synchronization with media requests is
> > required in order to ensure consistency between frame headers that
> > contain metadata about the frame to process and the raw slice data that
> > is used to generate the frame.
> >=20
> > This driver was made possible thanks to the long-standing effort
> > carried out by the linux-sunxi community in the interest of reverse
> > engineering, documenting and implementing support for Allwinner VPU.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
>=20
> <snip>

[...]

> > +static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_r=
un
> > *run) +{
> > +	const struct v4l2_ctrl_mpeg2_slice_params *slice_params;
> > +	const struct v4l2_ctrl_mpeg2_quantization *quantization;
> > +	dma_addr_t src_buf_addr, dst_luma_addr, dst_chroma_addr;
> > +	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
> > +	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	u32 vld_end, vld_len;
> > +	const u8 *matrix;
> > +	unsigned int i;
> > +	u32 reg;
> > +
> > +	slice_params =3D run->mpeg2.slice_params;
> > +	quantization =3D run->mpeg2.quantization;
> > +
> > +	/* Activate MPEG engine. */
> > +	cedrus_engine_enable(dev, CEDRUS_CODEC_MPEG2);
> > +
> > +	/* Set intra quantization matrix. */
> > +
> > +	if (quantization && quantization->load_intra_quantiser_matrix)
> > +		matrix =3D quantization->intra_quantiser_matrix;
> > +	else
> > +		matrix =3D intra_quantization_matrix_default;
> > +
> > +	for (i =3D 0; i < 64; i++) {
> > +		reg =3D VE_DEC_MPEG_IQMINPUT_WEIGHT(i, matrix[i]);
> > +		reg |=3D VE_DEC_MPEG_IQMINPUT_FLAG_INTRA;
> > +
> > +		cedrus_write(dev, VE_DEC_MPEG_IQMINPUT, reg);
> > +	}
> > +
> > +	/* Set non-intra quantization matrix. */
> > +
> > +	if (quantization && quantization->load_non_intra_quantiser_matrix)
> > +		matrix =3D quantization->non_intra_quantiser_matrix;
> > +	else
> > +		matrix =3D non_intra_quantization_matrix_default;
> > +
> > +	for (i =3D 0; i < 64; i++) {
> > +		reg =3D VE_DEC_MPEG_IQMINPUT_WEIGHT(i, matrix[i]);
> > +		reg |=3D VE_DEC_MPEG_IQMINPUT_FLAG_NON_INTRA;
> > +
> > +		cedrus_write(dev, VE_DEC_MPEG_IQMINPUT, reg);
> > +	}
> > +
> > +	/* Set MPEG picture header. */
> > +
> > +	reg =3D VE_DEC_MPEG_MP12HDR_SLICE_TYPE(slice_params->slice_type);
> > +	reg |=3D VE_DEC_MPEG_MP12HDR_F_CODE(0, 0, slice_params->f_code[0][0])=
;
> > +	reg |=3D VE_DEC_MPEG_MP12HDR_F_CODE(0, 1, slice_params->f_code[0][1])=
;
> > +	reg |=3D VE_DEC_MPEG_MP12HDR_F_CODE(1, 0, slice_params->f_code[1][0])=
;
> > +	reg |=3D VE_DEC_MPEG_MP12HDR_F_CODE(1, 1, slice_params->f_code[1][1])=
;
> > +	reg |=3D
> > VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(slice_params->intra_dc_precision=
);
> > +	reg |=3D
> > VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(slice_params->picture_struc=
ture
> > ); +	reg |=3D
> > VE_DEC_MPEG_MP12HDR_TOP_FIELD_FIRST(slice_params->top_field_first); +	r=
eg
> > > =3D
> >=20
> > VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(slice_params->frame_pred_frame=
_dct
> > ); +	reg |=3D
> > VE_DEC_MPEG_MP12HDR_CONCEALMENT_MOTION_VECTORS(slice_params->concealmen=
t_mo
> > tion_vectors); +	reg |=3D
> > VE_DEC_MPEG_MP12HDR_Q_SCALE_TYPE(slice_params->q_scale_type); +	reg |=
=3D
> > VE_DEC_MPEG_MP12HDR_INTRA_VLC_FORMAT(slice_params->intra_vlc_format); +=
=09
>=20
> reg
> > > =3D VE_DEC_MPEG_MP12HDR_ALTERNATE_SCAN(slice_params->alternate_scan);=
 +	reg
> > > =3D VE_DEC_MPEG_MP12HDR_FULL_PEL_FORWARD_VECTOR(0);
> >=20
> > +	reg |=3D VE_DEC_MPEG_MP12HDR_FULL_PEL_BACKWARD_VECTOR(0);
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_MP12HDR, reg);
> > +
> > +	/* Set frame dimensions. */
> > +
> > +	reg =3D VE_DEC_MPEG_PICCODEDSIZE_WIDTH(slice_params->width);
> > +	reg |=3D VE_DEC_MPEG_PICCODEDSIZE_HEIGHT(slice_params->height);
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_PICCODEDSIZE, reg);
> > +
> > +	reg =3D VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(slice_params->width);
> > +	reg |=3D VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(slice_params->height);
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
> > +
> > +	/* Forward and backward prediction reference buffers. */
> > +
> > +	fwd_luma_addr =3D cedrus_dst_buf_addr(ctx, slice_params->forward_ref_=
index,
> > 0); +	fwd_chroma_addr =3D cedrus_dst_buf_addr(ctx,
> > slice_params->forward_ref_index, 1); +
> > +	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
> > +	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
> > +
> > +	bwd_luma_addr =3D cedrus_dst_buf_addr(ctx, slice_params->backward_ref=
_index,
> > 0); +	bwd_chroma_addr =3D cedrus_dst_buf_addr(ctx,
> > slice_params->backward_ref_index, 1); +
> > +	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
> > +	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
> > +
> > +	/* Destination luma and chroma buffers. */
> > +
> > +	dst_luma_addr =3D cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0=
);
> > +	dst_chroma_addr =3D cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index,=
 1);
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_REC_LUMA, dst_luma_addr);
> > +	cedrus_write(dev, VE_DEC_MPEG_REC_CHROMA, dst_chroma_addr);
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_ROT_LUMA, dst_luma_addr);
> > +	cedrus_write(dev, VE_DEC_MPEG_ROT_CHROMA, dst_chroma_addr);
>=20
> It seems that above ROT buffers are not required at all, if (please see n=
ext=20
> comment)

Yes, you're totally right!

> > +
> > +	/* Source offset and length in bits. */
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_VLD_OFFSET, slice_params->slice_pos);
> > +
> > +	vld_len =3D slice_params->slice_len - slice_params->slice_pos;
> > +	cedrus_write(dev, VE_DEC_MPEG_VLD_LEN, vld_len);
> > +
> > +	/* Source beginning and end addresses. */
> > +
> > +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0)=
;
> > +
> > +	reg =3D VE_DEC_MPEG_VLD_ADDR_BASE(src_buf_addr);
> > +	reg |=3D VE_DEC_MPEG_VLD_ADDR_VALID_PIC_DATA;
> > +	reg |=3D VE_DEC_MPEG_VLD_ADDR_LAST_PIC_DATA;
> > +	reg |=3D VE_DEC_MPEG_VLD_ADDR_FIRST_PIC_DATA;
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_VLD_ADDR, reg);
> > +
> > +	vld_end =3D src_buf_addr + DIV_ROUND_UP(slice_params->slice_len, 8);
> > +	cedrus_write(dev, VE_DEC_MPEG_VLD_END, vld_end);
> > +
> > +	/* Macroblock address: start at the beginning. */
> > +	reg =3D VE_DEC_MPEG_MBADDR_Y(0) | VE_DEC_MPEG_MBADDR_X(0);
> > +	cedrus_write(dev, VE_DEC_MPEG_MBADDR, reg);
> > +
> > +	/* Clear previous errors. */
> > +	cedrus_write(dev, VE_DEC_MPEG_ERROR, 0);
> > +
> > +	/* Clear correct macroblocks register. */
> > +	cedrus_write(dev, VE_DEC_MPEG_CRTMBADDR, 0);
> > +
> > +	/* Enable appropriate interruptions and components. */
> > +
> > +	reg =3D VE_DEC_MPEG_CTRL_IRQ_MASK | VE_DEC_MPEG_CTRL_MC_NO_WRITEBACK =
|
> > +	      VE_DEC_MPEG_CTRL_ROTATE_SCALE_OUT_EN |
> > +	      VE_DEC_MPEG_CTRL_MC_CACHE_EN;
>=20
> ... if you remove VE_DEC_MPEG_CTRL_ROTATE_SCALE_OUT_EN. Everything gets s=
till=20
> correctly decoded. media-codec code for mpeg2 from AW doesn't use that at=
 all.=20
> I think that VE_DEC_MPEG_CTRL_MC_NO_WRITEBACK flag actually disables rota=
te/
> scale operation.

I agree with your conclusions here. The rotate and scale output (often
called 2nd output) is not used in our pipeline so there is indeed no
need to configure the dst addresses or set its enable bit.

Things indeed work just as well without it, so I'll get rid of that in
v7. Thanks!

Cheers,

Paul

> Best regards,
> Jernej
>=20
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_CTRL, reg);
> > +}
> > +
> > +static void cedrus_mpeg2_trigger(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	u32 reg;
> > +
> > +	/* Trigger MPEG engine. */
> > +	reg =3D VE_DEC_MPEG_TRIGGER_HW_MPEG_VLD | VE_DEC_MPEG_TRIGGER_MPEG2 |
> > +	      VE_DEC_MPEG_TRIGGER_MB_BOUNDARY;
> > +
> > +	cedrus_write(dev, VE_DEC_MPEG_TRIGGER, reg);
> > +}
> > +
> > +struct cedrus_dec_ops cedrus_dec_ops_mpeg2 =3D {
> > +	.irq_clear	=3D cedrus_mpeg2_irq_clear,
> > +	.irq_disable	=3D cedrus_mpeg2_irq_disable,
> > +	.irq_status	=3D cedrus_mpeg2_irq_status,
> > +	.setup		=3D cedrus_mpeg2_setup,
> > +	.trigger	=3D cedrus_mpeg2_trigger,
> > +};
>=20
>=20
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-wYvpBtmUXvfZqdKDv/NV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltpi5UACgkQ3cLmz3+f
v9ET4gf/TgawQys7yhf2NseBi01mGErLAqMGYz4+4bzjkeH5JBNhsJNMrdxPKGBh
tDj5K5mQYDBLRTml+KOAC7XvhgY8nw/QBDgHujiOBcSWayspxz8XsV5a5+1cBi78
HUHvHAoEGGwsQTVWkARqpmoIYuXQYnZNqVVE0+MIqSdh0ciQ4zzNxla/zOD8kMI0
QqVXHMCIko62eSopueqVlJ/hp0/6IkCusR2mePAoaUqeHMgFjZ9CEmQtx9Tcik+A
SD+A+YUInQeXwlun3poa0sNMREBV3lWsQyHppwZp5pr51JB+zcCbBds0KXLKfRq5
ZVn2IsO2jSM1wutLt5y/Ea9Tn646fQ==
=Hcxh
-----END PGP SIGNATURE-----

--=-wYvpBtmUXvfZqdKDv/NV--
