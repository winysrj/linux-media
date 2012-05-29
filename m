Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42366 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2E2JVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 05:21:31 -0400
Date: Tue, 29 May 2012 11:21:25 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 07/15] video: mx2_camera: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20120529092125.GJ30400@pengutronix.de>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
 <1337987696-31728-7-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337987696-31728-7-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2012 at 08:14:48PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Prepare the clock before enabling it.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: <linux-media@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/media/video/mx2_camera.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ded26b7..71b67a3 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -402,7 +402,7 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
>  {
>  	unsigned long flags;
>  
> -	clk_disable(pcdev->clk_csi);
> +	clk_disable_unprepare(pcdev->clk_csi);
>  	writel(0, pcdev->base_csi + CSICR1);
>  	if (cpu_is_mx27()) {
>  		writel(0, pcdev->base_emma + PRP_CNTL);
> @@ -430,7 +430,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  	if (pcdev->icd)
>  		return -EBUSY;
>  
> -	ret = clk_enable(pcdev->clk_csi);
> +	ret = clk_prepare_enable(pcdev->clk_csi);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1664,7 +1664,7 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
>  		goto exit_free_irq;
>  	}
>  
> -	clk_enable(pcdev->clk_emma);
> +	clk_prepare_enable(pcdev->clk_emma);
>  
>  	err = mx27_camera_emma_prp_reset(pcdev);
>  	if (err)
> @@ -1673,7 +1673,7 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
>  	return err;
>  
>  exit_clk_emma_put:
> -	clk_disable(pcdev->clk_emma);
> +	clk_disable_unprepare(pcdev->clk_emma);
>  	clk_put(pcdev->clk_emma);
>  exit_free_irq:
>  	free_irq(pcdev->irq_emma, pcdev);
> @@ -1810,7 +1810,7 @@ exit_free_emma:
>  eallocctx:
>  	if (cpu_is_mx27()) {
>  		free_irq(pcdev->irq_emma, pcdev);
> -		clk_disable(pcdev->clk_emma);
> +		clk_disable_unprepare(pcdev->clk_emma);
>  		clk_put(pcdev->clk_emma);
>  		iounmap(pcdev->base_emma);
>  		release_mem_region(pcdev->res_emma->start, resource_size(pcdev->res_emma));
> @@ -1850,7 +1850,7 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
>  	iounmap(pcdev->base_csi);
>  
>  	if (cpu_is_mx27()) {
> -		clk_disable(pcdev->clk_emma);
> +		clk_disable_unprepare(pcdev->clk_emma);
>  		clk_put(pcdev->clk_emma);
>  		iounmap(pcdev->base_emma);
>  		res = pcdev->res_emma;
> -- 
> 1.7.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
