Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B78CC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 18:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F7E2083B
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 18:22:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihq0Xc6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfBUSVz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 13:21:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34558 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfBUSVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 13:21:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id f14so31797881wrg.1;
        Thu, 21 Feb 2019 10:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vgF1ieACgFQ3SpKc5/+NoGgTnwuAaircQUH4dr3HOlk=;
        b=ihq0Xc6Ci3jH1j7N+HPtxsE0dss/byXgA9YoxHHDD4fjJ28ucWmAFWCfbdHcow4ME7
         RcmcF1+1D/NmY+0FVL7vxhovaEDf/yEDQOE0tKo+vrfYjXStl1/iQW19JKhfIeLY2U1j
         xnv7yYcm0d5j/6VUqS9VYmh4iGifSQQ5T+z/NYHUgUdhZ81BIsHaRlDIWEsevpnueX1w
         BsQqVsO6wr7rZAqP4p6pHyd+dPeq+PCV0hWykregPFkvDbB7iuZ6uejnQ/XKqUt54RAq
         HPgkgaa2YrY0A1oQiGEDFYVpE7UIeL9BZHTM2WXSgXsG2VKAd2fGe3sgKGtgTJXTG1RN
         VuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vgF1ieACgFQ3SpKc5/+NoGgTnwuAaircQUH4dr3HOlk=;
        b=BiruwNPVoHNAVwXPVDxRC8aMFjFAP6ZNCkli+svCC5cg6on4saC+ABTKZ1729VNapR
         Ik9Igo5E5wdQ7SFmbA05LcfLhLyZpeCFY1ETgTOK4ikul2PlGF2kb5zZ+ShrEEsKazRZ
         z/rPIMszyO5VHB/eV0Ya8SeP269ZjSY6PPSKaHtr9mFjOq1YYpQcYxxDAVh4FsKHpbuz
         5ydCwRAeLUlJzWLyOKbuQf5XajZQ/tsz6jerODTE9YRYV6bSr+8p0QZ3hrxYShj/vyCB
         55JTEBYYkircTjV0qT6q1r/NdvxMB1BkEXKe7OU0AZ5XsXK7BUrt9Kj8+SCrVror+qVf
         o4ZQ==
X-Gm-Message-State: AHQUAuYmsF0KW4U9jt9quZWDYodtNVFMHHRnEBh2DInlZ4MDgihboEPr
        fUDm1Ui4sZj6degLux5sZkI=
X-Google-Smtp-Source: AHgI3IYL8MGFumExa6IlVHyoe5F3kPgHIEw9/MxI8lQ82lqsyT8g/d4K+d00RfdF8vjBDWmk4LRAyw==
X-Received: by 2002:a5d:528e:: with SMTP id c14mr11044844wrv.304.1550773310981;
        Thu, 21 Feb 2019 10:21:50 -0800 (PST)
Received: from jernej-laptop.localnet (cpe-86-58-52-202.static.triera.net. [86.58.52.202])
        by smtp.gmail.com with ESMTPSA id h17sm18043256wrq.17.2019.02.21.10.21.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 10:21:49 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v4 2/2] media: cedrus: Add H264 decoding support
Date:   Thu, 21 Feb 2019 19:21:47 +0100
Message-ID: <2161521.rFApuVMEOR@jernej-laptop>
In-Reply-To: <1717029.ugS2kBEt89@jernej-laptop>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com> <864825e62e758ea51b61228a7ff140050810b48d.1550672228.git-series.maxime.ripard@bootlin.com> <1717029.ugS2kBEt89@jernej-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Dne sreda, 20. februar 2019 ob 18:50:54 CET je Jernej =C5=A0krabec napisal(=
a):
> Hi!
>=20
> I really wanted to do another review on previous series but got distracted
> by analyzing one particulary troublesome H264 sample. It still doesn't wo=
rk
> correctly, so I would ask you if you can test it with your stack (it might
> be userspace issue):
>=20
> http://jernej.libreelec.tv/videos/problematic/test.mkv
>=20
> Please take a look at my comments below.
>=20
> Dne sreda, 20. februar 2019 ob 15:17:34 CET je Maxime Ripard napisal(a):
> > Introduce some basic H264 decoding support in cedrus. So far, only the
> > baseline profile videos have been tested, and some more advanced featur=
es
> > used in higher profiles are not even implemented.
>=20
> What is not yet implemented? Multi slice frame decoding, interlaced frames
> and decoding frames with width > 2048. Anything else?
>=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >=20
> >  drivers/staging/media/sunxi/cedrus/Makefile       |   3 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus.c       |  30 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus.h       |  38 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus_dec.c   |  13 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus_h264.c  | 584 ++++++++++++++=
+-
> >  drivers/staging/media/sunxi/cedrus/cedrus_hw.c    |   4 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus_regs.h  |  91 ++-
> >  drivers/staging/media/sunxi/cedrus/cedrus_video.c |   9 +-
> >  8 files changed, 770 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_h264.c
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/Makefile
> > b/drivers/staging/media/sunxi/cedrus/Makefile index
> > e9dc68b7bcb6..aaf141fc58b6 100644
> > --- a/drivers/staging/media/sunxi/cedrus/Makefile
> > +++ b/drivers/staging/media/sunxi/cedrus/Makefile
> > @@ -1,3 +1,4 @@
> >=20
> >  obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) +=3D sunxi-cedrus.o
> >=20
> > -sunxi-cedrus-y =3D cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o
> > cedrus_mpeg2.o +sunxi-cedrus-y =3D cedrus.o cedrus_video.o cedrus_hw.o
> > cedrus_dec.o \ +		 cedrus_mpeg2.o cedrus_h264.o
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus.c index
> > ff11cbeba205..c1607142d998 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> > @@ -40,6 +40,35 @@ static const struct cedrus_control cedrus_controls[]=
 =3D
