Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81F1C10F04
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 20:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D6432192B
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 20:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5Zu1Dm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503187AbfBNUm5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:42:57 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38835 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394976AbfBNUmz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 15:42:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so7996060wrw.5;
        Thu, 14 Feb 2019 12:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lHBvXENANR97FxCioR3l296/LYxbFU0P8w4xUxqD3hQ=;
        b=W5Zu1Dm3N/SF0jPCo4zSxBzKRJQcz0tUaKuj2Nlf29c2vSwnEK0qOZGcOqpIqQvJZk
         QcIt8rh3fDLvu0Q6e7Sqeqv+8BkrgUiERAtTXL9pyzbag1aGtOxX9OIObPCm8gjvDo/0
         idAHIua0oXF/a9Xpb42K9oshi40lSO75uZ/FHCt3puyGzC/gSMYpqzGNkv3lEVYg7oF3
         RLs2nZpn+vWLPxX3rA2ZDt5z2XA8JD18UtLz+zBv+g5imLsIkYqAGa9SP5bnK9Y0SK26
         Jm1xS7rnLCWGp/c2IHQ89fJsl0oOSf3xEqy0ZGKulBsL6m8DOM2vX0TQogCyk3HeKIiI
         11wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHBvXENANR97FxCioR3l296/LYxbFU0P8w4xUxqD3hQ=;
        b=lLsJKxPJuEviORlyQUE9YcVSLVAKps7G0IORFAVTQzinPba58QBTODWXFuYvu+0ltg
         oZ4T0CWvkPpt1wZY4hXpJqsuChLRH88GnQv5PZ35dJ4aq07NZleUbGnOUEQU9SzkbQAh
         QxKwrzmma1OH0ohgdNVl6olPCBIT2rOcvtH1Y3mEb2gX1vQ6uOaWO2DlCGpk+rvgYsiX
         AaxvCP0rSfiPMmsxt/M5aFzzf62AjvDAkUi5NwoZbUOnv4hv9F+WU9PBis0zjU2IdfD2
         yrGtrQLCfBve29X2+3YVXFIzJE54kyU8AaAuhw0q3RLaPNUpMSNtabXqIycvV1hWX4VL
         Z19A==
X-Gm-Message-State: AHQUAuaGmjqtqXAgZuDHs5yUBe52qv3e02GcFQdtavXAzTBcaJEi9+KF
        rPbQVI11kbxdzBnyT9h0SOY=
X-Google-Smtp-Source: AHgI3IazXwuDqTmlaPB+165w9Jelia/AJS/1GvzTX1UwflXCqrqWQYpHsKY9EfCO3doE1od3peWYcg==
X-Received: by 2002:a5d:548f:: with SMTP id h15mr4157477wrv.238.1550176972719;
        Thu, 14 Feb 2019 12:42:52 -0800 (PST)
