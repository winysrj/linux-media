Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45031 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbbCQAst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 20:48:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH 14/15] omap3isp: Add support for the Device Tree
Date: Tue, 17 Mar 2015 02:48:54 +0200
Message-ID: <2603487.gEIKMl6vV7@avalon>
In-Reply-To: <1426465570-30295-15-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi> <1426465570-30295-15-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 16 March 2015 02:26:09 Sakari Ailus wrote:
> Add the ISP device to omap3 DT include file and add support to the driver to
> use it.
> 
> Also obtain information on the external entities and the ISP configuration
> related to them through the Device Tree in addition to the platform data.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/platform/omap3isp/isp.c       |  209 ++++++++++++++++++++++--
>  drivers/media/platform/omap3isp/isp.h       |   11 ++
>  drivers/media/platform/omap3isp/ispcsiphy.c |    7 +
>  3 files changed, 215 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 992e74c..0d6012a 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -64,6 +64,7 @@
> 
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> 
>  #include "isp.h"
>  #include "ispreg.h"
> @@ -1991,6 +1992,14 @@ static int isp_register_entities(struct isp_device
> *isp) if (ret < 0)
>  		goto done;
> 
> +	/*
> +	 * Device Tree --- the external of the sub-devices will be

What do you mean by "the external of the sub-devices" ?

> +	 * registered later. Same goes for the sub-device node
> +	 * registration.
> +	 */
> +	if (isp->dev->of_node)
> +		return 0;
> +
>  	/* Register external entities */
>  	for (isp_subdev = pdata ? pdata->subdevs : NULL;
>  	     isp_subdev && isp_subdev->board_info; isp_subdev++) {
> @@ -2016,8 +2025,10 @@ static int isp_register_entities(struct isp_device
> *isp) ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
> 
>  done:
> -	if (ret < 0)
> +	if (ret < 0) {
>  		isp_unregister_entities(isp);
> +		v4l2_async_notifier_unregister(&isp->notifier);
> +	}
> 
>  	return ret;
>  }
> @@ -2232,6 +2243,7 @@ static int isp_remove(struct platform_device *pdev)
>  {
>  	struct isp_device *isp = platform_get_drvdata(pdev);
> 
> +	v4l2_async_notifier_unregister(&isp->notifier);
>  	isp_unregister_entities(isp);
>  	isp_cleanup_modules(isp);
>  	isp_xclk_cleanup(isp);
> @@ -2243,6 +2255,151 @@ static int isp_remove(struct platform_device *pdev)
>  	return 0;
>  }
> 
> +enum isp_of_phy {
> +	ISP_OF_PHY_PARALLEL = 0,
> +	ISP_OF_PHY_CSIPHY1,
> +	ISP_OF_PHY_CSIPHY2,
> +};
> +
> +static int isp_of_parse_node(struct device *dev, struct device_node *node,
> +			     struct isp_async_subdev *isd)
> +{
> +	struct isp_bus_cfg *buscfg = &isd->bus;
> +	struct v4l2_of_endpoint vep;
> +	unsigned int i;
> +
> +	v4l2_of_parse_endpoint(node, &vep);
> +
> +	dev_dbg(dev, "interface %u\n", vep.base.port);

The message seems a bit terse to me, I would also print the endpoint node name 
to give a bit of context.

	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
		vep.base.port);

> +
> +	switch (vep.base.port) {
> +	case ISP_OF_PHY_PARALLEL:
> +		buscfg->interface = ISP_INTERFACE_PARALLEL;
> +		buscfg->bus.parallel.data_lane_shift =
> +			vep.bus.parallel.data_shift;
> +		buscfg->bus.parallel.clk_pol =
> +			!!(vep.bus.parallel.flags
> +			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
> +		buscfg->bus.parallel.hs_pol =
> +			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
> +		buscfg->bus.parallel.vs_pol =
> +			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
> +		buscfg->bus.parallel.fld_pol =
> +			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
> +		buscfg->bus.parallel.data_pol =
> +			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> +		break;
> +
> +	case ISP_OF_PHY_CSIPHY1:
> +	case ISP_OF_PHY_CSIPHY2:
> +		/* FIXME: always assume CSI-2 for now. */
> +		switch (vep.base.port) {
> +		case ISP_OF_PHY_CSIPHY1:

I'd use an if - else here, but that's up to you.

> +			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
> +			break;
> +		case ISP_OF_PHY_CSIPHY2:
> +			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
> +			break;
> +		}
> +		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
> +		buscfg->bus.csi2.lanecfg.clk.pol =
> +			vep.bus.mipi_csi2.lane_polarity[0];
> +		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +			buscfg->bus.csi2.lanecfg.clk.pol,
> +			buscfg->bus.csi2.lanecfg.clk.pos);
> +
> +		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
> +			buscfg->bus.csi2.lanecfg.data[i].pos =
> +				vep.bus.mipi_csi2.data_lanes[i];
> +			buscfg->bus.csi2.lanecfg.data[i].pol =
> +				vep.bus.mipi_csi2.lane_polarity[i + 1];
> +			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> +				buscfg->bus.csi2.lanecfg.data[i].pol,
> +				buscfg->bus.csi2.lanecfg.data[i].pos);
> +		}
> +
> +		/*
> +		 * FIXME: now we assume the CRC is always there.
> +		 * Implement a way to obtain this information from the
> +		 * sensor. Frame descriptors, perhaps?
> +		 */
> +		buscfg->bus.csi2.crc = 1;
> +		break;
> +
> +	default:
> +		dev_warn(dev, "invalid interface %d\n\n", vep.base.port);