> > {
> >=20
> >  		.codec		=3D CEDRUS_CODEC_MPEG2,
> >  		.required	=3D false,
> >  =09
> >  	},
> >=20
> > +	{
> > +		.id		=3D
>=20
> V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS,
>=20
> > +		.elem_size	=3D sizeof(struct
>=20
> v4l2_ctrl_h264_decode_param),
>=20
> > +		.codec		=3D CEDRUS_CODEC_H264,
> > +		.required	=3D true,
> > +	},
> > +	{
> > +		.id		=3D
>=20
> V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS,
>=20
> > +		.elem_size	=3D sizeof(struct=20
v4l2_ctrl_h264_slice_param),
> > +		.codec		=3D CEDRUS_CODEC_H264,
> > +		.required	=3D true,
> > +	},
> > +	{
> > +		.id		=3D V4L2_CID_MPEG_VIDEO_H264_SPS,
> > +		.elem_size	=3D sizeof(struct v4l2_ctrl_h264_sps),
> > +		.codec		=3D CEDRUS_CODEC_H264,
> > +		.required	=3D true,
> > +	},
> > +	{
> > +		.id		=3D V4L2_CID_MPEG_VIDEO_H264_PPS,
> > +		.elem_size	=3D sizeof(struct v4l2_ctrl_h264_pps),
> > +		.codec		=3D CEDRUS_CODEC_H264,
> > +		.required	=3D true,
> > +	},
> > +	{
> > +		.id		=3D
>=20
> V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX,
>=20
> > +		.elem_size	=3D sizeof(struct
>=20
> v4l2_ctrl_h264_scaling_matrix),
>=20
> > +		.codec		=3D CEDRUS_CODEC_H264,
> > +	},
> >=20
> >  };
> > =20
> >  #define CEDRUS_CONTROLS_COUNT	ARRAY_SIZE(cedrus_controls)
> >=20
> > @@ -278,6 +307,7 @@ static int cedrus_probe(struct platform_device *pde=
v)
> >=20
> >  	}
> >  =09
> >  	dev->dec_ops[CEDRUS_CODEC_MPEG2] =3D &cedrus_dec_ops_mpeg2;
> >=20
> > +	dev->dec_ops[CEDRUS_CODEC_H264] =3D &cedrus_dec_ops_h264;
> >=20
> >  	mutex_init(&dev->dev_mutex);
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h
> > b/drivers/staging/media/sunxi/cedrus/cedrus.h index
> > 4aedd24a9848..8c64f9a27e9d 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus.h
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
> > @@ -30,7 +30,7 @@
> >=20
> >  enum cedrus_codec {
> > =20
> >  	CEDRUS_CODEC_MPEG2,
> >=20
> > -
> > +	CEDRUS_CODEC_H264,
> >=20
> >  	CEDRUS_CODEC_LAST,
> > =20
> >  };
> >=20
> > @@ -40,6 +40,12 @@ enum cedrus_irq_status {
> >=20
> >  	CEDRUS_IRQ_OK,
> > =20
> >  };
> >=20
> > +enum cedrus_h264_pic_type {
> > +	CEDRUS_H264_PIC_TYPE_FRAME	=3D 0,
> > +	CEDRUS_H264_PIC_TYPE_FIELD,
> > +	CEDRUS_H264_PIC_TYPE_MBAFF,
> > +};
> > +
> >=20
> >  struct cedrus_control {
> > =20
> >  	u32			id;
> >  	u32			elem_size;
> >=20
> > @@ -47,6 +53,14 @@ struct cedrus_control {
> >=20
> >  	unsigned char		required:1;
> > =20
> >  };
> >=20
> > +struct cedrus_h264_run {
> > +	const struct v4l2_ctrl_h264_decode_param	*decode_param;
> > +	const struct v4l2_ctrl_h264_pps			*pps;
> > +	const struct v4l2_ctrl_h264_scaling_matrix=09
*scaling_matrix;
> > +	const struct v4l2_ctrl_h264_slice_param		*slice_param;
> > +	const struct v4l2_ctrl_h264_sps			*sps;
> > +};
> > +
> >=20
> >  struct cedrus_mpeg2_run {
> > =20
> >  	const struct v4l2_ctrl_mpeg2_slice_params	*slice_params;
> >  	const struct v4l2_ctrl_mpeg2_quantization	*quantization;
> >=20
> > @@ -57,12 +71,20 @@ struct cedrus_run {
> >=20
> >  	struct vb2_v4l2_buffer	*dst;
> >  =09
> >  	union {
> >=20
> > +		struct cedrus_h264_run	h264;
> >=20
> >  		struct cedrus_mpeg2_run	mpeg2;
> >  =09
> >  	};
> > =20
> >  };
> > =20
> >  struct cedrus_buffer {
> > =20
> >  	struct v4l2_m2m_buffer          m2m_buf;
> >=20
> > +
> > +	union {
> > +		struct {
> > +			unsigned int			position;
> > +			enum cedrus_h264_pic_type	pic_type;
> > +		} h264;
> > +	} codec;
> >=20
> >  };
> > =20
> >  struct cedrus_ctx {
> >=20
> > @@ -77,6 +99,19 @@ struct cedrus_ctx {
> >=20
> >  	struct v4l2_ctrl		**ctrls;
> >  =09
> >  	struct vb2_buffer		*dst_bufs[VIDEO_MAX_FRAME];
> >=20
> > +
> > +	union {
> > +		struct {
> > +			void		*mv_col_buf;
> > +			dma_addr_t	mv_col_buf_dma;
> > +			ssize_t		mv_col_buf_field_size;
> > +			ssize_t		mv_col_buf_size;
> > +			void		*pic_info_buf;
> > +			dma_addr_t	pic_info_buf_dma;
> > +			void		*neighbor_info_buf;
> > +			dma_addr_t	neighbor_info_buf_dma;
> > +		} h264;
> > +	} codec;
> >=20
> >  };
> > =20
> >  struct cedrus_dec_ops {
> >=20
> > @@ -118,6 +153,7 @@ struct cedrus_dev {
> >=20
> >  };
> > =20
> >  extern struct cedrus_dec_ops cedrus_dec_ops_mpeg2;
> >=20
> > +extern struct cedrus_dec_ops cedrus_dec_ops_h264;
> >=20
> >  static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 v=
al)
> >  {
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c index
> > 4d6d602cdde6..a290ae1b8f4d 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > @@ -46,6 +46,19 @@ void cedrus_device_run(void *priv)
> >=20
> >  			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
> >  	=09
> >  		break;
> >=20
> > +	case V4L2_PIX_FMT_H264_SLICE:
> > +		run.h264.decode_param =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS);
> > +		run.h264.pps =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_H264_PPS);
> > +		run.h264.scaling_matrix =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX);
> > +		run.h264.slice_param =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS);
> > +		run.h264.sps =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_H264_SPS);
> > +		break;
> > +
> >=20
> >  	default:
> >  		break;
> >  =09
> >  	}
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c new file mode 100644
> > index 000000000000..51e5f57120a2
> > --- /dev/null
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
> > @@ -0,0 +1,584 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Cedrus VPU driver
> > + *
> > + * Copyright (c) 2013 Jens Kuske <jenskuske@gmail.com>
> > + * Copyright (c) 2018 Bootlin
> > + */
> > +
> > +#include <linux/types.h>
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +
> > +#include "cedrus.h"
> > +#include "cedrus_hw.h"
> > +#include "cedrus_regs.h"
> > +
> > +enum cedrus_h264_sram_off {
> > +	CEDRUS_SRAM_H264_PRED_WEIGHT_TABLE	=3D 0x000,
> > +	CEDRUS_SRAM_H264_FRAMEBUFFER_LIST	=3D 0x100,
> > +	CEDRUS_SRAM_H264_REF_LIST_0		=3D 0x190,
> > +	CEDRUS_SRAM_H264_REF_LIST_1		=3D 0x199,
> > +	CEDRUS_SRAM_H264_SCALING_LIST_8x8_0	=3D 0x200,
> > +	CEDRUS_SRAM_H264_SCALING_LIST_8x8_1	=3D 0x210,
> > +	CEDRUS_SRAM_H264_SCALING_LIST_4x4	=3D 0x220,
> > +};
> > +
> > +struct cedrus_h264_sram_ref_pic {
> > +	__le32	top_field_order_cnt;
> > +	__le32	bottom_field_order_cnt;
> > +	__le32	frame_info;
> > +	__le32	luma_ptr;
> > +	__le32	chroma_ptr;
> > +	__le32	mv_col_top_ptr;
> > +	__le32	mv_col_bot_ptr;
> > +	__le32	reserved;
> > +} __packed;
> > +
> > +#define CEDRUS_H264_FRAME_NUM		18
> > +
> > +#define CEDRUS_NEIGHBOR_INFO_BUF_SIZE	(16 * SZ_1K)
> > +#define CEDRUS_PIC_INFO_BUF_SIZE	(128 * SZ_1K)
> > +
> > +static void cedrus_h264_write_sram(struct cedrus_dev *dev,
> > +				   enum cedrus_h264_sram_off off,
> > +				   const void *data, size_t len)
> > +{
> > +	const u32 *buffer =3D data;
> > +	size_t count =3D DIV_ROUND_UP(len, 4);
> > +
> > +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET, off << 2);
> > +
> > +	do {
> > +		cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);
> > +	} while (--count);
>=20
> Above loop will still write one word for count =3D 0. I propose following:
>=20
> while (count--)
> 	cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);
>=20
> > +}
> > +
> > +static dma_addr_t cedrus_h264_mv_col_buf_addr(struct cedrus_ctx *ctx,
> > +					      unsigned int
>=20
> position,
>=20
> > +					      unsigned int
>=20
> field)
>=20
> > +{
> > +	dma_addr_t addr =3D ctx->codec.h264.mv_col_buf_dma;
> > +
> > +	/* Adjust for the position */
> > +	addr +=3D position * ctx->codec.h264.mv_col_buf_field_size * 2;
> > +
> > +	/* Adjust for the field */
> > +	addr +=3D field * ctx->codec.h264.mv_col_buf_field_size;
> > +
> > +	return addr;
> > +}
> > +
> > +static void cedrus_fill_ref_pic(struct cedrus_ctx *ctx,
> > +				struct cedrus_buffer *buf,
> > +				unsigned int top_field_order_cnt,
> > +				unsigned int
>=20
> bottom_field_order_cnt,
>=20
> > +				struct cedrus_h264_sram_ref_pic
>=20
> *pic)
>=20
> > +{
> > +	struct vb2_buffer *vbuf =3D &buf->m2m_buf.vb.vb2_buf;
> > +	unsigned int position =3D buf->codec.h264.position;
> > +
> > +	pic->top_field_order_cnt =3D top_field_order_cnt;
> > +	pic->bottom_field_order_cnt =3D bottom_field_order_cnt;
> > +	pic->frame_info =3D buf->codec.h264.pic_type << 8;
> > +
> > +	pic->luma_ptr =3D cedrus_buf_addr(vbuf, &ctx->dst_fmt, 0);
> > +	pic->chroma_ptr =3D cedrus_buf_addr(vbuf, &ctx->dst_fmt, 1);
> > +	pic->mv_col_top_ptr =3D cedrus_h264_mv_col_buf_addr(ctx, position,
>=20
> 0);
>=20
> > +	pic->mv_col_bot_ptr =3D cedrus_h264_mv_col_buf_addr(ctx, position,
>=20
> 1);
>=20
> > +}
> > +
> > +static void cedrus_write_frame_list(struct cedrus_ctx *ctx,
> > +				    struct cedrus_run *run)
> > +{
> > +	struct cedrus_h264_sram_ref_pic pic_list[CEDRUS_H264_FRAME_NUM];
> > +	const struct v4l2_ctrl_h264_decode_param *dec_param =3D
> > run->h264.decode_param; +	const struct v4l2_ctrl_h264_slice_param
>=20
> *slice =3D
>=20
> > run->h264.slice_param; +	const struct v4l2_ctrl_h264_sps *sps =3D
> > run->h264.sps;
> > +	const struct vb2_buffer *dst_buf =3D &run->dst->vb2_buf;
> > +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > +	struct cedrus_buffer *output_buf;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	unsigned long used_dpbs =3D 0;
> > +	unsigned int position;
> > +	unsigned int output =3D 0;
> > +	unsigned int i;
> > +
> > +	memset(pic_list, 0, sizeof(pic_list));
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(dec_param->dpb); i++) {
> > +		const struct v4l2_h264_dpb_entry *dpb =3D &dec_param-
> >
> >dpb[i];
> >
> > +		struct cedrus_buffer *cedrus_buf;
> > +		int buf_idx;
> > +
> > +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_VALID))
> > +			continue;
> > +
> > +		buf_idx =3D vb2_find_timestamp(cap_q, dpb->timestamp, 0);
> > +		if (buf_idx < 0)
> > +			continue;
> > +
> > +		cedrus_buf =3D vb2_to_cedrus_buffer(ctx-
> >
> >dst_bufs[buf_idx]);
> >
> > +		position =3D cedrus_buf->codec.h264.position;
> > +		used_dpbs |=3D BIT(position);
> > +
> > +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > +			continue;
> > +
> > +		cedrus_fill_ref_pic(ctx, cedrus_buf,
> > +				    dpb->top_field_order_cnt,
> > +				    dpb->bottom_field_order_cnt,
> > +				    &pic_list[position]);
> > +
> > +		output =3D max(position, output);
> > +	}
> > +
> > +	position =3D find_next_zero_bit(&used_dpbs, CEDRUS_H264_FRAME_NUM,
> > +				      output);
> > +	if (position >=3D CEDRUS_H264_FRAME_NUM)
> > +		position =3D find_first_zero_bit(&used_dpbs,
>=20
> CEDRUS_H264_FRAME_NUM);
>=20
> I guess you didn't try any interlaced videos? Sometimes it happens that
> buffer is reference and output at the same time. In such cases, above code
> would make two entries, which doesn't work based on Kwiboo's and my
> experiments.
>=20
> I guess decoding interlaced videos is out of scope at this time?
>=20
> > +
> > +	output_buf =3D vb2_to_cedrus_buffer(&run->dst->vb2_buf);
> > +	output_buf->codec.h264.position =3D position;
> > +
> > +	if (slice->flags & V4L2_H264_SLICE_FLAG_FIELD_PIC)
> > +		output_buf->codec.h264.pic_type =3D
>=20
> CEDRUS_H264_PIC_TYPE_FIELD;
>=20
> > +	else if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
> > +		output_buf->codec.h264.pic_type =3D
>=20
> CEDRUS_H264_PIC_TYPE_MBAFF;
>=20
> > +	else
> > +		output_buf->codec.h264.pic_type =3D
>=20
> CEDRUS_H264_PIC_TYPE_FRAME;
>=20
> > +
> > +	cedrus_fill_ref_pic(ctx, output_buf,
> > +			    dec_param->top_field_order_cnt,
> > +			    dec_param->bottom_field_order_cnt,
> > +			    &pic_list[position]);
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_FRAMEBUFFER_LIST,
> > +			       pic_list, sizeof(pic_list));
> > +
> > +	cedrus_write(dev, VE_H264_OUTPUT_FRAME_IDX, position);
> > +}
> > +
> > +#define CEDRUS_MAX_REF_IDX	32
> > +
> > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > +				   struct cedrus_run *run,
> > +				   const u8 *ref_list, u8=20
num_ref,
> > +				   enum cedrus_h264_sram_off sram)
> > +{
> > +	const struct v4l2_ctrl_h264_decode_param *decode =3D run-
> >
> >h264.decode_param;
> >
> > +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > +	const struct vb2_buffer *dst_buf =3D &run->dst->vb2_buf;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	u8 sram_array[CEDRUS_MAX_REF_IDX];
> > +	unsigned int i;
> > +	size_t size;
> > +
> > +	memset(sram_array, 0, sizeof(sram_array));
> > +
> > +	for (i =3D 0; i < num_ref; i++) {
> > +		const struct v4l2_h264_dpb_entry *dpb;
> > +		const struct cedrus_buffer *cedrus_buf;
> > +		const struct vb2_v4l2_buffer *ref_buf;
> > +		unsigned int position;
> > +		int buf_idx;
> > +		u8 dpb_idx;
> > +
> > +		dpb_idx =3D ref_list[i];
> > +		dpb =3D &decode->dpb[dpb_idx];
> > +
> > +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > +			continue;
> > +
> > +		buf_idx =3D vb2_find_timestamp(cap_q, dpb->timestamp, 0);
> > +		if (buf_idx < 0)
> > +			continue;
> > +
> > +		ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > +		cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > +		position =3D cedrus_buf->codec.h264.position;
> > +
> > +		sram_array[i] |=3D position << 1;
> > +		if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
>=20
> I'm still not convinced that checking buffer field is appropriate solution
> here. IMO this bit defines top or bottom reference and same buffer could =
be
> used for both.
>=20
> But I guess this belongs for follow up patch which will fix decoding
> interlaced videos.
>=20
> > +			sram_array[i] |=3D BIT(0);
> > +	}
> > +
> > +	size =3D min_t(size_t, ALIGN(num_ref, 4), sizeof(sram_array));
> > +	cedrus_h264_write_sram(dev, sram, &sram_array, size);
> > +}
> > +
> > +static void cedrus_write_ref_list0(struct cedrus_ctx *ctx,
> > +				   struct cedrus_run *run)
> > +{
> > +	const struct v4l2_ctrl_h264_slice_param *slice =3D run-
> >
> >h264.slice_param;
> >
> > +
> > +	_cedrus_write_ref_list(ctx, run,
> > +			       slice->ref_pic_list0,
> > +			       slice->num_ref_idx_l0_active_minus1 +
>=20
> 1,
>=20
> > +			       CEDRUS_SRAM_H264_REF_LIST_0);
> > +}
> > +
> > +static void cedrus_write_ref_list1(struct cedrus_ctx *ctx,
> > +				   struct cedrus_run *run)
> > +{
> > +	const struct v4l2_ctrl_h264_slice_param *slice =3D run-
> >
> >h264.slice_param;
> >
> > +
> > +	_cedrus_write_ref_list(ctx, run,
> > +			       slice->ref_pic_list1,
> > +			       slice->num_ref_idx_l1_active_minus1 +
>=20
> 1,
>=20
> > +			       CEDRUS_SRAM_H264_REF_LIST_1);
> > +}
> > +
> > +static void cedrus_write_scaling_lists(struct cedrus_ctx *ctx,
> > +				       struct cedrus_run *run)
> > +{
> > +	const struct v4l2_ctrl_h264_scaling_matrix *scaling =3D
> > +		run->h264.scaling_matrix;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	if (!scaling)
> > +		return;
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_0,
> > +			       scaling->scaling_list_8x8[0],
> > +			       sizeof(scaling-
>scaling_list_8x8[0]));
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_1,
> > +			       scaling->scaling_list_8x8[1],
> > +			       sizeof(scaling-
>scaling_list_8x8[1]));
>=20
> Index above should be 3. IIRC 1 and 3 are used by 4:2:0 chroma subsamplin=
g,
> but currently I'm unable to find reference to that in standard.

