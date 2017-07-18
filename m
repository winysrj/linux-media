Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56384 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbdGRIkP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 04:40:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/7] omap3isp: Correctly put the last iterated endpoint fwnode always
Date: Tue, 18 Jul 2017 11:40:22 +0300
Message-ID: <5887799.m7Z6mdmlWv@avalon>
In-Reply-To: <20170717220116.17886-7-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com> <20170717220116.17886-7-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 18 Jul 2017 01:01:15 Sakari Ailus wrote:
> Put the last endpoint fwnode if there are too many endpoints to handle.
> Also tell the user about about the condition.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

There are so many refcount-related issues with fwnodes, I wonder whether we 
could/should teach a static analyzer about that.

> ---
>  drivers/media/platform/omap3isp/isp.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 4e6ba7f90e35..13a8ce4de18b
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2154,11 +2154,16 @@ static int isp_fwnodes_parse(struct device *dev,
>  	if (!notifier->subdevs)
>  		return -ENOMEM;
> 
> -	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> -	       (fwnode = fwnode_graph_get_next_endpoint(
> -			of_fwnode_handle(dev->of_node), fwnode))) {
> +	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev),
> +							fwnode))) {
>  		struct isp_async_subdev *isd;
> 
> +		if (notifier->num_subdevs >= ISP_MAX_SUBDEVS) {
> +			dev_warn(dev, "too many endpoints, ignoring\n");
> +			fwnode_handle_put(fwnode);
> +			break;
> +		}
> +
>  		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
>  		if (!isd)
>  			goto error;

-- 
Regards,

Laurent Pinchart
