Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37055 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751695AbZKMHzj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 02:55:39 -0500
Date: Fri, 13 Nov 2009 08:55:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] soc-camera: sh_mobile_ceu_camera: remove unused label
In-Reply-To: <upr7rm8i9.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911130853220.4601@axis700.grange>
References: <upr7rm8i9.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

here's one more patch for 2.6.32:

On Tue, 10 Nov 2009, Kuninori Morimoto wrote:

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> >> Guennadi
> 
> I'm very very very sorry.
> I forgot remove this label in "sh_mobile_ceu_camera: call pm_runtime_disable"

Would it be possible to merge it with the previous one

http://linuxtv.org/hg/~gliakhovetski/v4l-dvb/rev/56fb79be71c8

in your git? Shall I just push it into my hg for you to pick up?

> 
>  drivers/media/video/sh_mobile_ceu_camera.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index aa3e4af..bcfccc2 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -1857,7 +1857,6 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
>  
>  exit_free_clk:
>  	pm_runtime_disable(&pdev->dev);
> -exit_free_irq:
>  	free_irq(pcdev->irq, pcdev);
>  exit_release_mem:
>  	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
> -- 
> 1.6.3.3
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