Double \n ? I would also print the node name to add a bit of context.

> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int isp_of_parse_nodes(struct device *dev,
> +			      struct v4l2_async_notifier *notifier)
> +{
> +	struct device_node *node = NULL;

No need to initialize node to NULL.

> +	struct v4l2_async_subdev **asds;
> +
> +	asds = notifier->subdevs =

Could you use a single assignment per line, please ?

> +		devm_kcalloc(dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs),
> +			     GFP_KERNEL);
> +	if (!asds)
> +		return -ENOMEM;
> +
> +	while ((node = of_graph_get_next_endpoint(dev->of_node, node)) &&
> +	       notifier->num_subdevs < ISP_MAX_SUBDEVS) {
> +		struct isp_async_subdev *isd;
> +
> +		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> +		if (!isd)
> +			return -ENOMEM;
> +
> +		*asds = &isd->asd;
> +
> +		if (isp_of_parse_node(dev, node, isd))
> +			return -EINVAL;
> +
> +		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);

An of_node_put() is needed somewhere in the exit/cleanup paths.

> +
> +		if (!isd->asd.match.of.node) {
> +			dev_warn(dev, "bad remote port parent\n");
> +			return -EINVAL;
> +		}
> +		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +		notifier->num_subdevs++;
> +	}
> +
> +	return notifier->num_subdevs;
> +}
> +
> +static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
> +				     struct v4l2_subdev *subdev,
> +				     struct v4l2_async_subdev *asd)
> +{
> +	struct isp_device *isp = container_of(async, struct isp_device,
> +					      notifier);
> +	struct isp_async_subdev *isd =
> +		container_of(asd, struct isp_async_subdev, asd);
> +	int rval;

The coding style in the omap3isp driver mostly uses ret, sorry :-)

> +
> +	rval = isp_link_entity(isp, &subdev->entity, isd->bus.interface);
> +	if (rval < 0)
> +		return rval;
> +
> +	isd->sd = subdev;
> +	isd->sd->host_priv = &isd->bus;
> +
> +	return rval;
> +}
> +
> +static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
> +{
> +	struct isp_device *isp = container_of(async, struct isp_device,
> +					      notifier);
> +
> +	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
> +}
> +
>  /*
>   * isp_probe - Probe ISP platform device
>   * @pdev: Pointer to ISP platform device
> @@ -2256,7 +2413,6 @@ static int isp_remove(struct platform_device *pdev)
>   */
>  static int isp_probe(struct platform_device *pdev)
>  {
> -	struct isp_platform_data *pdata = pdev->dev.platform_data;
>  	struct isp_device *isp;
>  	struct resource *mem;
>  	int ret;
> @@ -2268,13 +2424,37 @@ static int isp_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
> 
> +	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
> +		ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
> +					   &isp->phy_type);
> +		if (ret)
> +			return ret;
> +
> +		isp->syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
> +							      "syscon");
> +		if (IS_ERR(isp->syscon))
> +			return PTR_ERR(isp->syscon);

isp->syscon_offset isn't set anywhere in the DT case, am I missing something ?

