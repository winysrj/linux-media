Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3CEGk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 01:40:29 -0500
Date: Tue, 5 Mar 2013 07:40:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] sh_veu: Use module_platform_driver_probe
 macro
In-Reply-To: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
Message-ID: <Pine.LNX.4.64.1303050740080.24699@axis700.grange>
References: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Mar 2013, Sachin Kamat wrote:

> module_platform_driver_probe() eliminates the boilerplate and simplifies
> the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, all 3 queued for 3.10

Regards
Guennadi

> ---
>  drivers/media/platform/sh_veu.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
> index 362d88e..0b32cc3 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -1249,18 +1249,7 @@ static struct platform_driver __refdata sh_veu_pdrv = {
>  	},
>  };
>  
> -static int __init sh_veu_init(void)
> -{
> -	return platform_driver_probe(&sh_veu_pdrv, sh_veu_probe);
> -}
> -
> -static void __exit sh_veu_exit(void)
> -{
> -	platform_driver_unregister(&sh_veu_pdrv);
> -}
> -
> -module_init(sh_veu_init);
> -module_exit(sh_veu_exit);
> +module_platform_driver_probe(sh_veu_pdrv, sh_veu_probe);
>  
>  MODULE_DESCRIPTION("sh-mobile VEU mem2mem driver");
>  MODULE_AUTHOR("Guennadi Liakhovetski, <g.liakhovetski@gmx.de>");
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
