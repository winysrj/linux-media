Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:42081 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753075AbeFDMw7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:52:59 -0400
Received: by mail-lf0-f67.google.com with SMTP id v135-v6so25037194lfa.9
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:52:58 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:52:56 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v5 06/10] media: rcar-vin: Parse parallel input on Gen3
Message-ID: <20180604125256.GL19674@bigcity.dyn.berto.se>
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527583688-314-7-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527583688-314-7-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-29 10:48:04 +0200, Jacopo Mondi wrote:
> The rcar-vin driver so far had a mutually exclusive code path for
> handling parallel and CSI-2 video input subdevices, with only the CSI-2
> use case supporting media-controller. As we add support for parallel
> inputs to Gen3 media-controller compliant code path now parse both port@0
> and port@1, handling the media-controller use case in the parallel
> bound/unbind notifier operations.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

I think this patch looks fine except the label name mismatch. I think 
it's ready but will hold off with my tag until I can review a complete 
version of the patch :-)

> 
> ---
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
> 
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 53 +++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index fc98986..c1d6feb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -399,6 +399,11 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
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
> @@ -460,10 +465,12 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
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
> @@ -552,18 +559,19 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
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
> @@ -1084,20 +1092,35 @@ static int rcar_vin_probe(struct platform_device *pdev)
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
> +error_group_unreg:
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
> +error_dma_unreg:
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
