Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48742C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D73F20645
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="rj9xdYM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfAOXvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:51:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49382 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbfAOXvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:51:47 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 01F28530;
        Wed, 16 Jan 2019 00:51:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547596305;
        bh=WFrEgzBOt+C0BtZP1JEhyfxTXYGDzCwUhOXffJyCApM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rj9xdYM+I7bf7vzBQJ/S4oevqgOgb/aoO2yu3M4+29pBPoWY2XSh2JJ25FibO5vmC
         w+ZdgUZHBWUA5s3kafbGZr48/2f9lFMYz7SoqWcoj7icMsYqhkFxz6ZyLrzDxlImNS
         BYrXzHDjkriPv1U+qv6tAQkoz4rdXB9T5Xt/Rhog=
Date:   Wed, 16 Jan 2019 01:51:45 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190115235145.GF31088@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:30AM +0100, Niklas Söderlund wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> - Add sink and source streams for multiplexed links
> - Copy the argument back in case of an error. This is needed to let the
>   caller know the number of routes.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c  | 20 +++++++++++++-
>  drivers/media/v4l2-core/v4l2-subdev.c | 28 +++++++++++++++++++
>  include/media/v4l2-subdev.h           |  7 +++++
>  include/uapi/linux/v4l2-subdev.h      | 40 +++++++++++++++++++++++++++

Missing documentation :-(

>  4 files changed, 94 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 7de041bae84fb2f2..40406acb51ec0906 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/version.h>
>  
> +#include <linux/v4l2-subdev.h>
>  #include <linux/videodev2.h>
>  
>  #include <media/v4l2-common.h>
> @@ -2924,6 +2925,23 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>  		}
>  		break;
>  	}
> +
> +	case VIDIOC_SUBDEV_G_ROUTING:
> +	case VIDIOC_SUBDEV_S_ROUTING: {
> +		struct v4l2_subdev_routing *route = parg;
> +
> +		if (route->num_routes > 0) {
> +			if (route->num_routes > 256)
> +				return -EINVAL;
> +
> +			*user_ptr = (void __user *)route->routes;
> +			*kernel_ptr = (void *)&route->routes;
> +			*array_size = sizeof(struct v4l2_subdev_route)
> +				    * route->num_routes;
> +			ret = 1;
> +		}
> +		break;
> +	}
>  	}
>  
>  	return ret;
> @@ -3033,7 +3051,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	 * Some ioctls can return an error, but still have valid
>  	 * results that must be returned.
>  	 */
> -	if (err < 0 && !always_copy)
> +	if (err < 0 && !always_copy && cmd != VIDIOC_SUBDEV_G_ROUTING)

This seems like a hack. Shouldn't VIDIOC_SUBDEV_G_ROUTING set
always_copy instead ?

