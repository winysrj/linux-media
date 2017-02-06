Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:51732 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdBFI5B (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 03:57:01 -0500
Subject: Re: [PATCH 05/11] [media] s5p-mfc: Add support for HEVC decoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-reply-to: <0b8c3503-ea16-99dc-d2be-85c122eac564@samsung.com>
Content-type: text/plain; charset=UTF-8
Date: Mon, 06 Feb 2017 14:09:47 +0530
Message-id: <1486370387.16927.80.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100737epcas1p269ede3c99e71ce55b934945cd20181e1@epcas1p2.samsung.com>
 <1484733729-25371-6-git-send-email-smitha.t@samsung.com>
 <0b8c3503-ea16-99dc-d2be-85c122eac564@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-02-02 at 08:58 +0100, Andrzej Hajda wrote: 
> On 18.01.2017 11:02, Smitha T Murthy wrote:
> > Add support for codec definition and corresponding buffer
> > requirements for HEVC decoder.
> >
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > ---
> >  drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |    3 +++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |    3 +++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    8 ++++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   18 ++++++++++++++++--
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    5 +++++
> >  6 files changed, 36 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > index 153ee68..a57009a 100644
> > --- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > @@ -32,6 +32,9 @@
> >  #define MFC_VERSION_V10		0xA0
> >  #define MFC_NUM_PORTS_V10	1
> >  
> > +/* MFCv10 codec defines*/
> > +#define S5P_FIMV_CODEC_HEVC_DEC		17
> > +
> >  /* Encoder buffer size for MFC v10.0 */
> >  #define ENC_V100_H264_ME_SIZE(x, y)	\
> >  	(((x + 3) * (y + 3) * 8)	\
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > index b1b1491..76eca67 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > @@ -101,6 +101,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
> >  	case S5P_MFC_CODEC_VP8_DEC:
> >  		codec_type = S5P_FIMV_CODEC_VP8_DEC_V6;
> >  		break;
> > +	case S5P_MFC_CODEC_HEVC_DEC:
> > +		codec_type = S5P_FIMV_CODEC_HEVC_DEC;
> > +		break;
> >  	case S5P_MFC_CODEC_H264_ENC:
> >  		codec_type = S5P_FIMV_CODEC_H264_ENC_V6;
> >  		break;
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > index 998e24b..5c46060 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > @@ -79,6 +79,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
> >  #define S5P_MFC_CODEC_H263_DEC		5
> >  #define S5P_MFC_CODEC_VC1RCV_DEC	6
> >  #define S5P_MFC_CODEC_VP8_DEC		7
> > +#define S5P_MFC_CODEC_HEVC_DEC		17
> >  
> >  #define S5P_MFC_CODEC_H264_ENC		20
> >  #define S5P_MFC_CODEC_H264_MVC_ENC	21
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > index 784b28e..9f459b3 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > @@ -156,6 +156,14 @@
> >  		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT |
> >  								MFC_V10_BIT,
> >  	},
> > +	{
> > +		.name		= "HEVC Encoded Stream",
> > +		.fourcc		= V4L2_PIX_FMT_HEVC,
> > +		.codec_mode	= S5P_FIMV_CODEC_HEVC_DEC,
> > +		.type		= MFC_FMT_DEC,
> > +		.num_planes	= 1,
> > +		.versions	= MFC_V10_BIT,
> > +	},
> >  };
> >  
> >  #define NUM_FORMATS ARRAY_SIZE(formats)
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> > index 369210a..b6cb280 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> > @@ -220,6 +220,13 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
> >  				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
> >  		ctx->bank1.size = ctx->scratch_buf_size;
> >  		break;
> > +	case S5P_MFC_CODEC_HEVC_DEC:
> > +		mfc_debug(2, "Use min scratch buffer size\n");
> > +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> 
> Again alignment of something which should be already aligned, and magic
> number instead of S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6.
> 
Yes if we are using the scratch buffer given by the firmware we need not
align. I will change it in the next version.

