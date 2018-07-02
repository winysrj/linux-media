Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41257 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbeGBSI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 14:08:26 -0400
Received: by mail-lj1-f194.google.com with SMTP id a17-v6so10094431ljd.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 11:08:25 -0700 (PDT)
Date: Mon, 2 Jul 2018 20:08:23 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 06/10] media: rcar-vin: Parse parallel input on Gen3
Message-ID: <20180702180823.GY5237@bigcity.dyn.berto.se>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528796612-7387-7-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1528796612-7387-7-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-06-12 11:43:28 +0200, Jacopo Mondi wrote:
> The rcar-vin driver so far had a mutually exclusive code path for
> handling parallel and CSI-2 video input subdevices, with only the CSI-2
> use case supporting media-controller. As we add support for parallel
> inputs to Gen3 media-controller compliant code path now parse both port@0
> and port@1, handling the media-controller use case in the parallel
> bound/unbind notifier operations.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> r5 -> r6:
> - Fix 'error_group_unregister' and 'error_dma_unregister' label names
> 
> v4 -> v5:
> - Re-group rvin_mc_init() function
> - Add error_group_unreg error path to clean up group registration
> - Change rvin_parallel_init() return type to make sure Gen2 works as before
> 
> v3 -> v4:
> - Change the mc/parallel initialization order. Initialize mc first, then
>   parallel
> - As a consequence no need to delay parallel notifiers registration, the
>   media controller is set up already when parallel input got parsed,
>   this greatly simplify the group notifier complete callback.
> ---
> 
>  drivers/media/platform/rcar-vin/rcar-core.c | 53 +++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 39bb193..91ccaf8 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -397,6 +397,11 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
>  	vin->parallel->sink_pad = ret < 0 ? 0 : ret;
> 
> +	if (vin->info->use_mc) {
> +		vin->parallel->subdev = subdev;
> +		return 0;
> +	}
> +
>  	/* Find compatible subdevices mbus format */
>  	vin->mbus_code = 0;
>  	code.index = 0;
> @@ -458,10 +463,12 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
>  static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
>  {
>  	rvin_v4l2_unregister(vin);
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> -
> -	vin->vdev.ctrl_handler = NULL;
>  	vin->parallel->subdev = NULL;
> +
> +	if (!vin->info->use_mc) {
> +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +		vin->vdev.ctrl_handler = NULL;
> +	}
>  }
> 
>  static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
> @@ -550,18 +557,19 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
>  	return 0;
>  }
> 
> -static int rvin_parallel_graph_init(struct rvin_dev *vin)
> +static int rvin_parallel_init(struct rvin_dev *vin)
>  {
>  	int ret;
> 
> -	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> -		vin->dev, &vin->notifier,
> -		sizeof(struct rvin_parallel_entity), rvin_parallel_parse_v4l2);
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> +		vin->dev, &vin->notifier, sizeof(struct rvin_parallel_entity),
> +		0, rvin_parallel_parse_v4l2);
>  	if (ret)
>  		return ret;
> 
> +	/* If using mc, it's fine not to have any input registered. */
>  	if (!vin->parallel)
> -		return -ENODEV;
> +		return vin->info->use_mc ? 0 : -ENODEV;
> 
>  	vin_dbg(vin, "Found parallel subdevice %pOF\n",
>  		to_of_node(vin->parallel->asd.match.fwnode));
> @@ -1074,20 +1082,35 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  		return ret;
> 
>  	platform_set_drvdata(pdev, vin);
> -	if (vin->info->use_mc)
> +
> +	if (vin->info->use_mc) {
>  		ret = rvin_mc_init(vin);
> -	else
> -		ret = rvin_parallel_graph_init(vin);
> -	if (ret < 0)
> -		goto error;
> +		if (ret)
> +			goto error_dma_unregister;
> +	}
> +
> +	ret = rvin_parallel_init(vin);
> +	if (ret)
> +		goto error_group_unregister;
> 
>  	pm_suspend_ignore_children(&pdev->dev, true);
>  	pm_runtime_enable(&pdev->dev);
> 
>  	return 0;
> -error:
> +
> +error_group_unregister:
> +	if (vin->info->use_mc) {
> +		mutex_lock(&vin->group->lock);
> +		if (&vin->v4l2_dev == vin->group->notifier.v4l2_dev) {
> +			v4l2_async_notifier_unregister(&vin->group->notifier);
> +			v4l2_async_notifier_cleanup(&vin->group->notifier);
> +		}
> +		mutex_unlock(&vin->group->lock);
> +		rvin_group_put(vin);
> +	}
> +
> +error_dma_unregister:
>  	rvin_dma_unregister(vin);
> -	v4l2_async_notifier_cleanup(&vin->notifier);
> 
>  	return ret;
>  }
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
