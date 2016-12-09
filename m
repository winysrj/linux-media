Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50225 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753790AbcLIPU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 10:20:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v2 7/9] omap3isp: Use a local media device pointer instead
Date: Fri, 09 Dec 2016 17:20:52 +0200
Message-ID: <23538411.soEARKePUB@avalon>
In-Reply-To: <1481295222-14743-8-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com> <1481295222-14743-8-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 09 Dec 2016 16:53:40 Sakari Ailus wrote:
> The function has a local variable that points to the media device; use
> that instead of finding the media device under the entity.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 5b0d16e..25a8210 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -232,7 +232,7 @@ static int isp_video_get_graph_data(struct isp_video
> *video, int ret;
> 
>  	mutex_lock(&mdev->graph_mutex);
> -	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
> +	ret = media_graph_walk_init(&graph, mdev);
>  	if (ret) {
>  		mutex_unlock(&mdev->graph_mutex);
>  		return ret;

-- 
Regards,

Laurent Pinchart
