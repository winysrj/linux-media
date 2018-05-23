Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38141 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934544AbeEWWm1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 18:42:27 -0400
Received: by mail-wr0-f194.google.com with SMTP id 94-v6so29270410wrf.5
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 15:42:27 -0700 (PDT)
Date: Thu, 24 May 2018 00:42:25 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 1/9] media: rcar-vin: Rename 'digital' to 'parallel'
Message-ID: <20180523224225.GF5115@bigcity.dyn.berto.se>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526654445-10702-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-18 16:40:37 +0200, Jacopo Mondi wrote:
> As the term 'digital' is used all over the rcar-vin code in place of
> 'parallel', rename all the occurrencies.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 72 ++++++++++++++---------------
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  4 +-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 12 ++---
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  6 +--
>  4 files changed, 47 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d3072e1..6b80f98 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -376,12 +376,12 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
>  }
>  
>  /* -----------------------------------------------------------------------------
> - * Digital async notifier
> + * Parallel async notifier
>   */
>  
>  /* The vin lock should be held when calling the subdevice attach and detach */
> -static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
> -					 struct v4l2_subdev *subdev)
> +static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
> +					  struct v4l2_subdev *subdev)
>  {
>  	struct v4l2_subdev_mbus_code_enum code = {
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> @@ -392,15 +392,15 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
>  	if (ret < 0)
>  		return ret;
> -	vin->digital->source_pad = ret;
> +	vin->parallel->source_pad = ret;
>  
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> -	vin->digital->sink_pad = ret < 0 ? 0 : ret;
> +	vin->parallel->sink_pad = ret < 0 ? 0 : ret;
>  
>  	/* Find compatible subdevices mbus format */
>  	vin->mbus_code = 0;
>  	code.index = 0;
> -	code.pad = vin->digital->source_pad;
> +	code.pad = vin->parallel->source_pad;
>  	while (!vin->mbus_code &&
>  	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
>  		code.index++;
> @@ -450,21 +450,21 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
>  
>  	vin->vdev.ctrl_handler = &vin->ctrl_handler;
>  
> -	vin->digital->subdev = subdev;
> +	vin->parallel->subdev = subdev;
>  
>  	return 0;
>  }
>  
> -static void rvin_digital_subdevice_detach(struct rvin_dev *vin)
> +static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
>  {
>  	rvin_v4l2_unregister(vin);
>  	v4l2_ctrl_handler_free(&vin->ctrl_handler);
>  
>  	vin->vdev.ctrl_handler = NULL;
> -	vin->digital->subdev = NULL;
> +	vin->parallel->subdev = NULL;
>  }
>  
> -static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
> +static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>  	int ret;
> @@ -478,28 +478,28 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>  	return rvin_v4l2_register(vin);
>  }
>  
> -static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
> -				       struct v4l2_subdev *subdev,
> -				       struct v4l2_async_subdev *asd)
> +static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
> +				        struct v4l2_subdev *subdev,
> +				        struct v4l2_async_subdev *asd)

When I run my indentation script this indentation changes from spaces to 
all tabs. If possible I would like to keep that as I usually run it on 
these files before submitting any patches, but it's not a big deal.

