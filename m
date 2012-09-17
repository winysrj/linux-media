Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2IQISy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 04:18:54 -0400
Date: Mon, 17 Sep 2012 10:18:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Shawn Guo <shawn.guo@linaro.org>
cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH 26/34] media: mx2_camera: remove dead code in
 mx2_camera_add_device
In-Reply-To: <1347860103-4141-27-git-send-email-shawn.guo@linaro.org>
Message-ID: <Pine.LNX.4.64.1209171017460.1689@axis700.grange>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <1347860103-4141-27-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shawn

Thanks for the clean up. Would you like these patches to go via a single 
tree, presumably, arm-soc? In this case

On Mon, 17 Sep 2012, Shawn Guo wrote:

> This is a piece of code becoming dead since commit 2c9ba37 ([media]
> V4L: mx2_camera: remove unsupported i.MX27 DMA mode, make EMMA
> mandatory).  It should have been removed together with the commit.
> Remove it now.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: linux-media@vger.kernel.org

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/video/mx2_camera.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 965427f..89c7e28 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -441,11 +441,9 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  
>  	csicr1 = CSICR1_MCLKEN;
>  
> -	if (cpu_is_mx27()) {
> +	if (cpu_is_mx27())
>  		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
>  			CSICR1_RXFF_LEVEL(0);
> -	} else if (cpu_is_mx27())
> -		csicr1 |= CSICR1_SOF_INTEN | CSICR1_RXFF_LEVEL(2);
>  
>  	pcdev->csicr1 = csicr1;
>  	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
