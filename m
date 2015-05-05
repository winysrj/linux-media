Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48904 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993104AbbEEOLj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 10:11:39 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NNV0040ARFDEF00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 May 2015 15:11:37 +0100 (BST)
Message-id: <5548CF76.7030601@samsung.com>
Date: Tue, 05 May 2015 16:11:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Nikhil Devshatwar <nikhil.nd@ti.com>
Cc: linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	vladimir.barinov@cogentembedded.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] v4l: of: Correct pclk-sample for BT656 bus
References: <1430833799-31936-1-git-send-email-nikhil.nd@ti.com>
In-reply-to: <1430833799-31936-1-git-send-email-nikhil.nd@ti.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/05/15 15:49, Nikhil Devshatwar wrote:
> Current v4l2_of_parse_parallel_bus function attempts to parse the
> DT properties for the parallel bus as well as BT656 bus.
> If the pclk-sample property is defined for the BT656 bus, it is still
> marked as a parallel bus.
> Fix this by parsing the pclk after the bus_type is selected.
> Only when hsync or vsync properties are specified, the bus_type should
> be set to V4L2_MBUS_PARALLEL.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>

Thanks for the patch.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I'd say this should be backported to stable.
> ---
>  drivers/media/v4l2-core/v4l2-of.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index c52fb96..b27cbb1 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -93,10 +93,6 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
>  			V4L2_MBUS_VSYNC_ACTIVE_LOW;
>  
> -	if (!of_property_read_u32(node, "pclk-sample", &v))
> -		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
> -			V4L2_MBUS_PCLK_SAMPLE_FALLING;
> -
>  	if (!of_property_read_u32(node, "field-even-active", &v))
>  		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
>  			V4L2_MBUS_FIELD_EVEN_LOW;
> @@ -105,6 +101,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  	else
>  		endpoint->bus_type = V4L2_MBUS_BT656;
>  
> +	if (!of_property_read_u32(node, "pclk-sample", &v))
> +		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
> +			V4L2_MBUS_PCLK_SAMPLE_FALLING;
> +
>  	if (!of_property_read_u32(node, "data-active", &v))
>  		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
>  			V4L2_MBUS_DATA_ACTIVE_LOW;

--
Regards,
Sylwester
