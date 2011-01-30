Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:62452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1A3V1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jan 2011 16:27:17 -0500
Date: Sun, 30 Jan 2011 22:27:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mathias Krause <minipli@googlemail.com>
cc: linux-media@vger.kernel.org,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] OMAP1: fix use after free
In-Reply-To: <1296381958-15760-1-git-send-email-minipli@googlemail.com>
Message-ID: <Pine.LNX.4.64.1101302225310.2084@axis700.grange>
References: <1296381958-15760-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 30 Jan 2011, Mathias Krause wrote:

> Even though clk_put() is a no-op on most architectures it is not for
> some ARM implementations. To not fail on those, release the clock timer
> before freeing the surrounding structure.

Hm, ok, I guess, it is a noop on OMAP1, otherwise they'd notice this much 
earlier, so, it, probably, doesn't currently affect the functionality, 
still, I think, this should go in 2.6.38. Don't think we need it in stable 
though. I'll queue it for one of -rcX.

Thanks
Guennadi

> 
> This bug was spotted by the semantic patch tool coccinelle using the
> script found at scripts/coccinelle/free/kfree.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  drivers/media/video/omap1_camera.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
> index 0a2fb2b..9ed1513 100644
> --- a/drivers/media/video/omap1_camera.c
> +++ b/drivers/media/video/omap1_camera.c
> @@ -1664,10 +1664,10 @@ static int __exit omap1_cam_remove(struct platform_device *pdev)
>  	res = pcdev->res;
>  	release_mem_region(res->start, resource_size(res));
>  
> -	kfree(pcdev);
> -
>  	clk_put(pcdev->clk);
>  
> +	kfree(pcdev);
> +
>  	dev_info(&pdev->dev, "OMAP1 Camera Interface driver unloaded\n");
>  
>  	return 0;
> -- 
> 1.5.6.5
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
