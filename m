Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_RHS_DOB
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BECC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 22:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71E5820989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 22:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E30tRmN+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71E5820989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbeLEW1O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 17:27:14 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41764 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbeLEW1O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 17:27:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so21314663wrs.8;
        Wed, 05 Dec 2018 14:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iQI0FnQUE6WbsHeRUP24fmdOCMMxL7N0GUJoAdRGYac=;
        b=E30tRmN+wC2F5Fj/9pNvWdKqgsQQWZUhCNc/3keCxhlVAGlmoMGT7mHEGbgNrjD2SM
         1k9etcjntbXzp4a7D/4yg3xJsFboO6be0d71x7qDP2INvU7iB4fvcE8/5NC5cVOgA2Az
         nTqv7H+WCGs0mptcEGtCc3ruXJlhF8aI9mtQP447VXvM+qPs+lhuS9mZkv7puXHAgJDV
         4Hmcva+EA0N87hocB55c5C4suM947+8W9QJ49eOKnVsK+eHUVke1ZPGJV8LZ/AKyLB+r
         I+csiMFzXMRx3My+PfuJW3ITG9XsZXTZTbqXwpwAXQbGh2HrfFhTH1UnXaA6lPlFwXFY
         pQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iQI0FnQUE6WbsHeRUP24fmdOCMMxL7N0GUJoAdRGYac=;
        b=avvtPQYC5iv4pAf4W4fMjXTybAt87EOoUQgwIOxnHHyJfRwbvJs+NnKGtk553LwctJ
         Dqnx5ZS/eZA/jFEvpTukBA31P7QzlNZqFCojhUD9rTQpshYuEwFOEYUX+v5aM3en5ZL2
         AcHPxj+3w22AsOniNFWb4lDKHdkBzALtfA+Z3h1hK8aZ87/5RqKi9qkD7aHhSsLHrpWF
         a+xONjCuhVXmRvEaAQQQakTJ6hbxKExqpb3c9WXUAEkzBk3+2TRWC2HXiHXBxUo+VBce
         znYUg1wQMt5YBpZHT1MQRiti5TeGs85fNLiK09enTJi/AM3vuIkmMYXAHw1nqXNcjcCc
         /j8w==
X-Gm-Message-State: AA+aEWbfcg+MeGPBe5AKOp801B0xJ/XdZZGSsb5TTB0L4grTN/T0M0sj
        CZUB+O4xyWYBYzf2+TnYhns=
X-Google-Smtp-Source: AFSGD/Wi/Ql20FqxhqGBjyIhSQCwNfXAtGSYNCYxjPkpUZW5Rk7CYbANZRVOq08fNv5zlC6o0LH+Aw==
X-Received: by 2002:adf:8484:: with SMTP id 4mr22963041wrg.249.1544048829925;
        Wed, 05 Dec 2018 14:27:09 -0800 (PST)
Received: from jernej-laptop.localnet (cpe1-8-82.cable.triera.net. [213.161.8.82])
        by smtp.gmail.com with ESMTPSA id s66sm16347174wmf.34.2018.12.05.14.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Dec 2018 14:27:08 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        jonas@kwiboo.se
Subject: Re: [linux-sunxi] [PATCH v2 2/2] media: cedrus: Add H264 decoding support
Date:   Wed, 05 Dec 2018 23:27:06 +0100
Message-ID: <1587627.EgO78k2rvW@jernej-laptop>
In-Reply-To: <20181115145650.9827-3-maxime.ripard@bootlin.com>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com> <20181115145650.9827-3-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi!

Jonas Karlman (in CC) and me managed to solve playback issues with interlac=
ed=20
H264 videos.

Please check comments below.=20

You can also build and test LibreELEC for H3 from=20
https://github.com/jernejsk/LibreELEC.tv/tree/hw_dec_ffmpeg

It has all changes suggested below, except buffer sizes are calculated for=
=20
worst case instead of using formula from CedarX. It also uses Jonas WIP FFm=
peg=20
patches for Request API. libva-v4l2-request library is not used.

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

HW actually supports 18 frames. It would be nice to at least zero out the l=
ast=20
position.

> +
> +#define CEDRUS_PIC_INFO_BUF_SIZE	(128 * SZ_1K)

I suggest to determine above value according to formula found in CedarX=20
source.

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

=46ield pictures may reference current capture buffer. However, vb2_find_ta=
g won't=20
check queued capture buffer tag, so the frame will be skipped and not writt=
en=20
to the frame list.

This can be solved by:

struct vb2_v4l2_buffer *v4l2_buf =3D to_vb2_v4l2_buffer(&run->dst->vb2_buf);
=2E..
if (v4l2_buf->tag =3D=3D dpb->tag)
	buf_idx =3D v4l2_buf->vb2_buf.index;
else
	buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);


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

If capture buffer is part of DPB, position is already known.

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

Same story as above. Capture buffer tag needs to be checked too.

> +			if (buf_idx < 0)
> +				continue;
> +
> +			ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> +			cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> +			position =3D cedrus_buf->codec.h264.position;
> +
> +			sram_array[i] |=3D position << (j * 8 + 1);
> +			if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)

Above check won't work. Here driver should check if this is "bottom referen=
ce"=20
which is different as picture field type. We made a hack for PoC code and=20
encoded "bottom reference" and "top reference" information in bit 7 and bit=
 6=20
of each ref_list[] element because only 4 bits are actually used.

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

My tests worked well without above line. Do you know if it is really needed=
?=20

> +	cedrus_write(dev, VE_H264_VLD_LEN, len);
> +	cedrus_write(dev, VE_H264_VLD_OFFSET, offset);
> +
> +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
> +	src_buf_addr -=3D PHYS_OFFSET;
> +	cedrus_write(dev, VE_H264_VLD_END, src_buf_addr + VBV_SIZE - 1);

VBV_SIZE should be replaced with true size aligned to 1024.

This might not be actually relevant for correctness of decoding.

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

I suggest to always set BIT(12) here (num_ref_idx_active_override_flag) bec=
ause=20
that information is always provided by userspace.

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

 VE_H264_EXTRA_BUFFER2 is actually MB_NEIGHBOR_INFO_ADDR so I would suggest=
 to=20
reintroduce the variable "neighbor info buffer" you removed between v1 and =
v2=20
and use it here. According to information I have, it has to be 16 KiB in si=
ze,=20
but also aligned to 16KiB. Easy solution is to allocate 32 KiB buffer and w=
rite=20
16K aligned address here.

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

Worst case is actually 2 times higher according to CedarX code.

However, better approach would be to multiply with 16 instead of 32 and=20
increase this number if:
V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE =3D=3D 0, by 2x
V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY =3D=3D 0, by 2x

That way only minimum needed amount of memory is allocated. CedarX code als=
o=20
aligns this number to 1024.

Unfortunately, above information is not available here, so this would mean=
=20
that memory allocation have to be done in setup() function, which is not=20
ideal...

Best regards,
Jernej

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




