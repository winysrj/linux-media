Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39213 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbDGJrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 05:47:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] v4l: of: Instead of zeroing bus_type and bus field separately, unify this
Date: Tue, 07 Apr 2015 12:47:56 +0300
Message-ID: <14728842.HyHhcxnctu@avalon>
In-Reply-To: <1428361053-20411-3-git-send-email-sakari.ailus@iki.fi>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi> <1428361053-20411-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thank you for the patch.

On Tuesday 07 April 2015 01:57:30 Sakari Ailus wrote:
> Clean the entire struct starting from bus_type. As more fields are added, no
> changes will be needed in the function to reset their value explicitly.

I would s/Clean/Clear/ or s/Clean/Zero/. Same for the comment in the code. 
Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-of.c |    5 +++--
>  include/media/v4l2-of.h           |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c
> b/drivers/media/v4l2-core/v4l2-of.c index 83143d3..3ac6348 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -149,8 +149,9 @@ int v4l2_of_parse_endpoint(const struct device_node
> *node, int rval;
> 
>  	of_graph_parse_endpoint(node, &endpoint->base);
> -	endpoint->bus_type = 0;
> -	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
> +	/* Zero fields from bus_type to until the end */
> +	memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
> +	       offsetof(typeof(*endpoint), bus_type));
> 
>  	rval = v4l2_of_parse_csi_bus(node, endpoint);
>  	if (rval)
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index f66b92c..5bbdfbf 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -60,6 +60,7 @@ struct v4l2_of_bus_parallel {
>   */
>  struct v4l2_of_endpoint {
>  	struct of_endpoint base;
> +	/* Fields below this line will be cleaned by v4l2_of_parse_endpoint() */
>  	enum v4l2_mbus_type bus_type;
>  	union {
>  		struct v4l2_of_bus_parallel parallel;

-- 
Regards,

Laurent Pinchart

