Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab2GFHeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 03:34:17 -0400
Date: Fri, 6 Jul 2012 09:34:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] [v2] i.MX27: Fix emma-prp clocks in mx2_camera.c
Message-ID: <20120706073414.GD30009@pengutronix.de>
References: <1341558791-9928-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341558791-9928-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2012 at 09:13:11AM +0200, Javier Martin wrote:
> This driver wasn't converted to the new clock changes
> (clk_prepare_enable/clk_disable_unprepare). Also naming
> of emma-prp related clocks for the i.MX27 was not correct.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  arch/arm/mach-imx/clk-imx27.c    |    8 ++++---
>  drivers/media/video/mx2_camera.c |   47 +++++++++++++++++++++-----------------
>  2 files changed, 31 insertions(+), 24 deletions(-)
> 
> @@ -1616,23 +1616,12 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
>  		goto exit_iounmap;
>  	}
>  
> -	pcdev->clk_emma = clk_get(NULL, "emma");
> -	if (IS_ERR(pcdev->clk_emma)) {
> -		err = PTR_ERR(pcdev->clk_emma);
> -		goto exit_free_irq;
> -	}
> -
> -	clk_enable(pcdev->clk_emma);
> -
>  	err = mx27_camera_emma_prp_reset(pcdev);
>  	if (err)
> -		goto exit_clk_emma_put;
> +		goto exit_free_irq;
>  
>  	return err;
>  
> -exit_clk_emma_put:
> -	clk_disable(pcdev->clk_emma);
> -	clk_put(pcdev->clk_emma);
>  exit_free_irq:
>  	free_irq(pcdev->irq_emma, pcdev);
>  exit_iounmap:
> @@ -1655,6 +1644,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  
>  	res_csi = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	irq_csi = platform_get_irq(pdev, 0);
> +
>  	if (res_csi == NULL || irq_csi < 0) {
>  		dev_err(&pdev->dev, "Missing platform resources data\n");
>  		err = -ENODEV;
> @@ -1668,12 +1658,26 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  		goto exit;
>  	}
>  
> -	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
> +	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
>  	if (IS_ERR(pcdev->clk_csi)) {
>  		dev_err(&pdev->dev, "Could not get csi clock\n");
>  		err = PTR_ERR(pcdev->clk_csi);
>  		goto exit_kfree;
>  	}
> +	pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "emma-ipg");
> +	if (IS_ERR(pcdev->clk_emma_ipg)) {
> +		err = PTR_ERR(pcdev->clk_emma_ipg);
> +		goto exit_kfree;
> +	}
> +	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "emma-ahb");
> +	if (IS_ERR(pcdev->clk_emma_ahb)) {
> +		err = PTR_ERR(pcdev->clk_emma_ahb);
> +		goto exit_kfree;
> +	}
> +
> +	clk_prepare_enable(pcdev->clk_csi);
> +	clk_prepare_enable(pcdev->clk_emma_ipg);
> +	clk_prepare_enable(pcdev->clk_emma_ahb);
>  
>  	pcdev->res_csi = res_csi;
>  	pcdev->pdata = pdev->dev.platform_data;
> @@ -1768,8 +1772,8 @@ exit_free_emma:
>  eallocctx:
>  	if (cpu_is_mx27()) {
>  		free_irq(pcdev->irq_emma, pcdev);
> -		clk_disable(pcdev->clk_emma);
> -		clk_put(pcdev->clk_emma);
> +		clk_disable_unprepare(pcdev->clk_emma_ipg);
> +		clk_disable_unprepare(pcdev->clk_emma_ahb);

The clk_disable_unprepare is inside a cpu_is_mx27() which seems correct.
Shouldn't the corresponding clk_get be in cpu_is_mx27() aswell?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