Whit this fixed, thanks for clearing this up!

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>  
> -	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> +	vin_dbg(vin, "unbind parallel subdev %s\n", subdev->name);
>  
>  	mutex_lock(&vin->lock);
> -	rvin_digital_subdevice_detach(vin);
> +	rvin_parallel_subdevice_detach(vin);
>  	mutex_unlock(&vin->lock);
>  }
>  
> -static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
> -				     struct v4l2_subdev *subdev,
> -				     struct v4l2_async_subdev *asd)
> +static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
> +				      struct v4l2_subdev *subdev,
> +				      struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>  	int ret;
>  
>  	mutex_lock(&vin->lock);
> -	ret = rvin_digital_subdevice_attach(vin, subdev);
> +	ret = rvin_parallel_subdevice_attach(vin, subdev);
>  	mutex_unlock(&vin->lock);
>  	if (ret)
>  		return ret;
> @@ -507,21 +507,21 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
>  	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
> -		subdev->name, vin->digital->source_pad,
> -		vin->digital->sink_pad);
> +		subdev->name, vin->parallel->source_pad,
> +		vin->parallel->sink_pad);
>  
>  	return 0;
>  }
>  
> -static const struct v4l2_async_notifier_operations rvin_digital_notify_ops = {
> -	.bound = rvin_digital_notify_bound,
> -	.unbind = rvin_digital_notify_unbind,
> -	.complete = rvin_digital_notify_complete,
> +static const struct v4l2_async_notifier_operations rvin_parallel_notify_ops = {
> +	.bound = rvin_parallel_notify_bound,
> +	.unbind = rvin_parallel_notify_unbind,
> +	.complete = rvin_parallel_notify_complete,
>  };
>  
> -static int rvin_digital_parse_v4l2(struct device *dev,
> -				   struct v4l2_fwnode_endpoint *vep,
> -				   struct v4l2_async_subdev *asd)
> +static int rvin_parallel_parse_v4l2(struct device *dev,
> +				    struct v4l2_fwnode_endpoint *vep,
> +				    struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = dev_get_drvdata(dev);
>  	struct rvin_graph_entity *rvge =
> @@ -546,28 +546,28 @@ static int rvin_digital_parse_v4l2(struct device *dev,
>  		return -EINVAL;
>  	}
>  
> -	vin->digital = rvge;
> +	vin->parallel = rvge;
>  
>  	return 0;
>  }
>  
> -static int rvin_digital_graph_init(struct rvin_dev *vin)
> +static int rvin_parallel_graph_init(struct rvin_dev *vin)
>  {
>  	int ret;
>  
>  	ret = v4l2_async_notifier_parse_fwnode_endpoints(
>  		vin->dev, &vin->notifier,
> -		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
> +		sizeof(struct rvin_graph_entity), rvin_parallel_parse_v4l2);
>  	if (ret)
>  		return ret;
>  
> -	if (!vin->digital)
> +	if (!vin->parallel)
>  		return -ENODEV;
>  
> -	vin_dbg(vin, "Found digital subdevice %pOF\n",
> -		to_of_node(vin->digital->asd.match.fwnode));
> +	vin_dbg(vin, "Found parallel subdevice %pOF\n",
> +		to_of_node(vin->parallel->asd.match.fwnode));
>  
> -	vin->notifier.ops = &rvin_digital_notify_ops;
> +	vin->notifier.ops = &rvin_parallel_notify_ops;
>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
> @@ -1088,7 +1088,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	if (vin->info->use_mc)
>  		ret = rvin_mc_init(vin);
>  	else
> -		ret = rvin_digital_graph_init(vin);
> +		ret = rvin_parallel_graph_init(vin);
>  	if (ret < 0)
>  		goto error;
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index ac07f99..f1c3585 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -733,7 +733,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  		vnmc |= VNMC_BPS;
>  
>  	if (vin->info->model == RCAR_GEN3) {
> -		/* Select between CSI-2 and Digital input */
> +		/* Select between CSI-2 and parallel input */
>  		if (vin->mbus_cfg.type == V4L2_MBUS_CSI2)
>  			vnmc &= ~VNMC_DPINE;
>  		else
> @@ -1074,7 +1074,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
>  
>  	/* No media controller used, simply pass operation to subdevice. */
>  	if (!vin->info->use_mc) {
> -		ret = v4l2_subdev_call(vin->digital->subdev, video, s_stream,
> +		ret = v4l2_subdev_call(vin->parallel->subdev, video, s_stream,
>  				       on);
>  
>  		return ret == -ENOIOCTLCMD ? 0 : ret;
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index e78fba8..87a718b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -144,7 +144,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev_format fmt = {
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> -		.pad = vin->digital->source_pad,
> +		.pad = vin->parallel->source_pad,
>  	};
>  	int ret;
>  
> @@ -175,7 +175,7 @@ static int rvin_try_format(struct rvin_dev *vin, u32 which,
>  	struct v4l2_subdev_pad_config *pad_cfg;
>  	struct v4l2_subdev_format format = {
>  		.which = which,
> -		.pad = vin->digital->source_pad,
> +		.pad = vin->parallel->source_pad,
>  	};
>  	enum v4l2_field field;
>  	u32 width, height;
> @@ -517,7 +517,7 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
>  	if (timings->pad)
>  		return -EINVAL;
>  
> -	timings->pad = vin->digital->sink_pad;
> +	timings->pad = vin->parallel->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
>  
> @@ -569,7 +569,7 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>  	if (cap->pad)
>  		return -EINVAL;
>  
> -	cap->pad = vin->digital->sink_pad;
> +	cap->pad = vin->parallel->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
>  
> @@ -587,7 +587,7 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>  	if (edid->pad)
>  		return -EINVAL;
>  
> -	edid->pad = vin->digital->sink_pad;
> +	edid->pad = vin->parallel->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
>  
> @@ -605,7 +605,7 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>  	if (edid->pad)
>  		return -EINVAL;
>  
> -	edid->pad = vin->digital->sink_pad;
> +	edid->pad = vin->parallel->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index c2aef78..755ac3c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -146,7 +146,7 @@ struct rvin_info {
>   * @v4l2_dev:		V4L2 device
>   * @ctrl_handler:	V4L2 control handler
>   * @notifier:		V4L2 asynchronous subdevs notifier
> - * @digital:		entity in the DT for local digital subdevice
> + * @parallel:		entity in the DT for local parallel subdevice
>   *
>   * @group:		Gen3 CSI group
>   * @id:			Gen3 group id for this VIN
> @@ -182,7 +182,7 @@ struct rvin_dev {
>  	struct v4l2_device v4l2_dev;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	struct v4l2_async_notifier notifier;
> -	struct rvin_graph_entity *digital;
> +	struct rvin_graph_entity *parallel;
>  
>  	struct rvin_group *group;
>  	unsigned int id;
> @@ -209,7 +209,7 @@ struct rvin_dev {
>  	v4l2_std_id std;
>  };
>  
> -#define vin_to_source(vin)		((vin)->digital->subdev)
> +#define vin_to_source(vin)		((vin)->parallel->subdev)
>  
>  /* Debug */
>  #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
