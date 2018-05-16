Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36485 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbeEPUlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 16:41:18 -0400
Received: by mail-wr0-f195.google.com with SMTP id p4-v6so3290122wrh.3
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 13:41:17 -0700 (PDT)
Date: Wed, 16 May 2018 22:41:15 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] media: rcar-vin: Handle mc in digital notifier ops
Message-ID: <20180516204115.GC17838@bigcity.dyn.berto.se>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526473016-30559-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526473016-30559-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

I only have one generic comment to this patch as I fear comments on 1/4 
have the potential to change quiet a few things here :-(

On 2018-05-16 14:16:54 +0200, Jacopo Mondi wrote:
> Handle media-controller in the digital notifier operations (bound,
> unbind and complete) registered for VIN instances handling a digital
> input subdevice.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 94 ++++++++++++++++++++---------
>  1 file changed, 65 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 0ea21ab..1003c8c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -379,7 +379,7 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
>   * Digital async notifier
>   */
>  
> -/* The vin lock should be held when calling the subdevice attach and detach */
> +/* The vin lock should be held when calling the subdevice attach. */
>  static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
>  					 struct v4l2_subdev *subdev)
>  {
> @@ -388,15 +388,6 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
>  	};
>  	int ret;
>  
> -	/* Find source and sink pad of remote subdevice */
> -	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> -	if (ret < 0)
> -		return ret;
> -	vin->digital->source_pad = ret;
> -
> -	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> -	vin->digital->sink_pad = ret < 0 ? 0 : ret;
> -
>  	/* Find compatible subdevices mbus format */
>  	vin->mbus_code = 0;
>  	code.index = 0;
> @@ -450,23 +441,14 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
>  
>  	vin->vdev.ctrl_handler = &vin->ctrl_handler;
>  
> -	vin->digital->subdev = subdev;
> -
>  	return 0;
>  }
>  
> -static void rvin_digital_subdevice_detach(struct rvin_dev *vin)

Please don't fold this function into the caller. I tired the same thing 
when adding Gen3 support but keeping the _attach and _detach functions 
keeps a nice abstraction on what happens when we add and remove a 
parallel subdevice to the internal data structures separated from the 
housekeeping stuff in the callbacks :-)


> -{
> -	rvin_v4l2_unregister(vin);
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> -
> -	vin->vdev.ctrl_handler = NULL;
> -	vin->digital->subdev = NULL;
> -}
> -
>  static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct media_entity *source;
> +	struct media_entity *sink;
>  	int ret;
>  
>  	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
> @@ -475,7 +457,26 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>  		return ret;
>  	}
>  
> -	return rvin_v4l2_register(vin);
> +	if (!video_is_registered(&vin->vdev)) {
> +		ret = rvin_v4l2_register(vin);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (!vin->info->use_mc)
> +		return 0;
> +
> +	/* If we're running with media controller, link the subdevice. */
> +	source = &vin->digital->subdev->entity;
> +	sink = &vin->vdev.entity;
> +
> +	ret = media_create_pad_link(source, vin->digital->source_pad,
> +				    sink, vin->digital->sink_pad, 0);
> +	if (ret)
> +		vin_err(vin, "Error adding link from %s to %s\n",
> +			source->name, sink->name);
> +
> +	return ret;
>  }
>  
>  static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
> @@ -487,7 +488,14 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
>  
>  	mutex_lock(&vin->lock);
> -	rvin_digital_subdevice_detach(vin);
> +
> +	rvin_v4l2_unregister(vin);
> +	vin->digital->subdev = NULL;
> +	if (!vin->info->use_mc) {
> +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +		vin->vdev.ctrl_handler = NULL;
> +	}
> +
>  	mutex_unlock(&vin->lock);
>  }
>  
> @@ -499,10 +507,29 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  	int ret;
>  
>  	mutex_lock(&vin->lock);
> -	ret = rvin_digital_subdevice_attach(vin, subdev);
> -	mutex_unlock(&vin->lock);
> -	if (ret)
> +
> +	/* Find source and sink pad of remote subdevice */
> +	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> +	if (ret < 0) {
> +		mutex_unlock(&vin->lock);
>  		return ret;
> +	}
> +	vin->digital->source_pad = ret;
> +
> +	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> +	vin->digital->sink_pad = ret < 0 ? 0 : ret;
> +
> +	vin->digital->subdev = subdev;
> +
> +	if (!vin->info->use_mc) {
> +		ret = rvin_digital_subdevice_attach(vin, subdev);
> +		if (ret) {
> +			mutex_unlock(&vin->lock);
> +			return ret;
> +		}
> +	}
> +
> +	mutex_unlock(&vin->lock);
>  
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
> @@ -555,9 +582,10 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  {
>  	int ret;
>  
> -	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  		vin->dev, &vin->notifier,
> -		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
> +		sizeof(struct rvin_graph_entity), RVIN_PORT_DIGITAL,
> +		rvin_digital_parse_v4l2);
>  	if (ret)
>  		return ret;
>  
> @@ -567,6 +595,13 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  	vin_dbg(vin, "Found digital subdevice %pOF\n",
>  		to_of_node(vin->digital->asd.match.fwnode));
>  
> +	/*
> +	 * If we run with media-controller, notifiers will be registered
> +	 * later, once all VINs have probed.
> +	 */
> +	if (vin->info->use_mc)
> +		return 0;
> +
>  	vin->notifier.ops = &rvin_digital_notify_ops;
>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>  	if (ret < 0) {
> @@ -596,7 +631,8 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
>  
>  	/* Register all video nodes for the group. */
>  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> -		if (vin->group->vin[i]) {
> +		if (vin->group->vin[i] &&
> +		    !video_is_registered(&vin->group->vin[i]->vdev)) {
>  			ret = rvin_v4l2_register(vin->group->vin[i]);
>  			if (ret)
>  				return ret;
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
