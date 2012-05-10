Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48844 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab2EJIzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:55:52 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M3S0098SU4X7XS0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:55:51 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M3S00HZMU4ZXB10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:55:51 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, kyungmin.park@samsung.com,
	patches@linaro.org
References: <1336631521-24820-1-git-send-email-sachin.kamat@linaro.org>
 <1336631521-24820-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1336631521-24820-2-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 2/2] [media] s5p-mfc: Add missing static storage class to
 silence warnings
Date: Thu, 10 May 2012 10:55:46 +0200
Message-id: <017201cd2e8a$b2efd8c0$18cf8a40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 10 May 2012 08:32
> To: linux-media@vger.kernel.org
> Cc: mchehab@infradead.org; k.debski@samsung.com;
> kyungmin.park@samsung.com; sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH 2/2] [media] s5p-mfc: Add missing static storage class to
> silence warnings
> 
> Fixes the following sparse warnings:
> 
> drivers/media/video/s5p-mfc/s5p_mfc.c:73:6
> 	warning: symbol 's5p_mfc_watchdog' was not declared. Should it be
> static?
> drivers/media/video/s5p-mfc/s5p_mfc_opr.c:299:6:
> 	warning: symbol 's5p_mfc_set_shared_buffer' was not declared.
> Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc.c     |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index ac2dac9..2de6c72 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -70,7 +70,7 @@ static void wake_up_dev(struct s5p_mfc_dev *dev,
> unsigned int reason,
>  	wake_up(&dev->queue);
>  }
> 
> -void s5p_mfc_watchdog(unsigned long arg)
> +static void s5p_mfc_watchdog(unsigned long arg)
>  {
>  	struct s5p_mfc_dev *dev = (struct s5p_mfc_dev *)arg;
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index a802829..e6217cb 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -296,7 +296,7 @@ void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx
> *ctx)
>  }
> 
>  /* Set registers for shared buffer */
> -void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
> +static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
>  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	mfc_write(dev, ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
> --
> 1.7.4.1

