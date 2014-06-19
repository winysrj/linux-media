Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:62263 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbaFSIRD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 04:17:03 -0400
Date: Thu, 19 Jun 2014 10:16:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: soc_camera: pxa_camera device-tree support
In-Reply-To: <1402863436-30311-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1406190939470.22703@axis700.grange>
References: <1402863436-30311-1-git-send-email-robert.jarzmik@free.fr>
 <1402863436-30311-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Jun 2014, Robert Jarzmik wrote:

> Add device-tree support to pxa_camera host driver.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 80 ++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index d4df305..e48d821 100644
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
> @@ -1650,9 +1651,74 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>  	.set_bus_param	= pxa_camera_set_bus_param,
>  };
>  
> +static const struct of_device_id pxacamera_dt_ids[] = {
> +	{ .compatible = "mrvl,pxa_camera", },

as Documentation/devicetree/bindings/vendor-prefixes.txt defines, it 
should be "marvell."

> +	{ }
> +};
> +
> +static int pxa_camera_pdata_from_dt(struct device *dev,
> +				    struct pxacamera_platform_data *pdata)
> +{
> +	int err = 0;
> +	struct device_node *np = dev->of_node;
> +	struct v4l2_of_endpoint ep;
> +
> +	dev_info(dev, "RJK: %s()\n", __func__);

I have nothing against attributing work to respective authors, but I don't 
think this makes a lot of sense in the long run in the above form :) Once 
you've verified that your binding is working and this function is working, 
either remove this or make it more informative - maybe at the end of this 
function, also listing a couple of important parameters, that you obtained 
from DT.

> +	err = of_property_read_u32(np, "mclk_10khz",
> +				   (u32 *)&pdata->mclk_10khz);

I think we'll be frowned upon for this :) PXA270 doesn't support CCF, does 
it? Even if it doesn't we probably should use the standard 
"clock-frequency" property in any case. Actually, I missed to mention on 
this in my comments to your bindings documentation.

> +	if (!err)
> +		pdata->flags |= PXA_CAMERA_MCLK_EN;
> +
> +	np = of_graph_get_next_endpoint(np, NULL);
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
> +		pdata->flags |= PXA_CAMERA_DATAWIDTH_4;
> +		break;
> +	case 5:
> +		pdata->flags |= PXA_CAMERA_DATAWIDTH_5;
> +		break;
> +	case 8:
> +		pdata->flags |= PXA_CAMERA_DATAWIDTH_8;
> +		break;
> +	case 9:
> +		pdata->flags |= PXA_CAMERA_DATAWIDTH_9;
> +		break;
> +	case 10:
> +		pdata->flags |= PXA_CAMERA_DATAWIDTH_10;
> +		break;
> +	default:
> +		break;
> +	};
> +
> +	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
> +		pdata->flags |= PXA_CAMERA_MASTER;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		pdata->flags |= PXA_CAMERA_HSP;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		pdata->flags |= PXA_CAMERA_VSP;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		pdata->flags |= PXA_CAMERA_PCLK_EN | PXA_CAMERA_PCP;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +		pdata->flags |= PXA_CAMERA_PCLK_EN;
> +
> +	return 0;
> +}
> +
>  static int pxa_camera_probe(struct platform_device *pdev)
>  {
>  	struct pxa_camera_dev *pcdev;
> +	struct pxacamera_platform_data pdata_dt;
>  	struct resource *res;
>  	void __iomem *base;
>  	int irq;
> @@ -1676,6 +1742,13 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	pcdev->res = res;
>  
>  	pcdev->pdata = pdev->dev.platform_data;
> +	if (&pdev->dev.of_node && !pcdev->pdata)
> +		err = pxa_camera_pdata_from_dt(&pdev->dev, &pdata_dt);
> +	if (err < 0)
> +		return err;
> +	else
> +		pcdev->pdata = &pdata_dt;

This will Oops, if someone decides to dereference pcdev->pdata outside of 
this function. pdata_dt is on stack and you store a pointer to it in your 
device data... But since ->pdata doesn't seem to be used anywhere else in 
this driver, maybe remove that struct member completely?

> +
>  	pcdev->platform_flags = pcdev->pdata->flags;
>  	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
>  			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
> @@ -1799,10 +1872,17 @@ static const struct dev_pm_ops pxa_camera_pm = {
>  	.resume		= pxa_camera_resume,
>  };
>  
> +static const struct of_device_id pxa_camera_of_match[] = {
> +	{ .compatible = "mrvl,pxa_camera", },

Another thing I failed to comment upon: I think DT should contain only 
hardware descriptions, nothing driver specific, and "pxa_camera" is more a 
name of the driver, than the hardware? Maybe something like 
"marvell,pxa27x-cif" would be suitable?

Thanks
Guennadi

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
