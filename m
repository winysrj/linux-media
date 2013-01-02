Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3ABIAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 03:00:31 -0500
Date: Wed, 2 Jan 2013 09:00:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 08/15] [media] marvell-ccic: switch to resource managed
 allocation and request
In-Reply-To: <1355565484-15791-9-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1301020851320.7829@axis700.grange>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-9-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch switchs to resource managed allocation and request in mmp-driver.
> It can remove free resource operations.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mmp-driver.c |   56 ++++++++--------------
>  1 file changed, 20 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index fec7cd8..40c243e 100755
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -315,7 +315,7 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	if (!pdata)
>  		return -ENODEV;
>  
> -	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
> +	cam = devm_kzalloc(&pdev->dev, sizeof(*cam), GFP_KERNEL);
>  	if (cam == NULL)
>  		return -ENOMEM;
>  	cam->pdev = pdev;
> @@ -343,14 +343,12 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "no iomem resource!\n");
> -		ret = -ENODEV;
> -		goto out_free;
> +		return -ENODEV;
>  	}
> -	mcam->regs = ioremap(res->start, resource_size(res));
> +	mcam->regs = devm_request_and_ioremap(&pdev->dev, res);
>  	if (mcam->regs == NULL) {
>  		dev_err(&pdev->dev, "MMIO ioremap fail\n");
> -		ret = -ENODEV;
> -		goto out_free;
> +		return -ENODEV;
>  	}
>  	/*
>  	 * Power/clock memory is elsewhere; get it too.  Perhaps this
> @@ -359,14 +357,12 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "no power resource!\n");
> -		ret = -ENODEV;
> -		goto out_unmap1;
> +		return -ENODEV;
>  	}
> -	cam->power_regs = ioremap(res->start, resource_size(res));
> +	cam->power_regs = devm_request_and_ioremap(&pdev->dev, res);
>  	if (cam->power_regs == NULL) {
>  		dev_err(&pdev->dev, "power MMIO ioremap fail\n");
> -		ret = -ENODEV;
> -		goto out_unmap1;
> +		return -ENODEV;
>  	}
>  
>  	mcam_init_clk(mcam, pdata, 1);
> @@ -376,25 +372,27 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	 */
>  	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
>  	if (mcam->i2c_adapter == NULL) {
> -		ret = -ENODEV;
>  		dev_err(&pdev->dev, "No i2c adapter\n");
> -		goto out_unmap2;
> +		ret = -ENODEV;
> +		goto out_uninit_clk;

Looks good in principle, but it will become a bit simpler yet after you 
change your patch 03/15 to not use mcam_init_clk() for clock 
deinitialisation, but that's going to be just a minor modification.

Thanks
Guennadi

>  	}
>  	/*
>  	 * Sensor GPIO pins.
>  	 */
> -	ret = gpio_request(pdata->sensor_power_gpio, "cam-power");
> +	ret = devm_gpio_request(&pdev->dev, pdata->sensor_power_gpio,
> +					"cam-power");
>  	if (ret) {
>  		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
>  				pdata->sensor_power_gpio);
> -		goto out_unmap2;
> +		goto out_uninit_clk;
>  	}
>  	gpio_direction_output(pdata->sensor_power_gpio, 0);
> -	ret = gpio_request(pdata->sensor_reset_gpio, "cam-reset");
> +	ret = devm_gpio_request(&pdev->dev, pdata->sensor_reset_gpio,
> +					"cam-reset");
>  	if (ret) {
>  		dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
>  				pdata->sensor_reset_gpio);
> -		goto out_gpio;
> +		goto out_uninit_clk;
>  	}
>  	gpio_direction_output(pdata->sensor_reset_gpio, 0);
>  
> @@ -404,7 +402,7 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	mmpcam_power_up(mcam);
>  	ret = mccic_register(mcam);
>  	if (ret)
> -		goto out_gpio2;
> +		goto out_power_down;
>  	/*
>  	 * Finally, set up our IRQ now that the core is ready to
>  	 * deal with it.
> @@ -415,8 +413,8 @@ static int mmpcam_probe(struct platform_device *pdev)
>  		goto out_unregister;
>  	}
>  	cam->irq = res->start;
> -	ret = request_irq(cam->irq, mmpcam_irq, IRQF_SHARED,
> -			"mmp-camera", mcam);
> +	ret = devm_request_irq(&pdev->dev, cam->irq, mmpcam_irq, IRQF_SHARED,
> +					"mmp-camera", mcam);
>  	if (ret == 0) {
>  		mmpcam_add_device(cam);
>  		return 0;
> @@ -424,18 +422,10 @@ static int mmpcam_probe(struct platform_device *pdev)
>  
>  out_unregister:
>  	mccic_shutdown(mcam);
> -out_gpio2:
> +out_power_down:
>  	mmpcam_power_down(mcam);
> -	gpio_free(pdata->sensor_reset_gpio);
> -out_gpio:
> -	gpio_free(pdata->sensor_power_gpio);
> -out_unmap2:
> +out_uninit_clk:
>  	mcam_init_clk(mcam, pdata, 0);
> -	iounmap(cam->power_regs);
> -out_unmap1:
> -	iounmap(mcam->regs);
> -out_free:
> -	kfree(cam);
>  	return ret;
>  }
>  
> @@ -446,16 +436,10 @@ static int mmpcam_remove(struct mmp_camera *cam)
>  	struct mmp_camera_platform_data *pdata;
>  
>  	mmpcam_remove_device(cam);
> -	free_irq(cam->irq, mcam);
>  	mccic_shutdown(mcam);
>  	mmpcam_power_down(mcam);
>  	pdata = cam->pdev->dev.platform_data;
> -	gpio_free(pdata->sensor_reset_gpio);
> -	gpio_free(pdata->sensor_power_gpio);
> -	iounmap(cam->power_regs);
> -	iounmap(mcam->regs);
>  	mcam_init_clk(mcam, pdata, 0);
> -	kfree(cam);
>  	return 0;
>  }
>  
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
