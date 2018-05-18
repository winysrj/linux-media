Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35179 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbeERKcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 06:32:50 -0400
Message-ID: <1526639561.3948.2.camel@pengutronix.de>
Subject: Re: [PATCH v5 01/12] media: staging/imx: refactor imx media device
 probe
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Date: Fri, 18 May 2018 12:32:41 +0200
In-Reply-To: <20180518092806.3829-2-rui.silva@linaro.org>
References: <20180518092806.3829-1-rui.silva@linaro.org>
         <20180518092806.3829-2-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

thank you for refactoring, I think this is much better than having the
pretend capture-subsytem device in the DT.

I would like to get rid of the ipu_present flag, if it can be done
reasonably. For details, see below.

On Fri, 2018-05-18 at 10:27 +0100, Rui Miguel Silva wrote:
> Refactor and move media device initialization code to a new common module, so it
> can be used by other devices, this will allow for example a near to introduce
> imx7 CSI driver, to use this media device.
> 
> Also introduce a new flag to control the presence of IPU or not (imx6/5 have
> this but imx7 does not have).
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/Makefile            |   1 +
>  .../staging/media/imx/imx-media-dev-common.c  | 102 ++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c     |  89 ++++-----------
>  .../staging/media/imx/imx-media-internal-sd.c |   3 +
>  drivers/staging/media/imx/imx-media-of.c      |   6 +-
>  drivers/staging/media/imx/imx-media.h         |  18 ++++
>  6 files changed, 150 insertions(+), 69 deletions(-)
>  create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 698a4210316e..a30b3033f9a3 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  imx-media-objs := imx-media-dev.o imx-media-internal-sd.o imx-media-of.o
> +imx-media-objs += imx-media-dev-common.o
>  imx-media-common-objs := imx-media-utils.o imx-media-fim.o
>  imx-media-ic-objs := imx-ic-common.o imx-ic-prp.o imx-ic-prpencvf.o
>  
> diff --git a/drivers/staging/media/imx/imx-media-dev-common.c b/drivers/staging/media/imx/imx-media-dev-common.c
> new file mode 100644
> index 000000000000..7e9613ca5b5f
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev-common.c
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL
> +/*
> + * V4L2 Media Controller Driver for Freescale common i.MX5/6/7 SOC
> + *
> + * Copyright (c) 2018 Linaro Ltd
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + */
> +
> +#include <linux/of_graph.h>
> +#include <linux/of_platform.h>
> +#include "imx-media.h"
> +
> +static const struct v4l2_async_notifier_operations imx_media_subdev_ops = {
> +	.bound = imx_media_subdev_bound,
> +	.complete = imx_media_probe_complete,
> +};
> +
> +static const struct media_device_ops imx_media_md_ops = {
> +	.link_notify = imx_media_link_notify,
> +};
> +
> +struct imx_media_dev *imx_media_dev_init(struct device *dev, bool ipu_present)
> +{
> +	struct imx_media_dev *imxmd;
> +	int ret;
> +
> +	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
> +	if (!imxmd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	dev_set_drvdata(dev, imxmd);
> +
> +	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
> +	imxmd->md.ops = &imx_media_md_ops;
> +	imxmd->md.dev = dev;
> +
> +	imxmd->ipu_present = ipu_present;

Storing this in the imxmd is not necessary if all subdevices are tagged
correctly, see below.

> +
> +	mutex_init(&imxmd->mutex);
> +
> +	imxmd->v4l2_dev.mdev = &imxmd->md;
> +	strlcpy(imxmd->v4l2_dev.name, "imx-media",
> +		sizeof(imxmd->v4l2_dev.name));
> +
> +	media_device_init(&imxmd->md);
> +
> +	ret = v4l2_device_register(dev, &imxmd->v4l2_dev);
> +	if (ret < 0) {
> +		v4l2_err(&imxmd->v4l2_dev,
> +			 "Failed to register v4l2_device: %d\n", ret);
> +		goto cleanup;
> +	}
> +
> +	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
> +
> +	INIT_LIST_HEAD(&imxmd->vdev_list);
> +
> +	return imxmd;
> +
> +cleanup:
> +	media_device_cleanup(&imxmd->md);
> +
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_dev_init);
> +
> +int imx_media_dev_notifier_register(struct imx_media_dev *imxmd)
> +{
> +	int ret;
> +
> +	/* no subdevs? just bail */
> +	if (imxmd->notifier.num_subdevs == 0) {
> +		v4l2_err(&imxmd->v4l2_dev, "no subdevs\n");
> +		return -ENODEV;
> +	}
> +
> +	/* prepare the async subdev notifier and register it */
> +	imxmd->notifier.ops = &imx_media_subdev_ops;
> +	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
> +					   &imxmd->notifier);
> +	if (ret) {
> +		v4l2_err(&imxmd->v4l2_dev,
> +			 "v4l2_async_notifier_register failed with %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_dev_notifier_register);
> +
> +void imx_media_dev_cleanup(struct imx_media_dev *imxmd)
> +{
> +	v4l2_device_unregister(&imxmd->v4l2_dev);
> +	media_device_cleanup(&imxmd->md);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_dev_cleanup);
> +
> +void imx_media_dev_notifier_unregister(struct imx_media_dev *imxmd)
> +{
> +	v4l2_async_notifier_cleanup(&imxmd->notifier);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_dev_notifier_unregister);
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 7e7bd1c6c81b..6160070b72fb 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -87,6 +87,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
>  	struct ipu_soc *ipu;
>  	int ipu_id;
>  
> +	if (!imxmd->ipu_present)
> +		return 0;
> +

Instead of returning here right away, it would be better if
imx_media_get_ipu wouldn't be called in the first place for subdevices
that are not an IPU CSI.
The only place this function is called is from imx_media_subdev_bound
iff the sd->grp_id has one of the IMX_MEDIA_GRP_ID_CSI flags set. You
could just make sure that those bits are not set on your CSI subdevice.
Maybe rename them to IMX_MEDIA_GRP_ID_IPU_CSIx to differentiate from the
standalone CSI.

>  	ipu = dev_get_drvdata(csi_sd->dev->parent);
>  	if (!ipu) {
>  		v4l2_err(&imxmd->v4l2_dev,
> @@ -107,9 +110,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
>  }
>  
>  /* async subdev bound notifier */
> -static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
> -				  struct v4l2_subdev *sd,
> -				  struct v4l2_async_subdev *asd)
> +int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
> +			   struct v4l2_subdev *sd,
> +			   struct v4l2_async_subdev *asd)
>  {
>  	struct imx_media_dev *imxmd = notifier2dev(notifier);
>  	int ret = 0;
> @@ -293,7 +296,7 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
>  }
>  
>  /* async subdev complete notifier */
> -static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
> +int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct imx_media_dev *imxmd = notifier2dev(notifier);
>  	int ret;
> @@ -317,11 +320,6 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
>  	return media_device_register(&imxmd->md);
>  }
>  
> -static const struct v4l2_async_notifier_operations imx_media_subdev_ops = {
> -	.bound = imx_media_subdev_bound,
> -	.complete = imx_media_probe_complete,
> -};
> -
>  /*
>   * adds controls to a video device from an entity subdevice.
>   * Continues upstream from the entity's sink pads.
> @@ -365,8 +363,8 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
>  	return ret;
>  }
>  
> -static int imx_media_link_notify(struct media_link *link, u32 flags,
> -				 unsigned int notification)
> +int imx_media_link_notify(struct media_link *link, u32 flags,
> +			  unsigned int notification)
>  {
>  	struct media_entity *source = link->source->entity;
>  	struct imx_media_pad_vdev *pad_vdev;
> @@ -429,10 +427,6 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
>  	return ret;
>  }
>  
> -static const struct media_device_ops imx_media_md_ops = {
> -	.link_notify = imx_media_link_notify,
> -};
> -
>  static int imx_media_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -440,74 +434,36 @@ static int imx_media_probe(struct platform_device *pdev)
>  	struct imx_media_dev *imxmd;
>  	int ret;
>  
> -	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
> -	if (!imxmd)
> -		return -ENOMEM;
> -
> -	dev_set_drvdata(dev, imxmd);
> -
> -	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
> -	imxmd->md.ops = &imx_media_md_ops;
> -	imxmd->md.dev = dev;
> -
> -	mutex_init(&imxmd->mutex);
> -
> -	imxmd->v4l2_dev.mdev = &imxmd->md;
> -	strlcpy(imxmd->v4l2_dev.name, "imx-media",
> -		sizeof(imxmd->v4l2_dev.name));
> -
> -	media_device_init(&imxmd->md);
> -
> -	ret = v4l2_device_register(dev, &imxmd->v4l2_dev);
> -	if (ret < 0) {
> -		v4l2_err(&imxmd->v4l2_dev,
> -			 "Failed to register v4l2_device: %d\n", ret);
> -		goto cleanup;
> -	}
> -
> -	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
> -
> -	INIT_LIST_HEAD(&imxmd->vdev_list);
> +	imxmd = imx_media_dev_init(dev, true);
> +	if (IS_ERR(imxmd))
> +		return PTR_ERR(imxmd);
>  
>  	ret = imx_media_add_of_subdevs(imxmd, node);
>  	if (ret) {
>  		v4l2_err(&imxmd->v4l2_dev,
>  			 "add_of_subdevs failed with %d\n", ret);
> -		goto notifier_cleanup;
> +		goto dev_cleanup;
>  	}
>  
>  	ret = imx_media_add_internal_subdevs(imxmd);
>  	if (ret) {
>  		v4l2_err(&imxmd->v4l2_dev,
>  			 "add_internal_subdevs failed with %d\n", ret);
> -		goto notifier_cleanup;
> -	}
> -
> -	/* no subdevs? just bail */
> -	if (imxmd->notifier.num_subdevs == 0) {
> -		ret = -ENODEV;
> -		goto notifier_cleanup;
> +		goto dev_cleanup;
>  	}
>  
> -	/* prepare the async subdev notifier and register it */
> -	imxmd->notifier.ops = &imx_media_subdev_ops;
> -	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
> -					   &imxmd->notifier);
> -	if (ret) {
> -		v4l2_err(&imxmd->v4l2_dev,
> -			 "v4l2_async_notifier_register failed with %d\n", ret);
> +	ret = imx_media_dev_notifier_register(imxmd);
> +	if (ret < 0)
>  		goto del_int;
> -	}
>  
>  	return 0;
>  
>  del_int:
>  	imx_media_remove_internal_subdevs(imxmd);
> -notifier_cleanup:
> -	v4l2_async_notifier_cleanup(&imxmd->notifier);
> -	v4l2_device_unregister(&imxmd->v4l2_dev);
> -cleanup:
> -	media_device_cleanup(&imxmd->md);
> +
> +dev_cleanup:
> +	imx_media_dev_cleanup(imxmd);
> +
>  	return ret;
>  }
>  
> @@ -520,10 +476,9 @@ static int imx_media_remove(struct platform_device *pdev)
>  
>  	v4l2_async_notifier_unregister(&imxmd->notifier);
>  	imx_media_remove_internal_subdevs(imxmd);
> -	v4l2_async_notifier_cleanup(&imxmd->notifier);
> -	v4l2_device_unregister(&imxmd->v4l2_dev);
> +	imx_media_dev_notifier_unregister(imxmd);
>  	media_device_unregister(&imxmd->md);
> -	media_device_cleanup(&imxmd->md);
> +	imx_media_dev_cleanup(imxmd);
>  
>  	return 0;
>  }
> diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
> index 0fdc45dbfb76..2bcdc232369a 100644
> --- a/drivers/staging/media/imx/imx-media-internal-sd.c
> +++ b/drivers/staging/media/imx/imx-media-internal-sd.c
> @@ -238,6 +238,9 @@ int imx_media_create_internal_links(struct imx_media_dev *imxmd,
>  	struct media_pad *pad;
>  	int i, j, ret;
>  
> +	if (!imxmd->ipu_present)
> +		return 0;
> +

Same here. Just make sure imx_media_create_internal_links is never
called. Possibly rename to imx_media_create_ipu_internal_links. It is
only called from imx_media_create_links, and only for subdevices that
have one of the following sd->grp_id set:
	IMX_MEDIA_GRP_ID_VDIC
	IMX_MEDIA_GRP_ID_IC_PRP
	IMX_MEDIA_GRP_ID_IC_PRPENC
	IMX_MEDIA_GRP_ID_IC_PRPVF
	IMX_MEDIA_GRP_ID_CSI0
	IMX_MEDIA_GRP_ID_CSI1
Just make sure your subdevices use neither of these. I would be fine
with adding an IPU_ prefix to all of them.

regards
Philipp
