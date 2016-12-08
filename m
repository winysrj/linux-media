Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59407 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753933AbcLHPu2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 10:50:28 -0500
Message-ID: <1481212227.2673.5.camel@pengutronix.de>
Subject: Re: [PATCH 5/9] [media] coda: get VDOA device using dt phandle
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Michael Tretter <m.tretter@pengutronix.de>
Cc: linux-media@vger.kernel.org
Date: Thu, 08 Dec 2016 16:50:27 +0100
In-Reply-To: <20161208152416.16031-5-m.tretter@pengutronix.de>
References: <20161208152416.16031-1-m.tretter@pengutronix.de>
         <20161208152416.16031-5-m.tretter@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 08.12.2016, 16:24 +0100 schrieb Michael Tretter:
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-common.c | 43 +++++++++++++++++++++++++++++++
>  drivers/media/platform/coda/coda.h        |  1 +
>  2 files changed, 44 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index e0184194..1adb6f3 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -41,6 +41,7 @@
>  #include <media/videobuf2-vmalloc.h>
>  
>  #include "coda.h"
> +#include "imx-vdoa.h"
>  
>  #define CODA_NAME		"coda"
>  
> @@ -66,6 +67,10 @@ static int disable_tiling;
>  module_param(disable_tiling, int, 0644);
>  MODULE_PARM_DESC(disable_tiling, "Disable tiled frame buffers");
>  
> +static int disable_vdoa;
> +module_param(disable_vdoa, int, 0644);
> +MODULE_PARM_DESC(disable_vdoa, "Disable Video Data Order Adapter tiled to raster-scan conversion");
> +
>  void coda_write(struct coda_dev *dev, u32 data, u32 reg)
>  {
>  	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
> @@ -325,6 +330,34 @@ const char *coda_product_name(int product)
>  	}
>  }
>  
> +static struct vdoa_data *coda_get_vdoa_data(struct device_node *np,
> +					    const char *name)

I'd drop the name parameter, there's only one possible phandle name.

> +{
> +	struct device_node *vdoa_node;
> +	struct platform_device *vdoa_pdev;
> +	struct vdoa_data *vdoa_data;
> +
> +	vdoa_node = of_parse_phandle(np, name, 0);

	vdoa_node = of_parse_phandle(np, "vdoa", 0);

> +	if (!vdoa_node)
> +		return NULL;
> +
> +	vdoa_pdev = of_find_device_by_node(vdoa_node);
> +	if (!vdoa_pdev) {
> +		vdoa_data = NULL;
> +		goto out;
> +	}
> +
> +	vdoa_data = platform_get_drvdata(vdoa_pdev);
> +	if (!vdoa_data)
> +		vdoa_data = ERR_PTR(-EPROBE_DEFER);
> +
> +out:
> +	if (vdoa_node)
> +		of_node_put(vdoa_node);
> +
> +	return vdoa_data;
> +}
> +
>  /*
>   * V4L2 ioctl() operations.
>   */
> @@ -2256,6 +2289,16 @@ static int coda_probe(struct platform_device *pdev)
>  	}
>  	dev->iram_pool = pool;
>  
> +	/* Get VDOA from device tree if available */
> +	if (!disable_tiling && !disable_vdoa) {

disable_tiling/disable_vdoa could be changed after the module is loaded.
Better always call coda_get_vdoa_data.

> +		dev->vdoa = coda_get_vdoa_data(np, "vdoa");

		dev->vdoa = coda_get_vdoa_data(np);

> +		if (PTR_ERR(dev->vdoa) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +		if (!dev->vdoa)
> +			dev_info(&pdev->dev,
> +				 "vdoa not available; not using tiled intermediate format");

This message is not useful on i.MX53, maybe use
	if (dev_type == CODA_960)

> +	}
> +
>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 53f9666..ae202dc 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -75,6 +75,7 @@ struct coda_dev {
>  	struct platform_device	*plat_dev;
>  	const struct coda_devtype *devtype;
>  	int			firmware;
> +	struct vdoa_data	*vdoa;
>  
>  	void __iomem		*regs_base;
>  	struct clk		*clk_per;

regards
Philipp

