Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42475 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbdBBIjR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 03:39:17 -0500
Subject: Re: [PATCH 08/11] [media] s5p-mfc: Add VP9 decoder support
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <0b2fc4bf-347e-f4d3-1004-d5816fb32cfa@samsung.com>
Date: Thu, 02 Feb 2017 09:39:10 +0100
MIME-version: 1.0
In-reply-to: <1484733729-25371-9-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100756epcas1p2c8a93b383a4c85648b5e9efac8cea9c7@epcas1p2.samsung.com>
 <1484733729-25371-9-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.01.2017 11:02, Smitha T Murthy wrote:
> Add support for codec definition and corresponding buffer
> requirements for VP9 decoder.
>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |    6 +++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |    3 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    8 ++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    2 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   28 +++++++++++++++++++++++
>  6 files changed, 48 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> index a57009a..81a0a96 100644
> --- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> @@ -18,6 +18,8 @@
>  /* MFCv10 register definitions*/
>  #define S5P_FIMV_MFC_CLOCK_OFF_V10			0x7120
>  #define S5P_FIMV_MFC_STATE_V10				0x7124
> +#define S5P_FIMV_D_STATIC_BUFFER_ADDR_V10		0xF570
> +#define S5P_FIMV_D_STATIC_BUFFER_SIZE_V10		0xF574
>  
>  /* MFCv10 Context buffer sizes */
>  #define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)	/* 30KB */
> @@ -34,6 +36,10 @@
>  
>  /* MFCv10 codec defines*/
>  #define S5P_FIMV_CODEC_HEVC_DEC		17
> +#define S5P_FIMV_CODEC_VP9_DEC		18
> +
> +/* Decoder buffer size for MFC v10 */
> +#define DEC_VP9_STATIC_BUFFER_SIZE	20480
>  
>  /* Encoder buffer size for MFC v10.0 */
>  #define ENC_V100_H264_ME_SIZE(x, y)	\
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> index 76eca67..102b47e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> @@ -104,6 +104,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
>  	case S5P_MFC_CODEC_HEVC_DEC:
>  		codec_type = S5P_FIMV_CODEC_HEVC_DEC;
>  		break;
> +	case S5P_MFC_CODEC_VP9_DEC:
> +		codec_type = S5P_FIMV_CODEC_VP9_DEC;
> +		break;
>  	case S5P_MFC_CODEC_H264_ENC:
>  		codec_type = S5P_FIMV_CODEC_H264_ENC_V6;
>  		break;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 5c46060..e720ce6 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -80,6 +80,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
>  #define S5P_MFC_CODEC_VC1RCV_DEC	6
>  #define S5P_MFC_CODEC_VP8_DEC		7
>  #define S5P_MFC_CODEC_HEVC_DEC		17
> +#define S5P_MFC_CODEC_VP9_DEC		18
>  
>  #define S5P_MFC_CODEC_H264_ENC		20
>  #define S5P_MFC_CODEC_H264_MVC_ENC	21
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 9f459b3..93626ed 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -164,6 +164,14 @@
>  		.num_planes	= 1,
>  		.versions	= MFC_V10_BIT,
>  	},
> +	{
> +		.name		= "VP9 Encoded Stream",
> +		.fourcc		= V4L2_PIX_FMT_VP9,
> +		.codec_mode	= S5P_FIMV_CODEC_VP9_DEC,
> +		.type		= MFC_FMT_DEC,
> +		.num_planes	= 1,
> +		.versions	= MFC_V10_BIT,
> +	},
>  };
>  
>  #define NUM_FORMATS ARRAY_SIZE(formats)
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> index 6478f70..565decf 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
> @@ -170,6 +170,8 @@ struct s5p_mfc_regs {
>  	void __iomem *d_used_dpb_flag_upper;/* v7 and v8 */
>  	void __iomem *d_used_dpb_flag_lower;/* v7 and v8 */
>  	void __iomem *d_min_scratch_buffer_size; /* v10 */
> +	void __iomem *d_static_buffer_addr; /* v10 */
> +	void __iomem *d_static_buffer_size; /* v10 */
>  
>  	/* encoder registers */
>  	void __iomem *e_frame_width;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index b6cb280..da4202f 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -227,6 +227,13 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
>  			ctx->scratch_buf_size +
>  			(ctx->mv_count * ctx->mv_size);
>  		break;
> +	case S5P_MFC_CODEC_VP9_DEC:
> +		mfc_debug(2, "Use min scratch buffer size\n");
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);

Again ALIGN and magic number.

Beside this:
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>


> +		ctx->bank1.size =
> +			ctx->scratch_buf_size +
> +			DEC_VP9_STATIC_BUFFER_SIZE;
> +		break;
>  	case S5P_MFC_CODEC_H264_ENC:
>  		if (IS_MFCV10(dev)) {
>  			mfc_debug(2, "Use min scratch buffer size\n");
> @@ -338,6 +345,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
>  	case S5P_MFC_CODEC_VC1_DEC:
>  	case S5P_MFC_CODEC_MPEG2_DEC:
>  	case S5P_MFC_CODEC_VP8_DEC:
> +	case S5P_MFC_CODEC_VP9_DEC:
>  		ctx->ctx.size = buf_size->other_dec_ctx;
>  		break;
>  	case S5P_MFC_CODEC_H264_ENC:
> @@ -579,6 +587,14 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
>  		}
>  	}
>  
> +	if (ctx->codec_mode == S5P_FIMV_CODEC_VP9_DEC) {
> +		writel(buf_addr1, mfc_regs->d_static_buffer_addr);
> +		writel(DEC_VP9_STATIC_BUFFER_SIZE,
> +				mfc_regs->d_static_buffer_size);
> +		buf_addr1 += DEC_VP9_STATIC_BUFFER_SIZE;
> +		buf_size1 -= DEC_VP9_STATIC_BUFFER_SIZE;
> +	}
> +
>  	mfc_debug(2, "Buf1: %zu, buf_size1: %d (frames %d)\n",
>  			buf_addr1, buf_size1, ctx->total_dpb_count);
>  	if (buf_size1 < 0) {
> @@ -2286,6 +2302,18 @@ static unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
>  	R(e_h264_options, S5P_FIMV_E_H264_OPTIONS_V8);
>  	R(e_min_scratch_buffer_size, S5P_FIMV_E_MIN_SCRATCH_BUFFER_SIZE_V8);
>  
> +	if (!IS_MFCV10(dev))
> +		goto done;
> +
> +	/* Initialize registers used in MFC v10 only.
> +	 * Also, over-write the registers which have
> +	 * a different offset for MFC v10.
> +	 */
> +
> +	/* decoder registers */
> +	R(d_static_buffer_addr, S5P_FIMV_D_STATIC_BUFFER_ADDR_V10);
> +	R(d_static_buffer_size, S5P_FIMV_D_STATIC_BUFFER_SIZE_V10);
> +
>  done:
>  	return &mfc_regs;
>  #undef S5P_MFC_REG_ADDR


