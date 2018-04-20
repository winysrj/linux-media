Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:43313 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754631AbeDTLxO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 07:53:14 -0400
Subject: Re: [PATCH v3 01/13] media: v4l2-fwnode: ignore endpoints that have
 no remote port parent
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <1521592649-7264-2-git-send-email-steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b6e88ab4-3f74-3485-d791-2ff5e4b2c73a@xs4all.nl>
Date: Fri, 20 Apr 2018 13:53:05 +0200
MIME-Version: 1.0
In-Reply-To: <1521592649-7264-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/18 01:37, Steve Longerbeam wrote:
> Documentation/devicetree/bindings/media/video-interfaces.txt states that
> the 'remote-endpoint' property is optional.
> 
> So v4l2_async_notifier_fwnode_parse_endpoint() should not return error
> if the endpoint has no remote port parent. Just ignore the endpoint,
> skip adding an asd to the notifier and return 0.
> __v4l2_async_notifier_parse_fwnode_endpoints() will then continue
> parsing the remaining port endpoints of the device.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> Changes since v2:
> - none
> Changes since v1:
> - don't pass an empty endpoint to the parse_endpoint callback,
>   v4l2_async_notifier_fwnode_parse_endpoint() now just ignores them
>   and returns success. The current users of
>   v4l2_async_notifier_parse_fwnode_endpoints() (omap3isp, rcar-vin,
>   intel-ipu3) no longer need modification.
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index d630640..b8afbac 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -363,7 +363,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
>  		fwnode_graph_get_remote_port_parent(endpoint);
>  	if (!asd->match.fwnode) {
>  		dev_warn(dev, "bad remote port parent\n");
> -		ret = -EINVAL;
> +		ret = -ENOTCONN;
>  		goto out_err;
>  	}
>  
> 
