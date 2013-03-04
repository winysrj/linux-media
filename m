Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3CDJZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:25:53 -0500
Date: Mon, 4 Mar 2013 10:25:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org, thierry.reding@avionic-design.de
Subject: Re: [PATCH 1/4] [media] sh_veu.c: Convert to devm_ioremap_resource()
In-Reply-To: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
Message-ID: <Pine.LNX.4.64.1303041025001.13371@axis700.grange>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Mon, 4 Mar 2013, Sachin Kamat wrote:

> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks for the patches. I'll add all 4 to my 3.10 queue.

Thanks
Guennadi

> ---
>  drivers/media/platform/sh_veu.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
> index cb54c69..362d88e 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -10,6 +10,7 @@
>   * published by the Free Software Foundation
>   */
>  
> +#include <linux/err.h>
>  #include <linux/fs.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -1164,9 +1165,9 @@ static int sh_veu_probe(struct platform_device *pdev)
>  
>  	veu->is_2h = resource_size(reg_res) == 0x22c;
>  
> -	veu->base = devm_request_and_ioremap(&pdev->dev, reg_res);
> -	if (!veu->base)
> -		return -ENOMEM;
> +	veu->base = devm_ioremap_resource(&pdev->dev, reg_res);
> +	if (IS_ERR(veu->base))
> +		return PTR_ERR(veu->base);
>  
>  	ret = devm_request_threaded_irq(&pdev->dev, irq, sh_veu_isr, sh_veu_bh,
>  					0, "veu", veu);
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