> > +		ctx->bank1.size =
> > +			ctx->scratch_buf_size +
> > +			(ctx->mv_count * ctx->mv_size);
> > +		break;
> >  	case S5P_MFC_CODEC_H264_ENC:
> >  		if (IS_MFCV10(dev)) {
> >  			mfc_debug(2, "Use min scratch buffer size\n");
> > @@ -322,6 +329,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
> >  	switch (ctx->codec_mode) {
> >  	case S5P_MFC_CODEC_H264_DEC:
> >  	case S5P_MFC_CODEC_H264_MVC_DEC:
> > +	case S5P_MFC_CODEC_HEVC_DEC:
> >  		ctx->ctx.size = buf_size->h264_dec_ctx;
> >  		break;
> >  	case S5P_MFC_CODEC_MPEG4_DEC:
> > @@ -438,6 +446,10 @@ static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
> >  					ctx->img_height);
> >  			ctx->mv_size = ALIGN(ctx->mv_size, 16);
> >  		}
> > +	} else if (ctx->codec_mode == S5P_MFC_CODEC_HEVC_DEC) {
> > +		ctx->mv_size = s5p_mfc_dec_hevc_mv_size(ctx->img_width,
> > +				ctx->img_height);
> > +		ctx->mv_size = ALIGN(ctx->mv_size, 32);
> 
> Again, unnecessary alignment, result of s5p_mfc_dec_hevc_mv_size is
> already aligned to 256.

#define s5p_mfc_dec_hevc_mv_size(x, y)   (dec_lcu_width(x) *
dec_lcu_height(y) * 256 + 512) is for calculation of the size of mv
buffer as given in the user manual. User Manual also mentions it needs
multiple of 32 alignment so added ctx->mv_size = ALIGN(ctx->mv_size,
32). Since it was already done for H264 codec in the same way,
ctx->mv_size = ALIGN(ctx->mv_size, 16) after size calculation through
#define S5P_MFC_DEC_MV_SIZE_V6(x, y)    (MB_WIDTH(x) * \
(((MB_HEIGHT(y)+1)/2)*2) * 64 + 128) I followed the same for HEVC mv
buffers too.

> 
> >  	} else {
> >  		ctx->mv_size = 0;
> >  	}
> > @@ -526,7 +538,8 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
> >  	buf_size1 -= ctx->scratch_buf_size;
> >  
> >  	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
> > -			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC){
> > +			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC ||
> > +			ctx->codec_mode == S5P_FIMV_CODEC_HEVC_DEC) {
> >  		writel(ctx->mv_size, mfc_regs->d_mv_buffer_size);
> >  		writel(ctx->mv_count, mfc_regs->d_num_mv);
> >  	}
> > @@ -549,7 +562,8 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
> >  				mfc_regs->d_second_plane_dpb + i * 4);
> >  	}
> >  	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
> > -			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
> > +			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC ||
> > +			ctx->codec_mode == S5P_MFC_CODEC_HEVC_DEC) {
> >  		for (i = 0; i < ctx->mv_count; i++) {
> >  			/* To test alignment */
> >  			align_gap = buf_addr1;
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
> > index 2b5a9f4..2e404d8 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
> > @@ -29,6 +29,11 @@
> >  #define enc_lcu_width(x_size)          ((x_size + 31) / 32)
> >  #define enc_lcu_height(y_size)         ((y_size + 31) / 32)
> >  
> > +#define dec_lcu_width(x_size)		((x_size + 63) / 64)
> 
> It could be replaced with:
> 
> +#define dec_lcu_width(x_size) ALIGN(x_size, 64)
> 
> 
> > +#define dec_lcu_height(y_size)		((y_size + 63) / 64)
> 
> The same here.
> > +#define s5p_mfc_dec_hevc_mv_size(x, y) \
> > +	(dec_lcu_width(x) * dec_lcu_height(y) * 256 + 512)
> > +
> 
> If dec_lcu_(width|height) are not used anywhere else, you can just
> squash them here:
> 
Yes dec_lcu_(width|height) is not used anywhere else, will squash it.

> #define s5p_mfc_dec_hevc_mv_size(x, y) (ALIGN(x, 64) * ALIGN(y, 64) * 256 + 512)
> 
> And if there is only one use of this macro, maybe it would be good to
> just hardcode it there.
> 
> Regards
> Andrzej
> 
I defined the macro s5p_mfc_dec_hevc_mv_size(x, y) in this file because
the same was done for another macro S5P_MFC_DEC_MV_SIZE_V6(x, y) which
is also used only once.

Thank you for the review.
Regards,
Smitha 
> 
> >  /* Definition */
> >  #define ENC_MULTI_SLICE_MB_MAX		((1 << 30) - 1)
> >  #define ENC_MULTI_SLICE_BIT_MIN		2800
> 
> 
> 




