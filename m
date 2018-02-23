Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47345 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbeBWJ3J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 04:29:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback decide if no remote is error
Date: Fri, 23 Feb 2018 11:29:54 +0200
Message-ID: <3283028.CgXzGkPyKt@avalon>
In-Reply-To: <1519263589-19647-2-git-send-email-steve_longerbeam@mentor.com>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com> <1519263589-19647-2-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Thank you for the patch.

On Thursday, 22 February 2018 03:39:37 EET Steve Longerbeam wrote:
> For some subdevices, a fwnode endpoint that has no connection to a remote
> endpoint may not be an error. Let the parse_endpoint callback make that
> decision in v4l2_async_notifier_fwnode_parse_endpoint(). If the callback
> indicates that is not an error, skip adding the asd to the notifier and
> return 0.
> 
> For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
> (omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
> unavailable remote fwnodes to maintain the previous behavior.

I'm not sure this should be a per-driver decision.

Generally speaking, if an endpoint node has no remote-endpoint property, the 
endpoint node is not needed. I've always considered such an endpoint node as 
invalid. The OF graphs DT bindings are however not clear on this subject. I 
have either failed to notice when they got merged, or they slowly evolved over 
time to contain contradictory information. In any case, I think we should 
decide on whether such a situation is valid or not from an OF graph point of 
view, and then always reject or always accept and ignore those endpoints.

> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c    | 3 +++
>  drivers/media/platform/omap3isp/isp.c       | 3 +++
>  drivers/media/platform/rcar-vin/rcar-core.c | 3 +++
>  drivers/media/v4l2-core/v4l2-fwnode.c       | 4 ++--
>  4 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> b/drivers/media/pci/intel/ipu3/ipu3-cio2.c index 6c4444b..2323151 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -1477,6 +1477,9 @@ static int cio2_fwnode_parse(struct device *dev,
>  	struct sensor_async_subdev *s_asd =
>  			container_of(asd, struct sensor_async_subdev, asd);
> 
> +	if (!fwnode_device_is_available(asd->match.fwnode))
> +		return -EINVAL;
> +
>  	if (vep->bus_type != V4L2_MBUS_CSI2) {
>  		dev_err(dev, "Only CSI2 bus type is currently supported\n");
>  		return -EINVAL;
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 8eb000e..4a302f2 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2025,6 +2025,9 @@ static int isp_fwnode_parse(struct device *dev,
>  	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
>  		to_of_node(vep->base.local_fwnode), vep->base.port);
> 
> +	if (!fwnode_device_is_available(asd->match.fwnode))
> +		return -EINVAL;
> +
>  	switch (vep->base.port) {
>  	case ISP_OF_PHY_PARALLEL:
>  		buscfg->interface = ISP_INTERFACE_PARALLEL;
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index f1fc797..51bb8f1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -149,6 +149,9 @@ static int rvin_digital_parse_v4l2(struct device *dev,
>  	struct rvin_graph_entity *rvge =
>  		container_of(asd, struct rvin_graph_entity, asd);
> 
> +	if (!fwnode_device_is_available(asd->match.fwnode))
> +		return -EINVAL;
> +
>  	if (vep->base.port || vep->base.id)
>  		return -ENOTCONN;
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> b/drivers/media/v4l2-core/v4l2-fwnode.c index d630640..446646b 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -361,7 +361,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
>  	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>  	asd->match.fwnode =
>  		fwnode_graph_get_remote_port_parent(endpoint);
> -	if (!asd->match.fwnode) {
> +	if (!asd->match.fwnode && !parse_endpoint) {
>  		dev_warn(dev, "bad remote port parent\n");
>  		ret = -EINVAL;
>  		goto out_err;
> @@ -384,7 +384,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
>  			 "driver could not parse port@%u/endpoint@%u (%d)\n",
>  			 vep->base.port, vep->base.id, ret);
>  	v4l2_fwnode_endpoint_free(vep);
> -	if (ret < 0)
> +	if (ret < 0 || !asd->match.fwnode)
>  		goto out_err;
> 
>  	notifier->subdevs[notifier->num_subdevs] = asd;


-- 
Regards,

Laurent Pinchart