I actually meant index 0 and 3. While I still can't pinpoint exact chapter =
in=20
specs, I found comment in ffmpeg what each index represents:

0 - Intra, Y
1 - Intra, Cr
2 - Intra, Cb
3 - Inter, Y
4 - Inter, Cr
5 - Inter, Cb

So 0 and 3 makes sense.

>=20
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_4x4,
> > +			       scaling->scaling_list_4x4,
> > +			       sizeof(scaling->scaling_list_4x4));
> > +}
> > +
> > +static void cedrus_write_pred_weight_table(struct cedrus_ctx *ctx,
> > +					   struct cedrus_run
>=20
> *run)
>=20
> > +{
> > +	const struct v4l2_ctrl_h264_slice_param *slice =3D
> > +		run->h264.slice_param;
> > +	const struct v4l2_h264_pred_weight_table *pred_weight =3D
> > +		&slice->pred_weight_table;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	int i, j, k;
> > +
> > +	cedrus_write(dev, VE_H264_SHS_WP,
> > +		     ((pred_weight->chroma_log2_weight_denom & 0xf) <<
>=20
> 4) |
>=20
> > +		     ((pred_weight->luma_log2_weight_denom & 0xf) <<
>=20
> 0));
>=20
> Denominators are only in range of 0-7, so mask should be 0x7. CedarX code
> also specify those two fields 3 bits wide.
>=20
> > +
> > +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET,
> > +		     CEDRUS_SRAM_H264_PRED_WEIGHT_TABLE << 2);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(pred_weight->weight_factors); i++) {
> > +		const struct v4l2_h264_weight_factors *factors =3D
> > +			&pred_weight->weight_factors[i];
> > +
> > +		for (j =3D 0; j < ARRAY_SIZE(factors->luma_weight); j++)=20
{
> > +			u32 val;
> > +
> > +			val =3D ((factors->luma_offset[j] & 0x1ff) <<=20
16)
> >=20
> > +				(factors->luma_weight[j] & 0x1ff);
> > +			cedrus_write(dev, VE_AVC_SRAM_PORT_DATA,
>=20
> val);
>=20
> You should cast offset varible to wider type. Currently some videos which
> use prediction weight table don't work for me, unless offset is casted to
> u32 first. Shifting 8 bit variable for 16 places gives you 0 every time.
>=20
> Luma offset and weight are defined as s8, so having wider mask doesn't
> really make sense. However, I think weight should be s16 anyway, because
> standard says that it's value could be 2^denominator for default value or
> in range -128..127. Worst case would be 2^7 =3D 128 and -128. To cover bo=
th
> values you need at least 9 bits.
>=20
> I guess there is a way to detect when default values need to be written (=
if
> at all) and that can be handled separately. But I don't see any reason why
> bigger type can't be used for just in case. Offset being s8 is fine and y=
ou
> can drop mask for it.
>=20
> Everything applies for chroma below too.
>=20
> > +		}
> > +
> > +		for (j =3D 0; j < ARRAY_SIZE(factors->chroma_weight); j+
+)
>=20
> {
>=20
> > +			for (k =3D 0; k < ARRAY_SIZE(factors-
> >
> >chroma_weight[0]); k++) {
> >
> > +				u32 val;
> > +
> > +				val =3D ((factors->chroma_offset[j]
>=20
> [k] & 0x1ff) << 16) |
>=20
> > +					(factors-
> >
> >chroma_weight[j][k] & 0x1ff);
> >
> > +				cedrus_write(dev,
>=20
> VE_AVC_SRAM_PORT_DATA, val);
>=20
> > +			}
> > +		}
> > +	}
> > +}
> > +
> > +static void cedrus_set_params(struct cedrus_ctx *ctx,
> > +			      struct cedrus_run *run)
> > +{
> > +	const struct v4l2_ctrl_h264_scaling_matrix *scaling =3D
> > run->h264.scaling_matrix; +	const struct v4l2_ctrl_h264_decode_param
> > *decode =3D run->h264.decode_param; +	const struct
>=20
> v4l2_ctrl_h264_slice_param
>=20
> > *slice =3D run->h264.slice_param; +	const struct v4l2_ctrl_h264_pps *pp=
s =3D
> > run->h264.pps;
> > +	const struct v4l2_ctrl_h264_sps *sps =3D run->h264.sps;
> > +	struct vb2_buffer *src_buf =3D &run->src->vb2_buf;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	dma_addr_t src_buf_addr;
> > +	u32 offset =3D slice->header_bit_size;
> > +	u32 len =3D (slice->size * 8) - offset;
> > +	u32 reg;
> > +
> > +	cedrus_write(dev, VE_H264_VLD_LEN, len);
> > +	cedrus_write(dev, VE_H264_VLD_OFFSET, offset);
> > +
> > +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(src_buf, 0);
> > +	cedrus_write(dev, VE_H264_VLD_END,
> > +		     src_buf_addr + vb2_get_plane_payload(src_buf, 0));
> > +	cedrus_write(dev, VE_H264_VLD_ADDR,
> > +		     VE_H264_VLD_ADDR_VAL(src_buf_addr) |
> > +		     VE_H264_VLD_ADDR_FIRST | VE_H264_VLD_ADDR_VALID |
> > +		     VE_H264_VLD_ADDR_LAST);
> > +
> > +	/*
> > +	 * FIXME: Since the bitstream parsing is done in software, and
> > +	 * in userspace, this shouldn't be needed anymore. But it
> > +	 * turns out that removing it breaks the decoding process,
> > +	 * without any clear indication why.
> > +	 */
> > +	cedrus_write(dev, VE_H264_TRIGGER_TYPE,
> > +		     VE_H264_TRIGGER_TYPE_INIT_SWDEC);
> > +
> > +	if (((pps->flags & V4L2_H264_PPS_FLAG_WEIGHTED_PRED) &&
> > +	     (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_P ||
> > +	      slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_SP)) ||
> > +	    (pps->weighted_bipred_idc =3D=3D 1 &&
> > +	     slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_B))
> > +		cedrus_write_pred_weight_table(ctx, run);
> > +
> > +	if ((slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_P) ||
> > +	    (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_SP) ||
> > +	    (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_B))
> > +		cedrus_write_ref_list0(ctx, run);
> > +
> > +	if (slice->slice_type =3D=3D V4L2_H264_SLICE_TYPE_B)
> > +		cedrus_write_ref_list1(ctx, run);
> > +
> > +	// picture parameters
> > +	reg =3D 0;
> > +	/*
> > +	 * FIXME: the kernel headers are allowing the default value to
> > +	 * be passed, but the libva doesn't give us that.
> > +	 */
> > +	reg |=3D (slice->num_ref_idx_l0_active_minus1 & 0x1f) << 10;
> > +	reg |=3D (slice->num_ref_idx_l1_active_minus1 & 0x1f) << 5;
> > +	reg |=3D (pps->weighted_bipred_idc & 0x3) << 2;
> > +	if (pps->flags & V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE)
> > +		reg |=3D VE_H264_PPS_ENTROPY_CODING_MODE;
> > +	if (pps->flags & V4L2_H264_PPS_FLAG_WEIGHTED_PRED)
> > +		reg |=3D VE_H264_PPS_WEIGHTED_PRED;
> > +	if (pps->flags & V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED)
> > +		reg |=3D VE_H264_PPS_CONSTRAINED_INTRA_PRED;
> > +	if (pps->flags & V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE)
> > +		reg |=3D VE_H264_PPS_TRANSFORM_8X8_MODE;
> > +	cedrus_write(dev, VE_H264_PPS, reg);
> > +
> > +	// sequence parameters
> > +	reg =3D 0;
> > +	reg |=3D (sps->chroma_format_idc & 0x7) << 19;
> > +	reg |=3D (sps->pic_width_in_mbs_minus1 & 0xff) << 8;
> > +	reg |=3D sps->pic_height_in_map_units_minus1 & 0xff;
> > +	if (sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY)
> > +		reg |=3D VE_H264_SPS_MBS_ONLY;
> > +	if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
> > +		reg |=3D VE_H264_SPS_MB_ADAPTIVE_FRAME_FIELD;
> > +	if (sps->flags & V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE)
> > +		reg |=3D VE_H264_SPS_DIRECT_8X8_INFERENCE;
> > +	cedrus_write(dev, VE_H264_SPS, reg);
> > +
> > +	// slice parameters
> > +	reg =3D 0;
> > +	reg |=3D decode->nal_ref_idc ? BIT(12) : 0;

BIT(12) should be a flag.

> > +	reg |=3D (slice->slice_type & 0xf) << 8;
> > +	reg |=3D slice->cabac_init_idc & 0x3;
> > +	reg |=3D VE_H264_SHS_FIRST_SLICE_IN_PIC;
> > +	if (slice->flags & V4L2_H264_SLICE_FLAG_FIELD_PIC)
> > +		reg |=3D VE_H264_SHS_FIELD_PIC;
> > +	if (slice->flags & V4L2_H264_SLICE_FLAG_BOTTOM_FIELD)
> > +		reg |=3D VE_H264_SHS_BOTTOM_FIELD;
> > +	if (slice->flags & V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED)
> > +		reg |=3D VE_H264_SHS_DIRECT_SPATIAL_MV_PRED;
> > +	cedrus_write(dev, VE_H264_SHS, reg);
> > +
> > +	reg =3D 0;
> > +	reg |=3D VE_H264_SHS2_NUM_REF_IDX_ACTIVE_OVRD;
> > +	reg |=3D (slice->num_ref_idx_l0_active_minus1 & 0x1f) << 24;
> > +	reg |=3D (slice->num_ref_idx_l1_active_minus1 & 0x1f) << 16;
> > +	reg |=3D (slice->disable_deblocking_filter_idc & 0x3) << 8;
> > +	reg |=3D (slice->slice_alpha_c0_offset_div2 & 0xf) << 4;
> > +	reg |=3D slice->slice_beta_offset_div2 & 0xf;
> > +	cedrus_write(dev, VE_H264_SHS2, reg);
> > +
> > +	reg =3D 0;
> > +	if (!(scaling && (pps->flags &
> > V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT))) +		reg |=3D
> > VE_H264_SHS_QP_SCALING_MATRIX_DEFAULT;
> > +	reg |=3D (pps->second_chroma_qp_index_offset & 0x3f) << 16;
> > +	reg |=3D (pps->chroma_qp_index_offset & 0x3f) << 8;
> > +	reg |=3D (pps->pic_init_qp_minus26 + 26 + slice->slice_qp_delta) &
>=20
> 0x3f;
>=20
> > +	cedrus_write(dev, VE_H264_SHS_QP, reg);
> > +
> > +	// clear status flags
> > +	cedrus_write(dev, VE_H264_STATUS, cedrus_read(dev,
>=20
> VE_H264_STATUS));
>=20
> I'm not sure clearing status here is needed. Do you have any case where it
> is need? Maybe if some error happened before and cedrus_h264_irq_clear()
> wasn't cleared. I'm fine either way.
>=20
> > +
> > +	// enable int
> > +	reg =3D cedrus_read(dev, VE_H264_CTRL);
> > +	cedrus_write(dev, VE_H264_CTRL, reg |
> > +		     VE_H264_CTRL_SLICE_DECODE_INT |
> > +		     VE_H264_CTRL_DECODE_ERR_INT |
> > +		     VE_H264_CTRL_VLD_DATA_REQ_INT);
>=20
> Since this is the only place where you set VE_H264_CTRL, I wouldn't prese=
rve
> previous content. This mode is also capable of decoding VP8 and AVS. So in
> theory, if user would want to decode H264 and VP8 videos at the same time,
> preserving content will probably corrupt your output. I would just set all
> other bits to 0. What do you think? I tested this without preservation and
> it works fine.
>=20
> > +}
> > +
> > +static enum cedrus_irq_status
> > +cedrus_h264_irq_status(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	u32 reg =3D cedrus_read(dev, VE_H264_STATUS);
> > +
> > +	if (reg & (VE_H264_STATUS_DECODE_ERR_INT |
> > +		   VE_H264_STATUS_VLD_DATA_REQ_INT))
> > +		return CEDRUS_IRQ_ERROR;
> > +
> > +	if (reg & VE_H264_CTRL_SLICE_DECODE_INT)
> > +		return CEDRUS_IRQ_OK;
> > +
> > +	return CEDRUS_IRQ_NONE;
> > +}
> > +
> > +static void cedrus_h264_irq_clear(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	cedrus_write(dev, VE_H264_STATUS,
> > +		     VE_H264_STATUS_INT_MASK);
> > +}
> > +
> > +static void cedrus_h264_irq_disable(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	u32 reg =3D cedrus_read(dev, VE_H264_CTRL);
> > +
> > +	cedrus_write(dev, VE_H264_CTRL,
> > +		     reg & ~VE_H264_CTRL_INT_MASK);
> > +}
> > +
> > +static void cedrus_h264_setup(struct cedrus_ctx *ctx,
> > +			      struct cedrus_run *run)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	cedrus_engine_enable(dev, CEDRUS_CODEC_H264);
> > +
> > +	cedrus_write(dev, VE_H264_SDROT_CTRL, 0);
> > +	cedrus_write(dev, VE_H264_EXTRA_BUFFER1,
> > +		     ctx->codec.h264.pic_info_buf_dma);
> > +	cedrus_write(dev, VE_H264_EXTRA_BUFFER2,
> > +		     ctx->codec.h264.neighbor_info_buf_dma);
> > +
> > +	cedrus_write_scaling_lists(ctx, run);
> > +	cedrus_write_frame_list(ctx, run);
> > +
> > +	cedrus_set_params(ctx, run);
> > +}
> > +
> > +static int cedrus_h264_start(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	unsigned int field_size;
> > +	unsigned int mv_col_size;
> > +	int ret;
> > +
> > +	/*
> > +	 * FIXME: It seems that the H6 cedarX code is using a formula
> > +	 * here based on the size of the frame, while all the older
> > +	 * code is using a fixed size, so that might need to be
> > +	 * changed at some point.
> > +	 */
> > +	ctx->codec.h264.pic_info_buf =3D
> > +		dma_alloc_coherent(dev->dev, CEDRUS_PIC_INFO_BUF_SIZE,
> > +				   &ctx-
> >
> >codec.h264.pic_info_buf_dma,
> >
> > +				   GFP_KERNEL);
> > +	if (!ctx->codec.h264.pic_info_buf)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * That buffer is supposed to be 16kiB in size, and be aligned
> > +	 * on 16kiB as well. However, dma_alloc_coherent provides the
> > +	 * guarantee that we'll have a CPU and DMA address aligned on
> > +	 * the smallest page order that is greater to the requested
> > +	 * size, so we don't have to overallocate.
> > +	 */
> > +	ctx->codec.h264.neighbor_info_buf =3D
> > +		dma_alloc_coherent(dev->dev,
>=20
> CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
>=20
> > +				   &ctx-
> >
> >codec.h264.neighbor_info_buf_dma,
> >
> > +				   GFP_KERNEL);
> > +	if (!ctx->codec.h264.neighbor_info_buf) {
> > +		ret =3D -ENOMEM;
> > +		goto err_pic_buf;
> > +	}
> > +
> > +	field_size =3D DIV_ROUND_UP(ctx->src_fmt.width, 16) *
> > +		DIV_ROUND_UP(ctx->src_fmt.height, 16) * 16;
> > +
> > +	/*
> > +	 * FIXME: This is actually conditional to
> > +	 * V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE not being set, we
> > +	 * might have to rework this if memory efficiency ever is
> > +	 * something we need to work on.
> > +	 */
> > +	field_size =3D field_size * 2;
> > +
> > +	/*
> > +	 * FIXME: This is actually conditional to
> > +	 * V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY not being set, we might
> > +	 * have to rework this if memory efficiency ever is something
> > +	 * we need to work on.
> > +	 */
> > +	field_size =3D field_size * 2;
> > +	ctx->codec.h264.mv_col_buf_field_size =3D field_size;
>=20
> CedarX code aligns this buffer to 1024. Should we do it too just to be on
> the safe side? I don't think it cost us anything due to
> dma_alloc_coherent() alignments.

I mixed up this a bit. While I still think we should do it, it cost us just=
 a=20
little extra memory.

It wouldn't cost us anything if they would be separately allocated (due to=
=20
alignment), but that's not the case here.

