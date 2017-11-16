Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60102 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934509AbdKPMg1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 07:36:27 -0500
Date: Thu, 16 Nov 2017 14:36:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 2/2] v4l: rcar-vin: Wait for device access to
 complete before unplugging
Message-ID: <20171116123624.swjichq5hcywaht4@valkosipuli.retiisi.org.uk>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171116003349.19235-3-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116003349.19235-3-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 16, 2017 at 02:33:49AM +0200, Laurent Pinchart wrote:
> To avoid races between device access and unplug, call the
> video_device_unplug() function in the platform driver remove handler.
> This will unsure that all device access completes before the remove
> handler proceeds to free resources.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index bd7976efa1fb..c5210f1d09ed 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1273,6 +1273,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  
>  	pm_runtime_disable(&pdev->dev);
>  
> +	video_device_unplug(&vin->vdev);

Does this depend on another patch?

>  
>  	if (!vin->info->use_mc) {
>  		v4l2_async_notifier_unregister(&vin->notifier);
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
