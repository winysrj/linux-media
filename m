Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51955 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbeKYHdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 02:33:05 -0500
From: Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To: linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com
Cc: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 2/2] media: cedrus: Add H264 decoding support
Date: Sat, 24 Nov 2018 21:43:43 +0100
Message-ID: <2826880.kP3DS59ZBy@jernej-laptop>
In-Reply-To: <20181115145650.9827-3-maxime.ripard@bootlin.com>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com> <20181115145650.9827-3-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

first, thanks you for working on this! I also spend some time working on H2=
64=20
and I have some comments below.

Dne =C4=8Detrtek, 15. november 2018 ob 15:56:50 CET je Maxime Ripard napisa=
l(a):
> Introduce some basic H264 decoding support in cedrus. So far, only the
> baseline profile videos have been tested, and some more advanced features
> used in higher profiles are not even implemented.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/staging/media/sunxi/cedrus/Makefile   |   3 +-
>  drivers/staging/media/sunxi/cedrus/cedrus.c   |  25 +
>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  35 +-
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  11 +
>  .../staging/media/sunxi/cedrus/cedrus_h264.c  | 470 ++++++++++++++++++
>  .../staging/media/sunxi/cedrus/cedrus_hw.c    |   4 +
>  .../staging/media/sunxi/cedrus/cedrus_regs.h  |  63 +++
>  .../staging/media/sunxi/cedrus/cedrus_video.c |   9 +
>  8 files changed, 618 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_h264.c
>=20
> diff --git a/drivers/staging/media/sunxi/cedrus/Makefile
> b/drivers/staging/media/sunxi/cedrus/Makefile index
> e9dc68b7bcb6..aaf141fc58b6 100644
> --- a/drivers/staging/media/sunxi/cedrus/Makefile
> +++ b/drivers/staging/media/sunxi/cedrus/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) +=3D sunxi-cedrus.o
>=20
> -sunxi-cedrus-y =3D cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o
> cedrus_mpeg2.o +sunxi-cedrus-y =3D cedrus.o cedrus_video.o cedrus_hw.o
> cedrus_dec.o \ +		 cedrus_mpeg2.o cedrus_h264.o
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c
> b/drivers/staging/media/sunxi/cedrus/cedrus.c index
> 82558455384a..627a8c07eb21 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> @@ -40,6 +40,30 @@ static const struct cedrus_control cedrus_controls[] =
=3D {
>  		.codec		=3D CEDRUS_CODEC_MPEG2,
>  		.required	=3D false,
>  	},
> +	{
> +		.id		=3D V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS,
> +		.elem_size	=3D sizeof(struct v4l2_ctrl_h264_decode_param),
> +		.codec		=3D CEDRUS_CODEC_H264,
> +		.required	=3D true,
> +	},
> +	{
> +		.id		=3D V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS,
> +		.elem_size	=3D sizeof(struct v4l2_ctrl_h264_slice_param),
> +		.codec		=3D CEDRUS_CODEC_H264,
> +		.required	=3D true,
> +	},
> +	{
> +		.id		=3D V4L2_CID_MPEG_VIDEO_H264_SPS,
> +		.elem_size	=3D sizeof(struct v4l2_ctrl_h264_sps),
> +		.codec		=3D CEDRUS_CODEC_H264,
> +		.required	=3D true,
> +	},
> +	{
> +		.id		=3D V4L2_CID_MPEG_VIDEO_H264_PPS,
> +		.elem_size	=3D sizeof(struct v4l2_ctrl_h264_pps),
> +		.codec		=3D CEDRUS_CODEC_H264,
> +		.required	=3D true,
> +	},
>  };
>=20
>  #define CEDRUS_CONTROLS_COUNT	ARRAY_SIZE(cedrus_controls)
> @@ -277,6 +301,7 @@ static int cedrus_probe(struct platform_device *pdev)
>  	}
>=20
>  	dev->dec_ops[CEDRUS_CODEC_MPEG2] =3D &cedrus_dec_ops_mpeg2;
> +	dev->dec_ops[CEDRUS_CODEC_H264] =3D &cedrus_dec_ops_h264;
>=20
>  	mutex_init(&dev->dev_mutex);
>  	spin_lock_init(&dev->irq_lock);
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h
> b/drivers/staging/media/sunxi/cedrus/cedrus.h index
> 781676b55a1b..179c10dcf6a7 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.h
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
> @@ -30,7 +30,7 @@
>=20
>  enum cedrus_codec {
>  	CEDRUS_CODEC_MPEG2,
> -
> +	CEDRUS_CODEC_H264,
>  	CEDRUS_CODEC_LAST,
>  };
>=20
> @@ -40,6 +40,12 @@ enum cedrus_irq_status {
>  	CEDRUS_IRQ_OK,
>  };
>=20
> +enum cedrus_h264_pic_type {
> +	CEDRUS_H264_PIC_TYPE_FRAME	=3D 0,
> +	CEDRUS_H264_PIC_TYPE_FIELD,
> +	CEDRUS_H264_PIC_TYPE_MBAFF,
> +};
> +
>  struct cedrus_control {
>  	u32			id;
>  	u32			elem_size;
> @@ -47,6 +53,13 @@ struct cedrus_control {
>  	unsigned char		required:1;
>  };
>=20
> +struct cedrus_h264_run {
> +	const struct v4l2_ctrl_h264_decode_param	*decode_param;
> +	const struct v4l2_ctrl_h264_pps			*pps;
> +	const struct v4l2_ctrl_h264_slice_param		*slice_param;
> +	const struct v4l2_ctrl_h264_sps			*sps;
> +};
> +
>  struct cedrus_mpeg2_run {
>  	const struct v4l2_ctrl_mpeg2_slice_params	*slice_params;
>  	const struct v4l2_ctrl_mpeg2_quantization	*quantization;
> @@ -57,12 +70,20 @@ struct cedrus_run {
>  	struct vb2_v4l2_buffer	*dst;
>=20
>  	union {
> +		struct cedrus_h264_run	h264;
>  		struct cedrus_mpeg2_run	mpeg2;
>  	};
>  };
>=20
>  struct cedrus_buffer {
>  	struct v4l2_m2m_buffer          m2m_buf;
> +
> +	union {
> +		struct {
> +			unsigned int			position;
> +			enum cedrus_h264_pic_type	pic_type;
> +		} h264;
> +	} codec;
>  };
>=20
>  struct cedrus_ctx {
> @@ -77,6 +98,17 @@ struct cedrus_ctx {
>  	struct v4l2_ctrl		**ctrls;
>=20
>  	struct vb2_buffer		*dst_bufs[VIDEO_MAX_FRAME];
> +
> +	union {
> +		struct {
> +			void		*mv_col_buf;
> +			dma_addr_t	mv_col_buf_dma;
> +			ssize_t		mv_col_buf_field_size;
> +			ssize_t		mv_col_buf_size;
> +			void		*pic_info_buf;
> +			dma_addr_t	pic_info_buf_dma;
> +		} h264;
> +	} codec;
>  };
>=20
>  struct cedrus_dec_ops {
> @@ -120,6 +152,7 @@ struct cedrus_dev {
>  };
>=20
>  extern struct cedrus_dec_ops cedrus_dec_ops_mpeg2;
> +extern struct cedrus_dec_ops cedrus_dec_ops_h264;
>=20
>  static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 val)
>  {
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c index
> 0cfd6036d0cd..b606f07d94ab 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -49,6 +49,17 @@ void cedrus_device_run(void *priv)
>  			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
>  		break;
>=20
> +	case V4L2_PIX_FMT_H264_SLICE:
> +		run.h264.decode_param =3D cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS);
> +		run.h264.pps =3D cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_PPS);
> +		run.h264.slice_param =3D cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS);
> +		run.h264.sps =3D cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_SPS);
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c new file mode 100644
> index 000000000000..5459a936b4b9
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
> @@ -0,0 +1,470 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (c) 2013 Jens Kuske <jenskuske@gmail.com>
> + * Copyright (c) 2018 Bootlin
> + */
> +
> +#include <linux/types.h>
> +
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "cedrus.h"
> +#include "cedrus_hw.h"
> +#include "cedrus_regs.h"
> +
> +enum cedrus_h264_sram_off {
> +	CEDRUS_SRAM_H264_PRED_WEIGHT_TABLE	=3D 0x000,
> +	CEDRUS_SRAM_H264_FRAMEBUFFER_LIST	=3D 0x100,
> +	CEDRUS_SRAM_H264_REF_LIST_0		=3D 0x190,
> +	CEDRUS_SRAM_H264_REF_LIST_1		=3D 0x199,
> +	CEDRUS_SRAM_H264_SCALING_LIST_8x8	=3D 0x200,
> +	CEDRUS_SRAM_H264_SCALING_LIST_4x4	=3D 0x218,

I triple checked above address and it should be 0x220. For easier=20
implementation later, you might want to add second scaling list address for=
=20
8x8 at 0x210. Then you can do something like:

cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_0,
			       scaling->scaling_list_8x8[0],
			       sizeof(scaling->scaling_list_8x8[0]));
cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_1,
			       scaling->scaling_list_8x8[3],
			       sizeof(scaling->scaling_list_8x8[0]));
cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_4x4,
			       scaling->scaling_list_4x4,
			       sizeof(scaling->scaling_list_4x4));

I know that it's not implemented here, just FYI.

> +};
> +
> +struct cedrus_h264_sram_ref_pic {
> +	__le32	top_field_order_cnt;
> +	__le32	bottom_field_order_cnt;
> +	__le32	frame_info;
> +	__le32	luma_ptr;
> +	__le32	chroma_ptr;
> +	__le32	mv_col_top_ptr;
> +	__le32	mv_col_bot_ptr;
> +	__le32	reserved;
> +} __packed;
> +
> +/* One for the output, 16 for the reference images */
> +#define CEDRUS_H264_FRAME_NUM		17
> +
> +#define CEDRUS_PIC_INFO_BUF_SIZE	(128 * SZ_1K)
> +
> +static void cedrus_h264_write_sram(struct cedrus_dev *dev,
> +				   enum cedrus_h264_sram_off off,
> +				   const void *data, size_t len)
> +{
> +	const u32 *buffer =3D data;
> +	size_t count =3D DIV_ROUND_UP(len, 4);
> +
> +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET, off << 2);
> +
> +	do {
> +		cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);
> +	} while (--count);
> +}
> +
> +static dma_addr_t cedrus_h264_mv_col_buf_addr(struct cedrus_ctx *ctx,
> +					      unsigned int position,
> +					      unsigned int field)
> +{
> +	dma_addr_t addr =3D ctx->codec.h264.mv_col_buf_dma - PHYS_OFFSET;
> +
> +	/* Adjust for the position */
> +	addr +=3D position * ctx->codec.h264.mv_col_buf_field_size * 2;
> +
> +	/* Adjust for the field */
> +	addr +=3D field * ctx->codec.h264.mv_col_buf_field_size;
> +
> +	return addr;
> +}
> +
> +static void cedrus_fill_ref_pic(struct cedrus_ctx *ctx,
> +				struct cedrus_buffer *buf,
> +				unsigned int top_field_order_cnt,
> +				unsigned int bottom_field_order_cnt,
> +				struct cedrus_h264_sram_ref_pic *pic)
> +{
> +	struct vb2_buffer *vbuf =3D &buf->m2m_buf.vb.vb2_buf;
> +	unsigned int position =3D buf->codec.h264.position;
> +
> +	pic->top_field_order_cnt =3D top_field_order_cnt;
> +	pic->bottom_field_order_cnt =3D bottom_field_order_cnt;
> +	pic->frame_info =3D buf->codec.h264.pic_type << 8;
> +
> +	pic->luma_ptr =3D cedrus_buf_addr(vbuf, &ctx->dst_fmt, 0) - PHYS_OFFSET;
> +	pic->chroma_ptr =3D cedrus_buf_addr(vbuf, &ctx->dst_fmt, 1) - PHYS_OFFS=
ET;

I think subtracting PHYS_OFFSET breaks driver on H3 boards with 2 GiB of RA=
M.=20
Isn't that unnecessary anyway due to

dev->dev->dma_pfn_offset =3D PHYS_PFN_OFFSET;

in cedrus_hw.c?

This comment is meant for all PHYS_OFFSET subtracting in this patch.

> +	pic->mv_col_top_ptr =3D cedrus_h264_mv_col_buf_addr(ctx, position, 0);
> +	pic->mv_col_bot_ptr =3D cedrus_h264_mv_col_buf_addr(ctx, position, 1);
> +}
> +
> +static void cedrus_write_frame_list(struct cedrus_ctx *ctx,
> +				    struct cedrus_run *run)
> +{
> +	struct cedrus_h264_sram_ref_pic pic_list[CEDRUS_H264_FRAME_NUM];
> +	const struct v4l2_ctrl_h264_decode_param *dec_param =3D
> run->h264.decode_param; +	const struct v4l2_ctrl_h264_slice_param *slice =
=3D
> run->h264.slice_param; +	const struct v4l2_ctrl_h264_sps *sps =3D
> run->h264.sps;
> +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> +	struct cedrus_buffer *output_buf;
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	unsigned long used_dpbs =3D 0;
> +	unsigned int position;
> +	unsigned int output =3D 0;
> +	unsigned int i;
> +
> +	memset(pic_list, 0, sizeof(pic_list));
> +
> +	for (i =3D 0; i < ARRAY_SIZE(dec_param->dpb); i++) {
> +		const struct v4l2_h264_dpb_entry *dpb =3D &dec_param->dpb[i];
> +		struct cedrus_buffer *cedrus_buf;
> +		int buf_idx;
> +
> +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_VALID))
> +			continue;
> +
> +		buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> +		if (buf_idx < 0)
> +			continue;
> +
> +		cedrus_buf =3D vb2_to_cedrus_buffer(ctx->dst_bufs[buf_idx]);
> +		position =3D cedrus_buf->codec.h264.position;
> +		used_dpbs |=3D BIT(position);
> +
> +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> +			continue;
> +
> +		cedrus_fill_ref_pic(ctx, cedrus_buf,
> +				    dpb->top_field_order_cnt,
> +				    dpb->bottom_field_order_cnt,
> +				    &pic_list[position]);
> +
> +		output =3D max(position, output);
> +	}
> +
> +	position =3D find_next_zero_bit(&used_dpbs, CEDRUS_H264_FRAME_NUM,
> +				      output);
> +	if (position >=3D CEDRUS_H264_FRAME_NUM)
> +		position =3D find_first_zero_bit(&used_dpbs, CEDRUS_H264_FRAME_NUM);
> +
> +	output_buf =3D vb2_to_cedrus_buffer(&run->dst->vb2_buf);
> +	output_buf->codec.h264.position =3D position;
> +
> +	if (slice->flags & V4L2_H264_SLICE_FLAG_FIELD_PIC)
> +		output_buf->codec.h264.pic_type =3D CEDRUS_H264_PIC_TYPE_FIELD;
> +	else if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
> +		output_buf->codec.h264.pic_type =3D CEDRUS_H264_PIC_TYPE_MBAFF;
> +	else
> +		output_buf->codec.h264.pic_type =3D CEDRUS_H264_PIC_TYPE_FRAME;
> +
> +	cedrus_fill_ref_pic(ctx, output_buf,
> +			    dec_param->top_field_order_cnt,
> +			    dec_param->bottom_field_order_cnt,
> +			    &pic_list[position]);
> +
> +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_FRAMEBUFFER_LIST,
> +			       pic_list, sizeof(pic_list));
> +
> +	cedrus_write(dev, VE_H264_OUTPUT_FRAME_IDX, position);
> +}
> +
> +#define CEDRUS_MAX_REF_IDX	32
> +
> +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> +				   struct cedrus_run *run,
> +				   const u8 *ref_list, u8 num_ref,
> +				   enum cedrus_h264_sram_off sram)
> +{
> +	const struct v4l2_ctrl_h264_decode_param *decode =3D run->h264.decode_p=
aram;
> +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	u32 sram_array[CEDRUS_MAX_REF_IDX / sizeof(u32)];
> +	unsigned int size, i;
> +
> +	memset(sram_array, 0, sizeof(sram_array));
> +
> +	for (i =3D 0; i < num_ref; i +=3D 4) {
> +		unsigned int j;
> +
> +		for (j =3D 0; j < 4; j++) {

I don't think you have to complicate with two loops here.=20
cedrus_h264_write_sram() takes void* and it aligns to 4 anyway. So as long=
=20
input buffer is multiple of 4 (u8[CEDRUS_MAX_REF_IDX] qualifies for that), =
you=20
can use single for loop with "u8 sram_array[CEDRUS_MAX_REF_IDX]". This shou=
ld=20
make code much more readable.

> +			const struct v4l2_h264_dpb_entry *dpb;
> +			const struct cedrus_buffer *cedrus_buf;
> +			const struct vb2_v4l2_buffer *ref_buf;
> +			unsigned int position;
> +			int buf_idx;
> +			u8 ref_idx =3D i + j;
> +			u8 dpb_idx;
> +
> +			if (ref_idx >=3D num_ref)
> +				break;
> +
> +			dpb_idx =3D ref_list[ref_idx];
> +			dpb =3D &decode->dpb[dpb_idx];
> +
> +			if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> +				continue;
> +
> +			buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> +			if (buf_idx < 0)
> +				continue;
> +
> +			ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> +			cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> +			position =3D cedrus_buf->codec.h264.position;
> +
> +			sram_array[i] |=3D position << (j * 8 + 1);
> +			if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)

You newer set above flag to buffer so this will be always false.

> +				sram_array[i] |=3D BIT(j * 8);
> +		}
> +	}
> +
> +	size =3D min((unsigned int)ALIGN(num_ref, 4), sizeof(sram_array));
> +	cedrus_h264_write_sram(dev, sram, &sram_array, size);
> +}
> +
> +static void cedrus_write_ref_list0(struct cedrus_ctx *ctx,
> +				   struct cedrus_run *run)
> +{
> +	const struct v4l2_ctrl_h264_slice_param *slice =3D run->h264.slice_para=
m;
> +
> +	_cedrus_write_ref_list(ctx, run,
> +			       slice->ref_pic_list0,
> +			       slice->num_ref_idx_l0_active_minus1 + 1,
> +			       CEDRUS_SRAM_H264_REF_LIST_0);
> +}
> +
> +static void cedrus_write_ref_list1(struct cedrus_ctx *ctx,
> +				   struct cedrus_run *run)
> +{
> +	const struct v4l2_ctrl_h264_slice_param *slice =3D run->h264.slice_para=
m;
> +
> +	_cedrus_write_ref_list(ctx, run,
> +			       slice->ref_pic_list1,
> +			       slice->num_ref_idx_l1_active_minus1 + 1,
> +			       CEDRUS_SRAM_H264_REF_LIST_1);
> +}
> +
> +static void cedrus_set_params(struct cedrus_ctx *ctx,
> +			      struct cedrus_run *run)
> +{
> +	const struct v4l2_ctrl_h264_slice_param *slice =3D run->h264.slice_para=
m;
> +	const struct v4l2_ctrl_h264_pps *pps =3D run->h264.pps;
> +	const struct v4l2_ctrl_h264_sps *sps =3D run->h264.sps;
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	dma_addr_t src_buf_addr;
> +	u32 offset =3D slice->header_bit_size;
> +	u32 len =3D (slice->size * 8) - offset;
> +	u32 reg;
> +
> +	cedrus_write(dev, 0x220, 0x02000400);
> +	cedrus_write(dev, VE_H264_VLD_LEN, len);
> +	cedrus_write(dev, VE_H264_VLD_OFFSET, offset);
> +
> +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
> +	src_buf_addr -=3D PHYS_OFFSET;
> +	cedrus_write(dev, VE_H264_VLD_END, src_buf_addr + VBV_SIZE - 1);
> +	cedrus_write(dev, VE_H264_VLD_ADDR,
> +		     VE_H264_VLD_ADDR_VAL(src_buf_addr) |
> +		     VE_H264_VLD_ADDR_FIRST | VE_H264_VLD_ADDR_VALID |
> +		     VE_H264_VLD_ADDR_LAST);
> +
> +	/*
> +	 * FIXME: Since the bitstream parsing is done in software, and
> +	 * in userspace, this shouldn't be needed anymore. But it
> +	 * turns out that removing it breaks the decoding process,
> +	 * without any clear indication why.
> +	 */
> +	cedrus_write(dev, VE_H264_TRIGGER_TYPE,
> +		     VE_H264_TRIGGER_TYPE_INIT_SWDEC);
> +
> +	if ((slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_P) ||
> +	    (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_SP) ||
> +	    (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_B))
> +		cedrus_write_ref_list0(ctx, run);
> +
> +	if (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_B)
> +		cedrus_write_ref_list1(ctx, run);
> +
> +	// picture parameters
> +	reg =3D 0;
> +	/*
> +	 * FIXME: the kernel headers are allowing the default value to
> +	 * be passed, but the libva doesn't give us that.
> +	 */
> +	reg |=3D (slice->num_ref_idx_l0_active_minus1 & 0x1f) << 10;
> +	reg |=3D (slice->num_ref_idx_l1_active_minus1 & 0x1f) << 5;
> +	reg |=3D (pps->weighted_bipred_idc & 0x3) << 2;
> +	if (pps->flags & V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE)
> +		reg |=3D BIT(15);
> +	if (pps->flags & V4L2_H264_PPS_FLAG_WEIGHTED_PRED)
> +		reg |=3D BIT(4);
> +	if (pps->flags & V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED)
> +		reg |=3D BIT(1);
> +	if (pps->flags & V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE)
> +		reg |=3D BIT(0);
> +	cedrus_write(dev, VE_H264_PIC_HDR, reg);
> +
> +	// sequence parameters
> +	reg =3D BIT(19);

This one can be inferred from sps->chroma_format_idc.

> +	reg |=3D (sps->pic_width_in_mbs_minus1 & 0xff) << 8;
> +	reg |=3D sps->pic_height_in_map_units_minus1 & 0xff;
> +	if (sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY)
> +		reg |=3D BIT(18);
> +	if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
> +		reg |=3D BIT(17);
> +	if (sps->flags & V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE)
> +		reg |=3D BIT(16);
> +	cedrus_write(dev, VE_H264_FRAME_SIZE, reg);
> +
> +	// slice parameters
> +	reg =3D 0;
> +	/*
> +	 * FIXME: This bit marks all the frames as references. This
> +	 * should probably be set based on nal_ref_idc, but the libva
> +	 * doesn't pass that information along, so this is not always
> +	 * available. We should find something else, maybe change the
> +	 * kernel UAPI somehow?
> +	 */
> +	reg |=3D BIT(12);

I really think you should use nal_ref_idc here as it is in specification.  =
You=20
can still fake the data from libva backend. I don't think that any driver=20
needs this for anything else than check if it is 0 or not.

> +	reg |=3D (slice->slice_type & 0xf) << 8;
> +	reg |=3D slice->cabac_init_idc & 0x3;
> +	reg |=3D BIT(5);
> +	if (slice->flags & V4L2_H264_SLICE_FLAG_FIELD_PIC)
> +		reg |=3D BIT(4);
> +	if (slice->flags & V4L2_H264_SLICE_FLAG_BOTTOM_FIELD)
> +		reg |=3D BIT(3);
> +	if (slice->flags & V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED)
> +		reg |=3D BIT(2);
> +	cedrus_write(dev, VE_H264_SLICE_HDR, reg);
> +
> +	reg =3D 0;

You might want to set bit 12 here, which enables active reference picture=20
override. However, I'm not completely sure about that.

Best regards,
Jernej

> +	reg |=3D (slice->num_ref_idx_l0_active_minus1 & 0x1f) << 24;
> +	reg |=3D (slice->num_ref_idx_l1_active_minus1 & 0x1f) << 16;
> +	reg |=3D (slice->disable_deblocking_filter_idc & 0x3) << 8;
> +	reg |=3D (slice->slice_alpha_c0_offset_div2 & 0xf) << 4;
> +	reg |=3D slice->slice_beta_offset_div2 & 0xf;
> +	cedrus_write(dev, VE_H264_SLICE_HDR2, reg);
> +
> +	reg =3D 0;
> +	/*
> +	 * FIXME: This bit tells the video engine to use the default
> +	 * quantization matrices. This will obviously need to be
> +	 * changed to support the profiles supporting custom
> +	 * quantization matrices.
> +	 */
> +	reg |=3D BIT(24);
> +	reg |=3D (pps->second_chroma_qp_index_offset & 0x3f) << 16;
> +	reg |=3D (pps->chroma_qp_index_offset & 0x3f) << 8;
> +	reg |=3D (pps->pic_init_qp_minus26 + 26 + slice->slice_qp_delta) & 0x3f;
> +	cedrus_write(dev, VE_H264_QP_PARAM, reg);
> +
> +	// clear status flags
> +	cedrus_write(dev, VE_H264_STATUS, cedrus_read(dev, VE_H264_STATUS));
> +
> +	// enable int
> +	reg =3D cedrus_read(dev, VE_H264_CTRL) | 0x7;
> +	cedrus_write(dev, VE_H264_CTRL, reg);
> +}
> +
> +static enum cedrus_irq_status
> +cedrus_h264_irq_status(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	u32 reg =3D cedrus_read(dev, VE_H264_STATUS) & 0x7;
> +
> +	if (!reg)
> +		return CEDRUS_IRQ_NONE;
> +
> +	if (reg & (BIT(1) | BIT(2)))
> +		return CEDRUS_IRQ_ERROR;
> +
> +	return CEDRUS_IRQ_OK;
> +}
> +
> +static void cedrus_h264_irq_clear(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +
> +	cedrus_write(dev, VE_H264_STATUS, GENMASK(2, 0));
> +}
> +
> +static void cedrus_h264_irq_disable(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	u32 reg =3D cedrus_read(dev, VE_H264_CTRL) & ~GENMASK(2, 0);
> +
> +	cedrus_write(dev, VE_H264_CTRL, reg);
> +}
> +
> +static void cedrus_h264_setup(struct cedrus_ctx *ctx,
> +			      struct cedrus_run *run)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +
> +	cedrus_engine_enable(dev, CEDRUS_CODEC_H264);
> +
> +	cedrus_write(dev, VE_H264_SDROT_CTRL, 0);
> +	cedrus_write(dev, VE_H264_EXTRA_BUFFER1,
> +		     ctx->codec.h264.pic_info_buf_dma - PHYS_OFFSET);
> +	cedrus_write(dev, VE_H264_EXTRA_BUFFER2,
> +		     (ctx->codec.h264.pic_info_buf_dma - PHYS_OFFSET) + 0x48000);
> +
> +	cedrus_write_frame_list(ctx, run);
> +
> +	cedrus_set_params(ctx, run);
> +}
> +
> +static int cedrus_h264_start(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	unsigned int field_size;
> +	unsigned int mv_col_size;
> +	int ret;
> +
> +	ctx->codec.h264.pic_info_buf =3D
> +		dma_alloc_coherent(dev->dev, CEDRUS_PIC_INFO_BUF_SIZE,
> +				   &ctx->codec.h264.pic_info_buf_dma,
> +				   GFP_KERNEL);
> +	if (!ctx->codec.h264.pic_info_buf)
> +		return -ENOMEM;
> +
> +	field_size =3D DIV_ROUND_UP(ctx->src_fmt.width, 16) *
> +		DIV_ROUND_UP(ctx->src_fmt.height, 16) * 32;
> +	ctx->codec.h264.mv_col_buf_field_size =3D field_size;
> +
> +	mv_col_size =3D field_size * 2 * CEDRUS_H264_FRAME_NUM;
> +	ctx->codec.h264.mv_col_buf_size =3D mv_col_size;
> +	ctx->codec.h264.mv_col_buf =3D dma_alloc_coherent(dev->dev,
> +							ctx->codec.h264.mv_col_buf_size,
> +							&ctx->codec.h264.mv_col_buf_dma,
> +							GFP_KERNEL);
> +	if (!ctx->codec.h264.mv_col_buf) {
> +		ret =3D -ENOMEM;
> +		goto err_pic_buf;
> +	}
> +
> +	return 0;
> +
> +err_pic_buf:
> +	dma_free_coherent(dev->dev, CEDRUS_PIC_INFO_BUF_SIZE,
> +			  ctx->codec.h264.pic_info_buf,
> +			  ctx->codec.h264.pic_info_buf_dma);
> +	return ret;
> +}
> +
> +static void cedrus_h264_stop(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +
> +	dma_free_coherent(dev->dev, ctx->codec.h264.mv_col_buf_size,
> +			  ctx->codec.h264.mv_col_buf,
> +			  ctx->codec.h264.mv_col_buf_dma);
> +	dma_free_coherent(dev->dev, CEDRUS_PIC_INFO_BUF_SIZE,
> +			  ctx->codec.h264.pic_info_buf,
> +			  ctx->codec.h264.pic_info_buf_dma);
> +}
> +
> +static void cedrus_h264_trigger(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +
> +	cedrus_write(dev, VE_H264_TRIGGER_TYPE,
> +		     VE_H264_TRIGGER_TYPE_AVC_SLICE_DECODE);
> +}
> +
> +struct cedrus_dec_ops cedrus_dec_ops_h264 =3D {
> +	.irq_clear	=3D cedrus_h264_irq_clear,
> +	.irq_disable	=3D cedrus_h264_irq_disable,
> +	.irq_status	=3D cedrus_h264_irq_status,
> +	.setup		=3D cedrus_h264_setup,
> +	.start		=3D cedrus_h264_start,
> +	.stop		=3D cedrus_h264_stop,
> +	.trigger	=3D cedrus_h264_trigger,
> +};
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c index
> 32adbcbe6175..8e559454ca82 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> @@ -46,6 +46,10 @@ int cedrus_engine_enable(struct cedrus_dev *dev, enum
> cedrus_codec codec) reg |=3D VE_MODE_DEC_MPEG;
>  		break;
>=20
> +	case CEDRUS_CODEC_H264:
> +		reg |=3D VE_MODE_DEC_H264;
> +		break;
> +
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h index
> de2d6b6f64bf..6fe9896a506d 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> @@ -232,4 +232,67 @@
>  #define VE_DEC_MPEG_ROT_LUMA			(VE_ENGINE_DEC_MPEG + 0xcc)
>  #define VE_DEC_MPEG_ROT_CHROMA			(VE_ENGINE_DEC_MPEG + 0xd0)
>=20
> +/*  FIXME: Legacy below. */
> +
> +#define VBV_SIZE                       (1024 * 1024)
> +
> +#define VE_H264_FRAME_SIZE		0x200
> +#define VE_H264_PIC_HDR			0x204
> +#define VE_H264_SLICE_HDR		0x208
> +#define VE_H264_SLICE_HDR2		0x20c
> +#define VE_H264_PRED_WEIGHT		0x210
> +#define VE_H264_QP_PARAM		0x21c
> +#define VE_H264_CTRL			0x220
> +
> +#define VE_H264_TRIGGER_TYPE		0x224
> +#define VE_H264_TRIGGER_TYPE_AVC_SLICE_DECODE	(8 << 0)
> +#define VE_H264_TRIGGER_TYPE_INIT_SWDEC		(7 << 0)
> +
> +#define VE_H264_STATUS			0x228
> +#define VE_H264_CUR_MB_NUM		0x22c
> +
> +#define VE_H264_VLD_ADDR		0x230
> +#define VE_H264_VLD_ADDR_FIRST			BIT(30)
> +#define VE_H264_VLD_ADDR_LAST			BIT(29)
> +#define VE_H264_VLD_ADDR_VALID			BIT(28)
> +#define VE_H264_VLD_ADDR_VAL(x)			(((x) & 0x0ffffff0) | ((x) >> 28))
> +
> +#define VE_H264_VLD_OFFSET		0x234
> +#define VE_H264_VLD_LEN			0x238
> +#define VE_H264_VLD_END			0x23c
> +#define VE_H264_SDROT_CTRL		0x240
> +#define VE_H264_OUTPUT_FRAME_IDX	0x24c
> +#define VE_H264_EXTRA_BUFFER1		0x250
> +#define VE_H264_EXTRA_BUFFER2		0x254
> +#define VE_H264_BASIC_BITS		0x2dc
> +#define VE_AVC_SRAM_PORT_OFFSET		0x2e0
> +#define VE_AVC_SRAM_PORT_DATA		0x2e4
> +
> +#define VE_ISP_INPUT_SIZE		0xa00
> +#define VE_ISP_INPUT_STRIDE		0xa04
> +#define VE_ISP_CTRL			0xa08
> +#define VE_ISP_INPUT_LUMA		0xa78
> +#define VE_ISP_INPUT_CHROMA		0xa7c
> +
> +#define VE_AVC_PARAM			0xb04
> +#define VE_AVC_QP			0xb08
> +#define VE_AVC_MOTION_EST		0xb10
> +#define VE_AVC_CTRL			0xb14
> +#define VE_AVC_TRIGGER			0xb18
> +#define VE_AVC_STATUS			0xb1c
> +#define VE_AVC_BASIC_BITS		0xb20
> +#define VE_AVC_UNK_BUF			0xb60
> +#define VE_AVC_VLE_ADDR			0xb80
> +#define VE_AVC_VLE_END			0xb84
> +#define VE_AVC_VLE_OFFSET		0xb88
> +#define VE_AVC_VLE_MAX			0xb8c
> +#define VE_AVC_VLE_LENGTH		0xb90
> +#define VE_AVC_REF_LUMA			0xba0
> +#define VE_AVC_REF_CHROMA		0xba4
> +#define VE_AVC_REC_LUMA			0xbb0
> +#define VE_AVC_REC_CHROMA		0xbb4
> +#define VE_AVC_REF_SLUMA		0xbb8
> +#define VE_AVC_REC_SLUMA		0xbbc
> +#define VE_AVC_MB_INFO			0xbc0
> +
>  #endif
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_video.c index
> 293df48326cc..7be2caacddde 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -37,6 +37,10 @@ static struct cedrus_format cedrus_formats[] =3D {
>  		.pixelformat	=3D V4L2_PIX_FMT_MPEG2_SLICE,
>  		.directions	=3D CEDRUS_DECODE_SRC,
>  	},
> +	{
> +		.pixelformat	=3D V4L2_PIX_FMT_H264_SLICE,
> +		.directions	=3D CEDRUS_DECODE_SRC,
> +	},
>  	{
>  		.pixelformat	=3D V4L2_PIX_FMT_SUNXI_TILED_NV12,
>  		.directions	=3D CEDRUS_DECODE_DST,
> @@ -100,6 +104,7 @@ static void cedrus_prepare_format(struct v4l2_pix_for=
mat
> *pix_fmt)
>=20
>  	switch (pix_fmt->pixelformat) {
>  	case V4L2_PIX_FMT_MPEG2_SLICE:
> +	case V4L2_PIX_FMT_H264_SLICE:
>  		/* Zero bytes per line for encoded source. */
>  		bytesperline =3D 0;
>=20
> @@ -451,6 +456,10 @@ static int cedrus_start_streaming(struct vb2_queue *=
vq,
> unsigned int count) ctx->current_codec =3D CEDRUS_CODEC_MPEG2;
>  		break;
>=20
> +	case V4L2_PIX_FMT_H264_SLICE:
> +		ctx->current_codec =3D CEDRUS_CODEC_H264;
> +		break;
> +
>  	default:
>  		return -EINVAL;
>  	}
