Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36860 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbeINUD3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 16:03:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 2/2] media: vsp1: Document max_width restriction on UDS
Date: Fri, 14 Sep 2018 17:48:50 +0300
Message-ID: <7357198.ccT2EWLa9U@avalon>
In-Reply-To: <20180914142652.30484-2-kieran.bingham+renesas@ideasonboard.com>
References: <20180914142652.30484-1-kieran.bingham+renesas@ideasonboard.com> <20180914142652.30484-2-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 14 September 2018 17:26:52 EEST Kieran Bingham wrote:
> The UDS is currently restricted based on a partition size of 256 pixels.
> Document the actual restrictions, but don't increase the implementation.
> 
> The extended partition algorithm may later choose to utilise a larger
> partition size to support overlapping partitions which will improve the
> quality of the output images.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_uds.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index 75c613050151..e8340de85813
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -342,6 +342,14 @@ static unsigned int uds_max_width(struct vsp1_entity
> *entity, UDS_PAD_SOURCE);
>  	hscale = output->width / input->width;
> 
> +	/*
> +	 * The maximum width of the UDS is 304 pixels. These are input pixels
> +	 * in the event of up-scaling, and output pixels in the event of
> +	 * downscaling.
> +	 *
> +	 * To support overlapping parition windows we clamp at units of 256 and
> +	 * the remaining pixels are reserved.
> +	 */
>  	if (hscale <= 2)
>  		return 256;
>  	else if (hscale <= 4)


-- 
Regards,

Laurent Pinchart
