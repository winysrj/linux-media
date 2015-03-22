Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51844 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbbCWGXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 02:23:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH v1.1 14/15] omap3isp: Add support for the Device Tree
Date: Sun, 22 Mar 2015 22:26:39 +0200
Message-ID: <3913985.bpC1SiT8Tn@avalon>
In-Reply-To: <1426889104-17921-1-git-send-email-sakari.ailus@iki.fi>
References: <2603487.gEIKMl6vV7@avalon> <1426889104-17921-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch. This looks good to me, except that there's one last 
bug I've spotted. Please see below.

On Saturday 21 March 2015 00:05:04 Sakari Ailus wrote:
> Add the ISP device to omap3 DT include file and add support to the driver to
> use it.
> 
> Also obtain information on the external entities and the ISP configuration
> related to them through the Device Tree in addition to the platform data.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> since v1:
> 
> - Print endpoint name in debug message when parsing an endpoint.
> 
> - Rename lane-polarity property as lane-polarities.
> 
> - Print endpoint name with the interface if the interface is invalid.
> 
> - Remove assignment to two variables at the same time.
> 
> - Fix multiple sub-device support in isp_of_parse_nodes().
> 
> - Put of_node properly in isp_of_parse_nodes() (requires Philipp Zabel's
>   patch "of: Decrement refcount of previous endpoint in
>   of_graph_get_next_endpoint".
> 
> - Rename return value variable rval as ret to be consistent with the rest of
> the driver.
> 
> - Read the register offset from the syscom property's first argument.
> 
>  drivers/media/platform/omap3isp/isp.c       |  218 ++++++++++++++++++++++--
>  drivers/media/platform/omap3isp/isp.h       |   11 ++
>  drivers/media/platform/omap3isp/ispcsiphy.c |    7 +
>  3 files changed, 224 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 992e74c..92a859e 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c

[snip]

> +static int isp_of_parse_nodes(struct device *dev,
> +			      struct v4l2_async_notifier *notifier)
> +{
> +	struct device_node *node;
> +
> +	notifier->subdevs = devm_kcalloc(
> +		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> +	if (!notifier->subdevs)
> +		return -ENOMEM;
> +
> +	while ((node = of_graph_get_next_endpoint(dev->of_node, node)) &&
> +	       notifier->num_subdevs < ISP_MAX_SUBDEVS) {

If the first condition evaluates to true and the second one to false, the loop 
will be exited without releasing the reference to the DT node. You could just 
switch the two conditions to fix this.

> +		struct isp_async_subdev *isd;
> +
> +		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> +		if (!isd) {
> +			of_node_put(node);
> +			return -ENOMEM;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> +
> +		if (isp_of_parse_node(dev, node, isd)) {
> +			of_node_put(node);
> +			return -EINVAL;
> +		}
> +
> +		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
> +		of_node_put(node);
> +		if (!isd->asd.match.of.node) {
> +			dev_warn(dev, "bad remote port parent\n");
> +			return -EINVAL;
> +		}
> +
> +		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +		notifier->num_subdevs++;
> +	}
> +
> +	return notifier->num_subdevs;
> +}

-- 
Regards,

Laurent Pinchart