Best regards,
Jernej

>=20
> Sorry again for a bit late in-depth review.
>=20
> Best regards,
> Jernej
>=20
> > +
> > +	mv_col_size =3D field_size * 2 * CEDRUS_H264_FRAME_NUM;
> > +	ctx->codec.h264.mv_col_buf_size =3D mv_col_size;
> > +	ctx->codec.h264.mv_col_buf =3D dma_alloc_coherent(dev->dev,
> > +
>=20
> ctx->codec.h264.mv_col_buf_size,
>=20
> > +
>=20
> &ctx->codec.h264.mv_col_buf_dma,
>=20
> > +
>=20
> GFP_KERNEL);
>=20
> > +	if (!ctx->codec.h264.mv_col_buf) {
> > +		ret =3D -ENOMEM;
> > +		goto err_neighbor_buf;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_neighbor_buf:
> > +	dma_free_coherent(dev->dev, CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
> > +			  ctx->codec.h264.neighbor_info_buf,
> > +			  ctx->codec.h264.neighbor_info_buf_dma);
> > +
> > +err_pic_buf:
> > +	dma_free_coherent(dev->dev, CEDRUS_PIC_INFO_BUF_SIZE,
> > +			  ctx->codec.h264.pic_info_buf,
> > +			  ctx->codec.h264.pic_info_buf_dma);
> > +	return ret;
> > +}
> > +
> > +static void cedrus_h264_stop(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	dma_free_coherent(dev->dev, ctx->codec.h264.mv_col_buf_size,
> > +			  ctx->codec.h264.mv_col_buf,
> > +			  ctx->codec.h264.mv_col_buf_dma);
> > +	dma_free_coherent(dev->dev, CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
> > +			  ctx->codec.h264.neighbor_info_buf,
> > +			  ctx->codec.h264.neighbor_info_buf_dma);
> > +	dma_free_coherent(dev->dev, CEDRUS_PIC_INFO_BUF_SIZE,
> > +			  ctx->codec.h264.pic_info_buf,
> > +			  ctx->codec.h264.pic_info_buf_dma);
> > +}
> > +
> > +static void cedrus_h264_trigger(struct cedrus_ctx *ctx)
> > +{
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	cedrus_write(dev, VE_H264_TRIGGER_TYPE,
> > +		     VE_H264_TRIGGER_TYPE_AVC_SLICE_DECODE);
> > +}
> > +
> > +struct cedrus_dec_ops cedrus_dec_ops_h264 =3D {
> > +	.irq_clear	=3D cedrus_h264_irq_clear,
> > +	.irq_disable	=3D cedrus_h264_irq_disable,
> > +	.irq_status	=3D cedrus_h264_irq_status,
> > +	.setup		=3D cedrus_h264_setup,
> > +	.start		=3D cedrus_h264_start,
> > +	.stop		=3D cedrus_h264_stop,
> > +	.trigger	=3D cedrus_h264_trigger,
> > +};
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c index
> > 0acf219a8c91..ab402b0cac4e 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> > @@ -46,6 +46,10 @@ int cedrus_engine_enable(struct cedrus_dev *dev, enum
> > cedrus_codec codec) reg |=3D VE_MODE_DEC_MPEG;
> >=20
> >  		break;
> >=20
> > +	case CEDRUS_CODEC_H264:
> > +		reg |=3D VE_MODE_DEC_H264;
> > +		break;
> > +
> >=20
> >  	default:
> >  		return -EINVAL;
> >  =09
> >  	}
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> > b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h index
> > de2d6b6f64bf..3e9931416e45 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> > @@ -232,4 +232,95 @@
> >=20
> >  #define VE_DEC_MPEG_ROT_LUMA			(VE_ENGINE_DEC_MPEG +
>=20
> 0xcc)
>=20
> >  #define VE_DEC_MPEG_ROT_CHROMA
>=20
> (VE_ENGINE_DEC_MPEG + 0xd0)
>=20
> > +#define VE_H264_SPS			0x200
> > +#define VE_H264_SPS_MBS_ONLY			BIT(18)
> > +#define VE_H264_SPS_MB_ADAPTIVE_FRAME_FIELD	BIT(17)
> > +#define VE_H264_SPS_DIRECT_8X8_INFERENCE	BIT(16)
> > +
> > +#define VE_H264_PPS			0x204
> > +#define VE_H264_PPS_ENTROPY_CODING_MODE		BIT(15)
> > +#define VE_H264_PPS_WEIGHTED_PRED		BIT(4)
> > +#define VE_H264_PPS_CONSTRAINED_INTRA_PRED	BIT(1)
> > +#define VE_H264_PPS_TRANSFORM_8X8_MODE		BIT(0)
> > +
> > +#define VE_H264_SHS			0x208
> > +#define VE_H264_SHS_FIRST_SLICE_IN_PIC		BIT(5)
> > +#define VE_H264_SHS_FIELD_PIC			BIT(4)
> > +#define VE_H264_SHS_BOTTOM_FIELD		BIT(3)
> > +#define VE_H264_SHS_DIRECT_SPATIAL_MV_PRED	BIT(2)
> > +
> > +#define VE_H264_SHS2			0x20c
> > +#define VE_H264_SHS2_NUM_REF_IDX_ACTIVE_OVRD	BIT(12)
> > +
> > +#define VE_H264_SHS_WP			0x210
> > +
> > +#define VE_H264_SHS_QP			0x21c
> > +#define VE_H264_SHS_QP_SCALING_MATRIX_DEFAULT	BIT(24)
> > +
> > +#define VE_H264_CTRL			0x220
> > +#define VE_H264_CTRL_VLD_DATA_REQ_INT		BIT(2)
> > +#define VE_H264_CTRL_DECODE_ERR_INT		BIT(1)
> > +#define VE_H264_CTRL_SLICE_DECODE_INT		BIT(0)
> > +
> > +#define VE_H264_CTRL_INT_MASK		(VE_H264_CTRL_VLD_DATA_REQ_INT |=20
\
> > +
>=20
> VE_H264_CTRL_DECODE_ERR_INT | \
>=20
> > +
>=20
> VE_H264_CTRL_SLICE_DECODE_INT)
>=20
> > +
> > +#define VE_H264_TRIGGER_TYPE		0x224
> > +#define VE_H264_TRIGGER_TYPE_AVC_SLICE_DECODE	(8 << 0)
> > +#define VE_H264_TRIGGER_TYPE_INIT_SWDEC		(7 << 0)
> > +
> > +#define VE_H264_STATUS			0x228
> > +#define VE_H264_STATUS_VLD_DATA_REQ_INT
>=20
> VE_H264_CTRL_VLD_DATA_REQ_INT
>=20
> > +#define VE_H264_STATUS_DECODE_ERR_INT
>=20
> VE_H264_CTRL_DECODE_ERR_INT
>=20
> > +#define VE_H264_STATUS_SLICE_DECODE_INT
>=20
> VE_H264_CTRL_SLICE_DECODE_INT
>=20
> > +
> > +#define VE_H264_STATUS_INT_MASK
>=20
> VE_H264_CTRL_INT_MASK
>=20
> > +
> > +#define VE_H264_CUR_MB_NUM		0x22c
> > +
> > +#define VE_H264_VLD_ADDR		0x230
> > +#define VE_H264_VLD_ADDR_FIRST			BIT(30)
> > +#define VE_H264_VLD_ADDR_LAST			BIT(29)
> > +#define VE_H264_VLD_ADDR_VALID			BIT(28)
> > +#define VE_H264_VLD_ADDR_VAL(x)			(((x) &=20
0x0ffffff0) |
>=20
> ((x) >> 28))
>=20
> > +
> > +#define VE_H264_VLD_OFFSET		0x234
> > +#define VE_H264_VLD_LEN			0x238
> > +#define VE_H264_VLD_END			0x23c
> > +#define VE_H264_SDROT_CTRL		0x240
> > +#define VE_H264_OUTPUT_FRAME_IDX	0x24c
> > +#define VE_H264_EXTRA_BUFFER1		0x250
> > +#define VE_H264_EXTRA_BUFFER2		0x254
> > +#define VE_H264_BASIC_BITS		0x2dc
> > +#define VE_AVC_SRAM_PORT_OFFSET		0x2e0
> > +#define VE_AVC_SRAM_PORT_DATA		0x2e4
> > +
> > +#define VE_ISP_INPUT_SIZE		0xa00
> > +#define VE_ISP_INPUT_STRIDE		0xa04
> > +#define VE_ISP_CTRL			0xa08
> > +#define VE_ISP_INPUT_LUMA		0xa78
> > +#define VE_ISP_INPUT_CHROMA		0xa7c
> > +
> > +#define VE_AVC_PARAM			0xb04
> > +#define VE_AVC_QP			0xb08
> > +#define VE_AVC_MOTION_EST		0xb10
> > +#define VE_AVC_CTRL			0xb14
> > +#define VE_AVC_TRIGGER			0xb18
> > +#define VE_AVC_STATUS			0xb1c
> > +#define VE_AVC_BASIC_BITS		0xb20
> > +#define VE_AVC_UNK_BUF			0xb60
> > +#define VE_AVC_VLE_ADDR			0xb80
> > +#define VE_AVC_VLE_END			0xb84
> > +#define VE_AVC_VLE_OFFSET		0xb88
> > +#define VE_AVC_VLE_MAX			0xb8c
> > +#define VE_AVC_VLE_LENGTH		0xb90
> > +#define VE_AVC_REF_LUMA			0xba0
> > +#define VE_AVC_REF_CHROMA		0xba4
> > +#define VE_AVC_REC_LUMA			0xbb0
> > +#define VE_AVC_REC_CHROMA		0xbb4
> > +#define VE_AVC_REF_SLUMA		0xbb8
> > +#define VE_AVC_REC_SLUMA		0xbbc
> > +#define VE_AVC_MB_INFO			0xbc0
> > +
> >=20
> >  #endif
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus_video.c index
> > b5cc79389d67..67062900f87a 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > @@ -38,6 +38,10 @@ static struct cedrus_format cedrus_formats[] =3D {
> >=20
> >  		.directions	=3D CEDRUS_DECODE_SRC,
> >  =09
> >  	},
> >  	{
> >=20
> > +		.pixelformat	=3D V4L2_PIX_FMT_H264_SLICE,
> > +		.directions	=3D CEDRUS_DECODE_SRC,
> > +	},
> > +	{
> >=20
> >  		.pixelformat	=3D V4L2_PIX_FMT_SUNXI_TILED_NV12,
> >  		.directions	=3D CEDRUS_DECODE_DST,
> >  =09
> >  	},
> >=20
> > @@ -100,6 +104,7 @@ static void cedrus_prepare_format(struct
> > v4l2_pix_format *pix_fmt)
> >=20
> >  	switch (pix_fmt->pixelformat) {
> >=20
> >  	case V4L2_PIX_FMT_MPEG2_SLICE:
> > +	case V4L2_PIX_FMT_H264_SLICE:
> >  		/* Zero bytes per line for encoded source. */
> >  		bytesperline =3D 0;
> >=20
> > @@ -454,6 +459,10 @@ static int cedrus_start_streaming(struct vb2_queue
> > *vq, unsigned int count) ctx->current_codec =3D CEDRUS_CODEC_MPEG2;
> >=20
> >  		break;
> >=20
> > +	case V4L2_PIX_FMT_H264_SLICE:
> > +		ctx->current_codec =3D CEDRUS_CODEC_H264;
> > +		break;
> > +
> >=20
> >  	default:
> >  		return -EINVAL;
> >  =09
> >  	}