Received: from jernej-laptop.localnet (cpe1-6-175.cable.triera.net. [213.161.6.175])
        by smtp.gmail.com with ESMTPSA id c9sm3063410wrs.84.2019.02.14.12.42.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Feb 2019 12:42:51 -0800 (PST)
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
Subject: Re: [PATCH v3 2/2] media: cedrus: Add H264 decoding support
Date:   Thu, 14 Feb 2019 21:42:49 +0100
Message-ID: <21530997.5t1HIVrtlz@jernej-laptop>
In-Reply-To: <4c00e1ab1e70adb1d94db59c37393250ca3791c5.1549895062.git-series.maxime.ripard@bootlin.com>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com> <4c00e1ab1e70adb1d94db59c37393250ca3791c5.1549895062.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne ponedeljek, 11. februar 2019 ob 15:39:03 CET je Maxime Ripard napisal(a):
> Introduce some basic H264 decoding support in cedrus. So far, only the
> baseline profile videos have been tested, and some more advanced features
> used in higher profiles are not even implemented.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/staging/media/sunxi/cedrus/Makefile       |   3 +-
>  drivers/staging/media/sunxi/cedrus/cedrus.c       |  31 +-
>  drivers/staging/media/sunxi/cedrus/cedrus.h       |  38 +-
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c   |  15 +-
>  drivers/staging/media/sunxi/cedrus/cedrus_h264.c  | 589 +++++++++++++++-
>  drivers/staging/media/sunxi/cedrus/cedrus_hw.c    |   4 +-
>  drivers/staging/media/sunxi/cedrus/cedrus_regs.h  |  91 ++-
>  drivers/staging/media/sunxi/cedrus/cedrus_video.c |   9 +-
>  8 files changed, 778 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_h264.c
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/Makefile
> b/drivers/staging/media/sunxi/cedrus/Makefile index
> e9dc68b7bcb6..aaf141fc58b6 100644
> --- a/drivers/staging/media/sunxi/cedrus/Makefile
> +++ b/drivers/staging/media/sunxi/cedrus/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi-cedrus.o
> 
> -sunxi-cedrus-y = cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o
> cedrus_mpeg2.o +sunxi-cedrus-y = cedrus.o cedrus_video.o cedrus_hw.o
> cedrus_dec.o \ +		 cedrus_mpeg2.o cedrus_h264.o
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c
> b/drivers/staging/media/sunxi/cedrus/cedrus.c index
> ff11cbeba205..b275607b8111 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> @@ -40,6 +40,36 @@ static const struct cedrus_control cedrus_controls[] = {
>  		.codec		= CEDRUS_CODEC_MPEG2,
>  		.required	= false,
>  	},
> +	{
> +		.id		= 
V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS,
> +		.elem_size	= sizeof(struct 
v4l2_ctrl_h264_decode_param),
> +		.codec		= CEDRUS_CODEC_H264,
> +		.required	= true,
> +	},
> +	{
> +		.id		= 
V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS,
> +		.elem_size	= sizeof(struct v4l2_ctrl_h264_slice_param),
> +		.codec		= CEDRUS_CODEC_H264,
> +		.required	= true,
> +	},
> +	{
> +		.id		= V4L2_CID_MPEG_VIDEO_H264_SPS,
> +		.elem_size	= sizeof(struct v4l2_ctrl_h264_sps),
> +		.codec		= CEDRUS_CODEC_H264,
> +		.required	= true,
> +	},
> +	{
> +		.id		= V4L2_CID_MPEG_VIDEO_H264_PPS,
> +		.elem_size	= sizeof(struct v4l2_ctrl_h264_pps),
> +		.codec		= CEDRUS_CODEC_H264,
> +		.required	= true,
> +	},
> +	{
> +		.id		= 
V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX,
> +		.elem_size	= sizeof(struct 
v4l2_ctrl_h264_scaling_matrix),
> +		.codec		= CEDRUS_CODEC_H264,
> +		.required	= true,
> +	},
>  };
> 
>  #define CEDRUS_CONTROLS_COUNT	ARRAY_SIZE(cedrus_controls)
> @@ -278,6 +308,7 @@ static int cedrus_probe(struct platform_device *pdev)
>  	}
> 
>  	dev->dec_ops[CEDRUS_CODEC_MPEG2] = &cedrus_dec_ops_mpeg2;
> +	dev->dec_ops[CEDRUS_CODEC_H264] = &cedrus_dec_ops_h264;
> 
>  	mutex_init(&dev->dev_mutex);
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h
> b/drivers/staging/media/sunxi/cedrus/cedrus.h index
> 4aedd24a9848..8c64f9a27e9d 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus.h
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
> @@ -30,7 +30,7 @@
> 
>  enum cedrus_codec {
>  	CEDRUS_CODEC_MPEG2,
> -
> +	CEDRUS_CODEC_H264,
>  	CEDRUS_CODEC_LAST,
>  };
> 
> @@ -40,6 +40,12 @@ enum cedrus_irq_status {
>  	CEDRUS_IRQ_OK,
>  };
> 
> +enum cedrus_h264_pic_type {
> +	CEDRUS_H264_PIC_TYPE_FRAME	= 0,
> +	CEDRUS_H264_PIC_TYPE_FIELD,
> +	CEDRUS_H264_PIC_TYPE_MBAFF,
> +};
> +
>  struct cedrus_control {
>  	u32			id;
>  	u32			elem_size;
> @@ -47,6 +53,14 @@ struct cedrus_control {
>  	unsigned char		required:1;
>  };
> 
> +struct cedrus_h264_run {
> +	const struct v4l2_ctrl_h264_decode_param	*decode_param;
> +	const struct v4l2_ctrl_h264_pps			*pps;
> +	const struct v4l2_ctrl_h264_scaling_matrix	*scaling_matrix;
> +	const struct v4l2_ctrl_h264_slice_param		*slice_param;
> +	const struct v4l2_ctrl_h264_sps			*sps;
> +};
> +
>  struct cedrus_mpeg2_run {
>  	const struct v4l2_ctrl_mpeg2_slice_params	*slice_params;
>  	const struct v4l2_ctrl_mpeg2_quantization	*quantization;
> @@ -57,12 +71,20 @@ struct cedrus_run {
>  	struct vb2_v4l2_buffer	*dst;
> 
>  	union {
> +		struct cedrus_h264_run	h264;
>  		struct cedrus_mpeg2_run	mpeg2;
>  	};
>  };
> 
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
> 
>  struct cedrus_ctx {
> @@ -77,6 +99,19 @@ struct cedrus_ctx {
>  	struct v4l2_ctrl		**ctrls;
> 
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
> +			void		*neighbor_info_buf;
> +			dma_addr_t	neighbor_info_buf_dma;
> +		} h264;
> +	} codec;
>  };
> 
>  struct cedrus_dec_ops {
> @@ -118,6 +153,7 @@ struct cedrus_dev {
>  };
> 
>  extern struct cedrus_dec_ops cedrus_dec_ops_mpeg2;
> +extern struct cedrus_dec_ops cedrus_dec_ops_h264;
> 
>  static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 val)
>  {
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c index
> 443fb037e1cf..4c33e3b1283f 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -46,6 +46,21 @@ void cedrus_device_run(void *priv)
>  			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
>  		break;
> 
> +	case V4L2_PIX_FMT_H264_SLICE:
> +		run.h264.decode_param = cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS);
> +		run.h264.pps = cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_PPS);
> +		run.h264.scaling_matrix = cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX);
> +		run.h264.slice_param = cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS);
> +		run.h264.scaling_matrix = cedrus_find_control_data(ctx,
> +			V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX);

You already assigned scaling_matrix few lines above.

Best regards,
Jernej



