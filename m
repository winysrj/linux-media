Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:59864 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbaGWJ2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 05:28:12 -0400
Date: Wed, 23 Jul 2014 11:28:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] media: soc_camera: pxa_camera device-tree support
In-Reply-To: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1407231126210.30243@axis700.grange>
References: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

Thanks for an updated patch. One question:

On Sun, 29 Jun 2014, Robert Jarzmik wrote:

> Add device-tree support to pxa_camera host driver.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> ---
> Since V1: Mark's review
>           - tmp u32 to long conversion for clock rate
>           - use device-tree clock binding for mclk output clock
>           - wildcard pxa27x becomes pxa270
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 80 +++++++++++++++++++++++++-
>  1 file changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index d4df305..e76c2ab 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -34,6 +34,7 @@
>  #include <media/videobuf-dma-sg.h>
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
> +#include <media/v4l2-of.h>
>  
>  #include <linux/videodev2.h>
>  
> @@ -1650,6 +1651,67 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>  	.set_bus_param	= pxa_camera_set_bus_param,
>  };
>  
> +static int pxa_camera_pdata_from_dt(struct device *dev,
> +				    struct pxa_camera_dev *pcdev)
> +{
> +	int err = 0;
> +	u32 mclk_rate = 0;
> +	struct device_node *np = dev->of_node;
> +	struct v4l2_of_endpoint ep;
> +
> +	err = of_property_read_u32(np, "clock-frequency",
> +				   &mclk_rate);
> +	if (!err) {
> +		pcdev->platform_flags |= PXA_CAMERA_MCLK_EN;
> +		pcdev->mclk = mclk_rate;
> +	}
> +
> +	np = of_graph_get_next_endpoint(np, NULL);

Isn't an of_node_put() required after this?

Thanks
Guennadi

> +	if (!np) {
> +		dev_err(dev, "could not find endpoint\n");
> +		return -EINVAL;
> +	}
> +
> +	err = v4l2_of_parse_endpoint(np, &ep);
> +	if (err) {
> +		dev_err(dev, "could not parse endpoint\n");
> +		return err;
> +	}
> +
> +	switch (ep.bus.parallel.bus_width) {
> +	case 4:
> +		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_4;
> +		break;
> +	case 5:
> +		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_5;
> +		break;
> +	case 8:
> +		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_8;
> +		break;
> +	case 9:
> +		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_9;
> +		break;
> +	case 10:
> +		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
> +		break;
> +	default:
> +		break;
> +	};
> +
> +	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
> +		pcdev->platform_flags |= PXA_CAMERA_MASTER;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		pcdev->platform_flags |= PXA_CAMERA_HSP;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		pcdev->platform_flags |= PXA_CAMERA_VSP;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN | PXA_CAMERA_PCP;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
> +
> +	return 0;
> +}
> +
>  static int pxa_camera_probe(struct platform_device *pdev)
>  {
>  	struct pxa_camera_dev *pcdev;
> @@ -1676,7 +1738,15 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	pcdev->res = res;
>  
>  	pcdev->pdata = pdev->dev.platform_data;
> -	pcdev->platform_flags = pcdev->pdata->flags;
> +	if (&pdev->dev.of_node && !pcdev->pdata) {
> +		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev);
> +	} else {
> +		pcdev->platform_flags = pcdev->pdata->flags;
> +		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
> +	}
> +	if (err < 0)
> +		return err;
> +
>  	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
>  			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
>  		/*
> @@ -1693,7 +1763,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  		pcdev->width_flags |= 1 << 8;
>  	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
>  		pcdev->width_flags |= 1 << 9;
> -	pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
>  	if (!pcdev->mclk) {
>  		dev_warn(&pdev->dev,
>  			 "mclk == 0! Please, fix your platform data. "
> @@ -1799,10 +1868,17 @@ static const struct dev_pm_ops pxa_camera_pm = {
>  	.resume		= pxa_camera_resume,
>  };
>  
> +static const struct of_device_id pxa_camera_of_match[] = {
> +	{ .compatible = "marvell,pxa270-qci", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pxa_camera_of_match);
> +
>  static struct platform_driver pxa_camera_driver = {
>  	.driver		= {
>  		.name	= PXA_CAM_DRV_NAME,
>  		.pm	= &pxa_camera_pm,
> +		.of_match_table = of_match_ptr(pxa_camera_of_match),
>  	},
>  	.probe		= pxa_camera_probe,
>  	.remove		= pxa_camera_remove,
> -- 
> 2.0.0.rc2
> 
