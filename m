Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12026 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaCaJjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 05:39:06 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <ben.dooks@codethink.co.uk>
CC: <josh.wu@atmel.com>, <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>, <linux-sh@vger.kernel.org>
Subject: Re: [RFCv3,3/3] soc_camera: initial of code
Date: Mon, 31 Mar 2014 17:28:34 +0800
Message-ID: <1396258114-30124-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1396216471-11532-3-git-send-email-ben.dooks@codethink.co.uk>
References: <1396216471-11532-3-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Ben 

Thanks for the patch, I just test atmel-isi with the your patch,
I find the "mclk" registered in soc-camera driver cannot be find
by the soc-camera sensors. See comment in below:

> [snip]

> ... ...

> +#ifdef CONFIG_OF
> +static int soc_of_bind(struct soc_camera_host *ici,
> +		       struct device_node *ep,
> +		       struct device_node *remote)
> +{
> +	struct soc_camera_device *icd;
> +	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
> +	struct soc_camera_async_client *sasc;
> +	struct soc_camera_async_subdev *sasd;
> +	struct v4l2_async_subdev **asd_array;
> +	char clk_name[V4L2_SUBDEV_NAME_SIZE];
> +	int ret;
> +
> +	/* alloacte a new subdev and add match info to it */
> +	sasd = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sasd), GFP_KERNEL);
> +	if (!sasd)
> +		return -ENOMEM;
> +
> +	asd_array = devm_kzalloc(ici->v4l2_dev.dev,
> +				 sizeof(struct v4l2_async_subdev **),
> +				 GFP_KERNEL);
> +	if (!asd_array)
> +		return -ENOMEM;
> +
> +	sasd->asd.match.of.node = remote;
> +	sasd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +	asd_array[0] = &sasd->asd;
> +
> +	/* Or shall this be managed by the soc-camera device? */
> +	sasc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sasc), GFP_KERNEL);
> +	if (!sasc)
> +		return -ENOMEM;
> +
> +	/* HACK: just need a != NULL */
> +	sdesc.host_desc.board_info = ERR_PTR(-ENODATA);
> +
> +	ret = soc_camera_dyn_pdev(&sdesc, sasc);
> +	if (ret < 0)
> +		return ret;
> +
> +	sasc->sensor = &sasd->asd;
> +
> +	icd = soc_camera_add_pdev(sasc);
> +	if (!icd) {
> +		platform_device_put(sasc->pdev);
> +		return -ENOMEM;
> +	}
> +
> +	//sasc->notifier.subdevs = asd;
> +	sasc->notifier.subdevs = asd_array;
> +	sasc->notifier.num_subdevs = 1;
> +	sasc->notifier.bound = soc_camera_async_bound;
> +	sasc->notifier.unbind = soc_camera_async_unbind;
> +	sasc->notifier.complete = soc_camera_async_complete;
> +
> +	icd->sasc = sasc;
> +	icd->parent = ici->v4l2_dev.dev;
> +
> +	snprintf(clk_name, sizeof(clk_name), "of-%s",
> +		 of_node_full_name(remote));

The clk_name you register here is a OF string, but for the i2c sensors, which
call the v4l2_clk_get by using dev_name(&client->dev). It is format like:
"1-0030", combined i2c adaptor ID and addr.
So the i2c sensor can not find this registered mclk as the name is not match.

Best Regards,
Josh Wu

> +
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
> +	if (IS_ERR(icd->clk)) {
> +		ret = PTR_ERR(icd->clk);
> +		goto eclkreg;
> +	}
> +


> [snip]
