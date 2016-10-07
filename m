Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:49146 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932338AbcJGSus (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 14:50:48 -0400
Subject: Re: [PATCH 03/22] [media] v4l: of: add v4l2_of_subdev_registered
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-4-p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
From: Marek Vasut <marex@denx.de>
Message-ID: <99f7a5c6-2b51-38f0-5984-366cdc858f3d@denx.de>
Date: Fri, 7 Oct 2016 20:50:43 +0200
MIME-Version: 1.0
In-Reply-To: <20161007160107.5074-4-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2016 06:00 PM, Philipp Zabel wrote:
> Provide a default registered callback for device tree probed subdevices
> that use OF graph bindings to add still missing source subdevices to
> the async notifier waiting list.
> This is only necessary for subdevices that have input ports to which
> other subdevices are connected that are not initially known to the
> master/bridge device when it sets up the notifier.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

[...]

> +int v4l2_of_subdev_registered(struct v4l2_subdev *sd)
> +{
> +	struct device_node *ep;
> +
> +	for_each_endpoint_of_node(sd->of_node, ep) {
> +		struct v4l2_of_link link;
> +		struct media_entity *entity;
> +		unsigned int pad;
> +		int ret;
> +
> +		ret = v4l2_of_parse_link(ep, &link);
> +		if (ret)
> +			continue;
> +
> +		/*
> +		 * Assume 1:1 correspondence between OF node and entity,
> +		 * and between OF port numbers and pad indices.
> +		 */
> +		entity = &sd->entity;

This here will not compile if CONFIG_MEDIA_CONTROLLER is not set,
because ->entity will be missing from struct v4l2_subdev {} .

> +		pad = link.local_port;
> +
> +		if (pad >= entity->num_pads)
> +			return -EINVAL;
> +
> +		/* Add source subdevs to async notifier */
> +		if (entity->pads[pad].flags & MEDIA_PAD_FL_SINK) {
> +			struct v4l2_async_subdev *asd;
> +
> +			asd = devm_kzalloc(sd->dev, sizeof(*asd), GFP_KERNEL);
> +			if (!asd) {
> +				v4l2_of_put_link(&link);
> +				return -ENOMEM;
> +			}
> +
> +			asd->match_type = V4L2_ASYNC_MATCH_OF;
> +			asd->match.of.node = link.remote_node;
> +
> +			__v4l2_async_notifier_add_subdev(sd->notifier, asd);
> +		}
> +
> +		v4l2_of_put_link(&link);
> +	}
> +
> +	return 0;
> +}
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 4dc34b2..67d4f8b 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -22,6 +22,8 @@
>  #include <media/v4l2-mediabus.h>
>  
>  struct device_node;
> +struct v4l2_device;
> +struct v4l2_subdev;
>  
>  /**
>   * struct v4l2_of_bus_mipi_csi2 - MIPI CSI-2 bus data structure
> @@ -95,6 +97,9 @@ void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint);
>  int v4l2_of_parse_link(const struct device_node *node,
>  		       struct v4l2_of_link *link);
>  void v4l2_of_put_link(struct v4l2_of_link *link);
> +int v4l2_of_subdev_registered(struct v4l2_subdev *sd);
> +struct v4l2_subdev *v4l2_find_subdev_by_node(struct v4l2_device *v4l2_dev,
> +					     struct device_node *node);
>  #else /* CONFIG_OF */
>  
>  static inline int v4l2_of_parse_endpoint(const struct device_node *node,
> @@ -123,6 +128,13 @@ static inline void v4l2_of_put_link(struct v4l2_of_link *link)
>  {
>  }
>  
> +#define v4l2_of_subdev_registered NULL
> +
> +struct v4l2_subdev *v4l2_find_subdev_by_node(struct v4l2_device *v4l2_dev,
> +					     struct device_node *node)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_OF */
>  
>  #endif /* _V4L2_OF_H */
> 


-- 
Best regards,
Marek Vasut
