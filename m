Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48198 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751798AbcJGWuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 18:50:54 -0400
Date: Sat, 8 Oct 2016 01:50:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Subject: Re: [PATCH 03/22] [media] v4l: of: add v4l2_of_subdev_registered
Message-ID: <20161007225018.GD9460@valkosipuli.retiisi.org.uk>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-4-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007160107.5074-4-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Fri, Oct 07, 2016 at 06:00:48PM +0200, Philipp Zabel wrote:
> Provide a default registered callback for device tree probed subdevices
> that use OF graph bindings to add still missing source subdevices to
> the async notifier waiting list.
> This is only necessary for subdevices that have input ports to which
> other subdevices are connected that are not initially known to the
> master/bridge device when it sets up the notifier.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-of.c | 68 +++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-of.h           | 12 +++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 93b3368..fbdd6b4 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -19,6 +19,7 @@
>  #include <linux/types.h>
>  
>  #include <media/v4l2-of.h>
> +#include <media/v4l2-device.h>

Alphabetical order, please.

>  
>  static int v4l2_of_parse_csi_bus(const struct device_node *node,
>  				 struct v4l2_of_endpoint *endpoint)
> @@ -314,3 +315,70 @@ void v4l2_of_put_link(struct v4l2_of_link *link)
>  	of_node_put(link->remote_node);
>  }
>  EXPORT_SYMBOL(v4l2_of_put_link);
> +
> +struct v4l2_subdev *v4l2_find_subdev_by_node(struct v4l2_device *v4l2_dev,
> +					     struct device_node *node)
> +{
> +	struct v4l2_subdev *sd;
> +
> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> +		if (sd->of_node == node)
> +			return sd;
> +	}

The braces aren't really needed. Up to you.

> +
> +	return NULL;
> +}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
