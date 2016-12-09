Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50233 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbcLIPUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 10:20:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v2 8/9] xilinx: Use a local media device pointer instead
Date: Fri, 09 Dec 2016 17:21:19 +0200
Message-ID: <5335070.Q68AlYuWjm@avalon>
In-Reply-To: <1481295222-14743-9-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com> <1481295222-14743-9-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 09 Dec 2016 16:53:41 Sakari Ailus wrote:
> The function has a local variable that points to the media device; use
> that instead of finding the media device under the entity.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/xilinx/xilinx-dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
> b/drivers/media/platform/xilinx/xilinx-dma.c index 065df82..522cdfd 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -187,7 +187,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline
> *pipe, mutex_lock(&mdev->graph_mutex);
> 
>  	/* Walk the graph to locate the video nodes. */
> -	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
> +	ret = media_graph_walk_init(&graph, mdev);
>  	if (ret) {
>  		mutex_unlock(&mdev->graph_mutex);
>  		return ret;

-- 
Regards,

Laurent Pinchart

