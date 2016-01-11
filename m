Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43314 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbcAKB6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 20:58:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8] [media] omap3isp: Check v4l2_of_parse_endpoint() return value
Date: Mon, 11 Jan 2016 03:58:09 +0200
Message-ID: <15964645.FOqpCbqGqp@avalon>
In-Reply-To: <1452191248-15847-9-git-send-email-javier@osg.samsung.com>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com> <1452191248-15847-9-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Thursday 07 January 2016 15:27:22 Javier Martinez Canillas wrote:
> The v4l2_of_parse_endpoint() function can fail so check the return value.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  drivers/media/platform/omap3isp/isp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 79a0b953bba3..891e54394a1c
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2235,8 +2235,11 @@ static int isp_of_parse_node(struct device *dev,
> struct device_node *node, struct isp_bus_cfg *buscfg = &isd->bus;
>  	struct v4l2_of_endpoint vep;
>  	unsigned int i;
> +	int ret;
> 
> -	v4l2_of_parse_endpoint(node, &vep);
> +	ret = v4l2_of_parse_endpoint(node, &vep);
> +	if (ret)
> +		return ret;
> 
>  	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
>  		vep.base.port);

-- 
Regards,

Laurent Pinchart

