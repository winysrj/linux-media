Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56435 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRJCJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 05:02:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] omap3isp: Ignore endpoints with invalid configuration
Date: Tue, 18 Jul 2017 12:02:16 +0300
Message-ID: <7431573.EthHK8LOg7@avalon>
In-Reply-To: <20170717220116.17886-2-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com> <20170717220116.17886-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 18 Jul 2017 01:01:10 Sakari Ailus wrote:
> If endpoint has an invalid configuration, ignore it instead of happily
> proceeding to use it nonetheless. Ignoring such an endpoint is better than
> failing since there could be multiple endpoints, only some of which are
> bad.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Tested-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index db2cccb57ceb..441eba1e02eb
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2110,10 +2110,12 @@ static int isp_fwnodes_parse(struct device *dev,
>  		if (!isd)
>  			goto error;
> 
> -		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> +		if (isp_fwnode_parse(dev, fwnode, isd)) {
> +			devm_kfree(dev, isd);
> +			continue;
> +		}
> 
> -		if (isp_fwnode_parse(dev, fwnode, isd))
> -			goto error;
> +		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> 
>  		isd->asd.match.fwnode.fwnode =
>  			fwnode_graph_get_remote_port_parent(fwnode);

-- 
Regards,

Laurent Pinchart
