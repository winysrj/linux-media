Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49319 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KETxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 14:53:30 -0500
Date: Tue, 5 Nov 2013 20:53:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: lbyang <lbyang@marvell.com>
Cc: corbet@lwn.net, linux-media@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] media: marvell-ccic: use devm to release clk
Message-ID: <20131105195325.GP14892@pengutronix.de>
References: <1383643996.30496.3.camel@younglee-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383643996.30496.3.camel@younglee-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 05, 2013 at 05:33:16PM +0800, lbyang wrote:
> From: Libin Yang <lbyang@marvell.com>
> Date: Tue, 5 Nov 2013 16:29:07 +0800
> Subject: [PATCH] media: marvell-ccic: use devm to release clk
> 
> This patch uses devm to release the clks instead of releasing
> manually.
> And it adds enable/disable mipi_clk when getting its rate.
> 
> Signed-off-by: Libin Yang <lbyang@marvell.com>
The driver still is no beauty, but with this patch the clk usage at
least seems to be API conformant.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

> ---
>  drivers/media/platform/marvell-ccic/mmp-driver.c |   39
> +++++-----------------
>  1 file changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
> b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index 70cb57f..054507f 100644
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -142,12 +142,6 @@ static int mmpcam_power_up(struct mcam_camera
> *mcam)
>  	struct mmp_camera *cam = mcam_to_cam(mcam);
>  	struct mmp_camera_platform_data *pdata;
>  
> -	if (mcam->bus_type == V4L2_MBUS_CSI2) {
> -		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
> -		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
> -			return PTR_ERR(cam->mipi_clk);
> -	}
> -
>  /*
>   * Turn on power and clocks to the controller.
>   */
> @@ -186,12 +180,6 @@ static void mmpcam_power_down(struct mcam_camera
> *mcam)
>  	gpio_set_value(pdata->sensor_power_gpio, 0);
>  	gpio_set_value(pdata->sensor_reset_gpio, 0);
>  
> -	if (mcam->bus_type == V4L2_MBUS_CSI2 && !IS_ERR(cam->mipi_clk)) {
> -		if (cam->mipi_clk)
> -			devm_clk_put(mcam->dev, cam->mipi_clk);
> -		cam->mipi_clk = NULL;
> -	}
> -
>  	mcam_clk_disable(mcam);
>  }
>  
> @@ -292,8 +280,9 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
>  		return;
>  
>  	/* get the escape clk, this is hard coded */
> +	clk_prepare_enable(cam->mipi_clk);
>  	tx_clk_esc = (clk_get_rate(cam->mipi_clk) / 1000000) / 12;
> -
> +	clk_disable_unprepare(cam->mipi_clk);
>  	/*
>  	 * dphy[2] - CSI2_DPHY6:
>  	 * bit 0 ~ bit 7: CK Term Enable
> @@ -325,19 +314,6 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -static void mcam_deinit_clk(struct mcam_camera *mcam)
> -{
> -	unsigned int i;
> -
> -	for (i = 0; i < NR_MCAM_CLK; i++) {
> -		if (!IS_ERR(mcam->clk[i])) {
> -			if (mcam->clk[i])
> -				devm_clk_put(mcam->dev, mcam->clk[i]);
> -		}
> -		mcam->clk[i] = NULL;
> -	}
> -}
> -
>  static void mcam_init_clk(struct mcam_camera *mcam)
>  {
>  	unsigned int i;
> @@ -371,7 +347,6 @@ static int mmpcam_probe(struct platform_device
> *pdev)
>  	if (cam == NULL)
>  		return -ENOMEM;
>  	cam->pdev = pdev;
> -	cam->mipi_clk = NULL;
>  	INIT_LIST_HEAD(&cam->devlist);
>  
>  	mcam = &cam->mcam;
> @@ -387,6 +362,11 @@ static int mmpcam_probe(struct platform_device
> *pdev)
>  	mcam->mclk_div = pdata->mclk_div;
>  	mcam->bus_type = pdata->bus_type;
>  	mcam->dphy = pdata->dphy;
> +	if (mcam->bus_type == V4L2_MBUS_CSI2) {
> +		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
> +		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
> +			return PTR_ERR(cam->mipi_clk);
> +	}
>  	mcam->mipi_enabled = false;
>  	mcam->lane = pdata->lane;
>  	mcam->chip_id = MCAM_ARMADA610;
> @@ -444,7 +424,7 @@ static int mmpcam_probe(struct platform_device
> *pdev)
>  	 */
>  	ret = mmpcam_power_up(mcam);
>  	if (ret)
> -		goto out_deinit_clk;
> +		return ret;
>  	ret = mccic_register(mcam);
>  	if (ret)
>  		goto out_power_down;
> @@ -469,8 +449,6 @@ out_unregister:
>  	mccic_shutdown(mcam);
>  out_power_down:
>  	mmpcam_power_down(mcam);
> -out_deinit_clk:
> -	mcam_deinit_clk(mcam);
>  	return ret;
>  }
>  
> @@ -482,7 +460,6 @@ static int mmpcam_remove(struct mmp_camera *cam)
>  	mmpcam_remove_device(cam);
>  	mccic_shutdown(mcam);
>  	mmpcam_power_down(mcam);
> -	mcam_deinit_clk(mcam);
>  	return 0;
>  }
>  
> -- 
> 1.7.9.5
> 
> 
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
