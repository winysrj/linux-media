Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr820058.outbound.protection.outlook.com ([40.107.82.58]:17321
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727724AbeKHLHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 06:07:10 -0500
Date: Wed, 7 Nov 2018 17:22:57 -0800
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] media: xilinx-video: fix bad of_node_put() on endpoint
 error
Message-ID: <20181108012254.GA25124@smtp.xilinx.com>
References: <1541337070-4917-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1541337070-4917-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thanks for the patch.

On Sun, 2018-11-04 at 05:11:10 -0800, Akinobu Mita wrote:
> The fwnode_graph_get_next_endpoint() returns an 'endpoint' node pointer
> with refcount incremented, and refcount of the passed as a previous
> 'endpoint' node is decremented.
> 
> So when iterating over all nodes using fwnode_graph_get_next_endpoint(),
> we don't need to call fwnode_handle_put() for each node except for error
> exit paths.  Otherwise we get "OF: ERROR: Bad of_node_put() on ..."
> messages.
> 
> Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
> Cc: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

This looks good to me,

     Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>

Thanks,
-hyun

> ---
>  drivers/media/platform/xilinx/xilinx-vipp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> index 574614d..26b13fd 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -377,8 +377,6 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
>  			goto err_notifier_cleanup;
>  		}
>  
> -		fwnode_handle_put(ep);
> -
>  		/* Skip entities that we have already processed. */
>  		if (remote == of_fwnode_handle(xdev->dev->of_node) ||
>  		    xvip_graph_find_entity(xdev, remote)) {
> -- 
> 2.7.4
> 
