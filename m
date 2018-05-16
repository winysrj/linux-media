Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38454 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbeEPUcw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 16:32:52 -0400
Received: by mail-wr0-f193.google.com with SMTP id 94-v6so3237265wrf.5
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 13:32:51 -0700 (PDT)
Date: Wed, 16 May 2018 22:32:49 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/4] media: rcar-vin: Parse digital input in mc-path
Message-ID: <20180516203249.GB17838@bigcity.dyn.berto.se>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526473016-30559-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526473016-30559-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work!

First let me apologies for the use of the keyword 'digital' in the 
driver it should have been parallel... Someday we should remedy this.

If you touch any parts of the code where such a transition make sens I 
would not complain about the intermixed use of digital/parallel. Once 
your work is done we could follow up with a cleanup patch to complete 
the transition. Or if you rather stick with digital here I'm fine with 
that too.

On 2018-05-16 14:16:53 +0200, Jacopo Mondi wrote:
> Add support for digital input subdevices to Gen-3 rcar-vin.
> The Gen-3, media-controller compliant, version has so far only accepted
> CSI-2 input subdevices. Remove assumptions on the supported bus_type and
> accepted number of subdevices, and allow digital input connections on port@0.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 99 +++++++++++++++++++++++------
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 15 +++++
>  2 files changed, 93 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d3072e1..0ea21ab 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -562,7 +562,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  		return ret;
>  
>  	if (!vin->digital)
> -		return -ENODEV;
> +		return -ENOTCONN;
>  
>  	vin_dbg(vin, "Found digital subdevice %pOF\n",
>  		to_of_node(vin->digital->asd.match.fwnode));
> @@ -703,15 +703,13 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
>  {
>  	struct rvin_dev *vin = dev_get_drvdata(dev);
>  
> -	if (vep->base.port != 1 || vep->base.id >= RVIN_CSI_MAX)
> +	if (vep->base.port != RVIN_PORT_CSI2 || vep->base.id >= RVIN_CSI_MAX)

I don't like this RVIN_PORT_CSI2. It makes the code harder to read as I 
have have to go and lookup which port RVIN_PORT_CSI2 represents. I would 
rater just keep vep->base.port != 1 as I think it's much clearer whats 
going on. And it's not as we will move the CSI-2 input to a different 
port as it's described in the bindings.

>  		return -EINVAL;
>  
>  	if (!of_device_is_available(to_of_node(asd->match.fwnode))) {
> -
>  		vin_dbg(vin, "OF device %pOF disabled, ignoring\n",
>  			to_of_node(asd->match.fwnode));
>  		return -ENOTCONN;
> -
>  	}
>  
>  	if (vin->group->csi[vep->base.id].fwnode) {
> @@ -720,6 +718,8 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
>  		return -ENOTCONN;
>  	}
>  
> +	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> +	vin->mbus_cfg.flags = 0;

I like this move of mbus_cfg handling! Makes the two cases more aligned 
which are good. Unfortunately I fear it needs more work :-(

With this series addition of parallel input support. There are now two 
input types CSI-2 and parallel which can be changed at runtime for the 
same VIN. The mbus connected to the VIN will therefor be different 
depending on which media graph link is connected to a particular VIN and 
this effects hardware configuration, see 'vin->mbus_cfg.type == 
V4L2_MBUS_CSI2' in rvin_setup().

Maybe the best solution is to move mbus_cfg into struct 
rvin_graph_entity, rename that struct rvin_parallel_input and cache the 
parallel input settings in there, much like we do today for the pads.
Remove mbus_cfg from struct rvin_dev and replace it with a bool flag 
(input_csi or similar)?

In rvin_setup() use this flag to check which input type is in use and if 
it's needed fetch mbus_cfg from this cache. Then in 
rvin_group_link_notify() you could handle this input_csi flag depending 
on which link is activated. But I'm open to other solutions.

>  	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
>  
>  	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
> @@ -742,7 +742,14 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  		return -EINVAL;
>  	}
>  
> -	/* If not all VIN's are registered don't register the notifier. */
> +	/* Collect digital subdevices in this VIN device node. */
> +	ret = rvin_digital_graph_init(vin);
> +	if (ret < 0 && ret != -ENOTCONN) {
> +		mutex_unlock(&vin->group->lock);
> +		return ret;
> +	}

Why do you need to add this here? Is it not better to in 
rcar_vin_probe() do something like:

    ret = rvin_digital_graph_init(vin);
    if (ret < 0)
        goto error;

    if (vin->info->use_mc) {
        ret = rvin_mc_init(vin);
        if (ret < 0)
            goto error;
    }

That way we can try and keep to two code paths separated and at lest for 
me that increases readability a lot.

> +
> +	/* Only the last registered VIN instance collects CSI-2 subdevices. */
>  	for (i = 0; i < RCAR_VIN_NUM; i++)
>  		if (vin->group->vin[i])
>  			count++;
> @@ -752,22 +759,33 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  		return 0;
>  	}
>  
> -	/*
> -	 * Have all VIN's look for subdevices. Some subdevices will overlap
> -	 * but the parser function can handle it, so each subdevice will
> -	 * only be registered once with the notifier.
> -	 */
> -
> -	vin->group->notifier = &vin->notifier;
> -
> +	vin->group->notifier = NULL;
>  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> +		struct v4l2_async_notifier *notifier;
> +
>  		if (!vin->group->vin[i])
>  			continue;
>  
> +		/* This VIN alread has digitial subdevices registered, skip. */
> +		notifier = &vin->group->vin[i]->notifier;
> +		if (notifier->num_subdevs)
> +			continue;

