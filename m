Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C26C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C0D2081B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbfBFPgN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:36:13 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54821 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728064AbfBFPgM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 10:36:12 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rPF5giHClNR5yrPF7gwKCr; Wed, 06 Feb 2019 16:36:08 +0100
Subject: Re: [PATCH v14 01/13] media: staging/imx: refactor imx media device
 probe
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
 <20190206151328.21629-2-rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <50cb0aad-0aa4-620e-2e3c-bd08a8c9cec7@xs4all.nl>
Date:   Wed, 6 Feb 2019 16:36:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190206151328.21629-2-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEYOtxPUz9t8qzRuc+43j9++Tm8dMOkkrcmGl/kszs7AFPijRfaTfoajORi1yXRBXyZBdzkl9Wg8K5/ayklHYtpimuD9mPAXUCIAjSSk4e12VwykOTDj
 GRMlpxWhkt6uAf0zDuPxJFgptoV1qdF4qEJznYco9mnslgX7w4niZIYMofzFbLsKGrFRZZy1zaiEoUBv//le8Gk9962QqZLXaXgqUlM3ogrMulfFGxFHZ0Mw
 7mVBIaRTOluqOczr8So3PMEzON4khAzGH7VbiwYwN2770Eh6twbXHg5hU6j0z++Gkghl7BrDQHnIkIr1pm1Tn6uiMbsHEuwOvafMWhXSAkBm0LSaO9VeEcaq
 Lz8qNC/4S/822kKhdzL++ngLL69EDVczjlWvBFDIxzqNzXh2wmj91Ml0MhlL8eVmwuwUtODUf9jJH78RFsWs96c2VXIRy9AFv3mrWdAPmnDfjwQbZGBl/NJ3
 L5V1TBfP0JyJ/e7u+dFrDe6DhTxXkPqrdVvI2sXzv23I6IyxnzHmCLYtuVagvZn1xKFiwE4dBxIyyFCI
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/6/19 4:13 PM, Rui Miguel Silva wrote:
> Refactor and move media device initialization code to a new common
> module, so it can be used by other devices, this will allow for example
> a near to introduce imx7 CSI driver, to use this media device.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/Makefile            |  1 +
>  .../staging/media/imx/imx-media-dev-common.c  | 90 +++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c     | 86 ++++--------------
>  drivers/staging/media/imx/imx-media-of.c      |  6 +-
>  drivers/staging/media/imx/imx-media.h         | 14 +++
>  5 files changed, 127 insertions(+), 70 deletions(-)
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
> index 000000000000..28bcb31cf6ca
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev-common.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL

WARNING: 'SPDX-License-Identifier: GPL' is not supported in LICENSES/...
#18: FILE: drivers/staging/media/imx/imx-media-dev-common.c:1:
+// SPDX-License-Identifier: GPL

You no doubt mean GPL-2.0. Just repost this patch with this change.

Regards,

	Hans

