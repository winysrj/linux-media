Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51464 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdLQQpH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 11:45:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sakari.ailus@linux.intel.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/5] v4l: async: Use endpoint node, not device node, for fwnode match
Date: Sun, 17 Dec 2017 18:45:15 +0200
Message-ID: <1932079.26pWFGcg6c@avalon>
In-Reply-To: <1513189580-32202-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org> <1513189580-32202-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday, 13 December 2017 20:26:16 EET Jacopo Mondi wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> V4L2 async framework can use both device's fwnode and endpoints's fwnode
> for matching the async sub-device with the sub-device. In order to proceed
> moving towards endpoint matching assign the endpoint to the async
> sub-device.
> 
> As most async sub-device drivers (and the related hardware) only supports
> a single endpoint, use the first endpoint found. This works for all
> current drivers --- we only ever supported a single async sub-device per
> device to begin with.
> 
> For async devices that have no endpoints, continue to use the fwnode
> related to the device. This includes e.g. lens devices.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/am437x/am437x-vpfe.c    |  2 +-
>  drivers/media/platform/atmel/atmel-isc.c       |  2 +-
>  drivers/media/platform/atmel/atmel-isi.c       |  2 +-
>  drivers/media/platform/davinci/vpif_capture.c  |  2 +-
>  drivers/media/platform/exynos4-is/media-dev.c  | 14 ++++++++++----
>  drivers/media/platform/pxa_camera.c            |  2 +-
>  drivers/media/platform/qcom/camss-8x16/camss.c |  2 +-
>  drivers/media/platform/rcar_drif.c             |  2 +-
>  drivers/media/platform/stm32/stm32-dcmi.c      |  2 +-
>  drivers/media/platform/ti-vpe/cal.c            |  2 +-
>  drivers/media/platform/xilinx/xilinx-vipp.c    | 16 +++++++++++++---
>  drivers/media/v4l2-core/v4l2-async.c           |  8 ++++++--
>  drivers/media/v4l2-core/v4l2-fwnode.c          |  2 +-
>  13 files changed, 39 insertions(+), 19 deletions(-)

[snip]

> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index a89367a..e150d75
> 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1572,7 +1572,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
>  		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>  			chan->vpif_if.vd_pol = 1;
> 
> -		rem = of_graph_get_remote_port_parent(endpoint);
> +		rem = of_graph_get_remote_endpoint(endpoint);
>  		if (!rem) {
>  			dev_dbg(&pdev->dev, "Remote device at %pOF not found\n",
>  				endpoint);

The node's full name is used as the subdev name, have you verified that this 
change won't break the driver ?

> diff --git a/drivers/media/platform/exynos4-is/media-dev.c
> b/drivers/media/platform/exynos4-is/media-dev.c index c15596b..c6b0220
> 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -409,7 +409,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
> 
>  	pd->mux_id = (endpoint.base.port - 1) & 0x1;
> 
> -	rem = of_graph_get_remote_port_parent(ep);
> +	rem = of_graph_get_remote_endpoint(ep);
>  	of_node_put(ep);
>  	if (rem == NULL) {
>  		v4l2_info(&fmd->v4l2_dev, "Remote device at %pOF not found\n",
> @@ -1360,11 +1360,17 @@ static int subdev_notifier_bound(struct
> v4l2_async_notifier *notifier, int i;
> 
>  	/* Find platform data for this sensor subdev */
> -	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
> -		if (fmd->sensor[i].asd.match.fwnode.fwnode ==
> -		    of_fwnode_handle(subdev->dev->of_node))
> +	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++) {
> +		struct fwnode_handle *fwnode =
> +			fwnode_graph_get_port_parent(
> +				of_fwnode_handle(subdev->dev->of_node));

Isn't fwnode_graph_get_port_parent() supposed to be called on an endpoint node 
? subdev->dev->of_node is the device's node.

> +		if (fmd->sensor[i].asd.match.fwnode.fwnode == fwnode)
>  			si = &fmd->sensor[i];
> 
> +		fwnode_handle_put(fwnode);
> +	}
> +
>  	if (si == NULL)
>  		return -EINVAL;
> 

[snip]

> diff --git a/drivers/media/platform/ti-vpe/cal.c
> b/drivers/media/platform/ti-vpe/cal.c index 8b586c8..9b29706 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1699,7 +1699,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx,
> int inst) goto cleanup_exit;
>  	}
> 
> -	sensor_node = of_graph_get_remote_port_parent(ep_node);
> +	sensor_node = of_graph_get_remote_endpoint(ep_node);
>  	if (!sensor_node) {
>  		ctx_dbg(3, ctx, "can't get remote parent\n");
>  		goto cleanup_exit;

sensor_node->name is used in a debug message that will become a bit less 
useful as a result.

> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c
> b/drivers/media/platform/xilinx/xilinx-vipp.c index d881cf0..17d4ac0 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -82,6 +82,8 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev, dev_dbg(xdev->dev, "creating links for entity
> %s\n", local->name);
> 
>  	while (1) {
> +		struct fwnode_handle *fwnode;
> +
>  		/* Get the next endpoint and parse its link. */
>  		next = of_graph_get_next_endpoint(entity->node, ep);
>  		if (next == NULL)
> @@ -121,8 +123,11 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev, continue;
>  		}
> 
> +		fwnode = fwnode_graph_get_port_parent(link.remote_node);
> +		fwnode_handle_put(fwnode);
> +
>  		/* Skip DMA engines, they will be processed separately. */
> -		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
> +		if (fwnode == of_fwnode_handle(xdev->dev->of_node)) {
>  			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
>  				to_of_node(link.local_node),
>  				link.local_port);
> @@ -367,20 +372,25 @@ static int xvip_graph_parse_one(struct
> xvip_composite_device *xdev, dev_dbg(xdev->dev, "parsing node %pOF\n",
> node);
> 
>  	while (1) {
> +		struct fwnode_handle *fwnode;
> +
>  		ep = of_graph_get_next_endpoint(node, ep);
>  		if (ep == NULL)
>  			break;
> 
>  		dev_dbg(xdev->dev, "handling endpoint %pOF\n", ep);
> 
> -		remote = of_graph_get_remote_port_parent(ep);
> +		remote = of_graph_get_remote_endpoint(ep);
>  		if (remote == NULL) {
>  			ret = -EINVAL;
>  			break;
>  		}
> 
> +		fwnode = fwnode_graph_get_port_parent(of_fwnode_handle(remote));
> +		fwnode_handle_put(fwnode);
> +
>  		/* Skip entities that we have already processed. */
> -		if (remote == xdev->dev->of_node ||
> +		if (fwnode == xdev->dev->of_node ||

The former is a fwnode_handle pointer and the latter a device_node pointer, I 
don't think that's expected. Doesn't gcc generate a warning ?

>  		    xvip_graph_find_entity(xdev, remote)) {
>  			of_node_put(remote);
>  			continue;
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index a7c3464..a6bddff 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -539,8 +539,12 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	 * (struct v4l2_subdev.dev), and async sub-device does not
>  	 * exist independently of the device at any point of time.
>  	 */
> -	if (!sd->fwnode && sd->dev)
> -		sd->fwnode = dev_fwnode(sd->dev);
> +	if (!sd->fwnode && sd->dev) {
> +		sd->fwnode = fwnode_graph_get_next_endpoint(
> +			dev_fwnode(sd->dev), NULL);
> +		if (!sd->fwnode)
> +			sd->fwnode = dev_fwnode(sd->dev);

Shouldn't you drop the reference to the fwnode here, as the framework doesn't 
release it (see the comment just above this piece of code) ? You'll have to 
update the comment as well to explain the new mechanism.

> +	}
> 
>  	mutex_lock(&list_lock);
> 

[snip]

-- 
Regards,

Laurent Pinchart
