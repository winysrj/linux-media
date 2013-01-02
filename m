Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59075 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3ABSa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 13:30:26 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG000I8RGQPZ700@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 18:30:25 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MG0007D2GQK4G10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 18:30:24 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sylvester.nawrocki@gmail.com, patches@linaro.org
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/3] [media] s5p-mfc: use mfc_err instead of printk
Date: Wed, 02 Jan 2013 19:30:19 +0100
Message-id: <007401cde917$38c58200$aa508600$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for your patch.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sachin Kamat
> Sent: Friday, December 28, 2012 11:18 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
> sylvester.nawrocki@gmail.com; sachin.kamat@linaro.org;
> patches@linaro.org
> Subject: [PATCH 1/3] [media] s5p-mfc: use mfc_err instead of printk
> 
> Use mfc_err for consistency. Also silences checkpatch warning.
> 

Acked-by: Kamil Debski <k.debski@samsung.com>

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> index bf7d010..bb99d3d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> @@ -187,8 +187,7 @@ int s5p_mfc_alloc_codec_buffers_v5(struct
> s5p_mfc_ctx *ctx)
>  		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
>  		if (IS_ERR(ctx->bank1_buf)) {
>  			ctx->bank1_buf = NULL;
> -			printk(KERN_ERR
> -			       "Buf alloc for decoding failed (port A)\n");
> +			mfc_err("Buf alloc for decoding failed (port A)\n");
>  			return -ENOMEM;
>  		}
>  		ctx->bank1_phys = s5p_mfc_mem_cookie(
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