> +
> +		ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
> +		if (ret < 0)
> +			return ret;
> +		ret = v4l2_async_notifier_register(&isp->v4l2_dev,
> +						   &isp->notifier);
> +		if (ret)
> +			return ret;
> +	} else {
> +		isp->pdata = pdev->dev.platform_data;
> +		isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
> +		if (IS_ERR(isp->syscon))
> +			return PTR_ERR(isp->syscon);
> +	}
> +
>  	isp->autoidle = autoidle;
> 
>  	mutex_init(&isp->isp_mutex);
>  	spin_lock_init(&isp->stat_lock);
> 
>  	isp->dev = &pdev->dev;
> -	isp->pdata = pdata;
>  	isp->ref_count = 0;
> 
>  	ret = dma_coerce_mask_and_coherent(isp->dev, DMA_BIT_MASK(32));
> @@ -2346,6 +2526,11 @@ static int isp_probe(struct platform_device *pdev)
>  		goto error_isp;
>  	}
> 
> +	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node) {
> +		isp->syscon_offset = isp_res_maps[m].syscon_offset;
> +		isp->phy_type = isp_res_maps[m].phy_type;
> +	}
> +
>  	for (i = 1; i < OMAP3_ISP_IOMEM_CSI2A_REGS1; i++)
>  		isp->mmio_base[i] =
>  			isp->mmio_base[0] + isp_res_maps[m].offset[i];
> @@ -2358,15 +2543,6 @@ static int isp_probe(struct platform_device *pdev)
>  	isp->mmio_hist_base_phys =
>  		mem->start + isp_res_maps[m].offset[OMAP3_ISP_IOMEM_HIST];
> 
> -	isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
> -	if (IS_ERR(isp->syscon)) {
> -		ret = PTR_ERR(isp->syscon);
> -		goto error_isp;
> -	}
> -
> -	isp->syscon_offset = isp_res_maps[m].syscon_offset;
> -	isp->phy_type = isp_res_maps[m].phy_type;
> -
>  	/* IOMMU */
>  	ret = isp_attach_iommu(isp);
>  	if (ret < 0) {
> @@ -2394,6 +2570,9 @@ static int isp_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto error_iommu;
> 
> +	isp->notifier.bound = isp_subdev_notifier_bound;
> +	isp->notifier.complete = isp_subdev_notifier_complete;
> +
>  	ret = isp_register_entities(isp);
>  	if (ret < 0)
>  		goto error_modules;
> @@ -2429,6 +2608,11 @@ static struct platform_device_id omap3isp_id_table[]
> = { };
>  MODULE_DEVICE_TABLE(platform, omap3isp_id_table);
> 
> +static const struct of_device_id omap3isp_of_table[] = {
> +	{ .compatible = "ti,omap3-isp" },
> +	{ },
> +};
> +
>  static struct platform_driver omap3isp_driver = {
>  	.probe = isp_probe,
>  	.remove = isp_remove,
> @@ -2436,6 +2620,7 @@ static struct platform_driver omap3isp_driver = {
>  	.driver = {
>  		.name = "omap3isp",
>  		.pm	= &omap3isp_pm_ops,
> +		.of_match_table = omap3isp_of_table,
>  	},
>  };
> 
> diff --git a/drivers/media/platform/omap3isp/isp.h
> b/drivers/media/platform/omap3isp/isp.h index dcb7d20..431224e 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -18,6 +18,7 @@
>  #define OMAP3_ISP_CORE_H
> 
>  #include <media/omap3isp.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <linux/clk-provider.h>
>  #include <linux/device.h>
> @@ -178,6 +179,7 @@ struct isp_xclk {
>   */
>  struct isp_device {
>  	struct v4l2_device v4l2_dev;
> +	struct v4l2_async_notifier notifier;
>  	struct media_device media_dev;
>  	struct device *dev;
>  	u32 revision;
> @@ -224,6 +226,15 @@ struct isp_device {
> 
>  	unsigned int sbl_resources;
>  	unsigned int subclk_resources;
> +
> +#define ISP_MAX_SUBDEVS		8
> +	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
> +};
> +
> +struct isp_async_subdev {
> +	struct v4l2_subdev *sd;
> +	struct isp_bus_cfg bus;
> +	struct v4l2_async_subdev asd;
>  };
> 
>  #define v4l2_dev_to_isp_device(dev) \
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> b/drivers/media/platform/omap3isp/ispcsiphy.c index d91dde1..495447d 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -173,6 +173,13 @@ static int omap3isp_csiphy_config(struct isp_csiphy
> *phy) unsigned int i;
>  	u32 reg;
> 
> +	if (!buscfg) {
> +		struct isp_async_subdev *isd =
> +			container_of(pipe->external->asd,
> +				     struct isp_async_subdev, asd);
> +		buscfg = &isd->bus;
> +	}
> +
>  	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
> 
>  	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2)
> 
>  		lanes = &buscfg->bus.ccp2.lanecfg;

-- 
Regards,

Laurent Pinchart

