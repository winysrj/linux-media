Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B72EC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 11:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FBC221872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 11:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfAXLQz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 06:16:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:28242 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfAXLQy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 06:16:54 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2019 03:16:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,515,1539673200"; 
   d="scan'208";a="140920650"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2019 03:16:50 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id AAE1D20826; Thu, 24 Jan 2019 13:16:49 +0200 (EET)
Date:   Thu, 24 Jan 2019 13:16:48 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Rui Miguel Silva <rui.silva@linaro.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v10 01/13] media: staging/imx: refactor imx media device
 probe
Message-ID: <20190124111648.gxm57hn42umqwzw4@paasikivi.fi.intel.com>
References: <20190123105222.2378-1-rui.silva@linaro.org>
 <20190123105222.2378-2-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123105222.2378-2-rui.silva@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rui,

On Wed, Jan 23, 2019 at 10:52:10AM +0000, Rui Miguel Silva wrote:
> Refactor and move media device initialization code to a new common
> module, so it can be used by other devices, this will allow for example
> a near to introduce imx7 CSI driver, to use this media device.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/Makefile            |   1 +
>  .../staging/media/imx/imx-media-dev-common.c  | 102 ++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c     |  88 ++++-----------
>  drivers/staging/media/imx/imx-media-of.c      |   6 +-
>  drivers/staging/media/imx/imx-media.h         |  15 +++
>  5 files changed, 141 insertions(+), 71 deletions(-)
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
> index 000000000000..55fe94fb72f2
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

Is the naming of the function intentional? I'd say adding an oddly named
wrapper for v4l2_async_notifier_cleanup() hardly makes the code more
readable. I'd just call the function directly instead; same for
imx_media_dev_cleanup().

> +}
> +EXPORT_SYMBOL_GPL(imx_media_dev_notifier_unregister);
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 4b344a4a3706..21f65af5c738 100644
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
> @@ -438,10 +433,6 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
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
> @@ -449,76 +440,36 @@ static int imx_media_probe(struct platform_device *pdev)
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
> -	if (list_empty(&imxmd->notifier.asd_list)) {
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
> +	if (ret)
>  		goto del_int;
> -	}
>  
>  	return 0;
>  
>  del_int:
>  	imx_media_remove_internal_subdevs(imxmd);
> -notifier_cleanup:
> -	v4l2_async_notifier_cleanup(&imxmd->notifier);

If you remove this one, you'll miss cleaning up the notifier afterwards: an
initialised async notifier needs to be cleaned up in the end.

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
> @@ -531,10 +482,9 @@ static int imx_media_remove(struct platform_device *pdev)
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
> index bc7feb81937c..b7f11c36461b 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -226,6 +226,19 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
>  			       struct fwnode_handle *fwnode,
>  			       struct platform_device *pdev);
>  
> +int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
> +			   struct v4l2_subdev *sd,
> +			   struct v4l2_async_subdev *asd);
> +int imx_media_link_notify(struct media_link *link, u32 flags,
> +			  unsigned int notification);
> +int imx_media_probe_complete(struct v4l2_async_notifier *notifier);
> +
> +struct imx_media_dev *imx_media_dev_init(struct device *dev);
> +int imx_media_dev_notifier_register(struct imx_media_dev *imxmd);
> +
> +void imx_media_dev_cleanup(struct imx_media_dev *imxmd);
> +void imx_media_dev_notifier_unregister(struct imx_media_dev *imxmd);
> +
>  /* imx-media-fim.c */
>  struct imx_media_fim;
>  void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
> @@ -249,6 +262,8 @@ int imx_media_create_of_links(struct imx_media_dev *imxmd,
>  			      struct v4l2_subdev *sd);
>  int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
>  				  struct v4l2_subdev *csi);
> +int imx_media_of_add_csi(struct imx_media_dev *imxmd,
> +			 struct device_node *csi_np);
>  
>  /* imx-media-capture.c */
>  struct imx_media_video_dev *

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
