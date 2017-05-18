Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55279 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbdEROBj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 10:01:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tuukka Toivonen <tuukka.toivonen@intel.com>,
        Javi Merino <javi.merino@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] v4l: async: Match parent devices
Date: Thu, 18 May 2017 17:01:48 +0300
Message-ID: <1611647.ovgU3nOQAy@avalon>
In-Reply-To: <4db2a777a71b51a864caae16385b60b4b7e9f992.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com> <4db2a777a71b51a864caae16385b60b4b7e9f992.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Wednesday 17 May 2017 16:03:39 Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Devices supporting multiple endpoints on a single device node must set
> their subdevice fwnode to the endpoint to allow distinct comparisons.
> 
> Adapt the match_fwnode call to compare against the provided fwnodes
> first, but also to search for a comparison against the parent fwnode.
> 
> This allows notifiers to pass the endpoint for comparison and still
> support existing subdevices which store their default parent device
> node.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index e1e181db90f7..65735a5c4350
> 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -41,14 +41,26 @@ static bool match_devname(struct v4l2_subdev *sd,
>  	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
>  }
> 
/*
 * Check whether the two device_node pointers refer to the same OF node. We
 * can't compare pointers directly as they can differ if overlays have been
 * applied.
 */

> +static bool match_of(struct device_node *a, struct device_node *b)
> +{
> +	return !of_node_cmp(of_node_full_name(a), of_node_full_name(b));
> +}
> +
>  static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev
> *asd)
> {
> +	struct device_node *sdnode;
> +	struct fwnode_handle *async_device;

I would name this asd_fwnode, and to be consistent rename sdnode to sd_ofnode.

> +
> +	async_device = fwnode_graph_get_port_parent(asd->match.fwnode.fwnode);
> +
>  	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
> -		return sd->fwnode == asd->match.fwnode.fwnode;
> +		return sd->fwnode == asd->match.fwnode.fwnode ||
> +		       sd->fwnode == async_device;

I wonder whether we could simplify this by changing the 
fwnode_graph_get_port_parent() API. At the moment the function walks two or 
three levels up depending on whether there's a ports name or not. If we turned 
in into a function that accepts an endpoint, port or device node, and returns 
the device node unconditionally (basically, returning the argument if its name 
is not "port(@[0-9]+)?" or "endpoint(@[0-9]+)?", and walking up until it 
reaches the device node otherwise), you could write the above

	asd_fwnode = fwnode_graph_get_port_parent(asd->match.fwnode.fwnode);

  	if (!is_of_node(sd->fwnode) || !is_of_node(asd_fwnode))
		       sd->fwnode == asd_fwnode;

	sdnode = to_of_node(sd->fwnode);
 
	return match_of(sdnode, to_of_node(asd_node));

> +
> +	sdnode = to_of_node(sd->fwnode);
> 
> -	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
> -			    of_node_full_name(
> -				    to_of_node(asd->match.fwnode.fwnode)));
> +	return match_of(sdnode, to_of_node(asd->match.fwnode.fwnode)) ||
> +	       match_of(sdnode, to_of_node(async_device));

This is getting a bit complex, could you document the function ?

>  }
> 
>  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev
> *asd)

-- 
Regards,

Laurent Pinchart
