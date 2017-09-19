Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37857 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbdISLkZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:40:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing fwnode endpoints
Date: Tue, 19 Sep 2017 14:40:29 +0300
Message-ID: <1555926.RTv2yyCEgl@avalon>
In-Reply-To: <20170915141724.23124-7-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <20170915141724.23124-7-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 15 September 2017 17:17:05 EEST Sakari Ailus wrote:
> Instead of using driver implementation, use

Did you mean s/using driver implementation/using a driver implementation/ (or 
perhaps "custom driver implementation") ?

> v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
> of the device.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/omap3isp/isp.c | 115 ++++++++++---------------------
>  drivers/media/platform/omap3isp/isp.h |   5 +-
>  2 files changed, 37 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 1a428fe9f070..a546cf774d40
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c

[snip]

> @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
> 
> -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> +		isp_fwnode_parse);
>  	if (ret < 0)

The documentation in patch 05/25 states that v4l2_async_notifier_release() 
should be called even if v4l2_async_notifier_parse_fwnode_endpoints() fails. I 
don't think that's needed here, so you might want to update the documentation 
(and possibly the implementation of the function).

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  		return ret;
> 
> @@ -2407,6 +2363,7 @@ static int isp_probe(struct platform_device *pdev)
>  	__omap3isp_put(isp, false);
>  error:
>  	mutex_destroy(&isp->isp_mutex);
> +	v4l2_async_notifier_release(&isp->notifier);
> 
>  	return ret;
>  }

[snip]

-- 
Regards,

Laurent Pinchart
