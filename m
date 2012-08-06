Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11508 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2HFNUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 09:20:13 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8C00CUY52EQO60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Aug 2012 14:20:38 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8C00NOJ51L5880@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Aug 2012 14:20:12 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
 <1343046557-25353-5-git-send-email-arun.kk@samsung.com>
In-reply-to: <1343046557-25353-5-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v3 4/4] [media] s5p-mfc: New files for MFCv6 support
Date: Mon, 06 Aug 2012 15:20:11 +0200
Message-id: <00f101cd73d6$352e8850$9f8b98f0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find my comments below.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 23 July 2012 14:29
> 
> From: Jeongtae Park <jtp.park@samsung.com>
> 
> New register definitions, commands and hardware operations
> file for MFCv6 support.
> 
> Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> Singed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
> Singed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  392 ++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  155 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h |   22 +
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1921
++++++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
>  5 files changed, 2540 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
> 

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
> new file mode 100644
> index 0000000..86c8645
> --- /dev/null
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -0,0 +1,1921 @@

[snip]

> +
> +/* Allocate codec buffers */
> +int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
> +{
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +	unsigned int mb_width, mb_height;
> +
> +	mb_width = mb_width(ctx->img_width);
> +	mb_height = mb_height(ctx->img_height);
> +
> +	if (ctx->type == MFCINST_DECODER) {
> +		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
> +			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
> +		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
> +	} else if (ctx->type == MFCINST_ENCODER) {
> +		ctx->tmv_buffer_size = 2 * ALIGN((mb_width + 1) *
> +				(mb_height + 1) * 8, 16);
> +		ctx->luma_dpb_size = ALIGN((mb_width * mb_height) * 256, 256);
> +		ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) * 128,
256);
> +		ctx->me_buffer_size = ALIGN(((((ctx->img_width+63)/64) * 16) *
> +			(((ctx->img_height+63)/64) * 16)) +
> +			 ((((mb_width*mb_height)+31)/32) * 16), 256);

Let's stop right here. There are too many magic numbers, all of them
need a nice #define name.

> +
> +		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
> +			  ctx->luma_dpb_size, ctx->chroma_dpb_size);
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	/* Codecs have different memory requirements */
> +	switch (ctx->codec_mode) {
> +	case S5P_MFC_CODEC_H264_DEC:
> +	case S5P_MFC_CODEC_H264_MVC_DEC:
> +		ctx->scratch_buf_size = (mb_width * 192) + 64;
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size =
> +			ctx->scratch_buf_size +
> +			(ctx->mv_count * ctx->mv_size);
> +		break;
> +	case S5P_MFC_CODEC_MPEG4_DEC:
> +		/* mb_width * (mb_height * 64 + 144) + 8192 * mb_height +
> +		 * 41088 */
> +		ctx->scratch_buf_size = mb_width * (mb_height * 64 + 144) +
> +			((2048 + 15)/16 * mb_height * 64) +
> +			((2048 + 15)/16 * 256 + 8320);
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size = ctx->scratch_buf_size;
> +		break;
> +	case S5P_MFC_CODEC_VC1RCV_DEC:
> +	case S5P_MFC_CODEC_VC1_DEC:
> +		ctx->scratch_buf_size = 2096 * (mb_width + mb_height + 1);
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size = ctx->scratch_buf_size;
> +		break;
> +	case S5P_MFC_CODEC_MPEG2_DEC:
> +		ctx->bank1_size = 0;
> +		ctx->bank2_size = 0;
> +		break;
> +	case S5P_MFC_CODEC_H263_DEC:
> +		ctx->scratch_buf_size = mb_width * 400;
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size = ctx->scratch_buf_size;
> +		break;
> +	case S5P_MFC_CODEC_VP8_DEC:
> +		ctx->scratch_buf_size = mb_width * 32 + mb_height * 128 +
34816;
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size = ctx->scratch_buf_size;
> +		break;
> +	case S5P_MFC_CODEC_H264_ENC:
> +		ctx->scratch_buf_size = (mb_width * 64) +
> +			((mb_width + 1) * 16) + (4096 * 16);
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size =
> +			ctx->scratch_buf_size + ctx->tmv_buffer_size +
> +			(ctx->dpb_count * (ctx->luma_dpb_size +
> +			ctx->chroma_dpb_size + ctx->me_buffer_size));
> +		ctx->bank2_size = 0;
> +		break;
> +	case S5P_MFC_CODEC_MPEG4_ENC:
> +	case S5P_MFC_CODEC_H263_ENC:
> +		ctx->scratch_buf_size = (mb_width * 16) + ((mb_width + 1) *
16);
> +		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
> +		ctx->bank1_size =
> +			ctx->scratch_buf_size + ctx->tmv_buffer_size +
> +			(ctx->dpb_count * (ctx->luma_dpb_size +
> +			ctx->chroma_dpb_size + ctx->me_buffer_size));
> +		ctx->bank2_size = 0;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* Allocate only if memory from bank 1 is necessary */
> +	if (ctx->bank1_size > 0) {
> +		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
> +		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
> +		if (IS_ERR(ctx->bank1_buf)) {
> +			ctx->bank1_buf = 0;
> +			pr_err("Buf alloc for decoding failed (port A)\n");
> +			return -ENOMEM;
> +		}
> +		ctx->bank1_phys = s5p_mfc_mem_cookie(
> +			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
> +		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> +	}
> +
> +	return 0;
> +}
> +

[snip]

> +
> +static int calc_plane(int width, int height)
> +{
> +	int mbX, mbY;
> +
> +	mbX = (width + 15)/16;
> +	mbY = (height + 15)/16;
> +
> +	if (width * height < 2048 * 1024)
> +		mbY = (mbY + 1) / 2 * 2;
> +
> +	return (mbX * 16) * (mbY * 16);
> +}

The magic numbers above should be defined in the headers file and
have readable and descriptive names.

[snip]

> +/* Decode a single frame */
> +int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
> +			enum s5p_mfc_decode_arg last_frame)
> +{
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +
> +	WRITEL(0xffffffff, S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V6);
> +	WRITEL(0xffffffff, S5P_FIMV_D_AVAILABLE_DPB_FLAG_UPPER_V6);

This cannot be done this way. Come on, the system of marking which buffer
is queued by the application is already in place (look at the
s5p_mfc_opr_v5.c file). If all buffers are marked accessible to MFC hardware
then there is no guarantee that buffers dequeued and used by user space
are not overwritten.

> +	WRITEL(ctx->slice_interface & 0x1, S5P_FIMV_D_SLICE_IF_ENABLE_V6);
> +
> +	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
> +	/* Issue different commands to instance basing on whether it
> +	 * is the last frame or not. */
> +	switch (last_frame) {
> +	case 0:
> +		s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_FRAME_START_V6, NULL);
> +		break;
> +	case 1:
> +		s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_LAST_FRAME_V6, NULL);
> +		break;
> +	default:
> +		mfc_err("Unsupported last frame arg.\n");
> +		return -EINVAL;
> +	}
> +
> +	mfc_debug(2, "Decoding a usual frame.\n");
> +	return 0;
> +}
> +

[snip]

