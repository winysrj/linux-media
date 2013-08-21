Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20216 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3HUOpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 10:45:17 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRV00IA1YA91QC0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Aug 2013 15:45:15 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Fabio Estevam' <fabio.estevam@freescale.com>
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org
References: <1377026978-23322-1-git-send-email-fabio.estevam@freescale.com>
 <1377026978-23322-2-git-send-email-fabio.estevam@freescale.com>
In-reply-to: <1377026978-23322-2-git-send-email-fabio.estevam@freescale.com>
Subject: RE: [PATCH v6 2/3] [media] coda: Check the return value from
 clk_prepare_enable()
Date: Wed, 21 Aug 2013 16:45:14 +0200
Message-id: <000401ce9e7d$0c1ef8a0$245ce9e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

I still cannot apply this patch. There is something wrong.
Could you rebase this patch (or even better all 3 patches) to:
http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/master ?

I really want to send the pull request before the end of the week. 

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Fabio Estevam
> Sent: Tuesday, August 20, 2013 9:30 PM
> To: k.debski@samsung.com
> Cc: p.zabel@pengutronix.de; linux-media@vger.kernel.org; Fabio Estevam
> Subject: [PATCH v6 2/3] [media] coda: Check the return value from
> clk_prepare_enable()
> 
> clk_prepare_enable() may fail, so let's check its return value and
> propagate it in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v5:
> - Rebased against latest Kamil's tree
> 
>  drivers/media/platform/coda.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c
> b/drivers/media/platform/coda.c index b5d48b7..a68379c 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -2406,8 +2406,14 @@ static int coda_open(struct file *file)
>  		ctx->reg_idx = idx;
>  	}
> 
> -	clk_prepare_enable(dev->clk_per);
> -	clk_prepare_enable(dev->clk_ahb);
> +	ret = clk_prepare_enable(dev->clk_per);
> +	if (ret)
> +		goto err_clk_per;
> +
> +	ret = clk_prepare_enable(dev->clk_ahb);
> +	if (ret)
> +		goto err_clk_ahb;
> +
>  	set_default_params(ctx);
>  	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
>  					 &coda_queue_init);
> @@ -2465,7 +2471,9 @@ err_ctrls_setup:
>         v4l2_m2m_ctx_release(ctx->m2m_ctx);
>  err_ctx_init:
>  	clk_disable_unprepare(dev->clk_ahb);
> +err_clk_ahb:
>  	clk_disable_unprepare(dev->clk_per);
> +err_clk_per:
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
>  	clear_bit(ctx->idx, &dev->instance_mask); @@ -2873,10 +2881,15 @@
> static int coda_hw_init(struct coda_dev *dev)
>  	u16 product, major, minor, release;
>  	u32 data;
>  	u16 *p;
> -	int i;
> +	int i, ret;
> +
> +	ret = clk_prepare_enable(dev->clk_per);
> +	if (ret)
> +		return ret;
> 
> -	clk_prepare_enable(dev->clk_per);
> -	clk_prepare_enable(dev->clk_ahb);
> +	ret = clk_prepare_enable(dev->clk_ahb);
> +	if (ret)
> +		goto err_clk_ahb;
> 
>  	/*
>  	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
> @@ -2985,6 +2998,10 @@ static int coda_hw_init(struct coda_dev *dev)
>  	}
> 
>  	return 0;
> +
> +err_clk_ahb:
> +	clk_disable_unprepare(dev->clk_per);
> +	return ret;
>  }
> 
>  static void coda_fw_callback(const struct firmware *fw, void *context)
> --
> 1.8.1.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