I'm afraid this won't work :-(

v4l2_async_notifier_parse_fwnode_endpoints_by_port() must be called on 
all VINs in the group using the same notifier else there is a potential 
subdevices can be missed.

> +
> +		/* This VIN instance notifier will collect all CSI-2 subdevs. */
> +		if (!vin->group->notifier) {
> +			vin->group->v4l2_dev = &vin->group->vin[i]->v4l2_dev;

The vin->group structure should only hold data which is as much as 
possible only associate with the group. This feels like a step backwards 
:-(

It's a real shame that v4l2_async_notifier_register() needs a video 
device at all else we could make the notifier part of the struct 
rvin_group and then have a specific VIN local notifier for the parallel 
inputs.

> +			vin->group->notifier = &vin->group->vin[i]->notifier;
> +		}
> +
> +		/*
> +		 * Some CSI-2 subdevices will overlap but the parser function
> +		 * can handle it, so each subdevice will only be registered
> +		 * once with the group notifier.
> +		 */
>  		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  				vin->group->vin[i]->dev, vin->group->notifier,
> -				sizeof(struct v4l2_async_subdev), 1,
> -				rvin_mc_parse_of_endpoint);
> +				sizeof(struct v4l2_async_subdev),
> +				RVIN_PORT_CSI2, rvin_mc_parse_of_endpoint);
>  		if (ret) {
>  			mutex_unlock(&vin->group->lock);
>  			return ret;
> @@ -776,25 +794,64 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  
>  	mutex_unlock(&vin->group->lock);
>  
> -	vin->group->notifier->ops = &rvin_group_notify_ops;
> +	/*
> +	 * Go and register all notifiers for digital subdevs, and
> +	 * the group notifier for CSI-2 subdevs, if any.
> +	 */
> +	for (i = 0; i < RCAR_VIN_NUM; i++) {
> +		struct rvin_dev *ivin = vin->group->vin[i];
> +		struct v4l2_async_notifier *notifier;
>  
> -	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> +		if (!ivin)
> +			continue;
> +
> +		notifier = &ivin->notifier;
> +		if (notifier == vin->group->notifier ||
> +		    !notifier->num_subdevs)
> +			continue;
> +
> +		notifier->ops = &rvin_digital_notify_ops;
> +		ret = v4l2_async_notifier_register(&ivin->v4l2_dev, notifier);
> +		if (ret < 0) {
> +			vin_err(ivin, "Notifier registration failed\n");
> +			goto error_unregister_notifiers;
> +		}
> +	}
> +
> +	if (!vin->group->notifier || !vin->group->notifier->num_subdevs)
> +		return 0;
> +
> +	vin->group->notifier->ops = &rvin_group_notify_ops;
> +	ret = v4l2_async_notifier_register(vin->group->v4l2_dev,
> +					   vin->group->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
>  		return ret;
>  	}
>  
>  	return 0;
> +
> +error_unregister_notifiers:
> +	for (; i > 0; i--) {

As this is an error path it feels a bit to optimised.

    for (i = 0; i < RCAR_VIN_NUM; i++)

With the same checks as bellow would work just as good with the checks 
you have bellow. v4l2_async_notifier_unregister() checks if it's called 
with a notifier that have not been registered and does the right thing.

> +		struct v4l2_async_notifier *notifier;
> +
> +		if (!vin->group->vin[i - 1])
> +			continue;
> +
> +		notifier = &vin->group->vin[i - 1]->notifier;
> +		if (!notifier->num_subdevs)
> +			continue;
> +
> +		v4l2_async_notifier_unregister(notifier);
> +	}
> +
> +	return ret;
>  }
>  
>  static int rvin_mc_init(struct rvin_dev *vin)
>  {
>  	int ret;
>  
> -	/* All our sources are CSI-2 */
> -	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> -	vin->mbus_cfg.flags = 0;
> -
>  	vin->pad.flags = MEDIA_PAD_FL_SINK;
>  	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
>  	if (ret)
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index c2aef78..836751e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -52,6 +52,19 @@ enum rvin_csi_id {
>  };
>  
>  /**
> + * enum rvin_port_id
> + *
> + * List the available VIN port functions.
> + *
> + * RVIN_PORT_DIGITAL	- Input port for digital video connection
> + * RVIN_PORT_CSI2	- Input port for CSI-2 video connection
> + */
> +enum rvin_port_id {
> +	RVIN_PORT_DIGITAL,
> +	RVIN_PORT_CSI2
> +};
> +
> +/**
>   * STOPPED  - No operation in progress
>   * RUNNING  - Operation in progress have buffers
>   * STOPPING - Stopping operation
> @@ -225,6 +238,7 @@ struct rvin_dev {
>   *
>   * @lock:		protects the count, notifier, vin and csi members
>   * @count:		number of enabled VIN instances found in DT
> + * @v4l2_dev:		pointer to the group v4l2 device

I pray there is a away to avoid adding this here, it feels awkward :-(

>   * @notifier:		pointer to the notifier of a VIN which handles the
>   *			groups async sub-devices.
>   * @vin:		VIN instances which are part of the group
> @@ -238,6 +252,7 @@ struct rvin_group {
>  
>  	struct mutex lock;
>  	unsigned int count;
> +	struct v4l2_device *v4l2_dev;
>  	struct v4l2_async_notifier *notifier;
>  	struct rvin_dev *vin[RCAR_VIN_NUM];
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
