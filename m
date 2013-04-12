Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3DLMip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 08:38:45 -0400
Date: Fri, 12 Apr 2013 14:38:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: media: platform: convert to devm_ioremap_resource()
In-Reply-To: <1365627565-17401-1-git-send-email-silviupopescu1990@gmail.com>
Message-ID: <Pine.LNX.4.64.1304121434031.1727@axis700.grange>
References: <1365627565-17401-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Wed, 10 Apr 2013, Silviu-Mihai Popescu wrote:

> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Thanks for the patch, but an equivalent one is already upstream:

http://git.linuxtv.org/media_tree.git/commitdiff/f2b4dc1a0fc8f52e06025497ce9bb252ff51f15f

Thanks
Guennadi

> ---
>  drivers/media/platform/sh_veu.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
> index cb54c69..911f562 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -1164,9 +1164,9 @@ static int sh_veu_probe(struct platform_device *pdev)
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
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
