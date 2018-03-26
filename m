Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43063 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeCZNjz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 09:39:55 -0400
Subject: Re: [PATCH] media: vsp1: Fix BRx conditional path in WPF
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
References: <1522070958-24295-1-git-send-email-kieran.bingham@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <da2ab7ff-c236-60da-f502-f15292add028@ideasonboard.com>
Date: Mon, 26 Mar 2018 14:39:51 +0100
MIME-Version: 1.0
In-Reply-To: <1522070958-24295-1-git-send-email-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry,

This should have been from my +renesas to support Renesas' statistics and
filtering of course.

On 26/03/18 14:29, Kieran Bingham wrote:
> When a BRx is provided by a pipeline, the WPF must determine the master
> layer. Currently the condition to check this identifies pipe->bru ||
> pipe->num_inputs > 1.
> 
> The code then moves on to dereference pipe->bru, thus the check fails
> static analysers on the possibility that pipe->num_inputs could be
> greater than 1 without pipe->bru being set.
> 
> The reality is that the pipeline must have a BRx to support more than
> one input, thus this could never cause a fault - however it also
> identifies that the num_inputs > 1 check is redundant.
> 
> Remove the redundant check - and always configure the master layer
> appropriately when we have a BRx configured in our pipeline.
> 
> Fixes: 6134148f6098 ("v4l: vsp1: Add support for the BRS entity")
> Cc: stable@vger.kernel.org
> 
> Suggested-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

And thus:

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_wpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index f7f3b4b2c2de..8bd6b2f1af15 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -452,7 +452,7 @@ static void wpf_configure(struct vsp1_entity *entity,
>  			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
>  	}
>  
> -	if (pipe->bru || pipe->num_inputs > 1)
> +	if (pipe->bru)
>  		srcrpf |= pipe->bru->type == VSP1_ENTITY_BRU
>  			? VI6_WPF_SRCRPF_VIRACT_MST
>  			: VI6_WPF_SRCRPF_VIRACT2_MST;
> 
