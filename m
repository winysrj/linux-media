Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59054 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3ABS3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 13:29:16 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG000L09GOIFO10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 18:29:14 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG0005AWGOIBS20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 18:29:14 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sylvester.nawrocki@gmail.com, patches@linaro.org
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
 <1356689908-6866-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1356689908-6866-2-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 2/3] [media] s5p-mfc: Remove redundant 'break'
Date: Wed, 02 Jan 2013 19:29:04 +0100
Message-id: <007301cde917$0c97b180$25c71480$%debski@samsung.com>
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

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sachin Kamat
> Sent: Friday, December 28, 2012 11:18 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
> sylvester.nawrocki@gmail.com; sachin.kamat@linaro.org;
> patches@linaro.org
> Subject: [PATCH 2/3] [media] s5p-mfc: Remove redundant 'break'
> 
> The code returns before this statement. Hence not required.
> Silences the following smatch message:
> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:525
> s5p_mfc_set_dec_frame_buffer_v5() info: ignoring unreachable code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> index bb99d3d..b0f277e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> @@ -522,7 +522,6 @@ int s5p_mfc_set_dec_frame_buffer_v5(struct
> s5p_mfc_ctx *ctx)
>  		mfc_err("Unknown codec for decoding (%x)\n",
>  			ctx->codec_mode);
>  		return -EINVAL;
> -		break;
>  	}
>  	frame_size = ctx->luma_size;
>  	frame_size_ch = ctx->chroma_size;
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


