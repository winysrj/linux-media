Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KQXQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 18:16:06 -0500
Date: Sun, 18 Nov 2012 00:16:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Tushar Behera <tushar.behera@linaro.org>
cc: linux-kernel@vger.kernel.org, patches@linaro.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 05/14] [media] atmel-isi: Update error check for unsigned
 variables
In-Reply-To: <1353048646-10935-6-git-send-email-tushar.behera@linaro.org>
Message-ID: <Pine.LNX.4.64.1211180014330.30062@axis700.grange>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
 <1353048646-10935-6-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Nov 2012, Tushar Behera wrote:

> Checking '< 0' for unsigned variables always returns false. For error
> codes, use IS_ERR_VALUE() instead.

Wouldn't just changing "irq" type to "int" also work? I think that would 
be a more straight-forward solution. If however there are strong arguments 
against that, I'm fine with this fix too.

Thanks
Guennadi

> 
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: linux-media@vger.kernel.org
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/media/platform/soc_camera/atmel-isi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 6274a91..5bd65df 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -1020,7 +1020,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0) {
> +	if (IS_ERR_VALUE(irq)) {
>  		ret = irq;
>  		goto err_req_irq;
>  	}
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
