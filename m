Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56802 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2CBSNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 13:13:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Handle omap3isp_csi2_reset() errors
Date: Fri, 02 Mar 2012 19:14:09 +0100
Message-ID: <3075998.ASxH1WVGZz@avalon>
In-Reply-To: <1330704181-31718-1-git-send-email-sakari.ailus@iki.fi>
References: <1330704181-31718-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 18:03:01 Sakari Ailus wrote:
> Handle errors from omap3isp_csi2_reset() in omap3isp_csiphy_acquire().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree with fuzz fixed (as the patch is based on top of your 
SMIA++ patches).

> ---
>  drivers/media/video/omap3isp/ispcsiphy.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> b/drivers/media/video/omap3isp/ispcsiphy.c index 902477d..a53f457 100644
> --- a/drivers/media/video/omap3isp/ispcsiphy.c
> +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> @@ -213,7 +213,9 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
>  	if (rval < 0)
>  		goto done;
> 
> -	omap3isp_csi2_reset(phy->csi2);
> +	rval = omap3isp_csi2_reset(phy->csi2);
> +	if (rval < 0)
> +		goto done;
> 
>  	rval = omap3isp_csiphy_config(phy);
>  	if (rval < 0)

-- 
Regards,

Laurent Pinchart

