Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35095 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbbBWRVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 12:21:07 -0500
Date: Mon, 23 Feb 2015 11:21:02 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: am437x: Don't release OF node reference twice
Message-ID: <20150223172102.GE31059@ti.com>
References: <1424702961-2349-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1424702961-2349-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch.

Acked-by: Benoit Parrot <bparrot@ti.com>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote on Mon [2015-Feb-23 16:49:21 +0200]:
> The remote port reference is released both at the end of the OF graph
> parsing loop, and in the error code path at the end of the function.
> Those two calls will release the same reference, causing the reference
> count to go negative.
> 
> Fix the problem by removing the second call.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/am437x/am437x-vpfe.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> I've found this issue while reading the code, the patch hasn't been tested.
> 
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index 56a5cb0..ce273b2 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -2425,7 +2425,7 @@ static int vpfe_async_complete(struct v4l2_async_notifier *notifier)
>  static struct vpfe_config *
>  vpfe_get_pdata(struct platform_device *pdev)
>  {
> -	struct device_node *endpoint = NULL, *rem = NULL;
> +	struct device_node *endpoint = NULL;
>  	struct v4l2_of_endpoint bus_cfg;
>  	struct vpfe_subdev_info *sdinfo;
>  	struct vpfe_config *pdata;
> @@ -2443,6 +2443,8 @@ vpfe_get_pdata(struct platform_device *pdev)
>  		return NULL;
>  
>  	for (i = 0; ; i++) {
> +		struct device_node *rem;
> +
>  		endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
>  						      endpoint);
>  		if (!endpoint)
> @@ -2513,7 +2515,6 @@ vpfe_get_pdata(struct platform_device *pdev)
>  
>  done:
>  	of_node_put(endpoint);
> -	of_node_put(rem);
>  	return NULL;
>  }
>  
> -- 
> Regards,
> 
> Laurent Pinchart
> 