>  		goto out;
>  
>  out_array_args:
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 792f41dffe2329b9..1d3b37cf548fa533 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -516,7 +516,35 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	case VIDIOC_SUBDEV_QUERYSTD:
>  		return v4l2_subdev_call(sd, video, querystd, arg);
> +
> +	case VIDIOC_SUBDEV_G_ROUTING:
> +		return v4l2_subdev_call(sd, pad, get_routing, arg);
> +
> +	case VIDIOC_SUBDEV_S_ROUTING: {
> +		struct v4l2_subdev_routing *route = arg;
> +		unsigned int i;
> +
> +		if (route->num_routes > sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		for (i = 0; i < route->num_routes; ++i) {
> +			unsigned int sink = route->routes[i].sink_pad;
> +			unsigned int source = route->routes[i].source_pad;
> +			struct media_pad *pads = sd->entity.pads;
> +
> +			if (sink >= sd->entity.num_pads ||
> +			    source >= sd->entity.num_pads)
> +				return -EINVAL;
> +
> +			if (!(pads[sink].flags & MEDIA_PAD_FL_SINK) ||
> +			    !(pads[source].flags & MEDIA_PAD_FL_SOURCE))
> +				return -EINVAL;
> +		}
> +
> +		return v4l2_subdev_call(sd, pad, set_routing, route);
> +	}
>  #endif
> +
>  	default:
>  		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
>  	}
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 9102d6ca566e01f2..5acaeeb9b3cacefa 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -679,6 +679,9 @@ struct v4l2_subdev_pad_config {
>   *
>   * @set_frame_desc: set the low level media bus frame parameters, @fd array
>   *                  may be adjusted by the subdev driver to device capabilities.
> + *
> + * @get_routing: callback for VIDIOC_SUBDEV_G_ROUTING IOCTL handler.
> + * @set_routing: callback for VIDIOC_SUBDEV_S_ROUTING IOCTL handler.

Please define the purpose of those operations instead of just pointing
to the userspace API.

>   */
>  struct v4l2_subdev_pad_ops {
>  	int (*init_cfg)(struct v4l2_subdev *sd,
> @@ -719,6 +722,10 @@ struct v4l2_subdev_pad_ops {
>  			      struct v4l2_mbus_frame_desc *fd);
>  	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
>  			      struct v4l2_mbus_frame_desc *fd);
> +	int (*get_routing)(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_routing *route);
> +	int (*set_routing)(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_routing *route);
>  };
>  
>  /**
> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> index 03970ce3074193e6..af069bfb10ca23a5 100644
> --- a/include/uapi/linux/v4l2-subdev.h
> +++ b/include/uapi/linux/v4l2-subdev.h
> @@ -155,6 +155,44 @@ struct v4l2_subdev_selection {
>  	__u32 reserved[8];
>  };
>  
> +#define V4L2_SUBDEV_ROUTE_FL_ACTIVE	(1 << 0)
> +#define V4L2_SUBDEV_ROUTE_FL_IMMUTABLE	(1 << 1)
> +
> +/**
> + * struct v4l2_subdev_route - A signal route inside a subdev
> + * @sink_pad: the sink pad
> + * @sink_stream: the sink stream
> + * @source_pad: the source pad
> + * @source_stream: the source stream

At this point in the series there's no concept of multiplexed streams,
so the two fields don't make sense. You may want to reorder patches, or
split this in two.

> + * @flags: route flags:
> + *
> + *	V4L2_SUBDEV_ROUTE_FL_ACTIVE: Is the stream in use or not? An
> + *	active stream will start when streaming is enabled on a video
> + *	node. Set by the user.

This is very confusing as "stream" isn't defined. The documentation
needs a rewrite with more details.

> + *
> + *	V4L2_SUBDEV_ROUTE_FL_IMMUTABLE: Is the stream immutable, i.e.
> + *	can it be activated and inactivated? Set by the driver.
> + */
> +struct v4l2_subdev_route {
> +	__u32 sink_pad;
> +	__u32 sink_stream;
> +	__u32 source_pad;
> +	__u32 source_stream;
> +	__u32 flags;
> +	__u32 reserved[5];
> +};
> +
> +/**
> + * struct v4l2_subdev_routing - Routing information
> + * @routes: the routes array
> + * @num_routes: the total number of routes in the routes array
> + */
> +struct v4l2_subdev_routing {
> +	struct v4l2_subdev_route *routes;

Missing __user ?

> +	__u32 num_routes;
> +	__u32 reserved[5];
> +};
> +
>  /* Backwards compatibility define --- to be removed */
>  #define v4l2_subdev_edid v4l2_edid
>  
> @@ -181,5 +219,7 @@ struct v4l2_subdev_selection {
>  #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
>  #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv_timings)
>  #define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv_timings_cap)
> +#define VIDIOC_SUBDEV_G_ROUTING			_IOWR('V', 38, struct v4l2_subdev_routing)
> +#define VIDIOC_SUBDEV_S_ROUTING			_IOWR('V', 39, struct v4l2_subdev_routing)
>  
>  #endif
> -- 
> 2.19.1
> 

-- 
Regards,

Laurent Pinchart