> +/*
> + * V4L2 Media Controller Driver for Freescale common i.MX5/6/7 SOC
> + *
> + * Copyright (c) 2019 Linaro Ltd
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
> +struct imx_media_dev *imx_media_dev_init(struct device *dev)
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
> +	mutex_init(&imxmd->mutex);
> +
> +	imxmd->v4l2_dev.mdev = &imxmd->md;
> +	imxmd->v4l2_dev.notify = imx_media_notify;
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
> +	v4l2_async_notifier_init(&imxmd->notifier);
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
> +	if (list_empty(&imxmd->notifier.asd_list)) {
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
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 25e916562c66..c42bddd78906 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -116,9 +116,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
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
> @@ -302,7 +302,7 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
>  }
>  
>  /* async subdev complete notifier */
> -static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
> +int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct imx_media_dev *imxmd = notifier2dev(notifier);
>  	int ret;
> @@ -326,11 +326,6 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
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
> @@ -374,8 +369,8 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
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
> @@ -438,13 +433,8 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
>  	return ret;
>  }
>  
> -static const struct media_device_ops imx_media_md_ops = {
> -	.link_notify = imx_media_link_notify,
> -};
> -
> -static void imx_media_notify(struct v4l2_subdev *sd,
> -			     unsigned int notification,
> -			     void *arg)
> +void imx_media_notify(struct v4l2_subdev *sd, unsigned int notification,
> +		      void *arg)
>  {
>  	struct media_entity *entity = &sd->entity;
>  	int i;
> @@ -472,77 +462,37 @@ static int imx_media_probe(struct platform_device *pdev)
>  	struct imx_media_dev *imxmd;
>  	int ret;
>  
> -	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
> -	if (!imxmd)
> -		return -ENOMEM;
> -
> -	dev_set_drvdata(dev, imxmd);
> -
> -	strscpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
> -	imxmd->md.ops = &imx_media_md_ops;
> -	imxmd->md.dev = dev;
> -
> -	mutex_init(&imxmd->mutex);
> -
> -	imxmd->v4l2_dev.mdev = &imxmd->md;
> -	imxmd->v4l2_dev.notify = imx_media_notify;
> -	strscpy(imxmd->v4l2_dev.name, "imx-media",
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
> -
> -	v4l2_async_notifier_init(&imxmd->notifier);
> +	imxmd = imx_media_dev_init(dev);
> +	if (IS_ERR(imxmd))
> +		return PTR_ERR(imxmd);
>  
>  	ret = imx_media_add_of_subdevs(imxmd, node);
>  	if (ret) {
>  		v4l2_err(&imxmd->v4l2_dev,
>  			 "add_of_subdevs failed with %d\n", ret);
> -		goto notifier_cleanup;
> +		goto cleanup;
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
> -	if (list_empty(&imxmd->notifier.asd_list)) {
> -		ret = -ENODEV;
> -		goto notifier_cleanup;
> +		goto cleanup;
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
> +	if (ret)
>  		goto del_int;
> -	}
>  
>  	return 0;
>  
>  del_int:
>  	imx_media_remove_internal_subdevs(imxmd);
> -notifier_cleanup:
> +cleanup:
>  	v4l2_async_notifier_cleanup(&imxmd->notifier);
>  	v4l2_device_unregister(&imxmd->v4l2_dev);
> -cleanup:
>  	media_device_cleanup(&imxmd->md);
> +
>  	return ret;
>  }
>  
> @@ -556,8 +506,8 @@ static int imx_media_remove(struct platform_device *pdev)
>  	v4l2_async_notifier_unregister(&imxmd->notifier);
>  	imx_media_remove_internal_subdevs(imxmd);
>  	v4l2_async_notifier_cleanup(&imxmd->notifier);
> -	v4l2_device_unregister(&imxmd->v4l2_dev);
>  	media_device_unregister(&imxmd->md);
> +	v4l2_device_unregister(&imxmd->v4l2_dev);
>  	media_device_cleanup(&imxmd->md);
>  
>  	return 0;
> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
> index a01327f6e045..03446335ac03 100644
> --- a/drivers/staging/media/imx/imx-media-of.c
> +++ b/drivers/staging/media/imx/imx-media-of.c
> @@ -20,7 +20,8 @@
>  #include <video/imx-ipu-v3.h>
>  #include "imx-media.h"
>  
> -static int of_add_csi(struct imx_media_dev *imxmd, struct device_node *csi_np)
> +int imx_media_of_add_csi(struct imx_media_dev *imxmd,
> +			 struct device_node *csi_np)
>  {
>  	int ret;
>  
> @@ -45,6 +46,7 @@ static int of_add_csi(struct imx_media_dev *imxmd, struct device_node *csi_np)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(imx_media_of_add_csi);
>  
>  int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
>  			     struct device_node *np)
> @@ -57,7 +59,7 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
>  		if (!csi_np)
>  			break;
>  
> -		ret = of_add_csi(imxmd, csi_np);
> +		ret = imx_media_of_add_csi(imxmd, csi_np);
>  		of_node_put(csi_np);
>  		if (ret)
>  			return ret;
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index 7a0e658753f0..0d1c6bbf1109 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -228,6 +228,18 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
>  			       struct fwnode_handle *fwnode,
>  			       struct platform_device *pdev);
>  
> +int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
> +			   struct v4l2_subdev *sd,
> +			   struct v4l2_async_subdev *asd);
> +int imx_media_link_notify(struct media_link *link, u32 flags,
> +			  unsigned int notification);
> +void imx_media_notify(struct v4l2_subdev *sd, unsigned int notification,
> +		      void *arg);
> +int imx_media_probe_complete(struct v4l2_async_notifier *notifier);
> +
> +struct imx_media_dev *imx_media_dev_init(struct device *dev);
> +int imx_media_dev_notifier_register(struct imx_media_dev *imxmd);
> +
>  /* imx-media-fim.c */
>  struct imx_media_fim;
>  void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
> @@ -251,6 +263,8 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
>  			      struct v4l2_subdev *sd);
>  int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
>  				  struct v4l2_subdev *csi);
> +int imx_media_of_add_csi(struct imx_media_dev *imxmd,
> +			 struct device_node *csi_np);
>  
>  /* imx-media-capture.c */
>  struct imx_media_video_dev *
> 

