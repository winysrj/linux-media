Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:38672 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdH2M5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:57:46 -0400
Received: by mail-lf0-f51.google.com with SMTP id d202so12959852lfd.5
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 05:57:45 -0700 (PDT)
Date: Tue, 29 Aug 2017 14:57:42 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 5/5] v4l: fwnode: Support generic parsing of graph
 endpoints in a single port
Message-ID: <20170829125742.GG12099@bigcity.dyn.berto.se>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com>
 <20170829110313.19538-6-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170829110313.19538-6-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your patch, I like how this turned out :-)

On 2017-08-29 14:03:13 +0300, Sakari Ailus wrote:
> This is the preferred way to parse the endpoints.
> 
> Comment rcar-vin as an example.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 111 ++++++++--------------------
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  10 +--
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  14 ++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |   4 +-
>  drivers/media/v4l2-core/v4l2-fwnode.c       |  47 ++++++++++++
>  include/media/v4l2-fwnode.h                 |  39 ++++++++++
>  6 files changed, 132 insertions(+), 93 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 142de447aaaa..4378806be1d4 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -21,6 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
>  
>  #include "rcar-vin.h"
> @@ -77,14 +78,14 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>  	int ret;
>  
>  	/* Verify subdevices mbus format */
> -	if (!rvin_mbus_supported(&vin->digital)) {
> +	if (!rvin_mbus_supported(vin->digital)) {
>  		vin_err(vin, "Unsupported media bus format for %s\n",
> -			vin->digital.subdev->name);
> +			vin->digital->subdev->name);
>  		return -EINVAL;
>  	}
>  
>  	vin_dbg(vin, "Found media bus format for %s: %d\n",
> -		vin->digital.subdev->name, vin->digital.code);
> +		vin->digital->subdev->name, vin->digital->code);
>  
>  	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
>  	if (ret < 0) {
> @@ -103,7 +104,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
>  
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
>  	rvin_v4l2_remove(vin);
> -	vin->digital.subdev = NULL;
> +	vin->digital->subdev = NULL;
>  }
>  
>  static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
> @@ -120,117 +121,67 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
>  	if (ret < 0)
>  		return ret;
> -	vin->digital.source_pad = ret;
> +	vin->digital->source_pad = ret;
>  
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> -	vin->digital.sink_pad = ret < 0 ? 0 : ret;
> +	vin->digital->sink_pad = ret < 0 ? 0 : ret;
>  
> -	vin->digital.subdev = subdev;
> +	vin->digital->subdev = subdev;
>  
>  	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
> -		subdev->name, vin->digital.source_pad,
> -		vin->digital.sink_pad);
> +		subdev->name, vin->digital->source_pad,
> +		vin->digital->sink_pad);
>  
>  	return 0;
>  }
>  
> -static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
> -				    struct device_node *ep,
> -				    struct v4l2_mbus_config *mbus_cfg)
> +static int rvin_digital_parse_v4l2(struct device *dev,
> +				   struct v4l2_fwnode_endpoint *vep,
> +				   struct v4l2_async_subdev *asd)
>  {
> -	struct v4l2_fwnode_endpoint v4l2_ep;
> -	int ret;
> -
> -	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> -	if (ret) {
> -		vin_err(vin, "Could not parse v4l2 endpoint\n");
> -		return -EINVAL;
> -	}
> +	struct rvin_dev *vin = dev_get_drvdata(dev);
> +	struct rvin_graph_entity *rvge =
> +		container_of(asd, struct rvin_graph_entity, asd);
>  
> -	mbus_cfg->type = v4l2_ep.bus_type;
> +	rvge->mbus_cfg.type = vep->bus_type;
>  
> -	switch (mbus_cfg->type) {
> +	switch (rvge->mbus_cfg.type) {
>  	case V4L2_MBUS_PARALLEL:
>  		vin_dbg(vin, "Found PARALLEL media bus\n");
> -		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
> +		rvge->mbus_cfg.flags = vep->bus.parallel.flags;
>  		break;
>  	case V4L2_MBUS_BT656:
>  		vin_dbg(vin, "Found BT656 media bus\n");
> -		mbus_cfg->flags = 0;
> +		rvge->mbus_cfg.flags = 0;
>  		break;
>  	default:
>  		vin_err(vin, "Unknown media bus type\n");
>  		return -EINVAL;
>  	}
>  
> -	return 0;
> -}
> -
> -static int rvin_digital_graph_parse(struct rvin_dev *vin)
> -{
> -	struct device_node *ep, *np;
> -	int ret;
> -
> -	vin->digital.asd.match.fwnode.fwnode = NULL;
> -	vin->digital.subdev = NULL;
> -
> -	/*
> -	 * Port 0 id 0 is local digital input, try to get it.
> -	 * Not all instances can or will have this, that is OK
> -	 */
> -	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);
> -	if (!ep)
> -		return 0;
> -
> -	np = of_graph_get_remote_port_parent(ep);
> -	if (!np) {
> -		vin_err(vin, "No remote parent for digital input\n");
> -		of_node_put(ep);
> -		return -EINVAL;
> -	}
> -	of_node_put(np);
> -
> -	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
> -	of_node_put(ep);
> -	if (ret)
> -		return ret;
> -
> -	vin->digital.asd.match.fwnode.fwnode = of_fwnode_handle(np);
> -	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +	vin->digital = rvge;
>  
>  	return 0;
>  }
>  
>  static int rvin_digital_graph_init(struct rvin_dev *vin)
>  {
> -	struct v4l2_async_subdev **subdevs = NULL;
>  	int ret;
>  
> -	ret = rvin_digital_graph_parse(vin);
> +	ret = v4l2_async_notifier_parse_fwnode_endpoint(
> +		vin->dev, &vin->notifier, 0, 0,
> +		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
>  	if (ret)
>  		return ret;
>  
> -	if (!vin->digital.asd.match.fwnode.fwnode) {
> -		vin_dbg(vin, "No digital subdevice found\n");
> -		return -ENODEV;
> -	}
> -
> -	/* Register the subdevices notifier. */
> -	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
> -	if (subdevs == NULL)
> -		return -ENOMEM;
> +	if (vin->notifier.num_subdevs > 0)
> +		vin_dbg(vin, "Found digital subdevice %pOF\n",
> +			to_of_node(
> +				vin->notifier.subdevs[0]->match.fwnode.fwnode));
>  
> -	subdevs[0] = &vin->digital.asd;
> -
> -	vin_dbg(vin, "Found digital subdevice %pOF\n",
> -		to_of_node(subdevs[0]->match.fwnode.fwnode));
> -
> -	vin->notifier.num_subdevs = 1;
> -	vin->notifier.subdevs = subdevs;
>  	vin->notifier.bound = rvin_digital_notify_bound;
>  	vin->notifier.unbind = rvin_digital_notify_unbind;
>  	vin->notifier.complete = rvin_digital_notify_complete;
> -
>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
> @@ -290,6 +241,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> +	platform_set_drvdata(pdev, vin);
> +
>  	ret = rvin_digital_graph_init(vin);
>  	if (ret < 0)
>  		goto error;
> @@ -297,11 +250,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	pm_suspend_ignore_children(&pdev->dev, true);
>  	pm_runtime_enable(&pdev->dev);
>  
> -	platform_set_drvdata(pdev, vin);
> -
>  	return 0;
>  error:
>  	rvin_dma_remove(vin);
> +	v4l2_async_notifier_release(&vin->notifier);
>  
>  	return ret;
>  }
> @@ -313,6 +265,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  	pm_runtime_disable(&pdev->dev);
>  
>  	v4l2_async_notifier_unregister(&vin->notifier);
> +	v4l2_async_notifier_release(&vin->notifier);
>  
>  	rvin_dma_remove(vin);
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index b136844499f6..23fdff7a7370 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -183,7 +183,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  	/*
>  	 * Input interface
>  	 */
> -	switch (vin->digital.code) {
> +	switch (vin->digital->code) {
>  	case MEDIA_BUS_FMT_YUYV8_1X16:
>  		/* BT.601/BT.1358 16bit YCbCr422 */
>  		vnmc |= VNMC_INF_YUV16;
> @@ -191,7 +191,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> -		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
> +		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
>  			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
>  		input_is_yuv = true;
>  		break;
> @@ -200,7 +200,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	case MEDIA_BUS_FMT_UYVY10_2X10:
>  		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> -		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
> +		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
>  			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
>  		input_is_yuv = true;
>  		break;
> @@ -212,11 +212,11 @@ static int rvin_setup(struct rvin_dev *vin)
>  	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
>  
>  	/* Hsync Signal Polarity Select */
> -	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> +	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
>  		dmr2 |= VNDMR2_HPS;
>  
>  	/* Vsync Signal Polarity Select */
> -	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> +	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
>  		dmr2 |= VNDMR2_VPS;
>  
>  	/*
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index dd37ea811680..b479b882da12 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -111,7 +111,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  	struct v4l2_mbus_framefmt *mf = &fmt.format;
>  	int ret;
>  
> -	fmt.pad = vin->digital.source_pad;
> +	fmt.pad = vin->digital->source_pad;
>  
>  	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
>  	if (ret)
> @@ -172,13 +172,13 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  
>  	sd = vin_to_source(vin);
>  
> -	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
> +	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
>  
>  	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
>  	if (pad_cfg == NULL)
>  		return -ENOMEM;
>  
> -	format.pad = vin->digital.source_pad;
> +	format.pad = vin->digital->source_pad;
>  
>  	field = pix->field;
>  
> @@ -555,7 +555,7 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
>  	if (timings->pad)
>  		return -EINVAL;
>  
> -	timings->pad = vin->digital.sink_pad;
> +	timings->pad = vin->digital->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
>  
> @@ -607,7 +607,7 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>  	if (cap->pad)
>  		return -EINVAL;
>  
> -	cap->pad = vin->digital.sink_pad;
> +	cap->pad = vin->digital->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
>  
> @@ -625,7 +625,7 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>  	if (edid->pad)
>  		return -EINVAL;
>  
> -	edid->pad = vin->digital.sink_pad;
> +	edid->pad = vin->digital->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
>  
> @@ -643,7 +643,7 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>  	if (edid->pad)
>  		return -EINVAL;
>  
> -	edid->pad = vin->digital.sink_pad;
> +	edid->pad = vin->digital->sink_pad;
>  
>  	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 9bfb5a7c4dc4..5382078143fb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -126,7 +126,7 @@ struct rvin_dev {
>  	struct v4l2_device v4l2_dev;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	struct v4l2_async_notifier notifier;
> -	struct rvin_graph_entity digital;
> +	struct rvin_graph_entity *digital;
>  
>  	struct mutex lock;
>  	struct vb2_queue queue;
> @@ -145,7 +145,7 @@ struct rvin_dev {
>  	struct v4l2_rect compose;
>  };
>  
> -#define vin_to_source(vin)		vin->digital.subdev
> +#define vin_to_source(vin)		((vin)->digital->subdev)
>  
>  /* Debug */
>  #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 39a587c6992a..e1a07916b9ca 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -445,6 +445,53 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
>  
> +int v4l2_async_notifier_parse_fwnode_endpoint(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	unsigned int port_id, unsigned int endpoint_id, size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd))
> +{
> +	struct fwnode_handle *fwnode = NULL;
> +	int ret;
> +
> +	while ((fwnode = fwnode_graph_get_next_endpoint(
> +			dev_fwnode(dev), fwnode))) {
> +		struct fwnode_endpoint ep;
> +
> +		ret = fwnode_graph_parse_endpoint(fwnode, &ep);
> +		if (ret < 0)
> +			continue;
> +
> +		if (!fwnode_device_is_available(
> +			    fwnode_graph_get_port_parent(fwnode)))
> +			continue;
> +
> +		if (ep.port == port_id && ep.id == endpoint_id)
> +			break;
> +	}
> +
> +	if (!fwnode)
> +		return -ENOENT;
> +
> +	ret = notifier_realloc(notifier, notifier->num_subdevs + 1);
> +	if (ret)
> +		goto out_err;
> +
> +	ret = parse_endpoint(dev, notifier, fwnode, asd_struct_size,
> +			     parse_single);
> +	if (ret)
> +		goto out_err;
> +
> +	return 0;
> +
> +out_err:
> +	fwnode_handle_put(fwnode);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoint);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 46521e8c8872..6bc7b02b2f46 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -240,4 +240,43 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  			    struct v4l2_fwnode_endpoint *vep,
>  			    struct v4l2_async_subdev *asd));
>  
> +/**
> + * v4l2_async_notifier_parse_fwnode_endpoint - Set up async notifier for an
> + *					       fwnode based sub-device
> + * @dev: @struct device pointer
> + * @notifier: pointer to &struct v4l2_async_notifier
> + * @port_id: port number
> + * @endpoint_id: endpoint number
> + * @asd_struct_size: size of the driver's async sub-device struct, including
> + *		     sizeof(struct v4l2_async_subdev). The &struct
> + *		     v4l2_async_subdev shall be the first member of
> + *		     the driver's async sub-device struct, i.e. both
> + *		     begin at the same memory address.
> + * @parse_single: driver's callback function called on each V4L2 fwnode endpoint
> + *
> + * Find an endpoint node for the given port and endpoint IDs and allocate an
> + * async sub-device struct for it. Parse the V4L2 fwnode endpoint and call the
> + * provided callback function.
> + *
> + * The function may not be called on a registered notifier.
> + *
> + * Once the user has called this function, the resources released by it need to
> + * be released by callin v4l2_async_notifier_release after the notifier has been
> + * unregistered and the sub-devices are no longer in use.
> + *
> + * A driver supporting fwnode (currently Devicetree and ACPI) should call this
> + * function as part of its probe function before it registers the notifier.
> + *
> + * Return: %0 on success, including when no async sub-devices are found
> + *	   %-ENOMEM if memory allocation failed
> + *	   %-EINVAL if graph or endpoint parsing failed
> + *	   Other error codes as returned by @parse_single
> + */
> +int v4l2_async_notifier_parse_fwnode_endpoint(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	unsigned int port_id, unsigned int endpoint_id, size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd));
> +
>  #endif /* _V4L2_FWNODE_H */
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
