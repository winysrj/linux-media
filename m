Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37793 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbcCVMND (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 08:13:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Franck Jullien <franck.jullien@odyssee-systemes.fr>
Cc: linux-media@vger.kernel.org, hyun.kwon@xilinx.com
Subject: Re: [PATCH] [media] xilinx-vipp: remove unnecessary of_node_put
Date: Tue, 22 Mar 2016 14:12:59 +0200
Message-ID: <21142136.KJJkg38sI8@avalon>
In-Reply-To: <1458643438-3486-1-git-send-email-franck.jullien@odyssee-systemes.fr>
References: <1458643438-3486-1-git-send-email-franck.jullien@odyssee-systemes.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

Thank you for the patch.

On Tuesday 22 Mar 2016 11:43:58 Franck Jullien wrote:
> of_graph_get_next_endpoint(node, ep) decrements refcount on
> ep. When next==NULL we break and refcount on ep is decremented
> again.
> 
> Signed-off-by: Franck Jullien <franck.jullien@odyssee-systemes.fr>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I don't have patches queued for Xilinx drivers, would you like to push this 
one to Mauro directly, or would you prefer me to take it in my tree ?

> ---
>  drivers/media/platform/xilinx/xilinx-vipp.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c
> b/drivers/media/platform/xilinx/xilinx-vipp.c index e795a45..feb3b2f 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -351,19 +351,15 @@ static int xvip_graph_parse_one(struct
> xvip_composite_device *xdev, struct xvip_graph_entity *entity;
>  	struct device_node *remote;
>  	struct device_node *ep = NULL;
> -	struct device_node *next;
>  	int ret = 0;
> 
>  	dev_dbg(xdev->dev, "parsing node %s\n", node->full_name);
> 
>  	while (1) {
> -		next = of_graph_get_next_endpoint(node, ep);
> -		if (next == NULL)
> +		ep = of_graph_get_next_endpoint(node, ep);
> +		if (ep == NULL)
>  			break;
> 
> -		of_node_put(ep);
> -		ep = next;
> -
>  		dev_dbg(xdev->dev, "handling endpoint %s\n", ep->full_name);
> 
>  		remote = of_graph_get_remote_port_parent(ep);

-- 
Regards,

Laurent Pinchart

