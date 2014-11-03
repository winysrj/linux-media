Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44290 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKCXpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 18:45:08 -0500
Date: Tue, 4 Nov 2014 08:44:57 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Remove support for platform data
Message-ID: <20141103234457.GA8941@verge.net.au>
References: <1414678153-11676-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414678153-11676-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 30, 2014 at 04:09:13PM +0200, Laurent Pinchart wrote:
> Now that all platforms instantiate the VSP1 through DT, platform data
> support isn't needed anymore.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Very nice :)

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/media/platform/Kconfig         |  2 +-
>  drivers/media/platform/vsp1/vsp1.h     | 14 +++++-
>  drivers/media/platform/vsp1/vsp1_drv.c | 81 ++++++++++++----------------------
>  drivers/media/platform/vsp1/vsp1_wpf.c |  2 +-
>  include/linux/platform_data/vsp1.h     | 27 ------------
>  5 files changed, 43 insertions(+), 83 deletions(-)
>  delete mode 100644 include/linux/platform_data/vsp1.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 0c61155699f7..0c301d8ded7f 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -231,7 +231,7 @@ config VIDEO_SH_VEU
>  config VIDEO_RENESAS_VSP1
>  	tristate "Renesas VSP1 Video Processing Engine"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> -	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	depends on (ARCH_SHMOBILE && OF) || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
> diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
> index 12467191dff4..989e96f7e360 100644
> --- a/drivers/media/platform/vsp1/vsp1.h
> +++ b/drivers/media/platform/vsp1/vsp1.h
> @@ -16,7 +16,6 @@
>  #include <linux/io.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> -#include <linux/platform_data/vsp1.h>
>  
>  #include <media/media-device.h>
>  #include <media/v4l2-device.h>
> @@ -40,9 +39,20 @@ struct vsp1_uds;
>  #define VSP1_MAX_UDS		3
>  #define VSP1_MAX_WPF		4
>  
> +#define VSP1_HAS_LIF		(1 << 0)
> +#define VSP1_HAS_LUT		(1 << 1)
> +#define VSP1_HAS_SRU		(1 << 2)
> +
> +struct vsp1_platform_data {
> +	unsigned int features;
> +	unsigned int rpf_count;
> +	unsigned int uds_count;
> +	unsigned int wpf_count;
> +};
> +
>  struct vsp1_device {
>  	struct device *dev;
> -	struct vsp1_platform_data *pdata;
> +	struct vsp1_platform_data pdata;
>  
>  	void __iomem *mmio;
>  	struct clk *clock;
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 3e6601b5b4de..d1911f8f1d55 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -40,7 +40,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
>  	irqreturn_t ret = IRQ_NONE;
>  	unsigned int i;
>  
> -	for (i = 0; i < vsp1->pdata->wpf_count; ++i) {
> +	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
>  		struct vsp1_rwpf *wpf = vsp1->wpf[i];
>  		struct vsp1_pipeline *pipe;
>  		u32 status;
> @@ -181,7 +181,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  
>  	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
>  
> -	if (vsp1->pdata->features & VSP1_HAS_LIF) {
> +	if (vsp1->pdata.features & VSP1_HAS_LIF) {
>  		vsp1->lif = vsp1_lif_create(vsp1);
>  		if (IS_ERR(vsp1->lif)) {
>  			ret = PTR_ERR(vsp1->lif);
> @@ -191,7 +191,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		list_add_tail(&vsp1->lif->entity.list_dev, &vsp1->entities);
>  	}
>  
> -	if (vsp1->pdata->features & VSP1_HAS_LUT) {
> +	if (vsp1->pdata.features & VSP1_HAS_LUT) {
>  		vsp1->lut = vsp1_lut_create(vsp1);
>  		if (IS_ERR(vsp1->lut)) {
>  			ret = PTR_ERR(vsp1->lut);
> @@ -201,7 +201,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		list_add_tail(&vsp1->lut->entity.list_dev, &vsp1->entities);
>  	}
>  
> -	for (i = 0; i < vsp1->pdata->rpf_count; ++i) {
> +	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
>  		struct vsp1_rwpf *rpf;
>  
>  		rpf = vsp1_rpf_create(vsp1, i);
> @@ -214,7 +214,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		list_add_tail(&rpf->entity.list_dev, &vsp1->entities);
>  	}
>  
> -	if (vsp1->pdata->features & VSP1_HAS_SRU) {
> +	if (vsp1->pdata.features & VSP1_HAS_SRU) {
>  		vsp1->sru = vsp1_sru_create(vsp1);
>  		if (IS_ERR(vsp1->sru)) {
>  			ret = PTR_ERR(vsp1->sru);
> @@ -224,7 +224,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		list_add_tail(&vsp1->sru->entity.list_dev, &vsp1->entities);
>  	}
>  
> -	for (i = 0; i < vsp1->pdata->uds_count; ++i) {
> +	for (i = 0; i < vsp1->pdata.uds_count; ++i) {
>  		struct vsp1_uds *uds;
>  
>  		uds = vsp1_uds_create(vsp1, i);
> @@ -237,7 +237,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		list_add_tail(&uds->entity.list_dev, &vsp1->entities);
>  	}
>  
> -	for (i = 0; i < vsp1->pdata->wpf_count; ++i) {
> +	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
>  		struct vsp1_rwpf *wpf;
>  
>  		wpf = vsp1_wpf_create(vsp1, i);
> @@ -261,7 +261,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  			goto done;
>  	}
>  
> -	if (vsp1->pdata->features & VSP1_HAS_LIF) {
> +	if (vsp1->pdata.features & VSP1_HAS_LIF) {
>  		ret = media_entity_create_link(
>  			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
>  			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
> @@ -294,7 +294,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
>  	/* Reset any channel that might be running. */
>  	status = vsp1_read(vsp1, VI6_STATUS);
>  
> -	for (i = 0; i < vsp1->pdata->wpf_count; ++i) {
> +	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
>  		unsigned int timeout;
>  
>  		if (!(status & VI6_STATUS_SYS_ACT(i)))
> @@ -318,10 +318,10 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
>  	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
>  		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
>  
> -	for (i = 0; i < vsp1->pdata->rpf_count; ++i)
> +	for (i = 0; i < vsp1->pdata.rpf_count; ++i)
>  		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
>  
> -	for (i = 0; i < vsp1->pdata->uds_count; ++i)
> +	for (i = 0; i < vsp1->pdata.uds_count; ++i)
>  		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
>  
>  	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
> @@ -428,28 +428,36 @@ static const struct dev_pm_ops vsp1_pm_ops = {
>   * Platform Driver
>   */
>  
> -static int vsp1_validate_platform_data(struct platform_device *pdev,
> -				       struct vsp1_platform_data *pdata)
> +static int vsp1_parse_dt(struct vsp1_device *vsp1)
>  {
> -	if (pdata == NULL) {
> -		dev_err(&pdev->dev, "missing platform data\n");
> -		return -EINVAL;
> -	}
> +	struct device_node *np = vsp1->dev->of_node;
> +	struct vsp1_platform_data *pdata = &vsp1->pdata;
> +
> +	if (of_property_read_bool(np, "renesas,has-lif"))
> +		pdata->features |= VSP1_HAS_LIF;
> +	if (of_property_read_bool(np, "renesas,has-lut"))
> +		pdata->features |= VSP1_HAS_LUT;
> +	if (of_property_read_bool(np, "renesas,has-sru"))
> +		pdata->features |= VSP1_HAS_SRU;
> +
> +	of_property_read_u32(np, "renesas,#rpf", &pdata->rpf_count);
> +	of_property_read_u32(np, "renesas,#uds", &pdata->uds_count);
> +	of_property_read_u32(np, "renesas,#wpf", &pdata->wpf_count);
>  
>  	if (pdata->rpf_count <= 0 || pdata->rpf_count > VSP1_MAX_RPF) {
> -		dev_err(&pdev->dev, "invalid number of RPF (%u)\n",
> +		dev_err(vsp1->dev, "invalid number of RPF (%u)\n",
>  			pdata->rpf_count);
>  		return -EINVAL;
>  	}
>  
>  	if (pdata->uds_count <= 0 || pdata->uds_count > VSP1_MAX_UDS) {
> -		dev_err(&pdev->dev, "invalid number of UDS (%u)\n",
> +		dev_err(vsp1->dev, "invalid number of UDS (%u)\n",
>  			pdata->uds_count);
>  		return -EINVAL;
>  	}
>  
>  	if (pdata->wpf_count <= 0 || pdata->wpf_count > VSP1_MAX_WPF) {
> -		dev_err(&pdev->dev, "invalid number of WPF (%u)\n",
> +		dev_err(vsp1->dev, "invalid number of WPF (%u)\n",
>  			pdata->wpf_count);
>  		return -EINVAL;
>  	}
> @@ -457,33 +465,6 @@ static int vsp1_validate_platform_data(struct platform_device *pdev,
>  	return 0;
>  }
>  
> -static struct vsp1_platform_data *
> -vsp1_get_platform_data(struct platform_device *pdev)
> -{
> -	struct device_node *np = pdev->dev.of_node;
> -	struct vsp1_platform_data *pdata;
> -
> -	if (!IS_ENABLED(CONFIG_OF) || np == NULL)
> -		return pdev->dev.platform_data;
> -
> -	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> -	if (pdata == NULL)
> -		return NULL;
> -
> -	if (of_property_read_bool(np, "renesas,has-lif"))
> -		pdata->features |= VSP1_HAS_LIF;
> -	if (of_property_read_bool(np, "renesas,has-lut"))
> -		pdata->features |= VSP1_HAS_LUT;
> -	if (of_property_read_bool(np, "renesas,has-sru"))
> -		pdata->features |= VSP1_HAS_SRU;
> -
> -	of_property_read_u32(np, "renesas,#rpf", &pdata->rpf_count);
> -	of_property_read_u32(np, "renesas,#uds", &pdata->uds_count);
> -	of_property_read_u32(np, "renesas,#wpf", &pdata->wpf_count);
> -
> -	return pdata;
> -}
> -
>  static int vsp1_probe(struct platform_device *pdev)
>  {
>  	struct vsp1_device *vsp1;
> @@ -499,11 +480,7 @@ static int vsp1_probe(struct platform_device *pdev)
>  	mutex_init(&vsp1->lock);
>  	INIT_LIST_HEAD(&vsp1->entities);
>  
> -	vsp1->pdata = vsp1_get_platform_data(pdev);
> -	if (vsp1->pdata == NULL)
> -		return -ENODEV;
> -
> -	ret = vsp1_validate_platform_data(pdev, vsp1->pdata);
> +	ret = vsp1_parse_dt(vsp1);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 6e057762c933..b1089d05583a 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -280,7 +280,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
>  	 * except for the WPF0 source link if a LIF is present.
>  	 */
>  	flags = MEDIA_LNK_FL_ENABLED;
> -	if (!(vsp1->pdata->features & VSP1_HAS_LIF) || index != 0)
> +	if (!(vsp1->pdata.features & VSP1_HAS_LIF) || index != 0)
>  		flags |= MEDIA_LNK_FL_IMMUTABLE;
>  
>  	ret = media_entity_create_link(&wpf->entity.subdev.entity,
> diff --git a/include/linux/platform_data/vsp1.h b/include/linux/platform_data/vsp1.h
> deleted file mode 100644
> index 63170e2614b3..000000000000
> --- a/include/linux/platform_data/vsp1.h
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -/*
> - * vsp1.h  --  R-Car VSP1 Platform Data
> - *
> - * Copyright (C) 2013 Renesas Corporation
> - *
> - * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -#ifndef __PLATFORM_VSP1_H__
> -#define __PLATFORM_VSP1_H__
> -
> -#define VSP1_HAS_LIF		(1 << 0)
> -#define VSP1_HAS_LUT		(1 << 1)
> -#define VSP1_HAS_SRU		(1 << 2)
> -
> -struct vsp1_platform_data {
> -	unsigned int features;
> -	unsigned int rpf_count;
> -	unsigned int uds_count;
> -	unsigned int wpf_count;
> -};
> -
> -#endif /* __PLATFORM_VSP1_H__ */
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
