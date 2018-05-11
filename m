Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32957 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKLB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 07:01:27 -0400
Received: by mail-lf0-f66.google.com with SMTP id h9-v6so6327278lfi.0
        for <linux-media@vger.kernel.org>; Fri, 11 May 2018 04:01:26 -0700 (PDT)
Date: Fri, 11 May 2018 13:01:24 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] media: rcar-vin: Add digital input subdevice parsing
Message-ID: <20180511110124.GC18974@bigcity.dyn.berto.se>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526032781-14319-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526032781-14319-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work!

The comments here apply to both 2/5 and 3/5.

On 2018-05-11 11:59:38 +0200, Jacopo Mondi wrote:
> Add support for digital input subdevices to Gen-3 rcar-vin.
> The Gen-3, media-controller compliant, version has so far only accepted
> CSI-2 input subdevices. Remove assumptions on the supported bus_type and
> accepted number of subdevices, and allow digital input connections on port@0.

I feel this much more complex then it has to be. You defer parsing the 
DT graph until all VIN's are probed just like it's done for the port@1 
parsing. For the CSI-2 endpoints in port@1 this is needed as they are 
shared for all VIN's in the group. While for the parallel input this is 
local for each VIN and could be parsed at probe time for each individual 
VIN. As a bonus for doing that I think you could reuse the parallel 
parsing functions from the Gen2 code whit small additions.

Maybe something like this can be done:

- At each VIN probe() rework the block

    if (vin->info->use_mc)
	    ret = rvin_mc_init(vin);
    else
	    ret = rvin_digital_graph_init(vin);

  To:
    ret = rvin_digital_graph_init(vin);
    ...
    ret = rvin_mc_init(vin);
    ...

- Then in rvin_digital_graph_init() don't call 
  v4l2_async_notifier_register() if vin->info->use_mc is set.

  And instead as a last step in rvin_mc_init() call 
  v4l2_async_notifier_register() for each vin->notifier that contains a 
  subdevice.

- As a last step add a check for vin->info->use_mc in 
  rvin_digital_notify_complete() and handle the case for Gen2 behavior 
  (what it does now) and Gen3 behavior (adding the MC link).


I think my doing this you could greatly simplify the process of handling 
the parallel subdevice.

Please see bellow for one additional comment.

> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 166 +++++++++++++++++++++++-----
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  13 +++
>  2 files changed, 153 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index e547ef7..105b6b6 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -697,29 +697,21 @@ static const struct v4l2_async_notifier_operations rvin_group_notify_ops = {
>  	.complete = rvin_group_notify_complete,
>  };
>  
> -static int rvin_mc_parse_of_endpoint(struct device *dev,
> -				     struct v4l2_fwnode_endpoint *vep,
> -				     struct v4l2_async_subdev *asd)
> +static int rvin_mc_parse_of_csi2(struct rvin_dev *vin,
> +				 struct v4l2_fwnode_endpoint *vep,
> +				 struct v4l2_async_subdev *asd)
>  {
> -	struct rvin_dev *vin = dev_get_drvdata(dev);
> -
> -	if (vep->base.port != 1 || vep->base.id >= RVIN_CSI_MAX)
> +	if (vep->base.id >= RVIN_CSI_MAX)
>  		return -EINVAL;
>  
> -	if (!of_device_is_available(to_of_node(asd->match.fwnode))) {
> -
> -		vin_dbg(vin, "OF device %pOF disabled, ignoring\n",
> -			to_of_node(asd->match.fwnode));
> -		return -ENOTCONN;
> -
> -	}
> -
>  	if (vin->group->csi[vep->base.id].fwnode) {
>  		vin_dbg(vin, "OF device %pOF already handled\n",
>  			to_of_node(asd->match.fwnode));
>  		return -ENOTCONN;
>  	}
>  
> +	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> +	vin->mbus_cfg.flags = 0;
>  	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
>  
>  	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
> @@ -728,9 +720,97 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
>  	return 0;
>  }
>  
> +static int rvin_mc_parse_of_digital(struct rvin_dev *vin,
> +				    struct v4l2_fwnode_endpoint *vep,
> +				    struct v4l2_async_subdev *asd)
> +{
> +	if (vep->base.id)
> +		return -EINVAL;
> +
> +	vin->mbus_cfg.type = vep->bus_type;
> +	if (vin->mbus_cfg.type == V4L2_MBUS_PARALLEL)
> +		vin->mbus_cfg.flags = vep->bus.parallel.flags;
> +	else
> +		vin->mbus_cfg.flags = 0;
> +
> +	/*
> +	 * 'v4l2_async_notifier_fwnode_parse_endpoint()' has reserved
> +	 * enough memory for a whole 'rvin_grap_entity' structure, whose 'asd'
> +	 * is the first member of. Safely cast it to the 'digital' field of
> +	 * the selected vin instance.
> +	 */
> +	vin->digital = (struct rvin_graph_entity *)asd;
> +
> +	vin_dbg(vin, "Add OF device %pOF as VIN%u digital input\n",
> +		to_of_node(asd->match.fwnode), vin->id);
> +
> +	return 0;
> +}
> +
> +static int rvin_mc_parse_of_endpoint(struct device *dev,
> +				     struct v4l2_fwnode_endpoint *vep,
> +				     struct v4l2_async_subdev *asd)
> +{
> +	struct rvin_dev *group_vin = dev_get_drvdata(dev);
> +	struct rvin_group *group = group_vin->group;
> +	struct fwnode_handle *fw_vin;
> +	struct fwnode_handle *fw_port;
> +	struct rvin_dev *vin;
> +	unsigned int i;
> +	int ret;
> +
> +	if (!fwnode_device_is_available(asd->match.fwnode)) {
> +		vin_dbg(group_vin, "OF device %pOF disabled, ignoring\n",
> +			to_of_node(asd->match.fwnode));
> +		return -ENOTCONN;
> +	}
> +
> +	/*
> +	 * Find out to which VIN instance this ep belongs to.
> +	 *
> +	 * While the list of async subdevices and the async notifier
> +	 * belong to the whole group, the bus configuration properties
> +	 * are instance specific; find the instance by matching its fwnode.
> +	 */
> +	fw_port = fwnode_get_parent(vep->base.local_fwnode);
> +	fw_vin = fwnode_graph_get_port_parent(fw_port);
> +	fwnode_handle_put(fw_port);
> +	if (!fw_vin)
> +		return -ENOENT;
> +
> +	for (i = 0; i < RCAR_VIN_NUM; i++) {
> +		if (!group->vin[i])
> +			continue;
> +
> +		if (fw_vin == dev_fwnode(group->vin[i]->dev))
> +			break;
> +	}
> +	fwnode_handle_put(fw_vin);
> +
> +	if (i == RCAR_VIN_NUM) {
> +		vin_err(group_vin, "Unable to find VIN device for %pOF\n",
> +			to_of_node(asd->match.fwnode));
> +		return -ENOENT;
> +	}
> +	vin = group->vin[i];
> +
> +	switch (vep->base.port) {
> +	case RVIN_PORT_DIGITAL:
> +		ret = rvin_mc_parse_of_digital(vin, vep, asd);
> +		break;
> +	case RVIN_PORT_CSI2:
> +	default:
> +		ret = rvin_mc_parse_of_csi2(vin, vep, asd);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  {
>  	unsigned int count = 0;
> +	size_t asd_struct_size;
>  	unsigned int i;
>  	int ret;
>  
> @@ -753,25 +833,58 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  	}
>  
>  	/*
> -	 * Have all VIN's look for subdevices. Some subdevices will overlap
> -	 * but the parser function can handle it, so each subdevice will
> -	 * only be registered once with the notifier.
> +	 * Have all VIN's look for subdevices. Some CSI-2 subdevices will
> +	 * overlap but the parser function can handle it, so each subdevice
> +	 * will only be registered once with the notifier.
>  	 */
>  
>  	vin->group->notifier = &vin->notifier;
>  
>  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> +		struct fwnode_handle *fwdev;
> +		struct fwnode_handle *fwep;
> +		struct fwnode_endpoint ep;
> +
>  		if (!vin->group->vin[i])
>  			continue;
>  
> +		/*
> +		 * If a digital input is described in port@0 proceed to parse
> +		 * it and register a single sub-device for this VIN instance.
> +		 * If no digital input is available go inspect the CSI-2
> +		 * connections described in port@1.
> +		 */
> +		fwdev = dev_fwnode(vin->group->vin[i]->dev);
> +		fwep = fwnode_graph_get_next_endpoint(fwdev, NULL);
> +		if (!fwep) {
> +			ret = PTR_ERR(fwep);
> +			goto error_unlock_return;
> +		}
> +
> +		ret = fwnode_graph_parse_endpoint(fwep, &ep);
> +		fwnode_handle_put(fwep);
> +		if (ret)
> +			goto error_unlock_return;
> +
> +		switch (ep.port) {
> +		case RVIN_PORT_DIGITAL:
> +			asd_struct_size = sizeof(struct rvin_graph_entity);
> +			break;
> +		case RVIN_PORT_CSI2:
> +			asd_struct_size = sizeof(struct v4l2_async_subdev);
> +			break;
> +		default:
> +			vin_err(vin, "port%u not allowed\n", ep.port);
> +			ret = -EINVAL;
> +			goto error_unlock_return;
> +		}
> +
>  		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  				vin->group->vin[i]->dev, vin->group->notifier,
> -				sizeof(struct v4l2_async_subdev), 1,
> +				asd_struct_size, ep.port,
>  				rvin_mc_parse_of_endpoint);
> -		if (ret) {
> -			mutex_unlock(&vin->group->lock);
> -			return ret;
> -		}
> +		if (ret)
> +			goto error_unlock_return;
>  	}
>  
>  	mutex_unlock(&vin->group->lock);
> @@ -785,16 +898,17 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  	}
>  
>  	return 0;
> +
> +error_unlock_return:
> +	mutex_unlock(&vin->group->lock);
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
> index c2aef78..a63f3c6 100644
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

This enum is never used in the patch-set is it used later by a different 
patch-set or a left over from refactoring?

> +
> +/**
>   * STOPPED  - No operation in progress
>   * RUNNING  - Operation in progress have buffers
>   * STOPPING - Stopping operation
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
