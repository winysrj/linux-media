Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57083 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbdLKNd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 08:33:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>
Subject: Re: [PATCH] media: xilinx-video: fix bad of_node_put() on endpoint error
Date: Mon, 11 Dec 2017 15:33:57 +0200
Message-ID: <10967298.zCYyocrkeW@avalon>
In-Reply-To: <1507824284-17809-1-git-send-email-akinobu.mita@gmail.com>
References: <1507824284-17809-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thank you for the patch.

On Thursday, 12 October 2017 19:04:44 EET Akinobu Mita wrote:
> When iterating through all endpoints using of_graph_get_next_endpoint(),
> the refcount of the returned endpoint node is incremented and the refcount
> of the node which is passed as previous endpoint is decremented.
> 
> So the caller doesn't need to call of_node_put() for each iterated node
> except for error exit paths.  Otherwise we get "OF: ERROR: Bad
> of_node_put() on ..." messages.
> 
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/xilinx/xilinx-vipp.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c
> b/drivers/media/platform/xilinx/xilinx-vipp.c index ebfdf33..e5c80c9 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -76,20 +76,16 @@ static int xvip_graph_build_one(struct
> xvip_composite_device *xdev, struct xvip_graph_entity *ent;
>  	struct v4l2_fwnode_link link;
>  	struct device_node *ep = NULL;
> -	struct device_node *next;
>  	int ret = 0;
> 
>  	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
> 
>  	while (1) {
>  		/* Get the next endpoint and parse its link. */
> -		next = of_graph_get_next_endpoint(entity->node, ep);
> -		if (next == NULL)
> +		ep = of_graph_get_next_endpoint(entity->node, ep);
> +		if (ep == NULL)
>  			break;
> 
> -		of_node_put(ep);
> -		ep = next;
> -
>  		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
> 
>  		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
> @@ -200,7 +196,6 @@ static int xvip_graph_build_dma(struct
> xvip_composite_device *xdev) struct xvip_graph_entity *ent;
>  	struct v4l2_fwnode_link link;
>  	struct device_node *ep = NULL;
> -	struct device_node *next;
>  	struct xvip_dma *dma;
>  	int ret = 0;
> 
> @@ -208,13 +203,10 @@ static int xvip_graph_build_dma(struct
> xvip_composite_device *xdev)
> 
>  	while (1) {
>  		/* Get the next endpoint and parse its link. */
> -		next = of_graph_get_next_endpoint(node, ep);
> -		if (next == NULL)
> +		ep = of_graph_get_next_endpoint(node, ep);
> +		if (ep == NULL)
>  			break;
> 
> -		of_node_put(ep);
> -		ep = next;
> -
>  		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
> 
>  		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);

-- 
Regards,

Laurent Pinchart
