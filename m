Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32831 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031548AbeEXKOz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:14:55 -0400
Received: by mail-wr0-f193.google.com with SMTP id a15-v6so2062489wrm.0
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 03:14:54 -0700 (PDT)
Date: Thu, 24 May 2018 12:14:52 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 3/9] media: rcar-vin: Create a group notifier
Message-ID: <20180524101452.GC31036@bigcity.dyn.berto.se>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526654445-10702-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-18 16:40:39 +0200, Jacopo Mondi wrote:
> As CSI-2 subdevices are shared between several VIN instances, a shared
> notifier to collect the CSI-2 async subdevices is required. So far, the
> rcar-vin driver used the notifier of the last VIN instance to probe but
> with the forth-coming introduction of parallel input subdevices support
> in mc-compliant code path, each VIN may register its own notifier if any
> parallel subdevice is connected there.
> 
> To avoid registering a notifier twice (once for parallel subdev and one
> for the CSI-2 subdevs) create a group notifier, shared by all the VIN
> instances.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 39 +++++++++++------------------
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  7 +++---
>  2 files changed, 18 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 1aadd90..c6e603f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -583,7 +583,7 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
>  
>  static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
>  {
> -	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
>  	const struct rvin_group_route *route;
>  	unsigned int i;
>  	int ret;
> @@ -649,7 +649,7 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
>  				     struct v4l2_subdev *subdev,
>  				     struct v4l2_async_subdev *asd)
>  {
> -	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
>  	unsigned int i;
>  
>  	for (i = 0; i < RCAR_VIN_NUM; i++)
> @@ -673,7 +673,7 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_subdev *subdev,
>  				   struct v4l2_async_subdev *asd)
>  {
> -	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
>  	unsigned int i;
>  
>  	mutex_lock(&vin->group->lock);
> @@ -734,12 +734,6 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  
>  	mutex_lock(&vin->group->lock);
>  
> -	/* If there already is a notifier something has gone wrong, bail out. */
> -	if (WARN_ON(vin->group->notifier)) {
> -		mutex_unlock(&vin->group->lock);
> -		return -EINVAL;
> -	}
> -
>  	/* If not all VIN's are registered don't register the notifier. */
>  	for (i = 0; i < RCAR_VIN_NUM; i++)
>  		if (vin->group->vin[i])
> @@ -751,19 +745,16 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  	}
>  
>  	/*
> -	 * Have all VIN's look for subdevices. Some subdevices will overlap
> -	 * but the parser function can handle it, so each subdevice will
> -	 * only be registered once with the notifier.
> +	 * Have all VIN's look for CSI-2 subdevices. Some subdevices will
> +	 * overlap but the parser function can handle it, so each subdevice
> +	 * will only be registered once with the group notifier.
>  	 */
> -
> -	vin->group->notifier = &vin->notifier;
> -
>  	for (i = 0; i < RCAR_VIN_NUM; i++) {
>  		if (!vin->group->vin[i])
>  			continue;
>  
>  		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> -				vin->group->vin[i]->dev, vin->group->notifier,
> +				vin->group->vin[i]->dev, &vin->group->notifier,
>  				sizeof(struct v4l2_async_subdev), 1,
>  				rvin_mc_parse_of_endpoint);
>  		if (ret) {
> @@ -774,9 +765,12 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  
>  	mutex_unlock(&vin->group->lock);
>  
> -	vin->group->notifier->ops = &rvin_group_notify_ops;
> +	if (!vin->group->notifier.num_subdevs)
> +		return 0;
>  
> -	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> +	vin->group->notifier.ops = &rvin_group_notify_ops;
> +	ret = v4l2_async_notifier_register(&vin->v4l2_dev,
> +					   &vin->group->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
>  		return ret;
> @@ -1112,15 +1106,10 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  	v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);

If the vin being removed is the one which v4l2_dev is used to register 
the group you should unregister the group notifier here. You got this 
for 'free' with the above code before this change so it's easy to miss 
:-)

>  
> -	if (vin->info->use_mc) {
> -		mutex_lock(&vin->group->lock);
> -		if (vin->group->notifier == &vin->notifier)
> -			vin->group->notifier = NULL;
> -		mutex_unlock(&vin->group->lock);
> +	if (vin->info->use_mc)
>  		rvin_group_put(vin);
> -	} else {
> +	else
>  		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> -	}
>  
>  	rvin_dma_unregister(vin);
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 755ac3c..7d0ffe08 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -209,6 +209,8 @@ struct rvin_dev {
>  	v4l2_std_id std;
>  };
>  
> +#define v4l2_dev_to_vin(d)	container_of(d, struct rvin_dev, v4l2_dev)

I think you should either define this in rcar-core.c (see 
notifier_to_vin()) or use the container_of() directly to limit it's 
scope.

Over all I'm not happy about my initial usage these defines in the 
driver, I was young and dumb :-) I won't object if you wish to keep it 
but then please move it to the .c file.

> +
>  #define vin_to_source(vin)		((vin)->parallel->subdev)

This in particular I hate and at some point I hope to remove it or move 
it to rcar-v4l2.c. :-) But that is a task for later and not related to 
your patch-set.

>  
>  /* Debug */
> @@ -225,8 +227,7 @@ struct rvin_dev {
>   *
>   * @lock:		protects the count, notifier, vin and csi members
>   * @count:		number of enabled VIN instances found in DT
> - * @notifier:		pointer to the notifier of a VIN which handles the
> - *			groups async sub-devices.
> + * @notifier:		group notifier for CSI-2 async subdevices
>   * @vin:		VIN instances which are part of the group
>   * @csi:		array of pairs of fwnode and subdev pointers
>   *			to all CSI-2 subdevices.
> @@ -238,7 +239,7 @@ struct rvin_group {
>  
>  	struct mutex lock;
>  	unsigned int count;
> -	struct v4l2_async_notifier *notifier;
> +	struct v4l2_async_notifier notifier;
>  	struct rvin_dev *vin[RCAR_VIN_NUM];
>  
>  	struct {
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
