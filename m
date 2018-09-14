Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34484 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbeINP4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 11:56:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] media: vsp1: Document max_width restriction on SRU
Date: Fri, 14 Sep 2018 13:42:31 +0300
Message-ID: <2947729.faakk1MfnN@avalon>
In-Reply-To: <20180831144044.31713-5-kieran.bingham+renesas@ideasonboard.com>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com> <20180831144044.31713-5-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 31 August 2018 17:40:42 EEST Kieran Bingham wrote:
> The SRU is currently restricted to 256 pixels as part of the current
> partition algorithm. Document that the actual capability of this
> component is 288 pixels, but don't increase the implementation.
> 
> The extended partition algorithm may later choose to utilise a larger
> input to support overlapping partitions.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_sru.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c
> b/drivers/media/platform/vsp1/vsp1_sru.c index f277700e5cc2..2a40e09b9aa7
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -314,6 +314,10 @@ static unsigned int sru_max_width(struct vsp1_entity
> *entity, output = vsp1_entity_get_pad_format(&sru->entity,
> sru->entity.config, SRU_PAD_SOURCE);
> 
> +	/*
> +	 * The maximum width of the SRU is 288 input pixels, but to support the
> +	 * partition algorithm, this is currently kept at 256.
> +	 */

s/maximum width/maximum input width/

I think you should also explain why we restrict it to 256 pixels (unless I'm 
mistaken the idea is that up to 32 pixels can be used for overlapping 
partitions, so each partition will process up to 256 useful pixels).

Patch 5/6 should also be updated in a similar way to better document the 
rationale.

>  	if (input->width != output->width)
>  		return 512;
>  	else

-- 
Regards,

Laurent Pinchart
