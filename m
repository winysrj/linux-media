Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43493 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933500AbdEVRF0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 13:05:26 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2 2/2] v4l: async: Match parent devices
References: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
 <133ce0f3de88925fee3685ebe3967b6c5f93f8ef.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
To: sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <3aace1d3-d8f9-0090-9c96-1bedcbddda8c@ideasonboard.com>
Date: Mon, 22 May 2017 18:05:12 +0100
MIME-Version: 1.0
In-Reply-To: <133ce0f3de88925fee3685ebe3967b6c5f93f8ef.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewing my own post:

On 19/05/17 17:16, Kieran Bingham wrote:
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
> 
> ---
> v2:
>  - Added documentation comments
>  - simplified the OF match by adding match_fwnode_of()
> 
>  drivers/media/v4l2-core/v4l2-async.c | 33 ++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index cbd919d4edd2..2473c0a1f7a8 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -41,14 +41,37 @@ static bool match_devname(struct v4l2_subdev *sd,
>  	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
>  }
>  
> +static bool match_fwnode_of(struct fwnode_handle *a, struct fwnode_handle *b)
> +{
> +	return !of_node_cmp(of_node_full_name(to_of_node(a)),
> +			    of_node_full_name(to_of_node(b)));
> +}
> +
> +/*
> + * Compare the sd with the notifier.
> + *
> + * As a measure to support drivers which have not been converted to use
> + * endpoint matching, we also find the parent device of the node in the
> + * notifier, and compare the sd against that device.
> + */
>  static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
> -	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
> -		return sd->fwnode == asd->match.fwnode.fwnode;
> +	struct fwnode_handle *asd_fwnode = asd->match.fwnode.fwnode;
> +	struct fwnode_handle *sd_parent, *asd_parent;
> +

The keen eyed will notice that sd_parent is not initialised here before use:
Fixed in the next version, pending testing and repost.

> +	asd_parent = fwnode_graph_get_port_parent(asd_fwnode);
> +
> +	if (!is_of_node(sd->fwnode) || !is_of_node(asd_fwnode))
> +		return sd->fwnode == asd_fwnode ||
> +		       sd_parent == asd_fwnode ||
> +		       sd->fwnode == asd_parent;
>  
> -	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
> -			    of_node_full_name(
> -				    to_of_node(asd->match.fwnode.fwnode)));
> +	/*
> +	 * Compare OF nodes with a full match to support removable dt snippets.
> +	 */
> +	return match_fwnode_of(sd->fwnode, asd_fwnode) ||
> +	       match_fwnode_of(sd_parent, asd_fwnode) ||
> +	       match_fwnode_of(sd->fwnode, asd_parent);
>  }
>  
>  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> 
