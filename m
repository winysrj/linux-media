Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20960 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdAROyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 09:54:25 -0500
Subject: Re: [PATCH 01/11] [media] s5p-mfc: Rename IS_MFCV8 macro
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <35fef778-fa21-5f40-d399-96acd64c8511@samsung.com>
Date: Wed, 18 Jan 2017 15:51:59 +0100
MIME-version: 1.0
In-reply-to: <1484733729-25371-2-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100718epcas5p1f9aebb16fc61d41a13d09054fa96a14d@epcas5p1.samsung.com>
 <1484733729-25371-2-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.01.2017 11:01, Smitha T Murthy wrote:
> This patch renames macro IS_MFCV8 to IS_MFCV8_PLUS so that the MFCv8
> code can be resued for MFCv10.10 support. Since the MFCv8 specific code
> holds good for MFC v10.10 also.
>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>

Acked-by: Andrzej Hajda <a.hajda@samsung.com>
--
Regards
Andrzej

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   18 +++++++++---------
>  4 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index ab23236..b45d18c 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -722,7 +722,7 @@ struct mfc_control {
>  #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
>  #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
>  #define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
> -#define IS_MFCV8(dev)		(dev->variant->version >= 0x80 ? 1 : 0)
> +#define IS_MFCV8_PLUS(dev)	(dev->variant->version >= 0x80 ? 1 : 0)
>  
>  #define MFC_V5_BIT	BIT(0)
>  #define MFC_V6_BIT	BIT(1)
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index cc88871..484af6b 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -427,7 +427,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
>  	s5p_mfc_clear_cmds(dev);
>  	s5p_mfc_clean_dev_int_flags(dev);
>  	/* 3. Send MFC wakeup command and wait for completion*/
> -	if (IS_MFCV8(dev))
> +	if (IS_MFCV8_PLUS(dev))
>  		ret = s5p_mfc_v8_wait_wakeup(dev);
>  	else
>  		ret = s5p_mfc_wait_wakeup(dev);
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 367ef8e..0ec2928 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -1177,7 +1177,7 @@ void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
>  	struct v4l2_format f;
>  	f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_H264;
>  	ctx->src_fmt = find_format(&f, MFC_FMT_DEC);
> -	if (IS_MFCV8(ctx->dev))
> +	if (IS_MFCV8_PLUS(ctx->dev))
>  		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12M;
>  	else if (IS_MFCV6_PLUS(ctx->dev))
>  		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT_16X16;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index 57da798..0572521 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -74,7 +74,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
>  		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
>  	} else if (ctx->type == MFCINST_ENCODER) {
> -		if (IS_MFCV8(dev))
> +		if (IS_MFCV8_PLUS(dev))
>  			ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
>  			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V8(mb_width, mb_height),
>  			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
> @@ -89,7 +89,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  		ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) *
>  				S5P_FIMV_CHROMA_MB_TO_PIXEL_V6,
>  				S5P_FIMV_CHROMA_DPB_BUFFER_ALIGN_V6);
> -		if (IS_MFCV8(dev))
> +		if (IS_MFCV8_PLUS(dev))
>  			ctx->me_buffer_size = ALIGN(S5P_FIMV_ME_BUFFER_SIZE_V8(
>  						ctx->img_width, ctx->img_height,
>  						mb_width, mb_height),
> @@ -110,7 +110,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  	switch (ctx->codec_mode) {
>  	case S5P_MFC_CODEC_H264_DEC:
>  	case S5P_MFC_CODEC_H264_MVC_DEC:
> -		if (IS_MFCV8(dev))
> +		if (IS_MFCV8_PLUS(dev))
>  			ctx->scratch_buf_size =
>  				S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V8(
>  					mb_width,
> @@ -167,7 +167,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  		ctx->bank1.size = ctx->scratch_buf_size;
>  		break;
>  	case S5P_MFC_CODEC_VP8_DEC:
> -		if (IS_MFCV8(dev))
> +		if (IS_MFCV8_PLUS(dev))
>  			ctx->scratch_buf_size =
>  				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V8(
>  						mb_width,
> @@ -182,7 +182,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  		ctx->bank1.size = ctx->scratch_buf_size;
>  		break;
>  	case S5P_MFC_CODEC_H264_ENC:
> -		if (IS_MFCV8(dev))
> +		if (IS_MFCV8_PLUS(dev))
>  			ctx->scratch_buf_size =
>  				S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V8(
>  					mb_width,
> @@ -215,7 +215,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  		ctx->bank2.size = 0;
>  		break;
>  	case S5P_MFC_CODEC_VP8_ENC:
> -		if (IS_MFCV8(dev))
> +		if (IS_MFCV8_PLUS(dev))
>  			ctx->scratch_buf_size =
>  				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V8(
>  					mb_width,
> @@ -366,7 +366,7 @@ static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
>  
>  	ctx->luma_size = calc_plane(ctx->img_width, ctx->img_height);
>  	ctx->chroma_size = calc_plane(ctx->img_width, (ctx->img_height >> 1));
> -	if (IS_MFCV8(ctx->dev)) {
> +	if (IS_MFCV8_PLUS(ctx->dev)) {
>  		/* MFCv8 needs additional 64 bytes for luma,chroma dpb*/
>  		ctx->luma_size += S5P_FIMV_D_ALIGN_PLANE_SIZE_V8;
>  		ctx->chroma_size += S5P_FIMV_D_ALIGN_PLANE_SIZE_V8;
> @@ -454,7 +454,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
>  	writel(buf_addr1, mfc_regs->d_scratch_buffer_addr);
>  	writel(ctx->scratch_buf_size, mfc_regs->d_scratch_buffer_size);
>  
> -	if (IS_MFCV8(dev)) {
> +	if (IS_MFCV8_PLUS(dev)) {
>  		writel(ctx->img_width,
>  			mfc_regs->d_first_plane_dpb_stride_size);
>  		writel(ctx->img_width,
> @@ -2120,7 +2120,7 @@ static unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
>  			S5P_FIMV_E_ENCODED_SOURCE_SECOND_ADDR_V7);
>  	R(e_vp8_options, S5P_FIMV_E_VP8_OPTIONS_V7);
>  
> -	if (!IS_MFCV8(dev))
> +	if (!IS_MFCV8_PLUS(dev))
>  		goto done;
>  
>  	/* Initialize registers used in MFC v8 only.


